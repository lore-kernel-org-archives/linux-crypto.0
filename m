From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ixp4xx - include fix
Date: Thu, 5 Apr 2012 20:36:54 +0800
Message-ID: <20120405123654.GB22120@gondor.apana.org.au>
References: <20120322120010.GA4695@FLYC077.flytronic.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: =?utf-8?B?TWljaGHFgiBXcsOzYmVs?= <michal.wrobel@flytronic.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:40874 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588Ab2DEMg5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Apr 2012 08:36:57 -0400
Content-Disposition: inline
In-Reply-To: <20120322120010.GA4695@FLYC077.flytronic.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 22, 2012 at 12:00:10PM +0000, Micha=C5=82 Wr=C3=B3bel wrote=
:
> Before commit de47725421ad5627a5c905f4e40bb844ebc06d29 ("include: rep=
lace
> linux/module.h with "struct module" wherever possible") <linux/module=
=2Eh> was
> implicitly included through <linux/platform_device.h> -> <linux/devic=
e.h>.
>=20
> Signed-off-by: Micha=C5=82 Wr=C3=B3bel <michal.wrobel@flytronic.pl>

Patch applied to crypto.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
