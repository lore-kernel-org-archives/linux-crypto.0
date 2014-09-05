From: behanw@converseincode.com
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/ccp/ccp-crypto-sha.c
Date: Fri,  5 Sep 2014 15:59:04 -0700
Message-ID: <1409957944-30173-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

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

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/c=
cp-crypto-sha.c
index 873f234..29f9fda 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -198,10 +198,11 @@ static int ccp_sha_setkey(struct crypto_ahash *tf=
m, const u8 *key,
 {
 	struct ccp_ctx *ctx =3D crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct crypto_shash *shash =3D ctx->u.sha.hmac_tfm;
-	struct {
-		struct shash_desc sdesc;
-		char ctx[crypto_shash_descsize(shash)];
-	} desc;
+
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *sdesc =3D (struct shash_desc *)desc;
+
 	unsigned int block_size =3D crypto_shash_blocksize(shash);
 	unsigned int digest_size =3D crypto_shash_digestsize(shash);
 	int i, ret;
@@ -216,11 +217,11 @@ static int ccp_sha_setkey(struct crypto_ahash *tf=
m, const u8 *key,
=20
 	if (key_len > block_size) {
 		/* Must hash the input key */
-		desc.sdesc.tfm =3D shash;
-		desc.sdesc.flags =3D crypto_ahash_get_flags(tfm) &
+		sdesc->tfm =3D shash;
+		sdesc->flags =3D crypto_ahash_get_flags(tfm) &
 			CRYPTO_TFM_REQ_MAY_SLEEP;
=20
-		ret =3D crypto_shash_digest(&desc.sdesc, key, key_len,
+		ret =3D crypto_shash_digest(sdesc, key, key_len,
 					  ctx->u.sha.key);
 		if (ret) {
 			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
--=20
1.9.1
