import React, { useState } from "react";

const RewardTransfer = ({mspId, domain}) => {
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    fetch("http://localhost:5000/api/reward/transfer", {
      method: "POST",
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mspId: mspId,
        domain: domain,
        from: from,
        to: to,
        amount: amount
      }),
    })
    .then(response => { 
      if(response.status !== 201) {
          throw response.status;
      }
      return response.json();
    })
    .then(responseData => {return responseData;})
    .then(data => {
      setMessage(JSON.stringify(data));
    })
    .catch(err => {
      setMessage("Some error occured" + err);
    });
  };

  return (
    <div className="container">
      <form onSubmit={handleSubmit}>
        <label>From:</label><br/>
        <input
          type="text"
          value={from}
          onChange={(e) => setFrom(e.target.value)}
        />
        <label>To:</label><br/>
        <input
          type="text"
          value={to}
          onChange={(e) => setTo(e.target.value)}
        />
        <label>Amount:</label><br/>
        <input
          type="number"
          value={amount}
          min="0"
          onChange={(e) => setAmount(e.target.value)}
        />

        <button type="submit">Transfer</button>

        <div className="message">{message ? <p>{message}</p> : null}</div>
      </form>
    </div>
  );
};
export default RewardTransfer;