Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6626028750B;
	Thu,  4 Sep 2025 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001471; cv=none; b=XGEVVST2s9Coj0nfVUneX5TjXWLPGXsV67SZZJnsbfLHUbE0uc8hPssDOBwctscl1f4nO9Mdz7yuyot5W4Lq55xw4LwWlVp17Zgco86uY86zb5fmG+/7AJ/bm6xkWS9yJiFlrSAbO4rsPqxrOxPUKlhpKLv61SDNbo5dQPJF1E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001471; c=relaxed/simple;
	bh=8TF4xjmWoGOdYT/8DVbqZF0D3lrHFykUz6c839Kqcts=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t1shwGjMpG/BApIrdVu4iFU6IQgw8buMSgR6V0xIY6hjgM7W9H3QEZAQwT3c0M6qj3C++FdGfv6gVyrImUE/IotjL8p1wNNEH+X1WfAMRjpRrBy2kfelhMkhsE6vUpv/5CYWBzPKdTl0chgrWTNV/HS8snjUMNRotxAZVR9rPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CxzHMBW/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CxzHMBW/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjK7014848;
	Thu, 4 Sep 2025 15:57:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ikRMi
	EczWdke0QUL+ICy8xf4FPg4rakv8TJ9XE9hRTQ=; b=CxzHMBW/laB1fz8jHp62X
	bBc4+gBvAqccfkfUd32DPO0Xcvp6BxNo0qFYqXFDegTitnIh2iH/HVQlfJkmESV4
	+0pHLByzy6zXeZi712hVjeL1HdX4RzTOv3mwOcnrJ6tS5Dwx6G9OFFHM6xeB8VRx
	XnYXkPelGURQAM/8xY7v6cB4cB3XVO5ZUAotxWIX+XdIeTTSIGa6h5J3l8iAc67o
	9GUlTME8bdRVDcypWo00p7CZ7e3NGnJDW/YcOLT4UC4um74aPw9ULjWMVYCm0y+M
	cIXHw/75MlayZMGSfj8CTelJJZ9FPqrAQLz/8oqlqEC43kUPSFyCBwzLFYB+D1Eq
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ff3GV040054;
	Thu, 4 Sep 2025 15:57:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtp2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6C000707;
	Thu, 4 Sep 2025 15:57:33 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-43;
	Thu, 04 Sep 2025 15:57:33 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 042/104] crypto: fips140: convert crypto/cryptd.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:14 +0200
Message-Id: <20250904155216.460962-43-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX/zwGMiILdNG4
 JeoZZsnrTHvpJvEWix1pAvhIhL4io0hgo1OTzrnmZwiYP0ME8+lpRPRwSMqQlqXaXDikndz8w28
 lbDTZ4IM7yKcp8b6xh26awTsGC/aWLUm7W5qoUyC1NhnnxPxgesCEMbhJI4fHgp4t2IoHoxYTZe
 rhmLMPevLcsn30XP8iYOft70yqQVZrIOM7Sdf6S4G5KoADKc0yWmsSRkBzJvNL5WJS+6kFh1njG
 8p/oIgC66tHI7bvp9HItrY7X3u3hJLK19yIvVI3tmK9tMRiazjY58VX5QsR8nFu89g8E9Zh0NTM
 o/rgSfGucgCEmwg3XxVZb7S0lkBuCFUXGM6yoKHvc+mKyLPFy3OfW41u6l6F6gGdBLIhPbIQEZI
 8xrjGRKwB+g7fgYQAZ8sOrwctYhRDA==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b6ef b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=vpFfCQ-dUYLQuGTY4IoA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: TO-JCL1i6ictNnsxoYMaInTZEddn5ceX
X-Proofpoint-ORIG-GUID: TO-JCL1i6ictNnsxoYMaInTZEddn5ceX

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_CRYPTD --source crypto/cryptd.c --header include/crypto/cryptd.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/cryptd.c         | 58 ++++++++++++++++++++---------------------
 crypto/fips140-api.c    | 23 ++++++++++++++++
 include/crypto/cryptd.h | 56 +++++++++++++++++++++++++++------------
 3 files changed, 92 insertions(+), 45 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index efff54e707cb..36aa07af29b2 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -646,7 +646,7 @@ static int cryptd_hash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct shash_desc *desc = cryptd_shash_desc(req);
+	struct shash_desc *desc = CRYPTO_API(cryptd_shash_desc)(req);
 
 	desc->tfm = ctx->child;
 
@@ -952,7 +952,7 @@ static struct crypto_template cryptd_tmpl = {
 	.module = THIS_MODULE,
 };
 
-struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
+struct cryptd_skcipher *CRYPTO_API(cryptd_alloc_skcipher)(const char *alg_name,
 					      u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
@@ -977,34 +977,34 @@ struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
 
 	return container_of(tfm, struct cryptd_skcipher, base);
 }
-EXPORT_SYMBOL_GPL(cryptd_alloc_skcipher);
+DEFINE_CRYPTO_API(cryptd_alloc_skcipher);
 
-struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm)
+struct crypto_skcipher *CRYPTO_API(cryptd_skcipher_child)(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
 	return ctx->child;
 }
-EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
+DEFINE_CRYPTO_API(cryptd_skcipher_child);
 
-bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm)
+bool CRYPTO_API(cryptd_skcipher_queued)(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
 	return refcount_read(&ctx->refcnt) - 1;
 }
-EXPORT_SYMBOL_GPL(cryptd_skcipher_queued);
+DEFINE_CRYPTO_API(cryptd_skcipher_queued);
 
-void cryptd_free_skcipher(struct cryptd_skcipher *tfm)
+void CRYPTO_API(cryptd_free_skcipher)(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
 	if (refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_skcipher(&tfm->base);
 }
-EXPORT_SYMBOL_GPL(cryptd_free_skcipher);
+DEFINE_CRYPTO_API(cryptd_free_skcipher);
 
-struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
+struct cryptd_ahash *CRYPTO_API(cryptd_alloc_ahash)(const char *alg_name,
 					u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
@@ -1027,41 +1027,41 @@ struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
 
 	return __cryptd_ahash_cast(tfm);
 }
-EXPORT_SYMBOL_GPL(cryptd_alloc_ahash);
+DEFINE_CRYPTO_API(cryptd_alloc_ahash);
 
-struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm)
+struct crypto_shash *CRYPTO_API(cryptd_ahash_child)(struct cryptd_ahash *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
 
 	return ctx->child;
 }
-EXPORT_SYMBOL_GPL(cryptd_ahash_child);
+DEFINE_CRYPTO_API(cryptd_ahash_child);
 
-struct shash_desc *cryptd_shash_desc(struct ahash_request *req)
+struct shash_desc *CRYPTO_API(cryptd_shash_desc)(struct ahash_request *req)
 {
 	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 	return &rctx->desc;
 }
-EXPORT_SYMBOL_GPL(cryptd_shash_desc);
+DEFINE_CRYPTO_API(cryptd_shash_desc);
 
-bool cryptd_ahash_queued(struct cryptd_ahash *tfm)
+bool CRYPTO_API(cryptd_ahash_queued)(struct cryptd_ahash *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
 
 	return refcount_read(&ctx->refcnt) - 1;
 }
-EXPORT_SYMBOL_GPL(cryptd_ahash_queued);
+DEFINE_CRYPTO_API(cryptd_ahash_queued);
 
-void cryptd_free_ahash(struct cryptd_ahash *tfm)
+void CRYPTO_API(cryptd_free_ahash)(struct cryptd_ahash *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
 
 	if (refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_ahash(&tfm->base);
 }
-EXPORT_SYMBOL_GPL(cryptd_free_ahash);
+DEFINE_CRYPTO_API(cryptd_free_ahash);
 
-struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
+struct cryptd_aead *CRYPTO_API(cryptd_alloc_aead)(const char *alg_name,
 						  u32 type, u32 mask)
 {
 	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
@@ -1084,32 +1084,32 @@ struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
 
 	return __cryptd_aead_cast(tfm);
 }
-EXPORT_SYMBOL_GPL(cryptd_alloc_aead);
+DEFINE_CRYPTO_API(cryptd_alloc_aead);
 
-struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm)
+struct crypto_aead *CRYPTO_API(cryptd_aead_child)(struct cryptd_aead *tfm)
 {
 	struct cryptd_aead_ctx *ctx;
 	ctx = crypto_aead_ctx(&tfm->base);
 	return ctx->child;
 }
-EXPORT_SYMBOL_GPL(cryptd_aead_child);
+DEFINE_CRYPTO_API(cryptd_aead_child);
 
-bool cryptd_aead_queued(struct cryptd_aead *tfm)
+bool CRYPTO_API(cryptd_aead_queued)(struct cryptd_aead *tfm)
 {
 	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(&tfm->base);
 
 	return refcount_read(&ctx->refcnt) - 1;
 }
-EXPORT_SYMBOL_GPL(cryptd_aead_queued);
+DEFINE_CRYPTO_API(cryptd_aead_queued);
 
-void cryptd_free_aead(struct cryptd_aead *tfm)
+void CRYPTO_API(cryptd_free_aead)(struct cryptd_aead *tfm)
 {
 	struct cryptd_aead_ctx *ctx = crypto_aead_ctx(&tfm->base);
 
 	if (refcount_dec_and_test(&ctx->refcnt))
 		crypto_free_aead(&tfm->base);
 }
-EXPORT_SYMBOL_GPL(cryptd_free_aead);
+DEFINE_CRYPTO_API(cryptd_free_aead);
 
 static int __init cryptd_init(void)
 {
@@ -1144,8 +1144,8 @@ static void __exit cryptd_exit(void)
 	crypto_unregister_template(&cryptd_tmpl);
 }
 
