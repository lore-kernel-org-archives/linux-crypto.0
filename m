Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D6A2D6630;
	Thu,  4 Sep 2025 15:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001601; cv=none; b=UTOAiN6KBVLiqSLnkULyR1I9i5kRG+lP6GYsGc7l8oR6kqgx/ytkblIY03YJRyaFRpZCbgaS9bh0mPx/1Ji7JTekbVDIeTmKnxSa7YSgrCbT4NpKVvM9avdb3w3e375/zfYZqV52nCXCMBmtDMw9FOHuqOglrlIycpHEv/GmIGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001601; c=relaxed/simple;
	bh=CE/Rsou7Q9X038KznH1i3ycPgxbOOL6p8mTAyF1HWpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j11EFj3iYyPO/4aEHgAXSet1oZWq3nxLrHH+dDETYYXAVwMjeyyPaT/YlBoMgBpNyjvDBFd1GKu24Irz3hUL/kVO9e6YKmK350O9tmkaFBE5GEWNbdYFrjHwPHDRFRqCEhL3QoD17GZQpB1K9ZSw7DMOMrzXUnm8jhanzQsBcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iC1eiEy/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iC1eiEy/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtnQN009150;
	Thu, 4 Sep 2025 15:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=ZBjY/
	U2By6Iq714po37R+S2JCRmtbfTsulom0X/HMxc=; b=iC1eiEy/SLVdmFDTNhPJI
	0zZ1dqzksXfsq9pBb6m/4jE1nH7JfAyroxX8rBooxlhU51khQ+PK9hc0w2f7mEj6
	V+Pkw7ZHupQFfexrzVCnoApfihoSysXfe5MX0rOI/y5br1ecQGNU0WmWZy3PAIib
	jsEHETp8kr563BSXPhijhwv5jvZtx7E0dYQrmCPEqQijHzvzM7ksvkq1121ru10J
	XZYIAzYkEnpbKt+Lb5Gd8dV7SuuzYiRo8Vpc/+g7i53PHKDbC39Keona0Jgte3/l
	647N91m5zlyHQfnIin+1HCE5hSVQzcMR0wILo5H6O54HpMF8IKFWuixdCewnwi1Z
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FV73E040033;
	Thu, 4 Sep 2025 15:59:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtr1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:47 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7E000707;
	Thu, 4 Sep 2025 15:59:47 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-74;
	Thu, 04 Sep 2025 15:59:46 +0000
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
Subject: [PATCH RFC 073/104] crypto: fips140: convert crypto/skcipher.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:45 +0200
Message-Id: <20250904155216.460962-74-vegard.nossum@oracle.com>
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
 definitions=main-2509040157
X-Proofpoint-ORIG-GUID: 2yfO6u2qs6u4usQCmLhNeK9zcwQxV-U5
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b774 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=HtD07q4cp0Z-bQA0zlsA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXymXuq/uG7PsQ
 drpFtkwZutL6fZ1HLqpt9cL+NBYs+RkefdunQjw+TcQyvXOoxTaVbWD8tYiqwpTLOZqDx5qa2HF
 fTQ99mcVYb4edYE47cdPyP0rVcffAbUAA0v8YWOpjeMQnro7LSG3v9izizRJPqYZGCu02kB/lyP
 8sIMC+oqznYVQj3I3rdDjadbF8BucFIQ3X6qpOCoW2zWG5YYPoe7YoieylDgm9+NCskyaaAQE3p
 MAOnL2OlwsEnn/HP+N+QRGzT0uWKvvoeTT8Dpf0cO/0aWTVMTnXth5uteqprN1rHiNz6kygIieV
 ttvp/sX0xTO115jwak+pIktCu+MkwOGJc7jieA01nDs091ZfEsdYlC39czDpj6joKUbJKz8Ltu+
 a/QSZAZ4pf89cmrepjxAGHB3ycmRTw==
