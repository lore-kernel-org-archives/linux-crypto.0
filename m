Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19B1285078;
	Thu,  4 Sep 2025 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001556; cv=none; b=q1q+GTz81WeAT2MGbpsbOZ3vGBDXk2UraZisDXlhkLBJGP0NMhmE5A+9cBlHgC4dIBf2TDE9+bYUzy2yNyPTLjVZV0ZC2dGZ2dD7sh8F/L5q2iXQNCs3QhqcN8PMCbIbdpJ+xhV/eCiul9gkms3bpwwBMNNlUBBtZkwvCeBnFZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001556; c=relaxed/simple;
	bh=+ZmLtMIdmurAL71JzFEBd3vShjrM56C1e1/YnA14ilM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nBf6MAbttyhSa4VGAFvr2YtExn/2pD7hR4VF3jgXKppAjWlVD7M9De00NZsG3bmCtOPsVFywmUi6m7v72jRqcL/8HhUpaPSkQrYYp07JVzzJlOkgd3yab+GpzHWUsRv4BwUY5Nl5Hr6BEZTyUZmP97C05pm3aef/cCp9bANraC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=omXucg67; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="omXucg67"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuk7m004100;
	Thu, 4 Sep 2025 15:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Xqg5W
	lYQHtB3G4hFDh2FY+sa1Ioz29va8Dp69nHDlOY=; b=omXucg67OGwQ+otDB1qeg
	509up39PX6IM4jS4ci89OLvYAZVsALrS832TT+UrHrpOHNh2CpugxBhBjYdbBnOh
	jDtZKQ/EQKYdcmPhte6qtE5hVbjd9bW7N6LPx0XGC82JVM+Ha6Qx23dCifty28Pc
	QkBeTuEBZgpIZIykoC5vC1z9lOLqn8VY9TYM8sA0z52riIxpiZSWn/EZOaQguSYA
	EUBRAR8LhZLN7CND04pHtp2cN6qLRNJGVNeDs0UfN1aLqYb7Wb6sOxkLA4RkyblM
	ye+gfNjp5WF0uvyhYX3Y+OmhgVrc9XUEME40UHwgek+GGDodoZbo5qm9aL3OE1QS
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun005x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FR1JR040152;
	Thu, 4 Sep 2025 15:59:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6m000707;
	Thu, 4 Sep 2025 15:59:02 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-61;
	Thu, 04 Sep 2025 15:59:02 +0000
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
Subject: [PATCH RFC 060/104] crypto: fips140: convert crypto/lskcipher.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:32 +0200
Message-Id: <20250904155216.460962-61-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: oR63FfqPQ4fF70_1igcCrnPxpFg21KJ-
X-Proofpoint-GUID: oR63FfqPQ4fF70_1igcCrnPxpFg21KJ-
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b747 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=nHyuKmgq4191pyuP54MA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX0wwZPFssNtuk
 5/7GU50KkKZWMeEelBRfMxMlCRDh/KigfTSvWVaFh3VK4WqsfHqdK4JiynDjNVutDcUvvdE00fT
 Odc7RGlb2dbGjEO1C/0s60tdZoGS5T+cZgcYGNGlUz0YmXhbh9UYBw1QaH9JSCGFGmy3psRU9d0
 /zs8ZfC6r85bVIksdHdGj4K9HL3oMg6dtKjpU1hlQ+gX8l7YnUVQlUxBqO8gZT4B0kFFtq6W+Li
 QoyXarVFdub6PO47dE/9coPJMlGVDx64HglFX5QbfzqRyti12xVn03zTRw+YzpEC8KORNW3IsGh
 BC/n0AUkM2QuKmmMNzA9DcH+pzNtNmQ6mktYV3Y+pm7REIgg5e3cicfhdxSgk4xj2ZX83lhD3g7
 c6l/l6YKA5TSm/vjG/vgJPcz3fajhA==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SKCIPHER2 --source crypto/lskcipher.c --header include/crypto/skcipher.h include/crypto/internal/skcipher.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c               | 24 ++++++++++++++++
 crypto/lskcipher.c                 | 44 +++++++++++++++---------------
 include/crypto/internal/skcipher.h | 34 +++++++++++++++--------
 include/crypto/skcipher.h          | 21 ++++++++------
 4 files changed, 82 insertions(+), 41 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 9c9f9d57f99d..70b896ef42ff 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -442,3 +442,27 @@ DEFINE_CRYPTO_API_STUB(crypto_grab_kpp);
 
 #endif
 
