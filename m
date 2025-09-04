Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37A428134C;
	Thu,  4 Sep 2025 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001433; cv=none; b=YhFs+kwdGzCSSFtRKwp7QQzbsZMRK9mczDks/7V8Ov2UGFwMicpzkGJdqJUDoUw8m1IXrHWWEWRMupQoSWnPgs6UcReI0ppbrGxpiUCVQTPBIsVHqiYWZm/dxa+xBe3pqZmE+ebNEw+iyIPs3cW3HSGTGTdz1sH4vv7bsVVyCx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001433; c=relaxed/simple;
	bh=dqI0b2iFQ4aNF4XGN8VJMr9q2525gK6jzzF3//Bg2RI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZBJEOpO9W1FNlQ3OFIdE21oVzD0XDHLlz+MHtI7vgC8VF5Diq3gr6aNQ7ZkvVmNaOAfA3fGlEzPnzUa3cEWFj3IEPyZ0CrwuG38dtkJda7lsWbU6joEdPKz6FrozCoHH9WYN6YKXcV9RHJlIFM2idEd+qzUsjKk/J6in5uzbiyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nAaiXPlb; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nAaiXPlb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiN5009080;
	Thu, 4 Sep 2025 15:57:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=TEusS
	F9hVlmKOKt1ajfVTadBJOP99wcXXturJ5VDCuc=; b=nAaiXPlbj5WkWeUB3MV3E
	KzcarObjAqe3rWAO/vFUiy/qHyGy5Hq7CdnocOQq02ObvyxZc5MzRPsbYuHfmRvf
	zOHQWMjixXIze3oa+8fbA6KJEPBW85fojQi7UOvWbfN3iH+vsHHj79G6Wa3FDTuh
	I89SvOurmsM74PsLO6GcqmdQpYtma/T/he/mzkbHWLhESH0qTaGrjVcAUXpq3bIM
	KdLfaygZbH9J1ClODsOOCCkpBR1AJJuqYN3cQObzyDtWfALsFeP7KNiYGyogsmnW
	WVpKLt6U2ebPwBpcYB79wyIhPfWvQsvDs8h8Mw6NdzVThji9t3XYiKPosLwCUVrb
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt0072-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:57:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FIfjS040023;
	Thu, 4 Sep 2025 15:56:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnh5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5q000707;
	Thu, 4 Sep 2025 15:56:58 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-33;
	Thu, 04 Sep 2025 15:56:58 +0000
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
Subject: [PATCH RFC 032/104] crypto: fips140: convert crypto/akcipher.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:04 +0200
Message-Id: <20250904155216.460962-33-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: OkCZGKNOFK-xxZtcC9fOHc8k7bRnxaA4
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b6cc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=AitMZ-3xgevXpIBoGDMA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXxT6IjRrwuZHV
 xdf5nfe8cZU758KVWrQ9YapEdJEMRK8QhCrkGd8Suw0ErrkR2HrNnS888V+s/7n6Pe3Q8NQ7Boi
 I+HmNpI5Ebod3uUta9fPwDEUhHRbh+C1HpYwPfuNJMCg/gdkW4mDq9yDg1f0Jo7wqozh2RaxdhC
 3QhVe/v8gybp0cS/sJhdR8UTGHHNaXM/w8Epv8w16Uihukrx/osL9vNtJU8ENisiaCMGNAN++ab
 Hu2bmW0/a2swL2foVoNdynKDWNlB9bztOTdE1r+ccjY94+519LumzoS19krEnEya+SYfTkwCugD
 dMgSSiiFHVPRQzBuEc3RD1Ms+RBQvD9F3C3AwoCToS3h3daMbDps952Q98SbukcsP/Tw7VzeFrU
 qNYwKGK40TmJT3/UgmMGE6BDOqxbVA==
X-Proofpoint-GUID: OkCZGKNOFK-xxZtcC9fOHc8k7bRnxaA4

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_AKCIPHER2 --source crypto/akcipher.c --header include/crypto/akcipher.h include/crypto/internal/akcipher.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/akcipher.c                  | 28 ++++++++++++++--------------
 crypto/fips140-api.c               | 20 ++++++++++++++++++++
 include/crypto/akcipher.h          | 18 ++++++++++--------
 include/crypto/internal/akcipher.h | 21 ++++++++++++++-------
 4 files changed, 58 insertions(+), 29 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index a36f50c83827..1cfc6c7bfbae 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -100,21 +100,21 @@ static const struct crypto_type crypto_akcipher_type = {
 	.algsize = offsetof(struct akcipher_alg, base),
 };
 
