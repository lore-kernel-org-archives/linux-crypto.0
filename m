From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - add support for LS1021A
Date: Tue, 18 Aug 2015 10:39:55 +0800
Message-ID: <20150818023955.GB4957@gondor.apana.org.au>
References: <1439814250-4221-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57170 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbHRCkC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 22:40:02 -0400
Content-Disposition: inline
In-Reply-To: <1439814250-4221-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 17, 2015 at 03:24:10PM +0300, Horia Geant=C4=83 wrote:
> LS1021A is a QorIQ SoC having little endian CAAM.
>=20
> There are a few differences b/w QorIQ and i.MX from CAAM perspective:
>=20
> 1. i.MX platforms are somewhat special wrt. 64-bit registers:
> -big endian format at 64-bit level: MSW at address+0 and LSW at addre=
ss+4
> -little endian format at 32-bit level (within MSW and LSW)
> and thus need special handling.
>=20
> 2. No CCM (clock controller module) for QorIQ.
> No CAAM clocks to enable / disable.
>=20
> A new Kconfig option - CRYPTO_DEV_FSL_CAAM_LE - is added to indicate
> CAAM is little endian (*). It is hidden from the user (to avoid
> misconfiguration); when adding support for a new platform with LE CAA=
M,
> either the Kconfig needs to be updated or the corresponding defconfig
> needs to indicate that CAAM is LE.
> (*) Using a DT property to provide CAAM endianness would not allow
> for the ifdeffery.
>=20
> In order to keep changes to a minimum, the following changes
> are postponed:
> -endianness fix of the last word in the S/G (rsvd2, bpid, offset),
> fields are always 0 anyway;
> -S/G format fix for i.MX7 (yes, i.MX7 support was not added yet,
> but still...)
>=20
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Patch applied.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