+/*
+ * crypto/lskcipher.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_SKCIPHER2)
+
+#include <crypto/skcipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_lskcipher);
+DEFINE_CRYPTO_API_STUB(crypto_lskcipher_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_lskcipher_encrypt);
+DEFINE_CRYPTO_API_STUB(crypto_lskcipher_decrypt);
+
+#include <crypto/internal/skcipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_grab_lskcipher);
+DEFINE_CRYPTO_API_STUB(crypto_register_lskcipher);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_lskcipher);
+DEFINE_CRYPTO_API_STUB(crypto_register_lskciphers);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_lskciphers);
+DEFINE_CRYPTO_API_STUB(lskcipher_register_instance);
+DEFINE_CRYPTO_API_STUB(lskcipher_alloc_instance_simple);
+
+#endif
+
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index c2e2c38b5aa8..147a897ae5ea 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -50,7 +50,7 @@ static int lskcipher_setkey_unaligned(struct crypto_lskcipher *tfm,
 	return ret;
 }
 
-int crypto_lskcipher_setkey(struct crypto_lskcipher *tfm, const u8 *key,
+int CRYPTO_API(crypto_lskcipher_setkey)(struct crypto_lskcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
@@ -64,7 +64,7 @@ int crypto_lskcipher_setkey(struct crypto_lskcipher *tfm, const u8 *key,
 	else
 		return cipher->setkey(tfm, key, keylen);
 }
-EXPORT_SYMBOL_GPL(crypto_lskcipher_setkey);
+DEFINE_CRYPTO_API(crypto_lskcipher_setkey);
 
 static int crypto_lskcipher_crypt_unaligned(
 	struct crypto_lskcipher *tfm, const u8 *src, u8 *dst, unsigned len,
@@ -137,23 +137,23 @@ static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
 	return crypt(tfm, src, dst, len, iv, CRYPTO_LSKCIPHER_FLAG_FINAL);
 }
 
-int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+int CRYPTO_API(crypto_lskcipher_encrypt)(struct crypto_lskcipher *tfm, const u8 *src,
 			     u8 *dst, unsigned len, u8 *iv)
 {
 	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
 
 	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->encrypt);
 }
-EXPORT_SYMBOL_GPL(crypto_lskcipher_encrypt);
+DEFINE_CRYPTO_API(crypto_lskcipher_encrypt);
 
-int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+int CRYPTO_API(crypto_lskcipher_decrypt)(struct crypto_lskcipher *tfm, const u8 *src,
 			     u8 *dst, unsigned len, u8 *iv)
 {
 	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
 
 	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->decrypt);
 }
-EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt);
+DEFINE_CRYPTO_API(crypto_lskcipher_decrypt);
 
 static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 				     int (*crypt)(struct crypto_lskcipher *tfm,
@@ -325,21 +325,21 @@ int crypto_init_lskcipher_ops_sg(struct crypto_tfm *tfm)
 	return 0;
 }
 
-int crypto_grab_lskcipher(struct crypto_lskcipher_spawn *spawn,
+int CRYPTO_API(crypto_grab_lskcipher)(struct crypto_lskcipher_spawn *spawn,
 			  struct crypto_instance *inst,
 			  const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_lskcipher_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_lskcipher);
+DEFINE_CRYPTO_API(crypto_grab_lskcipher);
 
-struct crypto_lskcipher *crypto_alloc_lskcipher(const char *alg_name,
+struct crypto_lskcipher *CRYPTO_API(crypto_alloc_lskcipher)(const char *alg_name,
 						u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_lskcipher_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_lskcipher);
+DEFINE_CRYPTO_API(crypto_alloc_lskcipher);
 
 static int lskcipher_prepare_alg(struct lskcipher_alg *alg)
 {
@@ -359,7 +359,7 @@ static int lskcipher_prepare_alg(struct lskcipher_alg *alg)
 	return 0;
 }
 
-int crypto_register_lskcipher(struct lskcipher_alg *alg)
+int CRYPTO_API(crypto_register_lskcipher)(struct lskcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->co.base;
 	int err;
@@ -370,15 +370,15 @@ int crypto_register_lskcipher(struct lskcipher_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_lskcipher);
+DEFINE_CRYPTO_API(crypto_register_lskcipher);
 
-void crypto_unregister_lskcipher(struct lskcipher_alg *alg)
+void CRYPTO_API(crypto_unregister_lskcipher)(struct lskcipher_alg *alg)
 {
 	crypto_unregister_alg(&alg->co.base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_lskcipher);
+DEFINE_CRYPTO_API(crypto_unregister_lskcipher);
 
-int crypto_register_lskciphers(struct lskcipher_alg *algs, int count)
+int CRYPTO_API(crypto_register_lskciphers)(struct lskcipher_alg *algs, int count)
 {
 	int i, ret;
 
@@ -396,18 +396,18 @@ int crypto_register_lskciphers(struct lskcipher_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_lskciphers);
+DEFINE_CRYPTO_API(crypto_register_lskciphers);
 
-void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_lskciphers)(struct lskcipher_alg *algs, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_lskcipher(&algs[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_lskciphers);
+DEFINE_CRYPTO_API(crypto_unregister_lskciphers);
 
-int lskcipher_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(lskcipher_register_instance)(struct crypto_template *tmpl,
 				struct lskcipher_instance *inst)
 {
 	int err;
@@ -421,7 +421,7 @@ int lskcipher_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, lskcipher_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(lskcipher_register_instance);
+DEFINE_CRYPTO_API(lskcipher_register_instance);
 
 static int lskcipher_setkey_simple(struct crypto_lskcipher *tfm, const u8 *key,
 				   unsigned int keylen)
@@ -480,7 +480,7 @@ static void lskcipher_free_instance_simple(struct lskcipher_instance *inst)
  * Return: a pointer to the new instance, or an ERR_PTR().  The caller still
  *	   needs to register the instance.
  */
