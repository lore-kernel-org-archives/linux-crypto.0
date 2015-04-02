From: "kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: Re: AW: problem with testing a CTR block cipher
 mode which is partially working
Date: Thu, 2 Apr 2015 10:10:29 +0800
Message-ID: <2015040210102714744761@gmail.com>
References: <55198F14.1090902@gmail.com>,
	<12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>,
	<551AE140.3000209@gmail.com>,
	<2015040110063394945846@gmail.com>,
	<551BD38B.6050307@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_001_NextPart002818716325_=----"
To: "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-sunxi+bncBC5PRQO6XENRBGOK6KUAKGQE6JPPGJA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.

------=_001_NextPart002818716325_=----
Content-Type: text/plain; charset=UTF-8

> Thanks for your answer, I have loose hours on that problem.
I'm sorry to hear that.
 
> Perhaps you could update all datasheet/user manual about this known issue ?
We have updated the user manual and datasheet, the latest version is 1.3 for 
A20 which is released in Oct. 2014. The CTR block mode is not support.
You can download it from the github: https://github.com/allwinner-zh/documents 
and check the details of the SS moudle.

Best Regards,


kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
 
From: Corentin LABBE
Date: 2015-04-01 19:16
To: linux-sunxi; linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [linux-sunxi] Re: AW: problem with testing a CTR block cipher mode which is partially working
On 04/01/15 04:06, kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> Dear All,
> 
> 
> About the SS module, there is some detail information.
> There is some issues on the SS hardware module, the issues make the some
> AES/DES/3DS algorithm be not available.
> 1. The byte order of the counter is wrong, make the result error, so, the CTR
> mode is not available.
> 2. Hardware don't support the continuous subcontracting, make the CTS mode is
> not available.
> 3. Another issue need be taken attention is that hardware will modify the key
> register when do AES encrypt, so, it need software to restore the key register
> 
> when doing every frame.
> 
> These issues are presented on the A10, A13, A20, A31 and A33.
> The issues of SS module have been fixed on the A83T platform, so, I suggest to
> take more attention to the A83T platform if any interest in the SS module.
> 
> If any problem, please don't hesitate to contact me(kevin-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org)
> 
> or Shuge(shuge-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org).
> 
 
Thanks for your answer, I have loose hours on that problem.
 
Perhaps you could update all datasheet/user manual about this known issue ?
 
Regards
 
-- 
You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

-- 
You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

------=_001_NextPart002818716325_=----
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=
=3DUTF-8"><style>body { line-height: 1.5; }blockquote { margin-top: 0px; ma=
rgin-bottom: 0px; margin-left: 0.5em; }body { font-size: 10.5pt; font-famil=
y: =E6=A5=B7=E4=BD=93; color: rgb(0, 0, 0); line-height: 1.5; }</style></he=
ad><body>
<div><span></span><div>&gt; Thanks for your answer, I have loose hours on t=
hat problem.</div><div>I'm sorry to hear that.</div><div>&nbsp;</div><div>&=
gt; Perhaps you could update all datasheet/user manual about this known iss=
ue ?</div></div><div>We have updated the user manual and datasheet, the lat=
est version is 1.3 for&nbsp;</div><div>A20 which is released in Oct. 2014. =
The CTR block mode is not support.</div><div>You can download it from the g=
ithub:&nbsp;<span style=3D"background-color: rgba(0, 0, 0, 0); font-size: 1=
0.5pt; line-height: 1.5;"></span><a href=3D"https://github.com/allwinner-zh=
/documents" style=3D"font-size: 10.5pt; line-height: 1.5; background-color:=
 window;">https://github.com/allwinner-zh/documents</a><span style=3D"font-=
size: 10.5pt; line-height: 1.5; background-color: rgba(0, 0, 0, 0);">&nbsp;=
</span></div><div><span style=3D"font-size: 10.5pt; line-height: 1.5; backg=
round-color: rgba(0, 0, 0, 0);">and check the details of the SS moudle.</sp=
an></div><span style=3D"background-color: rgba(0, 0, 0, 0);"></span><div><b=
r></div><div>Best Regards,</div><hr style=3D"width: 210px; height: 1px;" co=
lor=3D"#b5c4df" size=3D"1" align=3D"left">
<div><span><div style=3D"MARGIN: 10px; FONT-FAMILY: verdana; FONT-SIZE: 10p=
t"><div>kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</div></div></span></div>
<blockquote style=3D"margin-top: 0px; margin-bottom: 0px; margin-left: 0.5e=
m;"><div>&nbsp;</div><div style=3D"border:none;border-top:solid #B5C4DF 1.0=
pt;padding:3.0pt 0cm 0cm 0cm"><div style=3D"PADDING-RIGHT: 8px; PADDING-LEF=
T: 8px; FONT-SIZE: 12px;FONT-FAMILY:tahoma;COLOR:#000000; BACKGROUND: #efef=
ef; PADDING-BOTTOM: 8px; PADDING-TOP: 8px"><div><b>From:</b>&nbsp;<a href=
=3D"mailto:clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org">Corentin LABBE</a></div><div><b>Date:=
</b>&nbsp;2015-04-01&nbsp;19:16</div><div><b>To:</b>&nbsp;<a href=3D"mailto=
:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">linux-sunxi</a>; <a href=3D"mailto:linux-cry=
pto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a></div><div><b>Subject:=
</b>&nbsp;Re: [linux-sunxi] Re: AW: problem with testing a CTR block cipher=
 mode which is partially working</div></div></div><div><div>On 04/01/15 04:=
06, kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:</div>
<div>&gt; Dear All,</div>
<div>&gt; </div>
<div>&gt; </div>
<div>&gt; About the SS module, there is some detail information.</div>
<div>&gt; There is some issues on the SS hardware module, the issues make t=
he some</div>
<div>&gt; AES/DES/3DS algorithm be not available.</div>
<div>&gt; 1. The byte order of the counter is wrong, make the result error,=
 so, the CTR</div>
<div>&gt; mode is not available.</div>
<div>&gt; 2. Hardware don't support the continuous subcontracting, make the=
 CTS mode is</div>
<div>&gt; not available.</div>
<div>&gt; 3. Another issue need be taken attention is that hardware will mo=
dify the key</div>
<div>&gt; register when do AES encrypt, so, it need software to restore the=
 key register</div>
<div>&gt; </div>
<div>&gt; when doing every frame.</div>
<div>&gt; </div>
<div>&gt; These issues are presented on the A10, A13, A20, A31 and A33.</di=
v>
<div>&gt; The issues of SS module have been fixed on the A83T platform, so,=
 I suggest to</div>
<div>&gt; take more attention to the A83T platform if any interest in the S=
S module.</div>
<div>&gt; </div>
<div>&gt; If any problem, please don't hesitate to contact me(kevin@allwinn=
ertech.com)</div>
<div>&gt; </div>
<div>&gt; or Shuge(shuge-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org).</div>
<div>&gt; </div>
<div>&nbsp;</div>
<div>Thanks for your answer, I have loose hours on that problem.</div>
<div>&nbsp;</div>
<div>Perhaps you could update all datasheet/user manual about this known is=
sue ?</div>
<div>&nbsp;</div>
<div>Regards</div>
<div>&nbsp;</div>
<div>-- </div>
<div>You received this message because you are subscribed to the Google Gro=
ups "linux-sunxi" group.</div>
<div>To unsubscribe from this group and stop receiving emails from it, send=
 an email to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org</div>
<div>For more options, visit https://groups.google.com/d/optout.</div>
</div></blockquote>
</body></html>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;linux-sunxi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">linux-s=
unxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

------=_001_NextPart002818716325_=------
