import React, { useState } from "react";

const RewardGenerate = ({mspId, domain}) => {
  const [to, setTo] = useState("");
  const [amount, setAmount] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();

    fetch("http://localhost:5000/api/reward/generate", {
      method: "POST",
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mspId: mspId,
        domain: domain,
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
    .then(responseData => {console.log(responseData); return responseData;})
    .then(data => {
      console.log(data);
      setMessage(JSON.stringify(data));
    })
    .catch(err => {
      setMessage("Some error occured" + err);
    });
  };

  return (
    <div className="container">
      <form onSubmit={handleSubmit}>
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

        <button type="submit">Generate</button>

        <div className="message">{message ? <p>{message}</p> : null}</div>
      </form>
    </div>
  );
};
export default RewardGenerate;