import React, { useState } from "react";
import RewardGenerate from "../RewardGenerate";
import RewardTransfer from "../RewardTransfer";
import RewardView from "../RewardView";

const Accordion = ({ type, mspId, domain }) => {
  const [isActive, setIsActive] = useState(false);

  return (
    <React.Fragment>
      <div className="accordion">
        <div className="accordion-item">
          <div
            className="accordion-title"
            onClick={() => setIsActive(!isActive)}
          >
            <div>{type}</div>
            <div>+</div>
          </div>
          {isActive && type === "Generate" && <div className="accordion-content"><RewardGenerate mspId={mspId} domain={domain} /></div>}
          {isActive && type === "Transfer" && <div className="accordion-content"><RewardTransfer mspId={mspId} domain={domain} /></div>}
          {isActive && type === "View" && <div className="accordion-content"><RewardView mspId={mspId} domain={domain} /></div>}
        </div>
      </div>
    </React.Fragment>
  );
};
export default Accordion;