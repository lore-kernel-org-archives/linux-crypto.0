From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 14/17] crypto: Add userspace report for pcompress type
 algorithms
Date: Tue, 27 Sep 2011 07:46:32 +0200
Message-ID: <20110927054631.GQ1808@secunet.com>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:32994 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1I0Fqf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:46:35 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcompress.c         |   18 ++++++++++++++++++
 include/linux/cryptouser.h |    5 +++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index f7c4a7d..fefda78 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -24,6 +24,8 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
 
 #include <crypto/compress.h>
 #include <crypto/internal/compress.h>
@@ -46,6 +48,21 @@ static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_comp rpcomp;
+
+	snprintf(rpcomp.type, CRYPTO_MAX_ALG_NAME, "%s", "pcomp");
+
+	NLA_PUT(skb, CRYPTOCFGA_REPORT_COMPRESS,
+		sizeof(struct crypto_report_comp), &rpcomp);
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
@@ -60,6 +77,7 @@ static const struct crypto_type crypto_pcomp_type = {
 #ifdef CONFIG_PROC_FS
 	.show		= crypto_pcomp_show,
 #endif
+	.report		= crypto_pcomp_report,
 	.maskclear	= ~CRYPTO_ALG_TYPE_MASK,
 	.maskset	= CRYPTO_ALG_TYPE_MASK,
 	.type		= CRYPTO_ALG_TYPE_PCOMPRESS,
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
index 48030c7..c8c1dfc 100644
--- a/include/linux/cryptouser.h
+++ b/include/linux/cryptouser.h
@@ -40,6 +40,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_HASH,		/* struct crypto_report_hash */
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
+	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
 	__CRYPTOCFGA_MAX
 
 #define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
@@ -81,3 +82,7 @@ struct crypto_report_aead {
 	unsigned int maxauthsize;
 	unsigned int ivsize;
 };
+
+struct crypto_report_comp {
+	char type[CRYPTO_MAX_NAME];
+};
-- 
1.7.0.4
