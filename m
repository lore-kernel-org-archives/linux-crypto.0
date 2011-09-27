From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 13/17] crypto: Add userspace report for nivaead type
 algorithms
Date: Tue, 27 Sep 2011 07:45:44 +0200
Message-ID: <20110927054544.GP1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:32988 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1I0Fpr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:45:47 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/aead.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index bb641bd..701556f 100644
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
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_AEAD,
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
 
-- 
1.7.0.4