-struct lskcipher_instance *lskcipher_alloc_instance_simple(
+struct lskcipher_instance *CRYPTO_API(lskcipher_alloc_instance_simple)(
 	struct crypto_template *tmpl, struct rtattr **tb)
 {
 	u32 mask;
@@ -590,4 +590,4 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 	lskcipher_free_instance_simple(inst);
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(lskcipher_alloc_instance_simple);
+DEFINE_CRYPTO_API(lskcipher_alloc_instance_simple);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d5aa535263f6..69de98e9819a 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_INTERNAL_SKCIPHER_H
 #define _CRYPTO_INTERNAL_SKCIPHER_H
 
+#include <crypto/api.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/scatterwalk.h>
@@ -100,9 +101,9 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask);
 
-int crypto_grab_lskcipher(struct crypto_lskcipher_spawn *spawn,
-			  struct crypto_instance *inst,
-			  const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_lskcipher, int,
+	(struct crypto_lskcipher_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
@@ -164,12 +165,21 @@ void crypto_unregister_skciphers(struct skcipher_alg *algs, int count);
 int skcipher_register_instance(struct crypto_template *tmpl,
 			       struct skcipher_instance *inst);
 
-int crypto_register_lskcipher(struct lskcipher_alg *alg);
-void crypto_unregister_lskcipher(struct lskcipher_alg *alg);
-int crypto_register_lskciphers(struct lskcipher_alg *algs, int count);
-void crypto_unregister_lskciphers(struct lskcipher_alg *algs, int count);
-int lskcipher_register_instance(struct crypto_template *tmpl,
-				struct lskcipher_instance *inst);
+DECLARE_CRYPTO_API(crypto_register_lskcipher, int,
+	(struct lskcipher_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_lskcipher, void,
+	(struct lskcipher_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_lskciphers, int,
+	(struct lskcipher_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_lskciphers, void,
+	(struct lskcipher_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(lskcipher_register_instance, int,
+	(struct crypto_template *tmpl, struct lskcipher_instance *inst),
+	(tmpl, inst));
 
 int skcipher_walk_virt(struct skcipher_walk *__restrict walk,
 		       struct skcipher_request *__restrict req,
@@ -247,8 +257,10 @@ static inline struct crypto_lskcipher *lskcipher_cipher_simple(
 	return *ctx;
 }
 
-struct lskcipher_instance *lskcipher_alloc_instance_simple(
-	struct crypto_template *tmpl, struct rtattr **tb);
+DECLARE_CRYPTO_API(lskcipher_alloc_instance_simple, struct lskcipher_instance *,
+	(
+	struct crypto_template *tmpl, struct rtattr **tb),
+	(tmpl, tb));
 
 static inline struct lskcipher_alg *lskcipher_ialg_simple(
 	struct lskcipher_instance *inst)
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345..8ce770bb1f48 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_SKCIPHER_H
 #define _CRYPTO_SKCIPHER_H
 
+#include <crypto/api.h>
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
@@ -297,8 +298,9 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(const char *alg_name,
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_lskcipher *crypto_alloc_lskcipher(const char *alg_name,
-						u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_lskcipher, struct crypto_lskcipher *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_skcipher_tfm(
 	struct crypto_skcipher *tfm)
@@ -636,8 +638,9 @@ static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_lskcipher_setkey(struct crypto_lskcipher *tfm,
-			    const u8 *key, unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_lskcipher_setkey, int,
+	(struct crypto_lskcipher *tfm, const u8 *key, unsigned int keylen),
+	(tfm, key, keylen));
 
 static inline unsigned int crypto_skcipher_min_keysize(
 	struct crypto_skcipher *tfm)
@@ -761,8 +764,9 @@ int crypto_skcipher_import(struct skcipher_request *req, const void *in);
  *	   then this many bytes have been left unprocessed;
  *	   < 0 if an error occurred
  */
-int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned len, u8 *siv);
+DECLARE_CRYPTO_API(crypto_lskcipher_encrypt, int,
+	(struct crypto_lskcipher *tfm, const u8 *src, u8 *dst, unsigned len, u8 *siv),
+	(tfm, src, dst, len, siv));
 
 /**
  * crypto_lskcipher_decrypt() - decrypt ciphertext
@@ -781,8 +785,9 @@ int crypto_lskcipher_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
  *	   then this many bytes have been left unprocessed;
  *	   < 0 if an error occurred
  */
-int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned len, u8 *siv);
+DECLARE_CRYPTO_API(crypto_lskcipher_decrypt, int,
+	(struct crypto_lskcipher *tfm, const u8 *src, u8 *dst, unsigned len, u8 *siv),
+	(tfm, src, dst, len, siv));
 
 /**
  * DOC: Symmetric Key Cipher Request Handle
-- 
2.39.3

