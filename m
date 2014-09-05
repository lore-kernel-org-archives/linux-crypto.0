From: behanw@converseincode.com
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/mv_cesa.c
Date: Fri,  5 Sep 2014 15:59:41 -0700
Message-ID: <1409957981-31166-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>,
	Mark Charlebois <charlebm@gmail.com>,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38519 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaIEW7z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 18:59:55 -0400
Received: by mail-pa0-f51.google.com with SMTP id rd3so22987829pab.24
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2014 15:59:55 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Behan Webster <behanw@converseincode.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C9=
9
compliant equivalent. This patch allocates the appropriate amount of me=
mory
using an char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared =
with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that ca=
n
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long =
long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
---
 drivers/crypto/mv_cesa.c | 46 +++++++++++++++++++++++-----------------=
------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 29d0ee5..0d92c85 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -402,26 +402,25 @@ static int mv_hash_final_fallback(struct ahash_re=
quest *req)
 {
 	const struct mv_tfm_hash_ctx *tfm_ctx =3D crypto_tfm_ctx(req->base.tf=
m);
 	struct mv_req_hash_ctx *req_ctx =3D ahash_request_ctx(req);
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm_ctx->fallback)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(tfm_ctx->fallback)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
 	int rc;
=20
-	desc.shash.tfm =3D tfm_ctx->fallback;
-	desc.shash.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm =3D tfm_ctx->fallback;
+	shash->flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
 	if (unlikely(req_ctx->first_hash)) {
-		crypto_shash_init(&desc.shash);
-		crypto_shash_update(&desc.shash, req_ctx->buffer,
+		crypto_shash_init(shash);
+		crypto_shash_update(shash, req_ctx->buffer,
 				    req_ctx->extra_bytes);
 	} else {
 		/* only SHA1 for now....
 		 */
-		rc =3D mv_hash_import_sha1_ctx(req_ctx, &desc.shash);
+		rc =3D mv_hash_import_sha1_ctx(req_ctx, shash);
 		if (rc)
 			goto out;
 	}
-	rc =3D crypto_shash_final(&desc.shash, req->result);
+	rc =3D crypto_shash_final(shash, req->result);
 out:
 	return rc;
 }
@@ -794,23 +793,24 @@ static int mv_hash_setkey(struct crypto_ahash *tf=
m, const u8 * key,
 	ss =3D crypto_shash_statesize(ctx->base_hash);
=20
 	{
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(ctx->base_hash)];
-		} desc;
+		char desc[sizeof(struct shash_desc) +
+			crypto_shash_descsize(ctx->base_hash)]
+			CRYPTO_MINALIGN_ATTR;
+		struct shash_desc *shash =3D (struct shash_desc *)desc;
+
 		unsigned int i;
 		char ipad[ss];
 		char opad[ss];
=20
-		desc.shash.tfm =3D ctx->base_hash;
-		desc.shash.flags =3D crypto_shash_get_flags(ctx->base_hash) &
+		shash->tfm =3D ctx->base_hash;
+		shash->flags =3D crypto_shash_get_flags(ctx->base_hash) &
 		    CRYPTO_TFM_REQ_MAY_SLEEP;
=20
 		if (keylen > bs) {
 			int err;
=20
 			err =3D
-			    crypto_shash_digest(&desc.shash, key, keylen, ipad);
+			    crypto_shash_digest(shash, key, keylen, ipad);
 			if (err)
 				return err;
=20
@@ -826,12 +826,12 @@ static int mv_hash_setkey(struct crypto_ahash *tf=
m, const u8 * key,
 			opad[i] ^=3D 0x5c;
 		}
=20
-		rc =3D crypto_shash_init(&desc.shash) ? :
-		    crypto_shash_update(&desc.shash, ipad, bs) ? :
-		    crypto_shash_export(&desc.shash, ipad) ? :
-		    crypto_shash_init(&desc.shash) ? :
-		    crypto_shash_update(&desc.shash, opad, bs) ? :
-		    crypto_shash_export(&desc.shash, opad);
+		rc =3D crypto_shash_init(shash) ? :
+		    crypto_shash_update(shash, ipad, bs) ? :
+		    crypto_shash_export(shash, ipad) ? :
+		    crypto_shash_init(shash) ? :
+		    crypto_shash_update(shash, opad, bs) ? :
+		    crypto_shash_export(shash, opad);
=20
 		if (rc =3D=3D 0)
 			mv_hash_init_ivs(ctx, ipad, opad);
--=20
1.9.1
