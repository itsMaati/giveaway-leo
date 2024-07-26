program giveaway_v2_43643988.aleo {

    const GIVEAWAY_OWNER: address = aleo13y0vv5e358u0zxc7sesry8n6mz5rm22q4ay96mvglhwvehapzqgqrew65a;

    mapping initialized: bool => bool;
    mapping participants: address => bool;
    mapping participants_count: bool => u8;
    mapping finished: bool => bool;

    record Submission{
        id: field,
        owner: address,
        is_winner: bool,
    }

    async transition initialize() -> Future{
        assert_eq(self.caller, GIVEAWAY_OWNER);
        return initialize_final();
    }

    async function initialize_final(){
        assert(!Mapping::contains(initialized, true));
        Mapping::set(participants_count, true, 0u8);
        Mapping::set(initialized, true, true);
        Mapping::set(finished, true, false);
    }

    async transition enter_giveaway(participant: address) -> (Submission, Future){
        assert_eq(self.caller, participant);
        let id: field = Poseidon2::hash_to_field(participant);

        let submission: Submission = Submission{
            id: id,
            owner: participant,
            is_winner: false,
        };

        return (submission, enter_giveaway_final(participant, id ));
    }

    async function enter_giveaway_final(participant: address, id: field){
        //check if the giveaway is still going on
        let open: bool = Mapping::get(finished, true);
        assert(!open);
        //check if user is in the giveaway
        assert(!Mapping::contains(participants,participant));
        Mapping::set(participants, participant, true);
        
        let count: u8 = Mapping::get_or_use(participants_count, true, 0u8);
        Mapping::set(participants_count, true, count+1u8);
    }

    async transition choose_winner(submission: Submission) -> (Submission, Future){
        assert_eq(self.caller, GIVEAWAY_OWNER);

        let winner_submission: Submission = Submission{
            id: submission.id,
            owner: submission.owner,
            is_winner: true,
        };

        return (winner_submission, choose_winner_final(submission.owner));
    } 

    async function choose_winner_final(participant:address){
        //check if the user has participated in the giveaway
        assert(Mapping::contains(participants, participant));

         //check if the giveaway is still going on
        let open: bool = Mapping::get(finished, true);
        assert(!open);

        Mapping::set(finished, true,true);
    }

    async transition admin_reset() -> Future{
        assert_eq(self.caller, GIVEAWAY_OWNER);
        return admin_reset_final();
    }

    //does not remove previous participants, only resets the count and finished status 
    async function admin_reset_final(){
        Mapping::set(finished, true,false);
        Mapping::set(participants_count, true,0u8);
    }
    
}
