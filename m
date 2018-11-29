Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45426 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388363AbeK3BsV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 20:48:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id v6so2136276wrr.12
        for <linux-crypto@vger.kernel.org>; Thu, 29 Nov 2018 06:42:45 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 11/11] crypto: crypto_user_stat: Add crypto_stats_init
Date: Thu, 29 Nov 2018 14:42:26 +0000
Message-Id: <1543502546-23870-12-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
References: <1543502546-23870-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch add the crypto_stats_init() function.
This will permit to remove some ifdef from __crypto_register_alg().

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/algapi.c        | 10 +++++++---
 include/linux/crypto.h |  3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c0d4f9ef6b0f..8b65ada33e5d 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -258,9 +258,7 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 	list_add(&alg->cra_list, &crypto_alg_list);
 	list_add(&larval->alg.cra_list, &crypto_alg_list);
 
-#ifdef CONFIG_CRYPTO_STATS
-	memset(&alg->stats, 0, sizeof(alg->stats));
-#endif
+	crypto_stats_init(alg);
 
 out:
 	return larval;
@@ -1073,6 +1071,12 @@ int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
 EXPORT_SYMBOL_GPL(crypto_type_has_alg);
 
 #ifdef CONFIG_CRYPTO_STATS
+void crypto_stats_init(struct crypto_alg *alg)
+{
+	memset(&alg->stats, 0, sizeof(alg->stats));
+}
+EXPORT_SYMBOL_GPL(crypto_stats_init);
+
 void crypto_stats_get(struct crypto_alg *alg)
 {
 	crypto_alg_get(alg);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a2967c1a08b1..9850b41e38ae 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -614,6 +614,7 @@ struct crypto_alg {
 } CRYPTO_MINALIGN_ATTR;
 
 #ifdef CONFIG_CRYPTO_STATS
+void crypto_stats_init(struct crypto_alg *alg);
 void crypto_stats_get(struct crypto_alg *alg);
 void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret, struct crypto_alg *alg);
 void crypto_stats_ablkcipher_decrypt(unsigned int nbytes, int ret, struct crypto_alg *alg);
@@ -635,6 +636,8 @@ void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen, int re
 void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg);
 void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret, struct crypto_alg *alg);
 #else
+static inline void crypto_stats_init(struct crypto_alg *alg)
+{}
 static inline void crypto_stats_get(struct crypto_alg *alg)
 {}
 static inline void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret, struct crypto_alg *alg)
-- 
2.18.1