-module_init(cryptd_init);
-module_exit(cryptd_exit);
+crypto_module_init(cryptd_init);
+crypto_module_exit(cryptd_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Software async crypto daemon");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index c05fc645a5b6..816a55809f4a 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -327,3 +327,26 @@ DEFINE_CRYPTO_API_STUB(crypto_clone_cipher);
 
 #endif
 
+/*
+ * crypto/cryptd.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_CRYPTD)
+
+#include <crypto/cryptd.h>
+
+DEFINE_CRYPTO_API_STUB(cryptd_alloc_skcipher);
+DEFINE_CRYPTO_API_STUB(cryptd_skcipher_child);
+DEFINE_CRYPTO_API_STUB(cryptd_skcipher_queued);
+DEFINE_CRYPTO_API_STUB(cryptd_free_skcipher);
+DEFINE_CRYPTO_API_STUB(cryptd_alloc_ahash);
+DEFINE_CRYPTO_API_STUB(cryptd_ahash_child);
+DEFINE_CRYPTO_API_STUB(cryptd_shash_desc);
+DEFINE_CRYPTO_API_STUB(cryptd_ahash_queued);
+DEFINE_CRYPTO_API_STUB(cryptd_free_ahash);
+DEFINE_CRYPTO_API_STUB(cryptd_alloc_aead);
+DEFINE_CRYPTO_API_STUB(cryptd_aead_child);
+DEFINE_CRYPTO_API_STUB(cryptd_aead_queued);
+DEFINE_CRYPTO_API_STUB(cryptd_free_aead);
+
+#endif
+
diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index 796d986e58e1..42de15e2cd52 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -13,6 +13,7 @@
 #ifndef _CRYPTO_CRYPT_H
 #define _CRYPTO_CRYPT_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 #include <crypto/aead.h>
@@ -24,12 +25,19 @@ struct cryptd_skcipher {
 };
 
 /* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_skcipher *cryptd_alloc_skcipher(const char *alg_name,
-					      u32 type, u32 mask);
-struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm);
+DECLARE_CRYPTO_API(cryptd_alloc_skcipher, struct cryptd_skcipher *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
+DECLARE_CRYPTO_API(cryptd_skcipher_child, struct crypto_skcipher *,
+	(struct cryptd_skcipher *tfm),
+	(tfm));
 /* Must be called without moving CPUs. */
-bool cryptd_skcipher_queued(struct cryptd_skcipher *tfm);
-void cryptd_free_skcipher(struct cryptd_skcipher *tfm);
+DECLARE_CRYPTO_API(cryptd_skcipher_queued, bool,
+	(struct cryptd_skcipher *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(cryptd_free_skcipher, void,
+	(struct cryptd_skcipher *tfm),
+	(tfm));
 
 struct cryptd_ahash {
 	struct crypto_ahash base;
@@ -42,13 +50,22 @@ static inline struct cryptd_ahash *__cryptd_ahash_cast(
 }
 
 /* alg_name should be algorithm to be cryptd-ed */
-struct cryptd_ahash *cryptd_alloc_ahash(const char *alg_name,
-					u32 type, u32 mask);
-struct crypto_shash *cryptd_ahash_child(struct cryptd_ahash *tfm);
-struct shash_desc *cryptd_shash_desc(struct ahash_request *req);
+DECLARE_CRYPTO_API(cryptd_alloc_ahash, struct cryptd_ahash *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
+DECLARE_CRYPTO_API(cryptd_ahash_child, struct crypto_shash *,
+	(struct cryptd_ahash *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(cryptd_shash_desc, struct shash_desc *,
+	(struct ahash_request *req),
+	(req));
 /* Must be called without moving CPUs. */
-bool cryptd_ahash_queued(struct cryptd_ahash *tfm);
-void cryptd_free_ahash(struct cryptd_ahash *tfm);
+DECLARE_CRYPTO_API(cryptd_ahash_queued, bool,
+	(struct cryptd_ahash *tfm),
+	(tfm));
+DECLARE_CRYPTO_API(cryptd_free_ahash, void,
+	(struct cryptd_ahash *tfm),
+	(tfm));
 
 struct cryptd_aead {
 	struct crypto_aead base;
@@ -60,13 +77,20 @@ static inline struct cryptd_aead *__cryptd_aead_cast(
 	return (struct cryptd_aead *)tfm;
 }
 
-struct cryptd_aead *cryptd_alloc_aead(const char *alg_name,
-					  u32 type, u32 mask);
+DECLARE_CRYPTO_API(cryptd_alloc_aead, struct cryptd_aead *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
-struct crypto_aead *cryptd_aead_child(struct cryptd_aead *tfm);
+DECLARE_CRYPTO_API(cryptd_aead_child, struct crypto_aead *,
+	(struct cryptd_aead *tfm),
+	(tfm));
 /* Must be called without moving CPUs. */
-bool cryptd_aead_queued(struct cryptd_aead *tfm);
+DECLARE_CRYPTO_API(cryptd_aead_queued, bool,
+	(struct cryptd_aead *tfm),
+	(tfm));
 
-void cryptd_free_aead(struct cryptd_aead *tfm);
+DECLARE_CRYPTO_API(cryptd_free_aead, void,
+	(struct cryptd_aead *tfm),
+	(tfm));
 
 #endif
-- 
2.39.3

