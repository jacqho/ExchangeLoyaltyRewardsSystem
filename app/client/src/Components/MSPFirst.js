import React, { useState } from "react";
import Accordion from "./UI/Accordion";

const MSPFirstTab = () => {
  const [mspId] = useState("org1-example.com");
  const [domain, setDomain] = useState("User1@org1-example.com");
  const accordionData = [
    { type: 'Generate' },
    { type: 'Transfer' },
    { type: 'View' }
  ];

  return (
    <div className="MSPFirstTab">
      <div class="info">
        <label>MSP ID</label>
        <input type="text" readOnly value={mspId}/>
        <br/>
        <label>Domain</label>
        <input type="text" value={domain} onChange={(e) => setDomain(e.target.value)}/>
      </div>
      <div className="accordion">
        {accordionData.map(({ type }) => (
          <Accordion type={type} mspId={mspId} domain={domain}/>
        ))}
      </div>
    </div>
  );
};
export default MSPFirstTab;