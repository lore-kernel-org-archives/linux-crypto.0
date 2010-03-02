From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ahash - Fix handling of unaligned buffers
Date: Tue, 2 Mar 2010 22:37:31 +0800
Message-ID: <20100302143731.GA4120@gondor.apana.org.au>
References: <ac67d9131002230350o9618b9apd111f0da1bba15b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Szilveszter Ordog <slipszi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47907 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753246Ab0CBOhf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 09:37:35 -0500
Content-Disposition: inline
In-Reply-To: <ac67d9131002230350o9618b9apd111f0da1bba15b1@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 23, 2010 at 11:50:01AM +0000, Szilveszter Ordog wrote:
> The correct way to calculate the start of the aligned part of an
> unaligned buffer is:
>=20
>   offset =3D ALIGN(offset, alignmask + 1);
>=20
> However, crypto_hash_walk_done() has:
>=20
>   offset +=3D alignmask - 1;
>   offset =3D ALIGN(offset, alignmask + 1);
>=20
> which actually skips a whole block unless offset % (alignmask + 1) =3D=
=3D 1.
>=20
> This patch fixes the problem.
>=20
> Signed-off-by: Szilveszter =D6rd=F6g <slipszi@gmail.com>

I think you did find a bug, but it's not what you think it is :)

When we get an unaligned buffer, we first process the bit from the
start to the first aligned address.  Once we get to the aligned
address everything happens as usual.

So where this code is, we're trying to move to the next aligned
address, and as ALIGN rounds down, we need to add alignmask.
So the bug is the fact that we're adding alignmask - 1.

Were you able to reproduce this? If so please give this patch a
spin.

commit 483b84aa69382d581f272e882158b91387fa2b7a
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Mar 2 22:36:33 2010 +0800

    crypto: hash - Fix SG walk on unaligned addresses
   =20
    When we do an SG walk on an unaligned address that is exactly 1
    modulo the alignment, we end up hashing some of the data twice.
   =20
    Reported-by: Szilveszter Ordog <slipszi@gmail.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 33a4ff4..b52eb6d 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -78,7 +78,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *wa=
lk, int err)
 	walk->data -=3D walk->offset;
=20
 	if (nbytes && walk->offset & alignmask && !err) {
-		walk->offset +=3D alignmask - 1;
+		walk->offset +=3D alignmask;
 		walk->offset =3D ALIGN(walk->offset, alignmask + 1);
 		walk->data +=3D walk->offset;
=20
Thanks,
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
