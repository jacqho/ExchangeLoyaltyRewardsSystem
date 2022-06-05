import React, { useState } from "react";
import MSPFirstTab from "../MSPFirst";
import MSPSecondTab from "../MSPSecond";

const Tabs = () => {
  const [activeTab, setActiveTab] = useState("tab1");

  const handleTab1 = () => {
    // update the state to tab1
    setActiveTab("tab1");
  };
  const handleTab2 = () => {
    // update the state to tab2
    setActiveTab("tab2");
  };

  return (
    <div className="Tabs">
      {/* Tab nav */}
      <ul className="nav">
        <li className={activeTab === "tab1" ? "active" : ""} onClick={handleTab1}>MSP 1</li>
        <li className={activeTab === "tab2" ? "active" : ""} onClick={handleTab2}>MSP 2</li>
      </ul>
      <div className="outlet">
        {activeTab === "tab1" ? <MSPFirstTab /> : <MSPSecondTab />}
      </div>
    </div>
  );
};
export default Tabs;