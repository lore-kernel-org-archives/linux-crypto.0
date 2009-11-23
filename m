From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: move fips_cprng_get_random and
	fips_cprng_reset to CONFIG_CRYPTO_FIPS
Date: Mon, 23 Nov 2009 20:26:09 +0800
Message-ID: <20091123122609.GF6424@gondor.apana.org.au>
References: <1258725019.3562.3.camel@ht.satnam> <20091120153801.GB21197@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
	Jarod Wilson <jarod@redhat.com>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57074 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756997AbZKWM0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2009 07:26:19 -0500
Content-Disposition: inline
In-Reply-To: <20091120153801.GB21197@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 20, 2009 at 10:38:01AM -0500, Neil Horman wrote:
> On Fri, Nov 20, 2009 at 07:20:19PM +0530, Jaswinder Singh Rajput wrot=
e:
> >=20
> > fips_cprng_get_random and fips_cprng_reset is used only by
> > CONFIG_CRYPTO_FIPS. This also fixes compilation warnings:
> >=20
> >  crypto/ansi_cprng.c:360: warning: =E2=80=98fips_cprng_get_random=E2=
=80=99 defined but not used
> >  crypto/ansi_cprng.c:393: warning: =E2=80=98fips_cprng_reset=E2=80=99=
 defined but not used
> >=20
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Yeah, looks good to me, thanks!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Patch applied.  Thanks!
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
