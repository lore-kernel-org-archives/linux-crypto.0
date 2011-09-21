From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 13/17] crypto: Add userspace report for nivaead type
 algorithms
Date: Wed, 21 Sep 2011 11:09:29 +0200
Message-ID: <20110921090928.GR1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:41583 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1IUJJa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:09:30 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/aead.c              |   23 +++++++++++++++++++++++
 include/linux/cryptouser.h |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index bb641bd..44ced3c 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -190,6 +190,28 @@ static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_aead raead;
+	struct aead_alg *aead = &alg->cra_aead;
+
+	snprintf(raead.type, CRYPTO_MAX_ALG_NAME, "%s", "nivaead");
+	snprintf(raead.geniv, CRYPTO_MAX_ALG_NAME, "%s", aead->geniv);
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
@@ -211,6 +233,7 @@ const struct crypto_type crypto_nivaead_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_nivaead_show,
 #endif
+	.report = crypto_nivaead_report,
 };
 EXPORT_SYMBOL_GPL(crypto_nivaead_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 72aff18..b464e4a 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -43,6 +43,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_GIVCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
+	CRYPTOCFGA_REPORT_NIVAEAD,	/* struct crypto_report_aead */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
-- 
1.7.0.4
