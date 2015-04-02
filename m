From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: AW: problem with testing a CTR block cipher
 mode which is partially working
Date: Thu, 02 Apr 2015 21:02:42 +0200
Message-ID: <551D9252.4070509@gmail.com>
References: <55198F14.1090902@gmail.com>, 	<12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>, 	<551AE140.3000209@gmail.com>, 	<2015040110063394945846@gmail.com>, 	<551BD38B.6050307@gmail.com> <2015040210102714744761@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
 "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBVNE62UAKGQEOI4DZVY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <2015040210102714744761-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On 04/02/15 04:10, kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> Thanks for your answer, I have loose hours on that problem.
> I'm sorry to hear that.
> =20
>> Perhaps you could update all datasheet/user manual about this known issu=
e ?
> We have updated the user manual and datasheet, the latest version is 1.3 =
for=20
> A20 which is released in Oct. 2014. The CTR block mode is not support.
> You can download it from the github: https://github.com/allwinner-zh/docu=
ments=20
> and check the details of the SS moudle.

Sorry, I believed to have the latest user manual.

Great thanks for the information.

Regards

>=20
> Best Regards,
> -------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
----------------------------------------------------
> kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
>=20
>     =20
>     *From:* Corentin LABBE <mailto:clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>     *Date:* 2015-04-01 19:16
>     *To:* linux-sunxi <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>; linux-crypto=
@vger.kernel.org <mailto:linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>     *Subject:* Re: [linux-sunxi] Re: AW: problem with testing a CTR block=
 cipher mode which is partially working
>     On 04/01/15 04:06, kevin.z.m.zh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>     > Dear All,
>     >
>     >
>     > About the SS module, there is some detail information.
>     > There is some issues on the SS hardware module, the issues make the=
 some
>     > AES/DES/3DS algorithm be not available.
>     > 1. The byte order of the counter is wrong, make the result error, s=
o, the CTR
>     > mode is not available.
>     > 2. Hardware don't support the continuous subcontracting, make the C=
TS mode is
>     > not available.
>     > 3. Another issue need be taken attention is that hardware will modi=
fy the key
>     > register when do AES encrypt, so, it need software to restore the k=
ey register
>     >
>     > when doing every frame.
>     >
>     > These issues are presented on the A10, A13, A20, A31 and A33.
>     > The issues of SS module have been fixed on the A83T platform, so, I=
 suggest to
>     > take more attention to the A83T platform if any interest in the SS =
module.
>     >
>     > If any problem, please don't hesitate to contact me(kevin@allwinner=
tech.com)
>     >
>     > or Shuge(shuge-0TFLnhJekD6UEPyfVivIlAC/G2K4zDHf@public.gmane.org).
>     >
>     =20
>     Thanks for your answer, I have loose hours on that problem.
>     =20
>     Perhaps you could update all datasheet/user manual about this known i=
ssue ?
>     =20
>     Regards
>     =20
>     --=20
>     You received this message because you are subscribed to the Google Gr=
oups "linux-sunxi" group.
>     To unsubscribe from this group and stop receiving emails from it, sen=
d an email to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
>     For more options, visit https://groups.google.com/d/optout.
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org <mailto:linux-sunxi+unsu=
bscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>.
> For more options, visit https://groups.google.com/d/optout.

--=20
You received this message because you are subscribed to the Google Groups "=
linux-sunxi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to linux-sunxi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
