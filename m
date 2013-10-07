From: "Christoph G. Baumann" <cb@sgoc.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Mon, 7 Oct 2013 11:50:39 +0200 (CEST)
Message-ID: <632804650.191291.1381139440065.open-xchange@email.1und1.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <201309261407.33923.marex@denx.de> <5245AC5B.80800@gmail.com> <201309280535.33672.marex@denx.de>
Reply-To: "Christoph G. Baumann" <cb@sgoc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Fabio Estevam <festevam@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Tobias Rauter <tobiasrauter@gmail.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3JGJu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Oct 2013 05:50:56 -0400
In-Reply-To: <201309280535.33672.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Marek,

>=C2=A0Marek=C2=A0Vasut=C2=A0<marex@denx.de>=C2=A0hat=C2=A0am=C2=A028.=C2=
=A0September=C2=A02013=C2=A0um=C2=A005:35=C2=A0geschrieben:
> [...]
>=C2=A0>=C2=A0>=C2=A03)=C2=A0What=C2=A0are=C2=A0those=C2=A0ugly=C2=A0ne=
w=C2=A0IOCTLs=C2=A0in=C2=A0the=C2=A0dcp.c=C2=A0driver?
>=C2=A0>=C2=A0
>=C2=A0>=C2=A0When=C2=A0I=C2=A0firstly=C2=A0posted=C2=A0the=C2=A0driver=
=C2=A0in=C2=A0the=C2=A0mailinglist,=C2=A0there=C2=A0where=C2=A0one
>=C2=A0>=C2=A0person=C2=A0who=C2=A0actually=C2=A0used=C2=A0this=C2=A0in=
terface=C2=A0(it=C2=A0was=C2=A0introduced=C2=A0in
>=C2=A0>=C2=A0Freescale's=C2=A0SDK)=C2=A0to=C2=A0use=C2=A0the=C2=A0OTP=C2=
=A0keys=C2=A0for=C2=A0crypto.=C2=A0As=C2=A0far=C2=A0as=C2=A0I=C2=A0have
>=C2=A0>=C2=A0seen,=C2=A0the=C2=A0crypto=C2=A0API=C2=A0does=C2=A0not=C2=
=A0support=C2=A0such=C2=A0keys=C2=A0(i.e.=C2=A0there=C2=A0seems=C2=A0to
>=C2=A0>=C2=A0be=C2=A0no=C2=A0way=C2=A0to=C2=A0tell=C2=A0a=C2=A0driver=C2=
=A0to=C2=A0use=C2=A0some=C2=A0kind=C2=A0of=C2=A0special=C2=A0keys=C2=A0=
-=C2=A0which
>=C2=A0>=C2=A0are=C2=A0not=C2=A0delivered=C2=A0by=C2=A0the=C2=A0user=C2=
=A0-=C2=A0via=C2=A0the=C2=A0API).
>=C2=A0>=C2=A0Therefore=C2=A0I=C2=A0added=C2=A0this=C2=A0miscdevice=C2=A0=
and=C2=A0adopted=C2=A0Freescale's=C2=A0interface.
>=C2=A0
>=C2=A0The=C2=A0keys=C2=A0are=C2=A0programmed=C2=A0into=C2=A0the=C2=A0O=
TP=C2=A0registers,=C2=A0correct?=C2=A0There=C2=A0is=C2=A0OCOTP=C2=A0dri=
ver=C2=A0
>=C2=A0for=C2=A0the=C2=A0MX23/MX28=C2=A0OTP=C2=A0hardware.=C2=A0This=C2=
=A0is=C2=A0what=C2=A0should=C2=A0have=C2=A0been=C2=A0used=C2=A0then.
>=C2=A0
>=C2=A0NOTE:=C2=A0This=C2=A0IOCTL=C2=A0interface=C2=A0seems=C2=A0like=C2=
=A0quite=C2=A0an=C2=A0abusive=C2=A0way=C2=A0to=C2=A0allow=C2=A0userland=
=C2=A0to=C2=A0
>=C2=A0access=C2=A0the=C2=A0crypto=C2=A0API=C2=A0in=C2=A0kernel.=C2=A0I=
=C2=A0understand=C2=A0this=C2=A0is=C2=A0used=C2=A0by=C2=A0some=C2=A0Fre=
escale=C2=A0
>=C2=A0tool,=C2=A0but=C2=A0won't=C2=A0it=C2=A0be=C2=A0better=C2=A0to=C2=
=A0fix=C2=A0the=C2=A0Freescale=C2=A0tool=C2=A0instead=C2=A0?


the IOCTL interface is used to AES encrypt a bootstream with the AES ke=
y in
OCOTP.
The idea is that only the DCP can read/access the key once it has been
programmed
into the OCOTP. If the crypto API has means to tell the DCP to use the =
key from
OCOTP, the tool from Freescale is a minor problem.


Regards,
Christoph
