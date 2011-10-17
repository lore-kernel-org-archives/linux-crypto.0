From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 5/7] crypto: serpent: rename module from serpent to
	serpent_generic
Date: Tue, 18 Oct 2011 00:03:13 +0300
Message-ID: <20111017210313.13543.21354.stgit@localhost6.localdomain6>
References: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Dag Arne Osvik <osvik@ii.uib.no>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51269 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1JQVDP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 17:03:15 -0400
In-Reply-To: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rename module from serpent.ko to serpent_generic.ko and add module alias. This
is to allow assembler implementation to autoload on 'modprobe serpent'. Also
add driver_name and priority for serpent cipher.

CC: Dag Arne Osvik <osvik@ii.uib.no>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

---

(I choose not to do serpent.c -> serpent_generic.c rename as such patch
triggers lots of checkpatch errors. I can provide rename+style fix
patches, if you want so.)
---
 crypto/Makefile  |    4 +++-
 crypto/serpent.c |    3 +++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index fa8cbbb..dac8979 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -64,7 +64,9 @@ obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_COMMON) += blowfish_common.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
-obj-$(CONFIG_CRYPTO_SERPENT) += serpent.o
+
+serpent_generic-y := serpent.o
+obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
diff --git a/crypto/serpent.c b/crypto/serpent.c
index 867ca93..eb61630 100644
--- a/crypto/serpent.c
+++ b/crypto/serpent.c
@@ -478,6 +478,8 @@ static void serpent_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 static struct crypto_alg serpent_alg = {
 	.cra_name		=	"serpent",
+	.cra_driver_name	=	"serpent-generic",
+	.cra_priority		=	100,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct serpent_ctx),
@@ -588,3 +590,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Serpent and tnepres (kerneli compatible serpent reversed) Cipher Algorithm");
 MODULE_AUTHOR("Dag Arne Osvik <osvik@ii.uib.no>");
 MODULE_ALIAS("tnepres");
+MODULE_ALIAS("serpent");
