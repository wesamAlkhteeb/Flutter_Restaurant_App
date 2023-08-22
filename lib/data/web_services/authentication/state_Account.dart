
enum StateResponse{
  error , successfully
}

class ResponseMessageData{
  String message ;
  StateResponse stateResponse;

  ResponseMessageData(this.message, this.stateResponse);
}