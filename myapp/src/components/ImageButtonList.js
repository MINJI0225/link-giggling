import React from 'react';

const ImageButtonList = ({ images, onClick }) => {
  return (
    <div>
      {images.map((image, index) => (
        <img
          key={index}
          src={image.src}
          alt={image.alt}
          onClick={() => onClick(image)}
        />
      ))}
    </div>
  );
};

export default ImageButtonList;
