From: behanw@converseincode.com
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/n2_core.c
Date: Fri,  5 Sep 2014 16:00:08 -0700
Message-ID: <1409958008-32119-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>,
	Mark Charlebois <charlebm@gmail.com>,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45466 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaIEXAP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 19:00:15 -0400
Received: by mail-pd0-f177.google.com with SMTP id r10so16689222pdi.36
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2014 16:00:15 -0700 (PDT)
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
 drivers/crypto/n2_core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 7263c10..ed142d1 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -445,10 +445,9 @@ static int n2_hmac_async_setkey(struct crypto_ahas=
h *tfm, const u8 *key,
 	struct n2_hmac_ctx *ctx =3D crypto_ahash_ctx(tfm);
 	struct crypto_shash *child_shash =3D ctx->child_shash;
 	struct crypto_ahash *fallback_tfm;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(child_shash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(child_shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
 	int err, bs, ds;
=20
 	fallback_tfm =3D ctx->base.fallback_tfm;
@@ -456,15 +455,15 @@ static int n2_hmac_async_setkey(struct crypto_aha=
sh *tfm, const u8 *key,
 	if (err)
 		return err;
=20
-	desc.shash.tfm =3D child_shash;
-	desc.shash.flags =3D crypto_ahash_get_flags(tfm) &
+	shash->tfm =3D child_shash;
+	shash->flags =3D crypto_ahash_get_flags(tfm) &
 		CRYPTO_TFM_REQ_MAY_SLEEP;
=20
 	bs =3D crypto_shash_blocksize(child_shash);
 	ds =3D crypto_shash_digestsize(child_shash);
 	BUG_ON(ds > N2_HASH_KEY_MAX);
 	if (keylen > bs) {
-		err =3D crypto_shash_digest(&desc.shash, key, keylen,
+		err =3D crypto_shash_digest(shash, key, keylen,
 					  ctx->hash_key);
 		if (err)
 			return err;
--=20
1.9.1
