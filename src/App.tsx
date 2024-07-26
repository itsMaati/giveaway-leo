import { useState } from "react";

import "./App.css";
import { AleoWorker } from "./workers/AleoWorker";
import { WalletMultiButton } from "@demox-labs/aleo-wallet-adapter-reactui";
import { useWallet } from '@demox-labs/aleo-wallet-adapter-react';
import { Transaction, WalletAdapterNetwork,  WalletNotConnectedError,} from '@demox-labs/aleo-wallet-adapter-base';
import "@demox-labs/aleo-wallet-adapter-reactui/styles.css";

const aleoWorker = AleoWorker();
function App() {
  const { publicKey, requestTransaction, transactionStatus } = useWallet();
  
  const [winneraddr, setWinnerAddr] = useState('');

  const CreateTransaction = async (method: string, values: Array<any>, success_message: string ) => {
    if (!publicKey) throw new WalletNotConnectedError();

    const tx = Transaction.createTransaction(
      publicKey,
      WalletAdapterNetwork.TestnetBeta,
      "giveaway_v2_43643988.aleo",
      method,
      values,
      100000,
      false,
    );

    if (requestTransaction) {
      const result = await requestTransaction(tx);
      console.log(result);

      if (transactionStatus) {
        const status = await transactionStatus(result);
        console.log(status)
        if(status == 'Completed'){
          alert(success_message)
        }
      }
    }
  }


  const changeWinnerAddr = (event) => {
    setWinnerAddr(event.target.value);
  };
  const EnterGiveaway = async () => {
    if (!publicKey) throw new WalletNotConnectedError();
    await CreateTransaction('enter_giveaway',[publicKey],'you successfully participated in this giveaway with address: '+publicKey)
  }

  const Reset = async () => {
    CreateTransaction('admin_reset',[],'Successfully Reset Stats');
  }

  const Initialize = async () => {
    CreateTransaction('admin_reset',[],'Initialized');
  }

  const ChooseWinner = async () => {
    console.log(winneraddr.toString());  
    CreateTransaction('choose_winner',[winneraddr.toString()],'Winner was chosen as '+winneraddr);
  }


  return (
    <div className="container">
      <header className="navbar">
        <WalletMultiButton />
      </header>

      <div className="title">
        <h2>GiveAway App</h2>
      </div>

      <div className="sections">
        <div className="section">
          <p>Admin section</p>
          <input type="text" id="winner_addr" placeholder="Enter the winner address" value={winneraddr} 
        onChange={changeWinnerAddr}></input>
          <button onClick={ChooseWinner}>Choose Winner</button>
          <button onClick={Reset}>Reset</button>
          <button onClick={Initialize}>Initialize</button>

        </div>
        <div className="section">
          <p>User section</p>
          <button onClick={EnterGiveaway}>Enter GiveAway</button>
        </div>
      </div>
    </div>
  );
}

export default App;
