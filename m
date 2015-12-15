From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 4/4] crypto: ux500: Use precalculated hash from headers
Date: Tue, 15 Dec 2015 14:00:23 +0100
Message-ID: <1450184423-31155-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1450184423-31155-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, davem@davemloft.net,
	geert+renesas@glider.be, herbert@gondor.apana.org.au,
	luis@debethencourt.com, maxime.ripard@free-electrons.com,
	vinod.koul@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450184423-31155-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Precalculated hash for empty message are now present in hash headers.
This patch just use them.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/ux500/Kconfig          |  1 +
 drivers/crypto/ux500/hash/hash_core.c | 20 ++------------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ux500/Kconfig b/drivers/crypto/ux500/Kconfig
index 3079644..23abde6 100644
--- a/drivers/crypto/ux500/Kconfig
+++ b/drivers/crypto/ux500/Kconfig
@@ -18,6 +18,7 @@ config CRYPTO_DEV_UX500_HASH
         tristate "UX500 crypto driver for HASH block"
         depends on CRYPTO_DEV_UX500
         select CRYPTO_HASH
+	select CRYPTO_SHA1
         help
           This selects the hash driver for the UX500_HASH hardware.
           Depends on UX500/STM DMA if running in DMA mode.
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index f47d112..d6fdc58 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -41,22 +41,6 @@ static int hash_mode;
 module_param(hash_mode, int, 0);
 MODULE_PARM_DESC(hash_mode, "CPU or DMA mode. CPU = 0 (default), DMA = 1");
 
-/**
- * Pre-calculated empty message digests.
- */
-static const u8 zero_message_hash_sha1[SHA1_DIGEST_SIZE] = {
-	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
-	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
-	0xaf, 0xd8, 0x07, 0x09
-};
-
-static const u8 zero_message_hash_sha256[SHA256_DIGEST_SIZE] = {
-	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
-	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
-	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
-	0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55
-};
-
 /* HMAC-SHA1, no key */
 static const u8 zero_message_hmac_sha1[SHA1_DIGEST_SIZE] = {
 	0xfb, 0xdb, 0x1d, 0x1b, 0x18, 0xaa, 0x6c, 0x08,
@@ -242,13 +226,13 @@ static int get_empty_message_digest(
 
 	if (HASH_OPER_MODE_HASH == ctx->config.oper_mode) {
 		if (HASH_ALGO_SHA1 == ctx->config.algorithm) {
-			memcpy(zero_hash, &zero_message_hash_sha1[0],
+			memcpy(zero_hash, &sha1_zero_message_hash[0],
 			       SHA1_DIGEST_SIZE);
 			*zero_hash_size = SHA1_DIGEST_SIZE;
 			*zero_digest = true;
 		} else if (HASH_ALGO_SHA256 ==
 				ctx->config.algorithm) {
-			memcpy(zero_hash, &zero_message_hash_sha256[0],
+			memcpy(zero_hash, &sha256_zero_message_hash[0],
 			       SHA256_DIGEST_SIZE);
 			*zero_hash_size = SHA256_DIGEST_SIZE;
 			*zero_digest = true;
-- 
2.4.10
