Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977FC28314E;
	Thu,  4 Sep 2025 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001447; cv=none; b=ibYxDJK3jrsyq1f6JUh06fuJD+Ispzw2Fm8Wq2vdK4l6KUN2r9dFGg3pQmwusFrJvERssRqzB91zQ2Ay6MZSJbX6RDVGvfqD8kCrHBDuSY8G3hLazJgDCzFIooxaEa5rFxA0MP4kYxj9qViinHilXfglbDnS5jN8gfnrFaPeWf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001447; c=relaxed/simple;
	bh=FmYuOqF5e7h7ejcY6qa5SokK9We001Zp5CwkGbu5+GE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rJQa3ScwEpiYuoxadIPOYtA0cMyl92zX10tRsE2h4ntABB2DhZOqVjSZQ8buzHjg43S2FUFjxdJjQmY7UQLw/3dD5sHAEzdhXkRD7U8qAF8nNopgBm//rz+XqC/G8KJF//HL/n99aIE5Uw1HZbZS61bCUgLLhL/J8F+lKbNegf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KGZ+V9tT; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KGZ+V9tT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fu4jY011394;
	Thu, 4 Sep 2025 15:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=2q+R2
	eL5JtJFptLhjifImI3aWFSTa3QRjvtqbyV/SoQ=; b=KGZ+V9tT2O0qigmU86UEp
	leY2jt9FPDaFPDMULBbtakcUKdHTyp3jNx0/P3l5Z5bDOGAalJst6GRS/sz9q5cX
	f8F6HJvIt1u53fV9gAwrdOt38lPsX/9wH1wBSwr/k1vT+S8ZxfiNkREXN81guCns
	IXZlVeo5ZgRVn7EIHuyFRR0qfG7pa7E8+Xla+I06pFD+31vplZ0n/+vf4H58LWK7
	oy813/MqXqRFhRRdbfxnmAOtLA/fdb5NqpSy04tR4Mp9a00YQHoWnatNLin+hQV8
	rj5WS978UfNF1KOFoWE/5YTgP2C/pME5cykTYYg3NaNSGfWT4JNpZyyS1GA3s4Ea
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FPlVb040063;
	Thu, 4 Sep 2025 15:57:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:10 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5w000707;
	Thu, 4 Sep 2025 15:57:09 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-36;
	Thu, 04 Sep 2025 15:57:09 +0000
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
Subject: [PATCH RFC 035/104] crypto: fips140: convert crypto/api.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:07 +0200
Message-Id: <20250904155216.460962-36-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: oYYDWERPMWKdN_ArkJ9rou13TBMcO7B8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfXyv74i7kxzduW
 vk1FmNme8beyZXC82+pIClwvROozdlUksxAA5KqV6DsGRo8u7Juj7sn/3tFdTQEs4sUIe5jD4NK
 g1NqMK1XZU5pSb4VoNwirOXORVYLYRcxZPz6dCFxjYXU/leMvm12q9Kq/snZWJjM3bYhYlaZrFJ
 2TVdvxs+3yVPYf4JUmYjT4Gc6rsO84VdG5II8bt6kFXeqH2S0Z+9F76p+mSlT+vNvlyKt6kJXS7
 H/mXf8mroI2wNSvcTAXoPvhIvMZjOngkfWCAo+6M/3HNj/XjnK/LM/DBGQwQs2rju6s8twAzfHA
 ucFeXv9wotW5YK/QrJJEoeFzw+C9GT68SuWC2srsdPxkgMyaQJoovjWqE7cPkT8w8opr1i0g0xC
 xhuR7hOYz4DJfDTWL6T3YarfzDHyDg==
