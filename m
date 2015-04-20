From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/15] crypto: api - Add crypto_alg_extsize helper
Date: Mon, 20 Apr 2015 13:39:00 +0800
Message-ID: <E1Yk4Q8-0004ob-1W@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38871 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbbDTFjD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:03 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4Q8-0003CJ-9A
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:00 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a crypto_alg_extsize helper that can be used
by algorithm types such as pcompress and shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c   |    6 ++++++
 crypto/internal.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 2d0a1c6..25c8117 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -964,6 +964,12 @@ void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(crypto_xor);
 
+unsigned int crypto_alg_extsize(struct crypto_alg *alg)
+{
+	return alg->cra_ctxsize;
+}
+EXPORT_SYMBOL_GPL(crypto_alg_extsize);
+
 static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
diff --git a/crypto/internal.h b/crypto/internal.h
index bd39bfc..ed7a70c 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -103,6 +103,8 @@ int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
 int crypto_probing_notify(unsigned long val, void *v);
 
+unsigned int crypto_alg_extsize(struct crypto_alg *alg);
+
 static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 {
 	atomic_inc(&alg->cra_refcnt);
