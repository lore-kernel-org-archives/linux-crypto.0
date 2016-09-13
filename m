From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v7 3/9] crypto: scomp - add scratch buffers allocator and deallocator
Date: Tue, 13 Sep 2016 13:49:35 +0100
Message-ID: <1473770981-9869-4-git-send-email-giovanni.cabiddu@intel.com>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:62118 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754725AbcIMMt4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:49:56 -0400
In-Reply-To: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add utility functions to allocate and deallocate scratch buffers used by
software implementations of scomp

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/scompress.c                  |   41 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/scompress.h |    2 +
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 9f426cc..385e1da 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/crypto.h>
+#include <linux/vmalloc.h>
 #include <crypto/algapi.h>
 #include <linux/cryptouser.h>
 #include <net/netlink.h>
@@ -28,6 +29,46 @@
 
 static const struct crypto_type crypto_scomp_type;
 
+void crypto_scomp_free_scratches(void * __percpu *scratches)
+{
+	int i;
+
+	if (!scratches)
+		return;
+
+	for_each_possible_cpu(i)
+		vfree(*per_cpu_ptr(scratches, i));
+
+	free_percpu(scratches);
+}
+EXPORT_SYMBOL_GPL(crypto_scomp_free_scratches);
+
+void * __percpu *crypto_scomp_alloc_scratches(unsigned long size)
+{
+	void * __percpu *scratches;
+	int i;
+
+	scratches = alloc_percpu(void *);
+	if (!scratches)
+		return NULL;
+
+	for_each_possible_cpu(i) {
+		void *scratch;
+
+		scratch = vmalloc_node(size, cpu_to_node(i));
+		if (!scratch)
+			goto error;
+		*per_cpu_ptr(scratches, i) = scratch;
+	}
+
+	return scratches;
+
+error:
+	crypto_scomp_free_scratches(scratches);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(crypto_scomp_alloc_scratches);
+
 #ifdef CONFIG_NET
 static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 8708611..a3547c1 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -109,6 +109,8 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
 struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
 void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
+void crypto_scomp_free_scratches(void * __percpu *scratches);
+void * __percpu *crypto_scomp_alloc_scratches(unsigned long size);
 
 /**
  * crypto_register_scomp() -- Register synchronous compression algorithm
-- 
1.7.4.1
