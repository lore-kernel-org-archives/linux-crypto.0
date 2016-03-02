From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 02 Mar 2016 15:20:04 +0100
Message-ID: <1547276.hIHXt6xUvB@positron.chronox.de>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com> <20160302095351.GB2384@sbenedet-virtual-machine> <CACXcFmmuBJR93nW+-Qp2Yo95EXzuz+RXyH9_hw+RVXFqYZtgrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60472 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbcCBOUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 09:20:12 -0500
In-Reply-To: <CACXcFmmuBJR93nW+-Qp2Yo95EXzuz+RXyH9_hw+RVXFqYZtgrw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 2. M=E4rz 2016, 08:03:44 schrieb Sandy Harris:

Hi Sandy,

> Salvatore Benedetto <salvatore.benedetto@intel.com> wrote:
> >> > > > +static int dh_check_params_length(unsigned int p_len)
> >> > > > +{
> >> > > > +       switch (p_len) {
> >> > > > +       case 768:
> >> > > > +       case 1024:
> >> > > > +       case 1536:
> >> > > > +       case 2048:
> >> > > > +       case 3072:
> >> > > > +       case 4096:
> >> > > > +               return 0;
> >> > > > +       }
> >> > > > +       return -EINVAL;
> >> > > > +}
>=20
> As far back as 1999, the FreeS/WAN project refused to
> implement the 768-bit IPsec group 1 (even though it was
> the only one required by the RFCs) because it was not thought
> secure enough. I think the most-used group was 1536-bit
> group 5; it wasn't in the original RFCs but nearly everyone
> implemented it.
>=20
> >> And besides, I would like to disallow all < 2048 right from the st=
art.
>=20
> I'm not up-to-date on the performance of attacks. You may be right,
> or perhaps the minimum should be even higher. Certainly there is
> no reason to support 768 or 1024-bit groups.
>=20
> On the other hand, we should consider keeping the 1536-bit
> group since it is very widely used, likely including by people
> we'll want to interoperate with.

Considering the recent attacks which kind of broke DH <=3D 768, all sma=
ller than=20
1024 is not to be used any more. Even 1024 bit is not too far off from =
768 so=20
I would consider not using 1024 to keep a safety margin.

It is widely suggested to use 2048 and higher. But for compatibility, I=
 agree=20
with 1536.

However, that leaves us with the open question for the upper bound. I h=
ave no=20
idea which sizes hardware may implement. But considering that OpenSSH u=
ses DH=20
up to and including 8192 these days (see /etc/ssh/moduli), I would sugg=
est to=20
allow 8192 too.

In addition, we should all be prepared to increase the limit with a rea=
sonable=20
effort. Thus, if we have implementations covering hardware support, the=
y=20
should cope with reasonable efforts.

Ciao
Stephan
