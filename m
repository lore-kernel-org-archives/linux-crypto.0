From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/6] crypto: camellia - rename camellia module to
 camellia_generic
Date: Mon, 05 Mar 2012 20:26:32 +0200
Message-ID: <20120305182631.25411.75411.stgit@localhost6.localdomain6>
References: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:36427 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2CES1H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Mar 2012 13:27:07 -0500
In-Reply-To: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rename camellia module to camellia_generic to allow optimized assembler
implementations to autoload with module-alias.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Makefile   |    3 ++-
 crypto/camellia.c |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index f638063..4355943 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -67,7 +67,8 @@ obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
-obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
+camellia_generic-y = camellia.o
+obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
 obj-$(CONFIG_CRYPTO_ARC4) += arc4.o
diff --git a/crypto/camellia.c b/crypto/camellia.c
index 7ae4bcd..f07a19b 100644
--- a/crypto/camellia.c
+++ b/crypto/camellia.c
@@ -1096,3 +1096,4 @@ module_exit(camellia_fini);
 
 MODULE_DESCRIPTION("Camellia Cipher Algorithm");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("camellia");
