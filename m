From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 15/17] crypto: Add userspace report for rng type
 algorithms
Date: Tue, 27 Sep 2011 07:47:11 +0200
Message-ID: <20110927054711.GR1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:33002 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1I0FrO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:47:14 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/rng.c               |   20 ++++++++++++++++++++
 include/linux/cryptouser.h |    6 ++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 45229ae..feb7de0 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -21,6 +21,8 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 static DEFINE_MUTEX(crypto_default_rng_lock);
 struct crypto_rng *crypto_default_rng;
@@ -58,6 +60,23 @@ static int crypto_init_rng_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	return 0;
 }
 
+static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_rng rrng;
+
+	snprintf(rrng.type, CRYPTO_MAX_ALG_NAME, "%s", "rng");
+
+	rrng.seedsize = alg->cra_rng.seedsize;
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_RNG,
+		sizeof(struct crypto_report_rng), &rrng);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
@@ -78,6 +97,7 @@ const struct crypto_type crypto_rng_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_rng_show,
 #endif
+	.report = crypto_rng_report,
 };
 EXPORT_SYMBOL_GPL(crypto_rng_type);
 
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index c8c1dfc..ed8a40e 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -41,6 +41,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
 	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
+	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -86,3 +87,8 @@ struct crypto_report_aead {
 struct crypto_report_comp {
 	char type[CRYPTO_MAX_NAME];
 };
+
+struct crypto_report_rng {
+	char type[CRYPTO_MAX_NAME];
+	unsigned int seedsize;
+};
-- 
1.7.0.4