X-Proofpoint-ORIG-GUID: oYYDWERPMWKdN_ArkJ9rou13TBMcO7B8
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6d8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=QjG39sTP1dglnPMUoi8A:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO --source crypto/api.c --header include/linux/crypto.h include/crypto/algapi.h crypto/internal.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/api.c            | 76 ++++++++++++++++++++---------------------
 crypto/fips140-api.c    | 35 +++++++++++++++++++
 crypto/internal.h       | 62 +++++++++++++++++++++------------
 include/crypto/algapi.h |  4 ++-
 include/linux/crypto.h  | 23 +++++++++----
 5 files changed, 133 insertions(+), 67 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 5724d62e9d07..7ddc99599590 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -40,20 +40,20 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg,
 static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
 					    u32 mask);
 
-struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
+struct crypto_alg *CRYPTO_API(crypto_mod_get)(struct crypto_alg *alg)
 {
 	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
 }
-EXPORT_SYMBOL_GPL(crypto_mod_get);
+DEFINE_CRYPTO_API(crypto_mod_get);
 
-void crypto_mod_put(struct crypto_alg *alg)
+void CRYPTO_API(crypto_mod_put)(struct crypto_alg *alg)
 {
 	struct module *module = alg->cra_module;
 
 	crypto_alg_put(alg);
 	module_put(module);
 }
-EXPORT_SYMBOL_GPL(crypto_mod_put);
+DEFINE_CRYPTO_API(crypto_mod_put);
 
 static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 					      u32 mask)
@@ -100,7 +100,7 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
 	kfree(larval);
 }
 
-struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
+struct crypto_larval *CRYPTO_API(crypto_larval_alloc)(const char *name, u32 type, u32 mask)
 {
 	struct crypto_larval *larval;
 
@@ -120,7 +120,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 
 	return larval;
 }
-EXPORT_SYMBOL_GPL(crypto_larval_alloc);
+DEFINE_CRYPTO_API(crypto_larval_alloc);
 
 static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
 					    u32 mask)
@@ -168,14 +168,14 @@ static void crypto_larval_kill(struct crypto_larval *larval)
 	crypto_alg_put(&larval->alg);
 }
 
-void crypto_schedule_test(struct crypto_larval *larval)
+void CRYPTO_API(crypto_schedule_test)(struct crypto_larval *larval)
 {
 	int err;
 
 	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
 	WARN_ON_ONCE(err != NOTIFY_STOP);
 }