X-Proofpoint-GUID: 2yfO6u2qs6u4usQCmLhNeK9zcwQxV-U5

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SKCIPHER2 --source crypto/skcipher.c --header include/crypto/skcipher.h include/crypto/internal/skcipher.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c               | 31 +++++++++++++
 crypto/skcipher.c                  | 72 +++++++++++++++---------------
 include/crypto/internal/skcipher.h | 51 ++++++++++++---------
 include/crypto/skcipher.h          | 35 ++++++++++-----
 4 files changed, 122 insertions(+), 67 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 112212b32d6d..115a0fc99e31 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -578,3 +578,34 @@ DEFINE_CRYPTO_API_STUB(simd_unregister_aeads);
 
 #endif
 
+/*
+ * crypto/skcipher.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_SKCIPHER2)
+
+#include <crypto/skcipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_skcipher);
+DEFINE_CRYPTO_API_STUB(crypto_alloc_sync_skcipher);
+DEFINE_CRYPTO_API_STUB(crypto_has_skcipher);
+DEFINE_CRYPTO_API_STUB(crypto_skcipher_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_skcipher_encrypt);
+DEFINE_CRYPTO_API_STUB(crypto_skcipher_decrypt);
+DEFINE_CRYPTO_API_STUB(crypto_skcipher_export);
+DEFINE_CRYPTO_API_STUB(crypto_skcipher_import);
+
+#include <crypto/internal/skcipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_grab_skcipher);
+DEFINE_CRYPTO_API_STUB(crypto_register_skcipher);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_skcipher);
+DEFINE_CRYPTO_API_STUB(crypto_register_skciphers);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_skciphers);
+DEFINE_CRYPTO_API_STUB(skcipher_register_instance);
+DEFINE_CRYPTO_API_STUB(skcipher_walk_virt);
+DEFINE_CRYPTO_API_STUB(skcipher_walk_aead_encrypt);
+DEFINE_CRYPTO_API_STUB(skcipher_walk_aead_decrypt);
+DEFINE_CRYPTO_API_STUB(skcipher_alloc_instance_simple);
+
+#endif
+
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index de5fc91bba26..0bc53ac3fd0f 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -35,7 +35,7 @@ static inline struct skcipher_alg *__crypto_skcipher_alg(
 	return container_of(alg, struct skcipher_alg, base);
 }
 
-int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
+int CRYPTO_API(skcipher_walk_virt)(struct skcipher_walk *__restrict walk,
 		       struct skcipher_request *__restrict req, bool atomic)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -69,7 +69,7 @@ int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 
 	return skcipher_walk_first(walk, atomic);
 }
-EXPORT_SYMBOL_GPL(skcipher_walk_virt);
+DEFINE_CRYPTO_API(skcipher_walk_virt);
 
 static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 				     struct aead_request *__restrict req,
@@ -97,7 +97,7 @@ static int skcipher_walk_aead_common(struct skcipher_walk *__restrict walk,
 	return skcipher_walk_first(walk, atomic);
 }
 
-int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
+int CRYPTO_API(skcipher_walk_aead_encrypt)(struct skcipher_walk *__restrict walk,
 			       struct aead_request *__restrict req,
 			       bool atomic)
 {
@@ -105,9 +105,9 @@ int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
 
 	return skcipher_walk_aead_common(walk, req, atomic);
 }
-EXPORT_SYMBOL_GPL(skcipher_walk_aead_encrypt);
+DEFINE_CRYPTO_API(skcipher_walk_aead_encrypt);
 
-int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
+int CRYPTO_API(skcipher_walk_aead_decrypt)(struct skcipher_walk *__restrict walk,
 			       struct aead_request *__restrict req,
 			       bool atomic)
 {
@@ -117,7 +117,7 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
 
 	return skcipher_walk_aead_common(walk, req, atomic);
 }
-EXPORT_SYMBOL_GPL(skcipher_walk_aead_decrypt);
+DEFINE_CRYPTO_API(skcipher_walk_aead_decrypt);
 
 static void skcipher_set_needkey(struct crypto_skcipher *tfm)
 {
@@ -146,7 +146,7 @@ static int skcipher_setkey_unaligned(struct crypto_skcipher *tfm,
 	return ret;
 }
 
-int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
+int CRYPTO_API(crypto_skcipher_setkey)(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct skcipher_alg *cipher = crypto_skcipher_alg(tfm);
@@ -181,9 +181,9 @@ int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_skcipher_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_skcipher_setkey);
+DEFINE_CRYPTO_API(crypto_skcipher_setkey);
 
-int crypto_skcipher_encrypt(struct skcipher_request *req)
+int CRYPTO_API(crypto_skcipher_encrypt)(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
@@ -194,9 +194,9 @@ int crypto_skcipher_encrypt(struct skcipher_request *req)
 		return crypto_lskcipher_encrypt_sg(req);
 	return alg->encrypt(req);
 }
-EXPORT_SYMBOL_GPL(crypto_skcipher_encrypt);
+DEFINE_CRYPTO_API(crypto_skcipher_encrypt);
 
-int crypto_skcipher_decrypt(struct skcipher_request *req)
+int CRYPTO_API(crypto_skcipher_decrypt)(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
@@ -207,7 +207,7 @@ int crypto_skcipher_decrypt(struct skcipher_request *req)
 		return crypto_lskcipher_decrypt_sg(req);
 	return alg->decrypt(req);
 }
-EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
+DEFINE_CRYPTO_API(crypto_skcipher_decrypt);
 
 static int crypto_lskcipher_export(struct skcipher_request *req, void *out)
 {
@@ -245,7 +245,7 @@ static int skcipher_noimport(struct skcipher_request *req, const void *in)
 	return 0;
 }
 
-int crypto_skcipher_export(struct skcipher_request *req, void *out)
+int CRYPTO_API(crypto_skcipher_export)(struct skcipher_request *req, void *out)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
@@ -254,9 +254,9 @@ int crypto_skcipher_export(struct skcipher_request *req, void *out)
 		return crypto_lskcipher_export(req, out);
 	return alg->export(req, out);
 }
-EXPORT_SYMBOL_GPL(crypto_skcipher_export);
+DEFINE_CRYPTO_API(crypto_skcipher_export);
 
-int crypto_skcipher_import(struct skcipher_request *req, const void *in)
+int CRYPTO_API(crypto_skcipher_import)(struct skcipher_request *req, const void *in)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
@@ -265,7 +265,7 @@ int crypto_skcipher_import(struct skcipher_request *req, const void *in)
 		return crypto_lskcipher_import(req, in);
 	return alg->import(req, in);
 }
-EXPORT_SYMBOL_GPL(crypto_skcipher_import);
+DEFINE_CRYPTO_API(crypto_skcipher_import);
 
 static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
 {
@@ -374,23 +374,23 @@ static const struct crypto_type crypto_skcipher_type = {
 	.algsize = offsetof(struct skcipher_alg, base),
 };
 
-int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
+int CRYPTO_API(crypto_grab_skcipher)(struct crypto_skcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_skcipher_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
+DEFINE_CRYPTO_API(crypto_grab_skcipher);
 
-struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
+struct crypto_skcipher *CRYPTO_API(crypto_alloc_skcipher)(const char *alg_name,
 					      u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_skcipher);
+DEFINE_CRYPTO_API(crypto_alloc_skcipher);
 
-struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
+struct crypto_sync_skcipher *CRYPTO_API(crypto_alloc_sync_skcipher)(
 				const char *alg_name, u32 type, u32 mask)
 {
 	struct crypto_skcipher *tfm;
@@ -413,13 +413,13 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 
 	return (struct crypto_sync_skcipher *)tfm;
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
+DEFINE_CRYPTO_API(crypto_alloc_sync_skcipher);
 
-int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
+int CRYPTO_API(crypto_has_skcipher)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_skcipher_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_skcipher);
+DEFINE_CRYPTO_API(crypto_has_skcipher);
 
 int skcipher_prepare_alg_common(struct skcipher_alg_common *alg)
 {
@@ -465,7 +465,7 @@ static int skcipher_prepare_alg(struct skcipher_alg *alg)
 	return 0;
 }
 
-int crypto_register_skcipher(struct skcipher_alg *alg)
+int CRYPTO_API(crypto_register_skcipher)(struct skcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 	int err;
@@ -476,15 +476,15 @@ int crypto_register_skcipher(struct skcipher_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_skcipher);
+DEFINE_CRYPTO_API(crypto_register_skcipher);
 
-void crypto_unregister_skcipher(struct skcipher_alg *alg)
+void CRYPTO_API(crypto_unregister_skcipher)(struct skcipher_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_skcipher);
+DEFINE_CRYPTO_API(crypto_unregister_skcipher);
 
-int crypto_register_skciphers(struct skcipher_alg *algs, int count)
+int CRYPTO_API(crypto_register_skciphers)(struct skcipher_alg *algs, int count)
 {
 	int i, ret;
 
@@ -502,18 +502,18 @@ int crypto_register_skciphers(struct skcipher_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_skciphers);
+DEFINE_CRYPTO_API(crypto_register_skciphers);
 
-void crypto_unregister_skciphers(struct skcipher_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_skciphers)(struct skcipher_alg *algs, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_skcipher(&algs[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_skciphers);
+DEFINE_CRYPTO_API(crypto_unregister_skciphers);
 
-int skcipher_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(skcipher_register_instance)(struct crypto_template *tmpl,
 			   struct skcipher_instance *inst)
 {
 	int err;
@@ -527,7 +527,7 @@ int skcipher_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, skcipher_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(skcipher_register_instance);
+DEFINE_CRYPTO_API(skcipher_register_instance);
 
 static int skcipher_setkey_simple(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int keylen)
@@ -584,7 +584,7 @@ static void skcipher_free_instance_simple(struct skcipher_instance *inst)
  * Return: a pointer to the new instance, or an ERR_PTR().  The caller still
  *	   needs to register the instance.
  */
