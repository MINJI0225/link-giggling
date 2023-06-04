import React, { Fragment } from 'react';
import Hls from 'hls.js';

class VideoPlayer extends React.Component {
  constructor(props) {
    super(props);
    this.videoRef = React.createRef();
    this.hlsRef = null;
  }

  componentDidMount() {
    if (Hls.isSupported()) {
      const video = this.videoRef.current;
      const hls = new Hls();
      hls.loadSource(this.props.src);
      hls.attachMedia(video);

      // triggered when the loaded manifest is parsed.s
      hls.on(Hls.Events.MANIFEST_PARSED, function (event, data) {
        this.props.setLen(data.levels.length);
        console.log(
          '>>>>>>>>>>>> manifest loaded, found ' + data.levels.length + ' quality level');
        video.play();
      });
      this.hlsRef = hls;

      // triggered when a new segment (fragment) is loaded.
      hls.on(Hls.Events.FRAG_LOADED, function(event, data) {
        console.log('=========================================================');
        console.log('>>>>>>>>>>>> Estimated bandwidth:', hls.bandwidthEstimate + ' bps');   
        
        var index = hls.currentLevel;
        var level = hls.levels[index];
    
        console.log('>>>>>>>>>>>> currentLevel:', hls.currentLevel);
        console.log('>>>>>>>>>>>> levels:', hls.levels);
        console.log('>>>>>>>>>>>> loadLevel:', hls.loadLevel);

        this.props.setBuf(hls.currentLevel);
        
        if (level) {
          if (level.height) {
            console.log('>>>>>>>>>>>> Selected resolution:', level.height + 'p');
          }
          if (level.bitrate) {        
            console.log('>>>>>>>>>>>> Selected bandwidth:', Math.round(level.bitrate / 1000) + ' kbps');
            if (index !== -1 && index >=0) {
              console.log('>>>>>>>>>>>> Selected bandwidth:', hls.levels[index].attrs.BANDWIDTH + ' bps');
            }    
          }
        }
      });
    }
  }
  handleZeroClick = () => {
    console.log('Button clicked!');
    this.hlsRef.currentLevel = 0;
  };
  
  handleAutoClick = () => {
    console.log('Button clicked!');
    this.hlsRef.currentLevel = -1; // Auto resolution switching
  };

  render() {

    return (
      <>
        <div className='videoRow'>
          <button className='videobtn' onClick={this.handleZeroClick}>Level 0</button>
          <button className='videobtn' onClick={this.handleAutoClick}>Auto</button>
        </div>
       
        <video ref={this.videoRef} controls height={this.props.res} />
      </>
    );
  }
}

export default VideoPlayer;