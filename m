Return-Path: <SRS0=i4aU=AQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21198C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 09:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F16B220772
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Jul 2020 09:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgGEJVO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Jul 2020 05:21:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6818 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgGEJVN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Jul 2020 05:21:13 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2295893E2C09468F22C4;
        Sun,  5 Jul 2020 17:21:10 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.202.129) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sun, 5 Jul 2020 17:21:01 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <akpm@linux-foundation.org>, <linux-crypto@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Barry Song <song.bao.hua@hisilicon.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v3 1/3] crypto: permit users to specify numa node of acomp hardware
Date:   Sun, 5 Jul 2020 21:18:58 +1200
Message-ID: <20200705091900.29232-2-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200705091900.29232-1-song.bao.hua@hisilicon.com>
References: <20200705091900.29232-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.202.129]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For a Linux server with NUMA, there are possibly multiple (de)compressors
which are either local or remote to some NUMA node. Some drivers will
automatically use the (de)compressor near the CPU calling acomp_alloc().
However, it is not necessarily correct because users who send acomp_req
could be from different NUMA node with the CPU which allocates acomp.

Just like kernel has kmalloc() and kmalloc_node(), here crypto can have
same support.

Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 -v3: use kzalloc_node() according to Herbert Xu's comment

 crypto/acompress.c         |  8 ++++++++
 crypto/api.c               | 24 +++++++++++++++---------
 crypto/internal.h          | 23 +++++++++++++++++++----
 include/crypto/acompress.h | 18 ++++++++++++++++++
 include/linux/crypto.h     |  2 ++
 5 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 84a76723e851..c32c72048a1c 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -109,6 +109,14 @@ struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp);
 
+struct crypto_acomp *crypto_alloc_acomp_node(const char *alg_name, u32 type,
+					u32 mask, int node)
+{
+	return crypto_alloc_tfm_node(alg_name, &crypto_acomp_type, type, mask,
+				node);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_acomp_node);
+
 struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
diff --git a/crypto/api.c b/crypto/api.c
index edcf690800d4..5d8fe60b36c1 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -433,8 +433,9 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
 
