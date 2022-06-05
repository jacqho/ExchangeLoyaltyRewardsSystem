import React, { useState } from "react";

const RewardView = ({mspId, domain}) => {
  const [alias, setAlias] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();

    fetch(`http://localhost:5000/api/reward?mspId=${mspId}&domain=${domain}&alias=${alias}`, { method: "GET" })
    .then(response => { 
      if(response.status !== 200) {
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
        <label>Alias:</label><br/>
        <input
          type="text"
          value={alias}
          onChange={(e) => setAlias(e.target.value)}
        />
        <button type="submit">View</button>

        <div className="message">{message ? <p>{message}</p> : null}</div>
      </form>
    </div>
  );
};
export default RewardView;