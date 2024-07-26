program giveaway_v2_43643988.aleo;

record Submission:
    owner as address.private;
    id as field.private;
    is_winner as boolean.private;


mapping initialized:
	key as boolean.public;
	value as boolean.public;


mapping participants:
	key as address.public;
	value as boolean.public;


mapping participants_count:
	key as boolean.public;
	value as u8.public;


mapping finished:
	key as boolean.public;
	value as boolean.public;


function initialize:
    assert.eq self.caller aleo13y0vv5e358u0zxc7sesry8n6mz5rm22q4ay96mvglhwvehapzqgqrew65a;
    async initialize into r0;
    output r0 as giveaway_v2_43643988.aleo/initialize.future;

finalize initialize:
    contains initialized[true] into r0;
    not r0 into r1;
    assert.eq r1 true;
    set 0u8 into participants_count[true];
    set true into initialized[true];
    set false into finished[true];




function enter_giveaway:
    input r0 as address.private;
    assert.eq self.caller r0;
    hash.psd2 r0 into r1 as field;
    cast r0 r1 false into r2 as Submission.record;
    async enter_giveaway r0 r1 into r3;
    output r2 as Submission.record;
    output r3 as giveaway_v2_43643988.aleo/enter_giveaway.future;

finalize enter_giveaway:
    input r0 as address.public;
    input r1 as field.public;
    get finished[true] into r2;
    not r2 into r3;
    assert.eq r3 true;
    contains participants[r0] into r4;
    not r4 into r5;
    assert.eq r5 true;
    set true into participants[r0];
    get.or_use participants_count[true] 0u8 into r6;
    add r6 1u8 into r7;
    set r7 into participants_count[true];




function choose_winner:
    input r0 as Submission.record;
    assert.eq self.caller aleo13y0vv5e358u0zxc7sesry8n6mz5rm22q4ay96mvglhwvehapzqgqrew65a;
    cast r0.owner r0.id true into r1 as Submission.record;
    async choose_winner r0.owner into r2;
    output r1 as Submission.record;
    output r2 as giveaway_v2_43643988.aleo/choose_winner.future;

finalize choose_winner:
    input r0 as address.public;
    contains participants[r0] into r1;
    assert.eq r1 true;
    get finished[true] into r2;
    not r2 into r3;
    assert.eq r3 true;
    set true into finished[true];




function admin_reset:
    assert.eq self.caller aleo13y0vv5e358u0zxc7sesry8n6mz5rm22q4ay96mvglhwvehapzqgqrew65a;
    async admin_reset into r0;
    output r0 as giveaway_v2_43643988.aleo/admin_reset.future;

finalize admin_reset:
    set false into finished[true];
    set 0u8 into participants_count[true];

