From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Date: Thu, 24 Jul 2014 09:40:57 +0800
Message-ID: <20140724014057.GA2448@gondor.apana.org.au>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
 <201407231751.02050.marex@denx.de>
 <53D0045C.6090605@gmail.com>
 <201407232138.35268.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	rdunlap@infradead.org, maxime.ripard@free-electrons.com,
	linux@arm.linux.org.uk, davem@davemloft.net,
	grant.likely@linaro.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37420 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaGXBlx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Jul 2014 21:41:53 -0400
Content-Disposition: inline
In-Reply-To: <201407232138.35268.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 23, 2014 at 09:38:35PM +0200, Marek Vasut wrote:
> On Wednesday, July 23, 2014 at 08:52:12 PM, Corentin LABBE wrote:
> > Le 23/07/2014 17:51, Marek Vasut a =E9crit :
> > > On Wednesday, July 23, 2014 at 04:13:09 PM, Herbert Xu wrote:
> > >> On Wed, Jul 23, 2014 at 04:07:20PM +0200, Marek Vasut wrote:
> > >>> On Wednesday, July 23, 2014 at 03:57:35 PM, Herbert Xu wrote:
> > >>>> On Sat, May 24, 2014 at 02:00:03PM +0200, Marek Vasut wrote:
> > >>>>>> +	}
> > >>>>>> +#endif
> > >>>>>> +
> > >>>>>> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
> > >>>>>> +	err =3D crypto_register_shash(&sunxi_md5_alg);
> > >>>>>=20
> > >>>>> Do not use shash for such device. This is clearly and ahash (=
and
> > >>>>> async in general) device. The rule of a thumb here is that yo=
u use
> > >>>>> sync algos only for devices which have dedicated instructions=
 for
> > >>>>> computing the transformation. For devices which are attached =
to some
> > >>>>> kind of bus, you use async algos (ahash etc).
> > >>>>=20
> > >>>> I'm sorry that I didn't catch this earlier but there is no suc=
h
> > >>>> rule.
> > >>>>=20
> > >>>> Unless you need the async interface you should stick to the sy=
nc
> > >>>> interfaces for the sake of simplicity.
> > >>>>=20
> > >>>> We have a number of existing drivers that are synchronous but
> > >>>> using the async interface.  They should either be converted
> > >>>> over to the sync interface or made interrupt-driven if possibl=
e.
> > >>>=20
> > >>> Sure, but this device is interrupt driven and uses DMA to feed =
the
> > >>> crypto engine, therefore async, right ?
> > >>=20
> > >> If it's interrupt-driven, then yes it would certainly make sense=
 to
> > >> be async.  But all I see is polling in the latest posting, was t=
he
> > >> first version different?
> > >=20
> > > I stand corrected then, sorry.
> > >=20
> > > Is it possible to use DMA to feed the crypto accelerator, Corenti=
n?
> > >=20
> > > Best regards,
> > > Marek Vasut
> >=20
> > Yes, DMA is possible and will be implemented soon.
> > So if I have well understood, I keep using async interface.
>=20
> Yeah, in this case, using DMA and async interface combo is the way to=
 go.

OK fair enough.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
