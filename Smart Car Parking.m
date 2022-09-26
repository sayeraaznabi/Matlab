clc
clear
%%defining global variables:
parkingSpace = 13; 
runProgram = true; 
SpaceAvailable = true;
%%Creating Arduino, LCD, Servo, Ultrasonic objects and uploading these libraries to the Arduino board
a = arduino('COM3', 'Uno', 'Libraries', {'Servo','ExampleLCD/LCDAddon'});
lcd = addon(a,'ExampleLCD/LCDAddon','RegisterSelectPin','D7','EnablePin','D6','DataPins',{'D5','D4','D3','D2'});
s = servo(a, 'D10');
 writePosition(s, 0); 
 initializeLCD(lcd);
%%configuring Arduino pins;
configurePin(a,'A4','Pullup'); 
configurePin(a,'A5','Pullup'); 
configurePin(a,'D12','DigitalOutput'); 
configurePin(a,'D11','DigitalOutput');
%%Main program begins from here:
while runProgram
 if(parkingSpace>0)
    printLCD(lcd,'Welcome!!!'); printLCD(lcd,['Available:',num2str(parkingSpace),'.']);
 end
 if(parkingSpace==0)

clearLCD(lcd); printLCD(lcd,'Plz Come Later.');
end 
writeDigitalPin(a,'D12', 1);% Initially turning the red light on %if the slots available are(>1),then it will display, ‘Welcome’ %message
%if SpaceAvailable
%printLCD(lcd,'Welcome!!!'); printLCD(lcd,['Available:',num2str(parkingSpace),'.']);
%else
%clearLCD(lcd); printLCD(lcd,['Available:',num2str(parkingSpace)]); printLCD(lcd,'Plz Come Later.');
%end

EntryButton = readDigitalPin(a,'A4');
 ExitButton = readDigitalPin(a,'A5');
%When the entry button is pressed:%

 if(EntryButton == 1)
  if (parkingSpace>= 0&&parkingSpace<=13)
writeDigitalPin(a,'D12',0)% Turning the Red LED off. 
writeDigitalPin(a,'D11',1)% Turning the Green LED on.
writePosition (s,0.5); %Servo motor rotates to 90 degree.
pause(2); %Waiting for servomotor for 2 seconds till the gate opens. 
writePosition(s,0); %Motor rotates back to 0 degree.
parkingSpace= parkingSpace-1; %Decreasing the number of parking slots by 1. 
writeDigitalPin(a,'D11',0);%Green LED light turns off.
writeDigitalPin(a,'D12',1)% Turning the Red LED off. 
printLCD(lcd,'Welcome!!!'); printLCD(lcd,['Available:',num2str(parkingSpace),'.']);
 end
 end
 
%when exit button is pressed;

if(ExitButton==1)
 if (parkingSpace<13&&parkingSpace>=0)
    writeDigitalPin(a,'D12',0)%Turning the Red LED off. 
    writeDigitalPin(a,'D11',1)%Turning the Green LED on. 
    writePosition (s,0.5);%Servo motor rotates to 90 degree.
pause(2); % Waiting for servomotor for 2 seconds till the gate opens. 
writePosition(s,0); %Motor rotates back to 0 degree.
parkingSpace= parkingSpace+1; %Increasing the parking spots by 1. 
writeDigitalPin(a,'D11',0);%Green LED light turns off.
writeDigitalPin(a,'D12',1)% Turning the Red LED off. 
printLCD(lcd,'Welcome!!!'); printLCD(lcd,['Available:',num2str(parkingSpace),'.']);
 end
 if(parkingSpace==0)
writeDigitalPin(a,'D12',1)% Turning the Red LED off. 
clearLCD(lcd); printLCD(lcd,'Plz Come Later.');
end 
end
%If No Space is available then;

end