-EXPORT_SYMBOL_GPL(crypto_schedule_test);
+DEFINE_CRYPTO_API(crypto_schedule_test);
 
 static void crypto_start_test(struct crypto_larval *larval)
 {
@@ -320,7 +320,7 @@ static struct crypto_alg *crypto_larval_lookup(const char *name, u32 type,
 	return alg;
 }
 
-int crypto_probing_notify(unsigned long val, void *v)
+int CRYPTO_API(crypto_probing_notify)(unsigned long val, void *v)
 {
 	int ok;
 
@@ -332,9 +332,9 @@ int crypto_probing_notify(unsigned long val, void *v)
 
 	return ok;
 }
-EXPORT_SYMBOL_GPL(crypto_probing_notify);
+DEFINE_CRYPTO_API(crypto_probing_notify);
 
-struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
+struct crypto_alg *CRYPTO_API(crypto_alg_mod_lookup)(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *larval;
@@ -365,7 +365,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 	crypto_larval_kill(container_of(larval, struct crypto_larval, alg));
 	return alg;
 }
-EXPORT_SYMBOL_GPL(crypto_alg_mod_lookup);
+DEFINE_CRYPTO_API(crypto_alg_mod_lookup);
 
 static void crypto_exit_ops(struct crypto_tfm *tfm)
 {
@@ -396,15 +396,15 @@ static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
 	return len;
 }
 
-void crypto_shoot_alg(struct crypto_alg *alg)
+void CRYPTO_API(crypto_shoot_alg)(struct crypto_alg *alg)
 {
 	down_write(&crypto_alg_sem);
 	alg->cra_flags |= CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
-EXPORT_SYMBOL_GPL(crypto_shoot_alg);
+DEFINE_CRYPTO_API(crypto_shoot_alg);
 
-struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
+struct crypto_tfm *CRYPTO_API(__crypto_alloc_tfmgfp)(struct crypto_alg *alg, u32 type,
 					 u32 mask, gfp_t gfp)
 {
 	struct crypto_tfm *tfm;
@@ -434,14 +434,14 @@ struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
 out:
 	return tfm;
 }
-EXPORT_SYMBOL_GPL(__crypto_alloc_tfmgfp);
+DEFINE_CRYPTO_API(__crypto_alloc_tfmgfp);
 
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
+struct crypto_tfm *CRYPTO_API(__crypto_alloc_tfm)(struct crypto_alg *alg, u32 type,
 				      u32 mask)
 {
 	return __crypto_alloc_tfmgfp(alg, type, mask, GFP_KERNEL);
 }
-EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
+DEFINE_CRYPTO_API(__crypto_alloc_tfm);
 
 /*
  *	crypto_alloc_base - Locate algorithm and allocate transform
@@ -465,7 +465,7 @@ EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
  *
  *	In case of error the return value is an error pointer.
  */
-struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
+struct crypto_tfm *CRYPTO_API(crypto_alloc_base)(const char *alg_name, u32 type, u32 mask)
 {
 	struct crypto_tfm *tfm;
 	int err;
@@ -497,7 +497,7 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_base);
+DEFINE_CRYPTO_API(crypto_alloc_base);
 
 static void *crypto_alloc_tfmmem(struct crypto_alg *alg,
 				 const struct crypto_type *frontend, int node,
@@ -523,7 +523,7 @@ static void *crypto_alloc_tfmmem(struct crypto_alg *alg,
 	return mem;
 }
 
-void *crypto_create_tfm_node(struct crypto_alg *alg,
+void *CRYPTO_API(crypto_create_tfm_node)(struct crypto_alg *alg,
 			     const struct crypto_type *frontend,
 			     int node)
 {
@@ -557,9 +557,9 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 out:
 	return mem;
 }
-EXPORT_SYMBOL_GPL(crypto_create_tfm_node);
+DEFINE_CRYPTO_API(crypto_create_tfm_node);
 
-void *crypto_clone_tfm(const struct crypto_type *frontend,
+void *CRYPTO_API(crypto_clone_tfm)(const struct crypto_type *frontend,
 		       struct crypto_tfm *otfm)
 {
 	struct crypto_alg *alg = otfm->__crt_alg;
@@ -583,9 +583,9 @@ void *crypto_clone_tfm(const struct crypto_type *frontend,
 out:
 	return mem;
 }
-EXPORT_SYMBOL_GPL(crypto_clone_tfm);
+DEFINE_CRYPTO_API(crypto_clone_tfm);
 
-struct crypto_alg *crypto_find_alg(const char *alg_name,
+struct crypto_alg *CRYPTO_API(crypto_find_alg)(const char *alg_name,
 				   const struct crypto_type *frontend,
 				   u32 type, u32 mask)
 {
@@ -598,7 +598,7 @@ struct crypto_alg *crypto_find_alg(const char *alg_name,
 
 	return crypto_alg_mod_lookup(alg_name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_find_alg);
+DEFINE_CRYPTO_API(crypto_find_alg);
 
 /*
  *	crypto_alloc_tfm_node - Locate algorithm and allocate transform
@@ -623,7 +623,7 @@ EXPORT_SYMBOL_GPL(crypto_find_alg);
  *	In case of error the return value is an error pointer.
  */
 
-void *crypto_alloc_tfm_node(const char *alg_name,
+void *CRYPTO_API(crypto_alloc_tfm_node)(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask,
 		       int node)
 {
@@ -657,7 +657,7 @@ void *crypto_alloc_tfm_node(const char *alg_name,
 
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_tfm_node);
+DEFINE_CRYPTO_API(crypto_alloc_tfm_node);
 
 /*
  *	crypto_destroy_tfm - Free crypto transform
@@ -667,7 +667,7 @@ EXPORT_SYMBOL_GPL(crypto_alloc_tfm_node);
  *	This function frees up the transform and any associated resources,
  *	then drops the refcount on the associated algorithm.
  */
-void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
+void CRYPTO_API(crypto_destroy_tfm)(void *mem, struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg;
 
@@ -684,9 +684,9 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 	crypto_mod_put(alg);
 	kfree_sensitive(mem);
 }
-EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
+DEFINE_CRYPTO_API(crypto_destroy_tfm);
 
-int crypto_has_alg(const char *name, u32 type, u32 mask)
+int CRYPTO_API(crypto_has_alg)(const char *name, u32 type, u32 mask)
 {
 	int ret = 0;
 	struct crypto_alg *alg = crypto_alg_mod_lookup(name, type, mask);
@@ -698,9 +698,9 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_has_alg);
+DEFINE_CRYPTO_API(crypto_has_alg);
 
-void crypto_req_done(void *data, int err)
+void CRYPTO_API(crypto_req_done)(void *data, int err)
 {
 	struct crypto_wait *wait = data;
 
@@ -710,18 +710,18 @@ void crypto_req_done(void *data, int err)
 	wait->err = err;
 	complete(&wait->completion);
 }
-EXPORT_SYMBOL_GPL(crypto_req_done);
+DEFINE_CRYPTO_API(crypto_req_done);
 
-void crypto_destroy_alg(struct crypto_alg *alg)
+void CRYPTO_API(crypto_destroy_alg)(struct crypto_alg *alg)
 {
 	if (alg->cra_type && alg->cra_type->destroy)
 		alg->cra_type->destroy(alg);
 	if (alg->cra_destroy)
 		alg->cra_destroy(alg);
 }
-EXPORT_SYMBOL_GPL(crypto_destroy_alg);
+DEFINE_CRYPTO_API(crypto_destroy_alg);
 
-struct crypto_async_request *crypto_request_clone(
+struct crypto_async_request *CRYPTO_API(crypto_request_clone)(
 	struct crypto_async_request *req, size_t total, gfp_t gfp)
 {
 	struct crypto_tfm *tfm = req->tfm;
@@ -736,7 +736,7 @@ struct crypto_async_request *crypto_request_clone(
 	nreq->flags &= ~CRYPTO_TFM_REQ_ON_STACK;
 	return nreq;
 }
-EXPORT_SYMBOL_GPL(crypto_request_clone);
+DEFINE_CRYPTO_API(crypto_request_clone);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 1c7907b5e1dc..f5cf473f1f25 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -267,3 +267,38 @@ DEFINE_CRYPTO_API_STUB(crypto_type_has_alg);
 
 #endif
 
+/*
+ * crypto/api.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO)
+
+#include <linux/crypto.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_req_done);
+DEFINE_CRYPTO_API_STUB(crypto_has_alg);
+DEFINE_CRYPTO_API_STUB(crypto_alloc_base);
+DEFINE_CRYPTO_API_STUB(crypto_destroy_tfm);
+DEFINE_CRYPTO_API_STUB(crypto_request_clone);
+
+#include <crypto/algapi.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_mod_put);
+
+#include <crypto/internal.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_mod_get);
+DEFINE_CRYPTO_API_STUB(crypto_alg_mod_lookup);
+DEFINE_CRYPTO_API_STUB(crypto_larval_alloc);
+DEFINE_CRYPTO_API_STUB(crypto_schedule_test);
+DEFINE_CRYPTO_API_STUB(crypto_shoot_alg);
+DEFINE_CRYPTO_API_STUB(__crypto_alloc_tfmgfp);
+DEFINE_CRYPTO_API_STUB(__crypto_alloc_tfm);
+DEFINE_CRYPTO_API_STUB(crypto_create_tfm_node);
+DEFINE_CRYPTO_API_STUB(crypto_clone_tfm);
+DEFINE_CRYPTO_API_STUB(crypto_find_alg);
+DEFINE_CRYPTO_API_STUB(crypto_alloc_tfm_node);
+DEFINE_CRYPTO_API_STUB(crypto_probing_notify);
+DEFINE_CRYPTO_API_STUB(crypto_destroy_alg);
+
+#endif
+
diff --git a/crypto/internal.h b/crypto/internal.h
index d823931fd0e2..700280457bf6 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -110,11 +110,19 @@ static inline unsigned int crypto_compress_ctxsize(struct crypto_alg *alg)
 	return alg->cra_ctxsize;
 }
 
-struct crypto_alg *crypto_mod_get(struct crypto_alg *alg);
-struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
-
-struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
-void crypto_schedule_test(struct crypto_larval *larval);
+DECLARE_CRYPTO_API(crypto_mod_get, struct crypto_alg *,
+	(struct crypto_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_alg_mod_lookup, struct crypto_alg *,
+	(const char *name, u32 type, u32 mask),
+	(name, type, mask));
+
+DECLARE_CRYPTO_API(crypto_larval_alloc, struct crypto_larval *,
+	(const char *name, u32 type, u32 mask),
+	(name, type, mask));
+DECLARE_CRYPTO_API(crypto_schedule_test, void,
+	(struct crypto_larval *larval),
+	(larval));
 DECLARE_CRYPTO_API(crypto_alg_tested, void,
 	(struct crypto_alg *alg, int err),
 	(alg, err));
@@ -125,15 +133,21 @@ DECLARE_CRYPTO_API(crypto_remove_spawns, void,
 DECLARE_CRYPTO_API(crypto_remove_final, void,
 	(struct list_head *list),
 	(list));
-void crypto_shoot_alg(struct crypto_alg *alg);
-struct crypto_tfm *__crypto_alloc_tfmgfp(struct crypto_alg *alg, u32 type,
-					 u32 mask, gfp_t gfp);
-struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask);
-void *crypto_create_tfm_node(struct crypto_alg *alg,
-			const struct crypto_type *frontend, int node);
-void *crypto_clone_tfm(const struct crypto_type *frontend,
-		       struct crypto_tfm *otfm);
+DECLARE_CRYPTO_API(crypto_shoot_alg, void,
+	(struct crypto_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(__crypto_alloc_tfmgfp, struct crypto_tfm *,
+	(struct crypto_alg *alg, u32 type, u32 mask, gfp_t gfp),
+	(alg, type, mask, gfp));
+DECLARE_CRYPTO_API(__crypto_alloc_tfm, struct crypto_tfm *,
+	(struct crypto_alg *alg, u32 type, u32 mask),
+	(alg, type, mask));
+DECLARE_CRYPTO_API(crypto_create_tfm_node, void *,
+	(struct crypto_alg *alg, const struct crypto_type *frontend, int node),
+	(alg, frontend, node));
+DECLARE_CRYPTO_API(crypto_clone_tfm, void *,
+	(const struct crypto_type *frontend, struct crypto_tfm *otfm),
+	(frontend, otfm));
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
@@ -141,13 +155,13 @@ static inline void *crypto_create_tfm(struct crypto_alg *alg,
 	return crypto_create_tfm_node(alg, frontend, NUMA_NO_NODE);
 }
 
-struct crypto_alg *crypto_find_alg(const char *alg_name,
-				   const struct crypto_type *frontend,
-				   u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_find_alg, struct crypto_alg *,
+	(const char *alg_name, const struct crypto_type *frontend, u32 type, u32 mask),
+	(alg_name, frontend, type, mask));
 
-void *crypto_alloc_tfm_node(const char *alg_name,
-		       const struct crypto_type *frontend, u32 type, u32 mask,
-		       int node);
+DECLARE_CRYPTO_API(crypto_alloc_tfm_node, void *,
+	(const char *alg_name, const struct crypto_type *frontend, u32 type, u32 mask, int node),
+	(alg_name, frontend, type, mask, node));
 
 static inline void *crypto_alloc_tfm(const char *alg_name,
 		       const struct crypto_type *frontend, u32 type, u32 mask)
@@ -155,7 +169,9 @@ static inline void *crypto_alloc_tfm(const char *alg_name,
 	return crypto_alloc_tfm_node(alg_name, frontend, type, mask, NUMA_NO_NODE);
 }
 
-int crypto_probing_notify(unsigned long val, void *v);
+DECLARE_CRYPTO_API(crypto_probing_notify, int,
+	(unsigned long val, void *v),
+	(val, v));
 
 DECLARE_CRYPTO_API(crypto_alg_extsize, unsigned int,
 	(struct crypto_alg *alg),
@@ -171,7 +187,9 @@ static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
 	return alg;
 }
 
-void crypto_destroy_alg(struct crypto_alg *alg);
+DECLARE_CRYPTO_API(crypto_destroy_alg, void,
+	(struct crypto_alg *alg),
+	(alg));
 
 static inline void crypto_alg_put(struct crypto_alg *alg)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 9d7505b7f029..9844f3b0cb0a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -133,7 +133,9 @@ DECLARE_CRYPTO_API(crypto_unregister_algs, void,
 	(struct crypto_alg *algs, int count),
 	(algs, count));
 
-void crypto_mod_put(struct crypto_alg *alg);
+DECLARE_CRYPTO_API(crypto_mod_put, void,
+	(struct crypto_alg *alg),
+	(alg));
 
 DECLARE_CRYPTO_API(crypto_register_template, int,
 	(struct crypto_template *tmpl),
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 737e53a642d4..e4b356a3b27d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_CRYPTO_H
 #define _LINUX_CRYPTO_H
 
+#include <crypto/api.h>
 #include <linux/completion.h>
 #include <linux/errno.h>
 #include <linux/refcount_types.h>
@@ -384,7 +385,9 @@ struct crypto_wait {
 /*
  * Async ops completion helper functioons
  */
-void crypto_req_done(void *req, int err);
+DECLARE_CRYPTO_API(crypto_req_done, void,
+	(void *req, int err),
+	(req, err));
 
 static inline int crypto_wait_req(int err, struct crypto_wait *wait)
 {
@@ -408,7 +411,9 @@ static inline void crypto_init_wait(struct crypto_wait *wait)
 /*
  * Algorithm query interface.
  */
-int crypto_has_alg(const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_has_alg, int,
+	(const char *name, u32 type, u32 mask),
+	(name, type, mask));
 
 /*
  * Transforms: user-instantiated objects which encapsulate algorithms
@@ -436,8 +441,12 @@ struct crypto_tfm {
  * Transform user interface.
  */
  
-struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
-void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm);
+DECLARE_CRYPTO_API(crypto_alloc_base, struct crypto_tfm *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
+DECLARE_CRYPTO_API(crypto_destroy_tfm, void,
+	(void *mem, struct crypto_tfm *tfm),
+	(mem, tfm));
 
 static inline void crypto_free_tfm(struct crypto_tfm *tfm)
 {
@@ -522,8 +531,10 @@ static inline void crypto_request_set_tfm(struct crypto_async_request *req,
 	req->flags &= ~CRYPTO_TFM_REQ_ON_STACK;
 }
 
-struct crypto_async_request *crypto_request_clone(
-	struct crypto_async_request *req, size_t total, gfp_t gfp);
+DECLARE_CRYPTO_API(crypto_request_clone, struct crypto_async_request *,
+	(
+	struct crypto_async_request *req, size_t total, gfp_t gfp),
+	(req, total, gfp));
 
 static inline void crypto_stack_request_init(struct crypto_async_request *req,
 					     struct crypto_tfm *tfm)
-- 
2.39.3

