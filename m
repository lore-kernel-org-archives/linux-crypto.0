From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v3 12/17] crypto: Add userspace report for aead type
 algorithms
Date: Wed, 21 Sep 2011 11:08:49 +0200
Message-ID: <20110921090849.GQ1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:35797 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1IUJIx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Sep 2011 05:08:53 -0400
Content-Disposition: inline
In-Reply-To: <20110921085855.GE1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/aead.c              |   25 +++++++++++++++++++++++++
 include/linux/cryptouser.h |    9 +++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 6729e8f..bb641bd 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -109,6 +111,28 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_aead raead;
+	struct aead_alg *aead = &alg->cra_aead;
+
+	snprintf(raead.type, CRYPTO_MAX_ALG_NAME, "%s", "aead");
+	snprintf(raead.geniv, CRYPTO_MAX_ALG_NAME, "%s",
+		 aead->geniv ?: "<built-in>");
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
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
@@ -130,6 +154,7 @@ const struct crypto_type crypto_aead_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_aead_show,
 #endif
+	.report = crypto_aead_report,
 };
 EXPORT_SYMBOL_GPL(crypto_aead_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 9d7a981..72aff18 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -42,6 +42,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_GIVCIPHER,	/* struct crypto_report_blkcipher */
+	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -76,3 +77,11 @@ struct crypto_report_blkcipher {
 	unsigned int max_keysize;
 	unsigned int ivsize;
 };
+
+struct crypto_report_aead {
+	char type[CRYPTO_MAX_NAME];
+	char geniv[CRYPTO_MAX_NAME];
+	unsigned int blocksize;
+	unsigned int maxauthsize;
+	unsigned int ivsize;
+};
-- 
1.7.0.4
