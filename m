From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: make Open Firmware device id constant
Date: Sun, 17 Jan 2010 21:54:19 +1100
Message-ID: <20100117105419.GB32270@gondor.apana.org.au>
References: <4B4C2C69.9000804@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Julia Lawall <julia@diku.dk>, cocci@diku.dk
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33262 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953Ab0AQKyY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2010 05:54:24 -0500
Content-Disposition: inline
In-Reply-To: <4B4C2C69.9000804@freemail.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 12, 2010 at 09:01:45AM +0100, N=E9meth M=E1rton wrote:
> From: M=E1rton N=E9meth <nm127@freemail.hu>
>=20
> The match_table field of the struct of_device_id is constant in <linu=
x/of_platform.h>
> so it is worth to make the initialization data also constant.

Applied to cryptodev.  Thanks.
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
