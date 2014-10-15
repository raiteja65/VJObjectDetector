function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)

ni = size(fs, 1);
nf = size(fs, 2);

wsys = (ws.*ys)';
wsiys = (ws.*(1-ys))';

mp = (wsys *fs)/sum(wsys);
mn = (wsiys*fs)/sum(wsiys);

sp = (wsys*fs-mp).^2/sum(wsys);
sn = (wsiys*fs-mn).^2/sum(wsiys);

a = sp-sn;
b = -2*(sp.*mn-sn.*mp);
c = (sp.*(mn.^2)-sn.*(mp.^2)) - 2*sp.*sn.*log(sqrt(sp./sn));
d = sqrt(b.*b - 4.*a.*c);

x1 = (-b+d)./(2*a);
x2 = (-b-d)./(2*a);
xm = (mp+mn)/2;

[p1, err1] = GetClassiferError(ws, ys, fs, x1, ni, nf);
[p2, err2] = GetClassiferError(ws, ys, fs, x2, ni, nf);

idx = err1 < err2;
theta = x1.*idx + x2.*(1-idx);
p = p1.*idx + p2.*(1-idx);
err = err1.*idx + err2.*(1-idx);

    function [p, err] = GetClassiferError(ws, ys, fs, theta, ni, nf)
        ysx = repmat(ys,[1,nf]);
        fsth = (fs < repmat(theta,[ni,1]));

        ep = ws'*abs(ysx-fsth);
        en = ws'*abs(ysx-~fsth);

        ip = (ep <= en);
        in = (ep >  en);

        p = ip - in;
        err = ep.*ip + en.*in;
    end

end