-void *crypto_create_tfm(struct crypto_alg *alg,
-			const struct crypto_type *frontend)
+void *crypto_create_tfm_node(struct crypto_alg *alg,
+			const struct crypto_type *frontend,
+			int node)
 {
 	char *mem;
 	struct crypto_tfm *tfm = NULL;
@@ -445,12 +446,13 @@ void *crypto_create_tfm(struct crypto_alg *alg,
 	tfmsize = frontend->tfmsize;
 	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg);
 
-	mem = kzalloc(total, GFP_KERNEL);
+	mem = kzalloc_node(total, GFP_KERNEL, node);
 	if (mem == NULL)
 		goto out_err;
 
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
+	tfm->node = node;
 
 	err = frontend->init_tfm(tfm);
 	if (err)
@@ -472,7 +474,7 @@ void *crypto_create_tfm(struct crypto_alg *alg,
 out:
 	return mem;
 }
-EXPORT_SYMBOL_GPL(crypto_create_tfm);
+EXPORT_SYMBOL_GPL(crypto_create_tfm_node);
 
 struct crypto_alg *crypto_find_alg(const char *alg_name,
 				   const struct crypto_type *frontend,
@@ -490,11 +492,13 @@ struct crypto_alg *crypto_find_alg(const char *alg_name,
 EXPORT_SYMBOL_GPL(crypto_find_alg);
 
 /*
- *	crypto_alloc_tfm - Locate algorithm and allocate transform
+ *	crypto_alloc_tfm_node - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
  *	@frontend: Frontend algorithm type
  *	@type: Type of algorithm
  *	@mask: Mask for type comparison
+ *	@node: NUMA node in which users desire to put requests, if node is
+ *		NUMA_NO_NODE, it means users have no special requirement.
  *
  *	crypto_alloc_tfm() will first attempt to locate an already loaded
  *	algorithm.  If that fails and the kernel supports dynamically loadable
@@ -509,8 +513,10 @@ EXPORT_SYMBOL_GPL(crypto_find_alg);
  *
  *	In case of error the return value is an error pointer.
  */
-void *crypto_alloc_tfm(const char *alg_name,
-		       const struct crypto_type *frontend, u32 type, u32 mask)
+
+void *crypto_alloc_tfm_node(const char *alg_name,
+		       const struct crypto_type *frontend, u32 type, u32 mask,
+		       int node)
 {
 	void *tfm;
 	int err;
@@ -524,7 +530,7 @@ void *crypto_alloc_tfm(const char *alg_name,
 			goto err;
 		}
 
-		tfm = crypto_create_tfm(alg, frontend);
+		tfm = crypto_create_tfm_node(alg, frontend, node);
 		if (!IS_ERR(tfm))
 			return tfm;
 
@@ -542,7 +548,7 @@ void *crypto_alloc_tfm(const char *alg_name,
 
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
+EXPORT_SYMBOL_GPL(crypto_alloc_tfm_node);
 
 /*
  *	crypto_destroy_tfm - Free crypto transform
diff --git a/crypto/internal.h b/crypto/internal.h
index ff06a3bd1ca1..1b92a5a61852 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -68,13 +68,28 @@ void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
-void *crypto_create_tfm(struct crypto_alg *alg,
-			const struct crypto_type *frontend);
+void *crypto_create_tfm_node(struct crypto_alg *alg,
+			const struct crypto_type *frontend, int node);
+
+static inline void *crypto_create_tfm(struct crypto_alg *alg,
+			const struct crypto_type *frontend)
+{
+	return crypto_create_tfm_node(alg, frontend, NUMA_NO_NODE);
+}
+
 struct crypto_alg *crypto_find_alg(const char *alg_name,
 				   const struct crypto_type *frontend,
 				   u32 type, u32 mask);
-void *crypto_alloc_tfm(const char *alg_name,
-		       const struct crypto_type *frontend, u32 type, u32 mask);
+
+void *crypto_alloc_tfm_node(const char *alg_name,
+		       const struct crypto_type *frontend, u32 type, u32 mask,
+		       int node);
+
+static inline void *crypto_alloc_tfm(const char *alg_name,
+		       const struct crypto_type *frontend, u32 type, u32 mask)
+{
+	return crypto_alloc_tfm_node(alg_name, frontend, type, mask, NUMA_NO_NODE);
+}
 
 int crypto_probing_notify(unsigned long val, void *v);
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 2b4d2b06ccbd..fcde59c65a81 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -106,6 +106,24 @@ struct acomp_alg {
  */
 struct crypto_acomp *crypto_alloc_acomp(const char *alg_name, u32 type,
 					u32 mask);
+/**
+ * crypto_alloc_acomp_node() -- allocate ACOMPRESS tfm handle with desired NUMA node
+ * @alg_name:	is the cra_name / name or cra_driver_name / driver name of the
+ *		compression algorithm e.g. "deflate"
+ * @type:	specifies the type of the algorithm
+ * @mask:	specifies the mask for the algorithm
+ * @node:	specifies the NUMA node the ZIP hardware belongs to
+ *
+ * Allocate a handle for a compression algorithm. Drivers should try to use
+ * (de)compressors on the specified NUMA node.
+ * The returned struct crypto_acomp is the handle that is required for any
+ * subsequent API invocation for the compression operations.
+ *
+ * Return:	allocated handle in case of success; IS_ERR() is true in case
+ *		of an error, PTR_ERR() returns the error code.
+ */
+struct crypto_acomp *crypto_alloc_acomp_node(const char *alg_name, u32 type,
+					u32 mask, int node);
 
 static inline struct crypto_tfm *crypto_acomp_tfm(struct crypto_acomp *tfm)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 763863dbc079..ce144dfc2edc 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -595,6 +595,8 @@ int crypto_has_alg(const char *name, u32 type, u32 mask);
 struct crypto_tfm {
 
 	u32 crt_flags;
+
+	int node;
 	
 	void (*exit)(struct crypto_tfm *tfm);
 	
-- 
2.27.0


