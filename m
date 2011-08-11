From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 11/16] crypto: Add userspace report for aead type algorithms
Date: Thu, 11 Aug 2011 13:32:55 +0200
Message-ID: <20110811113255.GO16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56361 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab1HKLcX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:32:23 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/aead.c              |   31 +++++++++++++++++++++++++++++++
 include/linux/cryptouser.h |   10 ++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 6729e8f..25793b7 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -21,6 +21,8 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -109,6 +111,32 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_aead raead;
+	struct aead_alg *aead = &alg->cra_aead;
+
+	snprintf(raead.type, CRYPTO_MAX_ALG_NAME, "%s", "aead");
+	snprintf(raead.geniv, CRYPTO_MAX_ALG_NAME, "%s",
+		 aead->geniv ?: "<built-in>");
+	snprintf(raead.async, CRYPTO_MAX_ALG_NAME, "%s",
+		 alg->cra_flags & CRYPTO_ALG_ASYNC ? "yes" : "no");
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
@@ -130,6 +158,9 @@ const struct crypto_type crypto_aead_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_aead_show,
 #endif
+#ifdef CONFIG_CRYPTO_USER
+	.report = crypto_aead_report,
+#endif
 };
 EXPORT_SYMBOL_GPL(crypto_aead_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index e2c76f7..04762d7 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -40,6 +40,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_ABLKCIPHER,	/* struct crypto_report_ablkcipher */
 	CRYPTOCFGA_REPORT_GIVCIPHER,	/* struct crypto_report_ablkcipher */
+	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -99,3 +100,12 @@ struct crypto_report_ablkcipher {
 	unsigned int max_keysize;
 	unsigned int ivsize;
 };
+
+struct crypto_report_aead {
+	char type[CRYPTO_MAX_NAME];
+	char async[CRYPTO_MAX_NAME];
+	char geniv[CRYPTO_MAX_NAME];
+	unsigned int blocksize;
+	unsigned int maxauthsize;
+	unsigned int ivsize;
+};
-- 
1.7.0.4
