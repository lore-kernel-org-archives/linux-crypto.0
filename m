From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [CRYPTO] rmd128: Fix endian problems
Date: Tue, 20 May 2008 10:28:32 +0800
Message-ID: <20080520022832.GA6604@gondor.apana.org.au>
References: <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <12111465553916-git-send-email-rueegsegger@swiss-it.ch> <20080519200145.GB16813@Chamillionaire.breakpoint.cc> <4831E50B.4060101@swiss-it.ch> <20080519205944.GC16813@Chamillionaire.breakpoint.cc> <4831F010.5020202@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Adrian-Ken =?iso-8859-1?Q?R=FCegsegger?= <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42747 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752853AbYETC2o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 May 2008 22:28:44 -0400
Content-Disposition: inline
In-Reply-To: <4831F010.5020202@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 19, 2008 at 11:24:32PM +0200, Adrian-Ken R=FCegsegger wrote=
:
>
> >> If there are no objections I will prepare patches for the other RI=
PEMD modules and submit all of them in one patch set.
> > Any objections on moving ripemd.h from include/crypto into crypto?
>=20
> Not from my side. I put it there because the SHA header file is in th=
e same place.

OK it's moved.

Cheers,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
