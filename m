Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41301 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388337AbeK3BsQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 20:48:16 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so2150253wrs.8
        for <linux-crypto@vger.kernel.org>; Thu, 29 Nov 2018 06:42:39 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 05/11] crypto: tool: getstat: convert user space example to the new crypto_user_stat uapi
Date: Thu, 29 Nov 2018 14:42:20 +0000
Message-Id: <1543502546-23870-6-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
References: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the getstat example tool to the recent changes done in crypto_user_stat
- changed all stats to u64
- separated struct stats for each crypto alg

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 tools/crypto/getstat.c | 54 +++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/crypto/getstat.c b/tools/crypto/getstat.c
index 24115173a483..57fbb94608d4 100644
--- a/tools/crypto/getstat.c
+++ b/tools/crypto/getstat.c
@@ -152,53 +152,53 @@ static int get_stat(const char *drivername)
 
 	if (tb[CRYPTOCFGA_STAT_HASH]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_HASH];
-		struct crypto_stat *rhash =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tHash\n\tHash: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_hash *rhash =
+			(struct crypto_stat_hash *)RTA_DATA(rta);
+		printf("%s\tHash\n\tHash: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rhash->stat_hash_cnt, rhash->stat_hash_tlen,
 			rhash->stat_hash_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_COMPRESS]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_COMPRESS];
-		struct crypto_stat *rblk =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tCompress\n\tCompress: %u bytes: %llu\n\tDecompress: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_compress *rblk =
+			(struct crypto_stat_compress *)RTA_DATA(rta);
+		printf("%s\tCompress\n\tCompress: %llu bytes: %llu\n\tDecompress: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rblk->stat_compress_cnt, rblk->stat_compress_tlen,
 			rblk->stat_decompress_cnt, rblk->stat_decompress_tlen,
 			rblk->stat_compress_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_ACOMP]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_ACOMP];
-		struct crypto_stat *rcomp =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tACompress\n\tCompress: %u bytes: %llu\n\tDecompress: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_compress *rcomp =
+			(struct crypto_stat_compress *)RTA_DATA(rta);
+		printf("%s\tACompress\n\tCompress: %llu bytes: %llu\n\tDecompress: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rcomp->stat_compress_cnt, rcomp->stat_compress_tlen,
 			rcomp->stat_decompress_cnt, rcomp->stat_decompress_tlen,
 			rcomp->stat_compress_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_AEAD]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_AEAD];
-		struct crypto_stat *raead =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tAEAD\n\tEncrypt: %u bytes: %llu\n\tDecrypt: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_aead *raead =
+			(struct crypto_stat_aead *)RTA_DATA(rta);
+		printf("%s\tAEAD\n\tEncrypt: %llu bytes: %llu\n\tDecrypt: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			raead->stat_encrypt_cnt, raead->stat_encrypt_tlen,
 			raead->stat_decrypt_cnt, raead->stat_decrypt_tlen,
 			raead->stat_aead_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_BLKCIPHER]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_BLKCIPHER];
-		struct crypto_stat *rblk =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tCipher\n\tEncrypt: %u bytes: %llu\n\tDecrypt: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_cipher *rblk =
+			(struct crypto_stat_cipher *)RTA_DATA(rta);
+		printf("%s\tCipher\n\tEncrypt: %llu bytes: %llu\n\tDecrypt: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rblk->stat_encrypt_cnt, rblk->stat_encrypt_tlen,
 			rblk->stat_decrypt_cnt, rblk->stat_decrypt_tlen,
 			rblk->stat_cipher_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_AKCIPHER]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_AKCIPHER];
-		struct crypto_stat *rblk =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tAkcipher\n\tEncrypt: %u bytes: %llu\n\tDecrypt: %u bytes: %llu\n\tSign: %u\n\tVerify: %u\n\tErrors: %u\n",
+		struct crypto_stat_akcipher *rblk =
+			(struct crypto_stat_akcipher *)RTA_DATA(rta);
+		printf("%s\tAkcipher\n\tEncrypt: %llu bytes: %llu\n\tDecrypt: %llu bytes: %llu\n\tSign: %llu\n\tVerify: %llu\n\tErrors: %llu\n",
 			drivername,
 			rblk->stat_encrypt_cnt, rblk->stat_encrypt_tlen,
 			rblk->stat_decrypt_cnt, rblk->stat_decrypt_tlen,
@@ -206,27 +206,27 @@ static int get_stat(const char *drivername)
 			rblk->stat_akcipher_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_CIPHER]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_CIPHER];
-		struct crypto_stat *rblk =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tcipher\n\tEncrypt: %u bytes: %llu\n\tDecrypt: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_cipher *rblk =
+			(struct crypto_stat_cipher *)RTA_DATA(rta);
+		printf("%s\tcipher\n\tEncrypt: %llu bytes: %llu\n\tDecrypt: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rblk->stat_encrypt_cnt, rblk->stat_encrypt_tlen,
 			rblk->stat_decrypt_cnt, rblk->stat_decrypt_tlen,
 			rblk->stat_cipher_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_RNG]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_RNG];
-		struct crypto_stat *rrng =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tRNG\n\tSeed: %u\n\tGenerate: %u bytes: %llu\n\tErrors: %u\n",
+		struct crypto_stat_rng *rrng =
+			(struct crypto_stat_rng *)RTA_DATA(rta);
+		printf("%s\tRNG\n\tSeed: %llu\n\tGenerate: %llu bytes: %llu\n\tErrors: %llu\n",
 			drivername,
 			rrng->stat_seed_cnt,
 			rrng->stat_generate_cnt, rrng->stat_generate_tlen,
 			rrng->stat_rng_err_cnt);
 	} else if (tb[CRYPTOCFGA_STAT_KPP]) {
 		struct rtattr *rta = tb[CRYPTOCFGA_STAT_KPP];
-		struct crypto_stat *rkpp =
-			(struct crypto_stat *)RTA_DATA(rta);
-		printf("%s\tKPP\n\tSetsecret: %u\n\tGenerate public key: %u\n\tCompute_shared_secret: %u\n\tErrors: %u\n",
+		struct crypto_stat_kpp *rkpp =
+			(struct crypto_stat_kpp *)RTA_DATA(rta);
+		printf("%s\tKPP\n\tSetsecret: %llu\n\tGenerate public key: %llu\n\tCompute_shared_secret: %llu\n\tErrors: %llu\n",
 			drivername,
 			rkpp->stat_setsecret_cnt,
 			rkpp->stat_generate_public_key_cnt,
-- 
2.18.1
