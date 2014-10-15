function fpic = MakeFeaturePic(ftype, W, H)

x = ftype(2); y = ftype(3);
w = ftype(4); h = ftype(5);

fpic = zeros(H, W);

posc = 1;
negc = -1;

switch ftype(1)
    case 1
        fpic(y:y+h-1,       x:x+w-1)=posc;
        fpic(y+h:y+2*h-1,   x:x+w-1)=negc;
    case 2
        fpic(y:y+h-1,       x+w:x+2*w-1)=posc;
        fpic(y:y+h-1,       x:x+w-1)=negc;
    case 3
        fpic(y:y+h-1,       x+w:x+2*w-1)=posc;
        fpic(y:y+h-1,       x:x+w-1)= negc;
        fpic(y:y+h-1,       x+2*w:x+3*w-1)=negc;
    case 4
        fpic(y:y+h-1,       x+w:x+2*w-1)=posc;
        fpic(y+h-1:y+2*h-1, x:x+w-1)=posc;
        fpic(y:y+h-1,       x:x+w-1)=negc;
        fpic(y+h:y+2*h-1,   x+w:x+2*w-1)=negc;
end