-int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
+int CRYPTO_API(crypto_grab_akcipher)(struct crypto_akcipher_spawn *spawn,
 			 struct crypto_instance *inst,
 			 const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_akcipher_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_akcipher);
+DEFINE_CRYPTO_API(crypto_grab_akcipher);
 
-struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
+struct crypto_akcipher *CRYPTO_API(crypto_alloc_akcipher)(const char *alg_name, u32 type,
 					      u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_akcipher_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_akcipher);
+DEFINE_CRYPTO_API(crypto_alloc_akcipher);
 
 static void akcipher_prepare_alg(struct akcipher_alg *alg)
 {
@@ -136,7 +136,7 @@ static int akcipher_default_set_key(struct crypto_akcipher *tfm,
 	return -ENOSYS;
 }
 
-int crypto_register_akcipher(struct akcipher_alg *alg)
+int CRYPTO_API(crypto_register_akcipher)(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
@@ -150,15 +150,15 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
 	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_akcipher);
+DEFINE_CRYPTO_API(crypto_register_akcipher);
 
-void crypto_unregister_akcipher(struct akcipher_alg *alg)
+void CRYPTO_API(crypto_unregister_akcipher)(struct akcipher_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_akcipher);
+DEFINE_CRYPTO_API(crypto_unregister_akcipher);
 
-int akcipher_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(akcipher_register_instance)(struct crypto_template *tmpl,
 			       struct akcipher_instance *inst)
 {
 	if (WARN_ON(!inst->free))
@@ -166,7 +166,7 @@ int akcipher_register_instance(struct crypto_template *tmpl,
 	akcipher_prepare_alg(&inst->alg);
 	return crypto_register_instance(tmpl, akcipher_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(akcipher_register_instance);
+DEFINE_CRYPTO_API(akcipher_register_instance);
 
 static int crypto_akcipher_sync_prep(struct crypto_akcipher_sync_data *data)
 {
@@ -215,7 +215,7 @@ static int crypto_akcipher_sync_post(struct crypto_akcipher_sync_data *data,
 	return err;
 }
 
-int crypto_akcipher_sync_encrypt(struct crypto_akcipher *tfm,
+int CRYPTO_API(crypto_akcipher_sync_encrypt)(struct crypto_akcipher *tfm,
 				 const void *src, unsigned int slen,
 				 void *dst, unsigned int dlen)
 {
@@ -231,9 +231,9 @@ int crypto_akcipher_sync_encrypt(struct crypto_akcipher *tfm,
 	       crypto_akcipher_sync_post(&data,
 					 crypto_akcipher_encrypt(data.req));
 }
-EXPORT_SYMBOL_GPL(crypto_akcipher_sync_encrypt);
+DEFINE_CRYPTO_API(crypto_akcipher_sync_encrypt);
 
-int crypto_akcipher_sync_decrypt(struct crypto_akcipher *tfm,
+int CRYPTO_API(crypto_akcipher_sync_decrypt)(struct crypto_akcipher *tfm,
 				 const void *src, unsigned int slen,
 				 void *dst, unsigned int dlen)
 {
@@ -250,7 +250,7 @@ int crypto_akcipher_sync_decrypt(struct crypto_akcipher *tfm,
 					 crypto_akcipher_decrypt(data.req)) ?:
 	       data.dlen;
 }
-EXPORT_SYMBOL_GPL(crypto_akcipher_sync_decrypt);
+DEFINE_CRYPTO_API(crypto_akcipher_sync_decrypt);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic public key cipher type");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 530195c057eb..3c3445523803 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -203,3 +203,23 @@ DEFINE_CRYPTO_API_STUB(crypto_hash_digest);
 
 #endif
 
+/*
+ * crypto/akcipher.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_AKCIPHER2)
+
+#include <crypto/akcipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_akcipher);
+DEFINE_CRYPTO_API_STUB(crypto_akcipher_sync_encrypt);
+DEFINE_CRYPTO_API_STUB(crypto_akcipher_sync_decrypt);
+
+#include <crypto/internal/akcipher.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_grab_akcipher);
+DEFINE_CRYPTO_API_STUB(crypto_register_akcipher);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_akcipher);
+DEFINE_CRYPTO_API_STUB(akcipher_register_instance);
+
+#endif
+
diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index cdf7da74bf2f..d6ae05da0811 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_AKCIPHER_H
 #define _CRYPTO_AKCIPHER_H
 
+#include <crypto/api.h>
 #include <linux/atomic.h>
 #include <linux/crypto.h>
 
@@ -116,8 +117,9 @@ struct akcipher_alg {
  * Return: allocated handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_akcipher *crypto_alloc_akcipher(const char *alg_name, u32 type,
-					      u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_akcipher, struct crypto_akcipher *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_akcipher_tfm(
 	struct crypto_akcipher *tfm)
@@ -310,9 +312,9 @@ static inline int crypto_akcipher_decrypt(struct akcipher_request *req)
  *
  * Return: zero on success; error code in case of error
  */
-int crypto_akcipher_sync_encrypt(struct crypto_akcipher *tfm,
-				 const void *src, unsigned int slen,
-				 void *dst, unsigned int dlen);
+DECLARE_CRYPTO_API(crypto_akcipher_sync_encrypt, int,
+	(struct crypto_akcipher *tfm, const void *src, unsigned int slen, void *dst, unsigned int dlen),
+	(tfm, src, slen, dst, dlen));
 
 /**
  * crypto_akcipher_sync_decrypt() - Invoke public key decrypt operation
@@ -328,9 +330,9 @@ int crypto_akcipher_sync_encrypt(struct crypto_akcipher *tfm,
  *
  * Return: Output length on success; error code in case of error
  */
-int crypto_akcipher_sync_decrypt(struct crypto_akcipher *tfm,
-				 const void *src, unsigned int slen,
-				 void *dst, unsigned int dlen);
+DECLARE_CRYPTO_API(crypto_akcipher_sync_decrypt, int,
+	(struct crypto_akcipher *tfm, const void *src, unsigned int slen, void *dst, unsigned int dlen),
+	(tfm, src, slen, dst, dlen));
 
 /**
  * crypto_akcipher_set_pub_key() - Invoke set public key operation
diff --git a/include/crypto/internal/akcipher.h b/include/crypto/internal/akcipher.h
index 14ee62bc52b6..5ea9c6cbce04 100644
--- a/include/crypto/internal/akcipher.h
+++ b/include/crypto/internal/akcipher.h
@@ -7,6 +7,8 @@
  */
 #ifndef _CRYPTO_AKCIPHER_INT_H
 #define _CRYPTO_AKCIPHER_INT_H
+
+#include <crypto/api.h>
 #include <crypto/akcipher.h>
 #include <crypto/algapi.h>
 
@@ -100,9 +102,9 @@ static inline void *akcipher_instance_ctx(struct akcipher_instance *inst)
 	return crypto_instance_ctx(akcipher_crypto_instance(inst));
 }
 
-int crypto_grab_akcipher(struct crypto_akcipher_spawn *spawn,
-			 struct crypto_instance *inst,
-			 const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_akcipher, int,
+	(struct crypto_akcipher_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 static inline struct crypto_akcipher *crypto_spawn_akcipher(
 		struct crypto_akcipher_spawn *spawn)
@@ -130,7 +132,9 @@ static inline struct akcipher_alg *crypto_spawn_akcipher_alg(
  *
  * Return: zero on success; error code in case of error
  */
-int crypto_register_akcipher(struct akcipher_alg *alg);
+DECLARE_CRYPTO_API(crypto_register_akcipher, int,
+	(struct akcipher_alg *alg),
+	(alg));
 
 /**
  * crypto_unregister_akcipher() -- Unregister public key algorithm
@@ -139,7 +143,9 @@ int crypto_register_akcipher(struct akcipher_alg *alg);
  *
  * @alg:	algorithm definition
  */
-void crypto_unregister_akcipher(struct akcipher_alg *alg);
+DECLARE_CRYPTO_API(crypto_unregister_akcipher, void,
+	(struct akcipher_alg *alg),
+	(alg));
 
 /**
  * akcipher_register_instance() -- Unregister public key template instance
@@ -150,6 +156,7 @@ void crypto_unregister_akcipher(struct akcipher_alg *alg);
  * @tmpl:	the template from which the algorithm was created
  * @inst:	the template instance
  */
-int akcipher_register_instance(struct crypto_template *tmpl,
-		struct akcipher_instance *inst);
+DECLARE_CRYPTO_API(akcipher_register_instance, int,
+	(struct crypto_template *tmpl, struct akcipher_instance *inst),
+	(tmpl, inst));
 #endif
-- 
2.39.3

