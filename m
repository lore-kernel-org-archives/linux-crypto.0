From: behanw@converseincode.com
Subject: [PATCH v2] crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
Date: Fri,  5 Sep 2014 16:02:43 -0700
Message-ID: <1409958163-3730-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). This patch instead allocates the appropriate amount of=
 memory
using an char array.

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

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Cc: pageexec@freemail.hu
---
 crypto/hmac.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8d9544c..f2da806 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -52,20 +52,19 @@ static int hmac_setkey(struct crypto_shash *parent,
 	struct hmac_ctx *ctx =3D align_ptr(opad + ss,
 					 crypto_tfm_ctx_alignment());
 	struct crypto_shash *hash =3D ctx->hash;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(hash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(hash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
 	unsigned int i;
=20
-	desc.shash.tfm =3D hash;
-	desc.shash.flags =3D crypto_shash_get_flags(parent) &
-			    CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm =3D hash;
+	shash->flags =3D crypto_shash_get_flags(parent)
+		& CRYPTO_TFM_REQ_MAY_SLEEP;
=20
 	if (keylen > bs) {
 		int err;
=20
-		err =3D crypto_shash_digest(&desc.shash, inkey, keylen, ipad);
+		err =3D crypto_shash_digest(shash, inkey, keylen, ipad);
 		if (err)
 			return err;
=20
@@ -81,12 +80,12 @@ static int hmac_setkey(struct crypto_shash *parent,
 		opad[i] ^=3D 0x5c;
 	}
=20
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, ipad, bs) ?:
-	       crypto_shash_export(&desc.shash, ipad) ?:
-	       crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, opad, bs) ?:
-	       crypto_shash_export(&desc.shash, opad);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, ipad, bs) ?:
+	       crypto_shash_export(shash, ipad) ?:
+	       crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, opad, bs) ?:
+	       crypto_shash_export(shash, opad);
 }
=20
 static int hmac_export(struct shash_desc *pdesc, void *out)
--=20
1.9.1
