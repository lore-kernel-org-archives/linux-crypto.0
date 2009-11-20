From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: move fips_cprng_get_random and
	fips_cprng_reset to CONFIG_CRYPTO_FIPS
Date: Fri, 20 Nov 2009 10:38:01 -0500
Message-ID: <20091120153801.GB21197@hmsreliant.think-freely.org>
References: <1258725019.3562.3.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jarod Wilson <jarod@redhat.com>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50400 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZKTPiV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Nov 2009 10:38:21 -0500
Content-Disposition: inline
In-Reply-To: <1258725019.3562.3.camel@ht.satnam>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 20, 2009 at 07:20:19PM +0530, Jaswinder Singh Rajput wrote:
>=20
> fips_cprng_get_random and fips_cprng_reset is used only by
> CONFIG_CRYPTO_FIPS. This also fixes compilation warnings:
>=20
>  crypto/ansi_cprng.c:360: warning: =E2=80=98fips_cprng_get_random=E2=80=
=99 defined but not used
>  crypto/ansi_cprng.c:393: warning: =E2=80=98fips_cprng_reset=E2=80=99=
 defined but not used
>=20
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Yeah, looks good to me, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
