Return-Path: <SRS0=GKHD=M7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44450 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbeJSUdf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 16:33:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id q6-v6so912007wrw.11
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 05:27:41 -0700 (PDT)
From: Corentin Labbe <clabbe@baylibre.com>
To: dan.carpenter@oracle.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: crypto_user_stat: Zeroize whole structure given to user space
Date: Fri, 19 Oct 2018 12:27:25 +0000
Message-Id: <1539952045-18784-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For preventing un-initilized data to be given to user-space (and so leak
potential useful data), the crypto_stat structure must be correctly
initialised.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: cac5818c25d0 ("crypto: user - Implement a generic crypto statistics")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/crypto_user_stat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 021ad06bbb62..9990c599f648 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -37,6 +37,7 @@ static int crypto_report_aead(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&raead, 0, sizeof(struct crypto_stat));
 	strncpy(raead.type, "aead", sizeof(raead.type));
 
 	v32 = atomic_read(&alg->encrypt_cnt);
@@ -65,6 +66,7 @@ static int crypto_report_cipher(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&rcipher, 0, sizeof(struct crypto_stat));
 	strlcpy(rcipher.type, "cipher", sizeof(rcipher.type));
 
 	v32 = atomic_read(&alg->encrypt_cnt);
@@ -93,6 +95,7 @@ static int crypto_report_comp(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&rcomp, 0, sizeof(struct crypto_stat));
 	strlcpy(rcomp.type, "compression", sizeof(rcomp.type));
 	v32 = atomic_read(&alg->compress_cnt);
 	rcomp.stat_compress_cnt = v32;
@@ -120,6 +123,7 @@ static int crypto_report_acomp(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&racomp, 0, sizeof(struct crypto_stat));
 	strlcpy(racomp.type, "acomp", sizeof(racomp.type));
 	v32 = atomic_read(&alg->compress_cnt);
 	racomp.stat_compress_cnt = v32;
@@ -147,6 +151,7 @@ static int crypto_report_akcipher(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&rakcipher, 0, sizeof(struct crypto_stat));
 	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
 	v32 = atomic_read(&alg->encrypt_cnt);
 	rakcipher.stat_encrypt_cnt = v32;
@@ -177,6 +182,7 @@ static int crypto_report_kpp(struct sk_buff *skb, struct crypto_alg *alg)
 	struct crypto_stat rkpp;
 	u32 v;
 
+	memset(&rkpp, 0, sizeof(struct crypto_stat));
 	strlcpy(rkpp.type, "kpp", sizeof(rkpp.type));
 
 	v = atomic_read(&alg->setsecret_cnt);
@@ -203,6 +209,7 @@ static int crypto_report_ahash(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&rhash, 0, sizeof(struct crypto_stat));
 	strncpy(rhash.type, "ahash", sizeof(rhash.type));
 
 	v32 = atomic_read(&alg->hash_cnt);
@@ -227,6 +234,7 @@ static int crypto_report_shash(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&rhash, 0, sizeof(struct crypto_stat));
 	strncpy(rhash.type, "shash", sizeof(rhash.type));
 
 	v32 = atomic_read(&alg->hash_cnt);
@@ -251,6 +259,7 @@ static int crypto_report_rng(struct sk_buff *skb, struct crypto_alg *alg)
 	u64 v64;
 	u32 v32;
 
+	memset(&rrng, 0, sizeof(struct crypto_stat));
 	strncpy(rrng.type, "rng", sizeof(rrng.type));
 
 	v32 = atomic_read(&alg->generate_cnt);
-- 
2.18.1
