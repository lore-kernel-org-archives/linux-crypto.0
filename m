From: behanw@converseincode.com
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/.../qat_algs.c
Date: Fri,  5 Sep 2014 16:01:47 -0700
Message-ID: <1409958107-1805-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bruce.w.allan@intel.com, john.griffin@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	qat-linux@intel.com, torvalds@linux-foundation.org,
	Behan Webster <behanw@converseincode.com>,
	Mark Charlebois <charlebm@gmail.com>,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
	tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61165 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaIEXCA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 19:02:00 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so23157252pab.29
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2014 16:01:59 -0700 (PDT)
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
 drivers/crypto/qat/qat_common/qat_algs.c | 33 ++++++++++++++++--------=
--------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/=
qat/qat_common/qat_algs.c
index 59df488..3090333 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -152,10 +152,9 @@ static int qat_alg_do_precomputes(struct icp_qat_h=
w_auth_algo_blk *hash,
 				  const uint8_t *auth_key,
 				  unsigned int auth_keylen, uint8_t *auth_state)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ctx->hash_tfm)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(ctx->hash_tfm)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash =3D (struct shash_desc *)desc;
 	struct sha1_state sha1;
 	struct sha256_state sha256;
 	struct sha512_state sha512;
@@ -167,12 +166,12 @@ static int qat_alg_do_precomputes(struct icp_qat_=
hw_auth_algo_blk *hash,
 	__be64 *hash512_state_out;
 	int i, offset;
=20
-	desc.shash.tfm =3D ctx->hash_tfm;
-	desc.shash.flags =3D 0x0;
+	shash->tfm =3D ctx->hash_tfm;
+	shash->flags =3D 0x0;
=20
 	if (auth_keylen > block_size) {
 		char buff[SHA512_BLOCK_SIZE];
-		int ret =3D crypto_shash_digest(&desc.shash, auth_key,
+		int ret =3D crypto_shash_digest(shash, auth_key,
 					      auth_keylen, buff);
 		if (ret)
 			return ret;
@@ -195,10 +194,10 @@ static int qat_alg_do_precomputes(struct icp_qat_=
hw_auth_algo_blk *hash,
 		*opad_ptr ^=3D 0x5C;
 	}
=20
-	if (crypto_shash_init(&desc.shash))
+	if (crypto_shash_init(shash))
 		return -EFAULT;
=20
-	if (crypto_shash_update(&desc.shash, ipad, block_size))
+	if (crypto_shash_update(shash, ipad, block_size))
 		return -EFAULT;
=20
 	hash_state_out =3D (__be32 *)hash->sha.state1;
@@ -206,19 +205,19 @@ static int qat_alg_do_precomputes(struct icp_qat_=
hw_auth_algo_blk *hash,
=20
 	switch (ctx->qat_hash_alg) {
 	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export(&desc.shash, &sha1))
+		if (crypto_shash_export(shash, &sha1))
 			return -EFAULT;
 		for (i =3D 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out =3D cpu_to_be32(*(sha1.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export(&desc.shash, &sha256))
+		if (crypto_shash_export(shash, &sha256))
 			return -EFAULT;
 		for (i =3D 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out =3D cpu_to_be32(*(sha256.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export(&desc.shash, &sha512))
+		if (crypto_shash_export(shash, &sha512))
 			return -EFAULT;
 		for (i =3D 0; i < digest_size >> 3; i++, hash512_state_out++)
 			*hash512_state_out =3D cpu_to_be64(*(sha512.state + i));
@@ -227,10 +226,10 @@ static int qat_alg_do_precomputes(struct icp_qat_=
hw_auth_algo_blk *hash,
 		return -EFAULT;
 	}
=20
-	if (crypto_shash_init(&desc.shash))
+	if (crypto_shash_init(shash))
 		return -EFAULT;
=20
-	if (crypto_shash_update(&desc.shash, opad, block_size))
+	if (crypto_shash_update(shash, opad, block_size))
 		return -EFAULT;
=20
 	offset =3D round_up(qat_get_inter_state_size(ctx->qat_hash_alg), 8);
@@ -239,19 +238,19 @@ static int qat_alg_do_precomputes(struct icp_qat_=
hw_auth_algo_blk *hash,
=20
 	switch (ctx->qat_hash_alg) {
 	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export(&desc.shash, &sha1))
+		if (crypto_shash_export(shash, &sha1))
 			return -EFAULT;
 		for (i =3D 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out =3D cpu_to_be32(*(sha1.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export(&desc.shash, &sha256))
+		if (crypto_shash_export(shash, &sha256))
 			return -EFAULT;
 		for (i =3D 0; i < digest_size >> 2; i++, hash_state_out++)
 			*hash_state_out =3D cpu_to_be32(*(sha256.state + i));
 		break;
 	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export(&desc.shash, &sha512))
+		if (crypto_shash_export(shash, &sha512))
 			return -EFAULT;
 		for (i =3D 0; i < digest_size >> 3; i++, hash512_state_out++)
 			*hash512_state_out =3D cpu_to_be64(*(sha512.state + i));
--=20
1.9.1
