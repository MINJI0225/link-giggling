import React from 'react';

const ButtonList = ({ buttons, onClick }) => {
  return (
    <div className="button-list">
      {buttons.map((button, index) => (
        <button className="custom-button" key={index} onClick={() => onClick(button, index)}>
          {button.label}
        </button>
      ))}
    </div>
  );
};

export default ButtonList;
