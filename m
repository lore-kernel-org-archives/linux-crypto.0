From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 11/15] crypto: Add userspace report for nivaead type
 algorithms
Date: Wed, 17 Aug 2011 14:15:36 +0200
Message-ID: <20110817121536.GI16877@secunet.com>
References: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46998 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1HQMOk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20110817120859.GX16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/aead.c              |   25 +++++++++++++++++++++++++
 include/linux/cryptouser.h |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 17fec4a..ee5e060 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -192,6 +192,30 @@ static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_aead raead;
+	struct aead_alg *aead = &alg->cra_aead;
+
+	snprintf(raead.type, CRYPTO_MAX_ALG_NAME, "%s", "nivaead");
+	snprintf(raead.geniv, CRYPTO_MAX_ALG_NAME, "%s", aead->geniv);
+	snprintf(raead.async, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_flags & CRYPTO_ALG_ASYNC ? "yes" : "no");
+
+	raead.blocksize = alg->cra_blocksize;
+	raead.maxauthsize = aead->maxauthsize;
+	raead.ivsize = aead->ivsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_NIVAEAD,
+		sizeof(struct crypto_report_aead), &raead);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+
 static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
@@ -213,6 +237,7 @@ const struct crypto_type crypto_nivaead_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_nivaead_show,
 #endif
+	.report = crypto_nivaead_report,
 };
 EXPORT_SYMBOL_GPL(crypto_nivaead_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index c41acbd..ecd13ec 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -40,6 +40,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_ablkcipher */
 	CRYPTOCFGA_REPORT_GIVCIPHER,	/* struct crypto_report_ablkcipher */
 	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
+	CRYPTOCFGA_REPORT_NIVAEAD,	/* struct crypto_report_aead */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
-- 
1.7.0.4
