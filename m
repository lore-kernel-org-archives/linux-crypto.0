From: behanw@converseincode.com
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/omap_sham.c
Date: Fri,  5 Sep 2014 16:01:04 -0700
Message-ID: <1409958064-753-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	Behan Webster <behanw@converseincode.com>,
	Mark Charlebois <charlebm@gmail.com>,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61811 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIEXBQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 19:01:16 -0400
Received: by mail-pd0-f178.google.com with SMTP id p10so35606pdj.23
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2014 16:01:16 -0700 (PDT)
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
 drivers/crypto/omap-sham.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 710d863..dcbfd35 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -949,17 +949,16 @@ static int omap_sham_finish_hmac(struct ahash_req=
uest *req)
 	struct omap_sham_hmac_ctx *bctx =3D tctx->base;
 	int bs =3D crypto_shash_blocksize(bctx->shash);
 	int ds =3D crypto_shash_digestsize(bctx->shash);
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(bctx->shash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(bctx->shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
=20
-	desc.shash.tfm =3D bctx->shash;
-	desc.shash.flags =3D 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
+	shash->tfm =3D bctx->shash;
+	shash->flags =3D 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
=20
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, bctx->opad, bs) ?:
-	       crypto_shash_finup(&desc.shash, req->result, ds, req->result);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, bctx->opad, bs) ?:
+	       crypto_shash_finup(shash, req->result, ds, req->result);
 }
=20
 static int omap_sham_finish(struct ahash_request *req)
@@ -1118,18 +1117,17 @@ static int omap_sham_update(struct ahash_reques=
t *req)
 	return omap_sham_enqueue(req, OP_UPDATE);
 }
=20
-static int omap_sham_shash_digest(struct crypto_shash *shash, u32 flag=
s,
+static int omap_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
 				  const u8 *data, unsigned int len, u8 *out)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(shash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
=20
-	desc.shash.tfm =3D shash;
-	desc.shash.flags =3D flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm =3D tfm;
+	shash->flags =3D flags & CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-	return crypto_shash_digest(&desc.shash, data, len, out);
+	return crypto_shash_digest(shash, data, len, out);
 }
=20
 static int omap_sham_final_shash(struct ahash_request *req)
--=20
1.9.1
