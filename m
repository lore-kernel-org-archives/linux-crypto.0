From: Marek Vasut <marex@denx.de>
Subject: [PATCH 1/4] crypto: geode: Kill AES_MIN_BLOCK_SIZE
Date: Wed, 14 May 2014 11:36:38 +0200
Message-ID: <1400060201-11519-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	=?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Michal Ludvig <michal@logix.cz>,
	Varun Wadekar <vwadekar@nvidia.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-geode@lists.infradead.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60918 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaENJgt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:36:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is actually defined in include/crypto/aes.h , no need to have
a a different symbol for the same thing twice.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: Eric B=C3=A9nard <eric@eukrea.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Michal Ludvig <michal@logix.cz>
Cc: Varun Wadekar <vwadekar@nvidia.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: linux-geode@lists.infradead.org
---
 drivers/crypto/geode-aes.c | 18 +++++++++---------
 drivers/crypto/geode-aes.h |  1 -
 2 files changed, 9 insertions(+), 10 deletions(-)

NOTE: Geode guys, can you please test this change ?

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 0c9ff49..32001d6b 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -226,7 +226,7 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, cons=
t u8 *in)
 	op->dst =3D (void *) out;
 	op->mode =3D AES_MODE_ECB;
 	op->flags =3D 0;
-	op->len =3D AES_MIN_BLOCK_SIZE;
+	op->len =3D AES_BLOCK_SIZE;
 	op->dir =3D AES_DIR_ENCRYPT;
=20
 	geode_aes_crypt(op);
@@ -247,7 +247,7 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, cons=
t u8 *in)
 	op->dst =3D (void *) out;
 	op->mode =3D AES_MODE_ECB;
 	op->flags =3D 0;
-	op->len =3D AES_MIN_BLOCK_SIZE;
+	op->len =3D AES_BLOCK_SIZE;
 	op->dir =3D AES_DIR_DECRYPT;
=20
 	geode_aes_crypt(op);
@@ -286,7 +286,7 @@ static struct crypto_alg geode_alg =3D {
 							CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=3D	fallback_init_cip,
 	.cra_exit			=3D	fallback_exit_cip,
-	.cra_blocksize		=3D	AES_MIN_BLOCK_SIZE,
+	.cra_blocksize		=3D	AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D	sizeof(struct geode_aes_op),
 	.cra_module			=3D	THIS_MODULE,
 	.cra_u				=3D	{
@@ -320,7 +320,7 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 		op->src =3D walk.src.virt.addr,
 		op->dst =3D walk.dst.virt.addr;
 		op->mode =3D AES_MODE_CBC;
-		op->len =3D nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len =3D nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir =3D AES_DIR_DECRYPT;
=20
 		ret =3D geode_aes_crypt(op);
@@ -352,7 +352,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 		op->src =3D walk.src.virt.addr,
 		op->dst =3D walk.dst.virt.addr;
 		op->mode =3D AES_MODE_CBC;
-		op->len =3D nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len =3D nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir =3D AES_DIR_ENCRYPT;
=20
 		ret =3D geode_aes_crypt(op);
@@ -396,7 +396,7 @@ static struct crypto_alg geode_cbc_alg =3D {
 						CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=3D	fallback_init_blk,
 	.cra_exit			=3D	fallback_exit_blk,
-	.cra_blocksize		=3D	AES_MIN_BLOCK_SIZE,
+	.cra_blocksize		=3D	AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D	sizeof(struct geode_aes_op),
 	.cra_alignmask		=3D	15,
 	.cra_type			=3D	&crypto_blkcipher_type,
@@ -432,7 +432,7 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 		op->src =3D walk.src.virt.addr,
 		op->dst =3D walk.dst.virt.addr;
 		op->mode =3D AES_MODE_ECB;
-		op->len =3D nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len =3D nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir =3D AES_DIR_DECRYPT;
=20
 		ret =3D geode_aes_crypt(op);
@@ -462,7 +462,7 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 		op->src =3D walk.src.virt.addr,
 		op->dst =3D walk.dst.virt.addr;
 		op->mode =3D AES_MODE_ECB;
-		op->len =3D nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len =3D nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir =3D AES_DIR_ENCRYPT;
=20
 		ret =3D geode_aes_crypt(op);
@@ -482,7 +482,7 @@ static struct crypto_alg geode_ecb_alg =3D {
 						CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init			=3D	fallback_init_blk,
 	.cra_exit			=3D	fallback_exit_blk,
-	.cra_blocksize		=3D	AES_MIN_BLOCK_SIZE,
+	.cra_blocksize		=3D	AES_BLOCK_SIZE,
 	.cra_ctxsize		=3D	sizeof(struct geode_aes_op),
 	.cra_alignmask		=3D	15,
 	.cra_type			=3D	&crypto_blkcipher_type,
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index f1855b5..cedf2c5 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -12,7 +12,6 @@
 /* driver logic flags */
 #define AES_IV_LENGTH  16
 #define AES_KEY_LENGTH 16
-#define AES_MIN_BLOCK_SIZE 16
=20
 #define AES_MODE_ECB 0
 #define AES_MODE_CBC 1
--=20
2.0.0.rc0
