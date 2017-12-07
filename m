From: Pierre <pinaraf@pinaraf.info>
Subject: Re: [PATCH] Fix NULL pointer deref. on no default_rng
Date: Thu, 07 Dec 2017 11:32:47 +0100
Message-ID: <2556930.8tHcIEql08@peanuts2>
References: <20171112142432.20186-1-pinaraf@pinaraf.info> <20171129063430.GD21575@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3900354.K5vSuZu25U"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55555 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdLGKdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 05:33:15 -0500
In-Reply-To: <20171129063430.GD21575@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart3900354.K5vSuZu25U
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday, November 29, 2017 5:34:30 PM CET you wrote:
> On Sun, Nov 12, 2017 at 03:24:32PM +0100, Pierre Ducroquet wrote:
> > If crypto_get_default_rng returns an error, the
> > function ecc_gen_privkey should return an error.
> > Instead, it currently tries to use the default_rng
> > nevertheless, thus creating a kernel panic with a
> > NULL pointer dereference.
> > Returning the error directly, as was supposedly
> > intended when looking at the code, fixes this.
> > 
> > Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
> 
> Patch applied.  Thanks.

Thanks to you.

Will it be backported to 4.14 and the LTS releases ? Currently, no recent 
debian kernel can boot on my system without that patch (I don't know why 
nobody else noticed that before).

 Pierre
--nextPart3900354.K5vSuZu25U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEds3aTMo5n1dvXH/GYkPWy+GpSGUFAlopGM8ACgkQYkPWy+Gp
SGVk5Q/+OLAWY9NHlOy32lw/RbG7LiNzEW2So2ozw976NkG4tEzvSBiWasTNjLAl
jKiJwCZH2OZlUViVLuJgQ5MbHgD3XkKSl6YIOW8uL/mWx+pArcpM1XQHTnK/+kyV
fLalKrdCRusP3qPAerpDub2misdGtcTzSwhg+q0Bj7wvy8wHpARTADD/z/8Dqo2U
Nv15xeuKTpd1MDFia47gIthrIy/sUNzqT//+43Y3+rQjUqeulRS9Uloyp3YfMBZd
GX3uIuziQOEMskglhKXmm2zSvcyMI6NqnLQIta4n3iPO1lsCZSDDsMTdWy7lTMpe
ZpAgl91s5rGbuoimgXFgbxFj9yDaklLIMgNFK/Sav+wRcC2mYKLkOYVwNIzzoxkp
U08ar1VzqB8lvLCXQfr8wed1uQcZ6pu0YeFj5zoCx7ZhKgTrucKR0ASiMSkfZ5BM
Xd3sbHjzSUA3KzKyp7PywIynGeAExXdz9vDK7FzOi5v90rFZ5yVx7BNB7X/tG36c
Yu43Wq37K727Ls1kOU/+bnOBX6gkK+1zv++VkkVQ7jOxDLuqKaJzuXzAKai+8UuH
O2Asd5KZdqgcLzF+QfSqdq3DYsYymakIu14+49UoApQqkVCUYt3KYK+cYdApTTm+
J1Ns9dLT9//WiOksxA33n8qfM8WXBqbvhTlWlxNYW+2NXWmN8+U=
=OzbK
-----END PGP SIGNATURE-----

--nextPart3900354.K5vSuZu25U--
