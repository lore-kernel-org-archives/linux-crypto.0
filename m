From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Fri, 17 Apr 2015 17:49:10 +0200
Message-ID: <20150417154910.GS15807@lukather>
References: <87r3rom2qu.fsf@natisbad.org>
 <20150413201146.GL18660@io.lakedaemon.net>
 <20150417103356.6ce78145@bbrezillon>
 <20150417103946.2a46c243@bbrezillon>
 <5531040D.4000007@free-electrons.com>
 <20150417161922.54adec64@bbrezillon>
 <20150417143216.GQ15807@lukather>
 <55311B6B.2090108@free-electrons.com>
 <20150417145022.GR15807@lukather>
 <55312063.7050206@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LXqH7sWsIplhrbjF"
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Arnaud Ebalard <arno@natisbad.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eran Ben-Avi <benavi@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>, devicetree@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	linux-crypto@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lior Amsalem <alior@marvell.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53973 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753955AbbDQPzK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 11:55:10 -0400
Content-Disposition: inline
In-Reply-To: <55312063.7050206@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--LXqH7sWsIplhrbjF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2015 at 05:01:55PM +0200, Gregory CLEMENT wrote:
> On 17/04/2015 16:50, Maxime Ripard wrote:
> > On Fri, Apr 17, 2015 at 04:40:43PM +0200, Gregory CLEMENT wrote:
> >> Hi Maxime,
> >>
> >> On 17/04/2015 16:32, Maxime Ripard wrote:
> >>> On Fri, Apr 17, 2015 at 04:19:22PM +0200, Boris Brezillon wrote:
> >>>> Hi Gregory,
> >>>>
> >>>> On Fri, 17 Apr 2015 15:01:01 +0200
> >>>> Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:
> >>>>
> >>>>> Hi Boris,
> >>>>>
> >>>>> On 17/04/2015 10:39, Boris Brezillon wrote:
> >>>>>> On Fri, 17 Apr 2015 10:33:56 +0200
> >>>>>> Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
> >>>>>>
> >>>>>>> Hi Jason,
> >>>>>>>
> >>>>>>> On Mon, 13 Apr 2015 20:11:46 +0000
> >>>>>>> Jason Cooper <jason@lakedaemon.net> wrote:
> >>>>>>>
> >>>>>>>>>
> >>>>>>>>>> I'd appreciate if we'd look into it.  I understand from on-lis=
t and
> >>>>>>>>>> off-list discussion that the rewrite was unavoidable.  So I'm =
willing to
> >>>>>>>>>> concede that.  Giving people time to migrate from old to new w=
hile still
> >>>>>>>>>> being able to update for other security fixes seems reasonable.
> >>>>>>>>>
> >>>>>>>>> Jason, what do you think of the approach above?=20
> >>>>>>>>
> >>>>>>>> I say keep it simple.  We shouldn't use the DT changes to trigge=
r one
> >>>>>>>> vice the other.  We need to be able to build both, but only load=
 one at
> >>>>>>>> a time.  If that's anything other than simple to do, then we mak=
e it a
> >>>>>>>> Kconfig binary choice and move on.
> >>>>>>>
> >>>>>>> Actually I was planning to handle it with a Kconfig dependency ru=
le
> >>>>>>> (NEW_DRIVER depends on !OLD_DRIVER and OLD_DRIVER depends
> >>>>>>> on !NEW_DRIVER).
> >>>>>>> I don't know how to make it a runtime check without adding new
> >>>>>>> compatible strings for the kirkwood, dove and orion platforms, an=
d I'm
> >>>>>>> sure sure this is a good idea.
> >>>>>>   ^ not
> >>>>>>
> >>>>>>> Do you have any ideas ?
> >>>>>
> >>>>> You use devm_ioremap_resource() in the new driver, so if the old one
> >>>>> is already loaded the memory region will be already hold and the new
> >>>>> driver will simply fail during the probe. So for this part it is OK.
> >>>>
> >>>> I like the idea :-).
> >>>
> >>> Not really, how do you know which device is going to be probed? For
> >>> that matter, it's pretty much random, and you have no control over it.
> >>>
> >>> Why not just have a choice option, and select which one you want to
> >>> enable?
> >>
> >> Because you can't prevent an user to build a module, then modifying the
> >> configuration and building the other module.
> >=20
> > Well, actually, you don't even know if it's going to be a module. You
> > might very well have both drivers compiled statically in the kernel
> > image, and this is where the trouble begins.
>=20
> No it won't be possible, Boris already speak about this issue (see below):
> "Actually I was planning to handle it with a Kconfig dependency rule
> (NEW_DRIVER depends on !OLD_DRIVER and OLD_DRIVER depends
> on !NEW_DRIVER)."

Which is a circular dependency and won't work.

> >> So even if there is a choice at build time, and I think that it is
> >> something expected for the v2, we still need preventing having the
> >> both drivers trying accessing the same hardware in the same time.
> >=20
> > Of course, but this is already there, and doesn't really address the
> > same issue.
>=20
> This was the only issue remaining, (see below again):
> "I don't know how to make it a runtime check ". And my last emails
> was bout it.

Ok, my bad then :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--LXqH7sWsIplhrbjF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVMSt2AAoJEBx+YmzsjxAgGpEP/RwgySofHxRN38Jwsx07jQJE
2J+Cwf8u+ih+y9sDtPon2K0BBSp2vGHZsnVL9+ppXpWwDD4cMOp7X6O5m94Di9bG
nEPcMAGD3W02HK2MDtyr87FYyJoVaCw+rw/YSoTFX/nG+qyzEzy+N6eogAVfqN7h
xxDZq51ChwGs7g2qTYOJeudnlAzD87oz5oV2y6w3Z75ko/1DIzFI1xq7wbMt5Gmt
9atfRajyOdowpxjaFE5MRoConcU16rD1Cp+MRP3BzS/lO1igZemLYMoQZAF2oHYE
zex+nVs32ZC7DoZTlcxY2CeJ2eY4d126W82Q1gcB6OV9/a5pFjXn0mRG+ZieVn5H
TeVs5n5VAnhSAeHrhir4JxpUC3fFIg7Qk+IqHRsvPbNeeOyHjjXcV4py0cy+4iij
tosE86hO7ywOD2IaOocqJgxsK1C9UelLctFzadYv7Bi4V6xjs0ntufr862FZLC73
ug+8g9CaAqqH0lrGkeNs3yI8KrPZKCTqegB09TV+4wAd8z+ivrjmuEZWiJNONKGJ
6+PrLQzaTt0EW7nqjgrUYoeOy8g+JOZ2HDQOWfvN0FmsnY9cu/vkguUeQUyvfSw2
9lBtrClSvy6pSBhBkVtFJrlBiv8nHcs+NW1Xi8CQT3nI1VV2KKkR8z1A0HSexDl7
T0hXzB955gd9Tss+WzK/
=c2xZ
-----END PGP SIGNATURE-----

--LXqH7sWsIplhrbjF--