-struct skcipher_instance *skcipher_alloc_instance_simple(
+struct skcipher_instance *CRYPTO_API(skcipher_alloc_instance_simple)(
 	struct crypto_template *tmpl, struct rtattr **tb)
 {
 	u32 mask;
@@ -635,7 +635,7 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 	skcipher_free_instance_simple(inst);
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(skcipher_alloc_instance_simple);
+DEFINE_CRYPTO_API(skcipher_alloc_instance_simple);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Symmetric key cipher type");
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 69de98e9819a..d55b9b9d42a1 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -97,9 +97,9 @@ static inline void skcipher_request_complete(struct skcipher_request *req, int e
 	crypto_request_complete(&req->base, err);
 }
 
-int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
-			 struct crypto_instance *inst,
-			 const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_skcipher, int,
+	(struct crypto_skcipher_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 DECLARE_CRYPTO_API(crypto_grab_lskcipher, int,
 	(struct crypto_lskcipher_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
@@ -158,12 +158,21 @@ static inline void crypto_skcipher_set_reqsize_dma(
 	skcipher->reqsize = reqsize;
 }
 
-int crypto_register_skcipher(struct skcipher_alg *alg);
-void crypto_unregister_skcipher(struct skcipher_alg *alg);
-int crypto_register_skciphers(struct skcipher_alg *algs, int count);
-void crypto_unregister_skciphers(struct skcipher_alg *algs, int count);
-int skcipher_register_instance(struct crypto_template *tmpl,
-			       struct skcipher_instance *inst);
+DECLARE_CRYPTO_API(crypto_register_skcipher, int,
+	(struct skcipher_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_skcipher, void,
+	(struct skcipher_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_skciphers, int,
+	(struct skcipher_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_skciphers, void,
+	(struct skcipher_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(skcipher_register_instance, int,
+	(struct crypto_template *tmpl, struct skcipher_instance *inst),
+	(tmpl, inst));
 
 DECLARE_CRYPTO_API(crypto_register_lskcipher, int,
 	(struct lskcipher_alg *alg),
@@ -181,15 +190,15 @@ DECLARE_CRYPTO_API(lskcipher_register_instance, int,
 	(struct crypto_template *tmpl, struct lskcipher_instance *inst),
 	(tmpl, inst));
 
-int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
-		       struct skcipher_request *__restrict req,
-		       bool atomic);
-int skcipher_walk_aead_encrypt(struct skcipher_walk *__restrict walk,
-			       struct aead_request *__restrict req,
-			       bool atomic);
-int skcipher_walk_aead_decrypt(struct skcipher_walk *__restrict walk,
-			       struct aead_request *__restrict req,
-			       bool atomic);
+DECLARE_CRYPTO_API(skcipher_walk_virt, int,
+	(struct skcipher_walk *__restrict walk, struct skcipher_request *__restrict req, bool atomic),
+	(walk, req, atomic));
+DECLARE_CRYPTO_API(skcipher_walk_aead_encrypt, int,
+	(struct skcipher_walk *__restrict walk, struct aead_request *__restrict req, bool atomic),
+	(walk, req, atomic));
+DECLARE_CRYPTO_API(skcipher_walk_aead_decrypt, int,
+	(struct skcipher_walk *__restrict walk, struct aead_request *__restrict req, bool atomic),
+	(walk, req, atomic));
 
 static inline void *crypto_skcipher_ctx(struct crypto_skcipher *tfm)
 {
@@ -238,8 +247,10 @@ skcipher_cipher_simple(struct crypto_skcipher *tfm)
 	return ctx->cipher;
 }
 
-struct skcipher_instance *skcipher_alloc_instance_simple(
-	struct crypto_template *tmpl, struct rtattr **tb);
+DECLARE_CRYPTO_API(skcipher_alloc_instance_simple, struct skcipher_instance *,
+	(
+	struct crypto_template *tmpl, struct rtattr **tb),
+	(tmpl, tb));
 
 static inline struct crypto_alg *skcipher_ialg_simple(
 	struct skcipher_instance *inst)
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 8ce770bb1f48..ad2e945de9fa 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -277,11 +277,13 @@ static inline struct crypto_skcipher *__crypto_skcipher_cast(
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
-					      u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_skcipher, struct crypto_skcipher *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
-struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(const char *alg_name,
-					      u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_sync_skcipher, struct crypto_sync_skcipher *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 
 /**
@@ -357,7 +359,9 @@ static inline void crypto_free_lskcipher(struct crypto_lskcipher *tfm)
  * Return: true when the skcipher is known to the kernel crypto API; false
  *	   otherwise
  */
-int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_has_skcipher, int,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline const char *crypto_skcipher_driver_name(
 	struct crypto_skcipher *tfm)
@@ -613,8 +617,9 @@ static inline void crypto_lskcipher_clear_flags(struct crypto_lskcipher *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
-			   const u8 *key, unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_skcipher_setkey, int,
+	(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen),
+	(tfm, key, keylen));
 
 static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
 					 const u8 *key, unsigned int keylen)
@@ -700,7 +705,9 @@ static inline struct crypto_sync_skcipher *crypto_sync_skcipher_reqtfm(
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-int crypto_skcipher_encrypt(struct skcipher_request *req);
+DECLARE_CRYPTO_API(crypto_skcipher_encrypt, int,
+	(struct skcipher_request *req),
+	(req));
 
 /**
  * crypto_skcipher_decrypt() - decrypt ciphertext
@@ -713,7 +720,9 @@ int crypto_skcipher_encrypt(struct skcipher_request *req);
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-int crypto_skcipher_decrypt(struct skcipher_request *req);
+DECLARE_CRYPTO_API(crypto_skcipher_decrypt, int,
+	(struct skcipher_request *req),
+	(req));
 
 /**
  * crypto_skcipher_export() - export partial state
@@ -731,7 +740,9 @@ int crypto_skcipher_decrypt(struct skcipher_request *req);
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-int crypto_skcipher_export(struct skcipher_request *req, void *out);
+DECLARE_CRYPTO_API(crypto_skcipher_export, int,
+	(struct skcipher_request *req, void *out),
+	(req, out));
 
 /**
  * crypto_skcipher_import() - import partial state
@@ -746,7 +757,9 @@ int crypto_skcipher_export(struct skcipher_request *req, void *out);
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-int crypto_skcipher_import(struct skcipher_request *req, const void *in);
+DECLARE_CRYPTO_API(crypto_skcipher_import, int,
+	(struct skcipher_request *req, const void *in),
+	(req, in));
 
 /**
  * crypto_lskcipher_encrypt() - encrypt plaintext
-- 
2.39.3

