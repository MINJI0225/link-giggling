import React from 'react';

const ImageButtonList = ({ images, onClick }) => {
  return (
    <div className="image-button-list">
      {images.map((image, index) => (
        <img className='image-button'
          key={index}
          id={image.medID}
          category = {image.category}
          url = {image.URL}
          src='myapp/src/logo.svg'
          alt={image.title}
          onClick={() => onClick(image)}
        />
      ))}
    </div>
  );
};

export default ImageButtonList;
