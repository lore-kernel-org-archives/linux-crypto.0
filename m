Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53628315D;
	Thu,  4 Sep 2025 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001423; cv=none; b=ooXWot20X//eKhvZSGtmZUcdDbUBtmzGIOtfC9niXTj9EKA4JIifbRY1GfmRtcO3bt1V9uUlfRDO6obZ02jajmqGWiaKDhRwgV8u0IYNnZ2n2aByecLZ2kRqvQshKsGJ5fll4A/a75mxJ28OfuNcTC4BP7DgKy0j2hPThAnJQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001423; c=relaxed/simple;
	bh=ot8QqweXq8NRqtdCSwCPGX5/cLjJjlYbDu8BDtQjaYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qk+PAqOFuvUy91LGvZmlbvZTjZqvO95LYdBSZRw7ulD4qx9WwyL1c0Hg+tycqm91jpFVjVzV0VTa0tmS+X8sFOWvaCY7ydQuRqDJGej9MlYfceVXOKcIU4lk8kAMcZ9/U7Cb5aboDHg378EyuQqPNrqhOSxiyMl9hyWVEPMXDT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eupNW78Q; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eupNW78Q"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftk48023945;
	Thu, 4 Sep 2025 15:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=tpAJt
	fEJr4tEM5cFFdYbk7gmZMfYIjYSEm/d4LOixsY=; b=eupNW78Qqv+smh+DWWt/Z
	v75pw8rPKgL15Oz88baTE5jQ6+ufaqHadBGkJONYXxD74/F8mIiBHr2Xb/E5Zv5r
	XPu06G3TRzGPqD5s3zQjvoqDLm8gTEw95wkkcPBiT//01rriXmdteIrgnys7m6Xv
	ye76eJiyJfJxkxuPSIP/+USNCCuLwdt1OVw1e4Cn2C10uK3hxmlvRT6U3G1sz5xh
	muQk8H/u/0Lst8j3OgXKpsulOyOqm7XEUC/1PKWj6+WDO/nP/JMAlKWRsb5PZEDA
	BioaFjdefV6gpC6jsSg/SM8zEqCZCnqIrWFSkXO2rO6Ov309fjnQzbTz7hiJgS2G
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd0248-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F46pB040015;
	Thu, 4 Sep 2025 15:56:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtncf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5k000707;
	Thu, 4 Sep 2025 15:56:48 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-30;
	Thu, 04 Sep 2025 15:56:48 +0000
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
Subject: [PATCH RFC 029/104] crypto: fips140: convert crypto/aead.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:01 +0200
Message-Id: <20250904155216.460962-30-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfXw9Yxu3iqUhCJ
 jPXMI2X92kcVyy+gO/u5LWjQ+OQsWa88acSSw8wJEn22pLL8SYcdgdvmhl0aGXVBXqWObxXpIeR
 dp9eUsDqd8Pu1HOT1/m+sXMFmRjmtvd1gjR/WMP2CPapFLX+E/2Tytt62aeXHTUgYATNNLjWrFC
 T+AQbr+aJNme99tL/DapeoOFJI/1w2A8fb1OsHdgDR+5yXkSad5YUJAuuMNflqEHs1LEGmhWTkq
 NDL9HFXQoyCoTINaOuN57af/u2uZAt7TIOInk5ACFq2N7RuCY/QGqmLAE+1LYaIGBP0iQ7FQ4sP
 qw5sEY7N2QeoAgxOOJpIRQZ9dFp/9Qe7tF8obuDcM8CZ1pbwglpZFx8xOUJzC8RpwiIM+2SA/v7
 N0PUEuyWaRncuQhtUMhU8afMApooBw==
X-Proofpoint-GUID: jsx_MubVnxS7mDBSrDGyR-h-ZG57s5wX
X-Proofpoint-ORIG-GUID: jsx_MubVnxS7mDBSrDGyR-h-ZG57s5wX
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b6c2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=C-48EvJf1n4mUmqdypEA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_AEAD2 --source crypto/aead.c --header include/crypto/aead.h include/crypto/internal/aead.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/aead.c                  | 48 +++++++++++++++++-----------------
 crypto/fips140-api.c           | 25 ++++++++++++++++++
 include/crypto/aead.h          | 26 +++++++++++++-----
 include/crypto/internal/aead.h | 28 +++++++++++++-------
 4 files changed, 87 insertions(+), 40 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 5d14b775036e..f6cc3a76120e 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -41,7 +41,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 	return ret;
 }
 
-int crypto_aead_setkey(struct crypto_aead *tfm,
+int CRYPTO_API(crypto_aead_setkey)(struct crypto_aead *tfm,
 		       const u8 *key, unsigned int keylen)
 {
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
@@ -60,9 +60,9 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
 	crypto_aead_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_aead_setkey);
+DEFINE_CRYPTO_API(crypto_aead_setkey);
 
-int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+int CRYPTO_API(crypto_aead_setauthsize)(struct crypto_aead *tfm, unsigned int authsize)
 {
 	int err;
 
@@ -79,9 +79,9 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 	tfm->authsize = authsize;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
+DEFINE_CRYPTO_API(crypto_aead_setauthsize);
 
-int crypto_aead_encrypt(struct aead_request *req)
+int CRYPTO_API(crypto_aead_encrypt)(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 
@@ -90,9 +90,9 @@ int crypto_aead_encrypt(struct aead_request *req)
 
 	return crypto_aead_alg(aead)->encrypt(req);
 }
-EXPORT_SYMBOL_GPL(crypto_aead_encrypt);
+DEFINE_CRYPTO_API(crypto_aead_encrypt);
 
-int crypto_aead_decrypt(struct aead_request *req)
+int CRYPTO_API(crypto_aead_decrypt)(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 
@@ -104,7 +104,7 @@ int crypto_aead_decrypt(struct aead_request *req)
 
 	return crypto_aead_alg(aead)->decrypt(req);
 }
-EXPORT_SYMBOL_GPL(crypto_aead_decrypt);
+DEFINE_CRYPTO_API(crypto_aead_decrypt);
 
 static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
 {
@@ -189,26 +189,26 @@ static const struct crypto_type crypto_aead_type = {
 	.algsize = offsetof(struct aead_alg, base),
 };
 
-int crypto_grab_aead(struct crypto_aead_spawn *spawn,
+int CRYPTO_API(crypto_grab_aead)(struct crypto_aead_spawn *spawn,
 		     struct crypto_instance *inst,
 		     const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_aead_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_aead);
+DEFINE_CRYPTO_API(crypto_grab_aead);
 
-struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
+struct crypto_aead *CRYPTO_API(crypto_alloc_aead)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_aead_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_aead);
+DEFINE_CRYPTO_API(crypto_alloc_aead);
 
-int crypto_has_aead(const char *alg_name, u32 type, u32 mask)
+int CRYPTO_API(crypto_has_aead)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_aead_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_aead);
+DEFINE_CRYPTO_API(crypto_has_aead);
 
 static int aead_prepare_alg(struct aead_alg *alg)
 {
@@ -228,7 +228,7 @@ static int aead_prepare_alg(struct aead_alg *alg)
 	return 0;
 }
 
-int crypto_register_aead(struct aead_alg *alg)
+int CRYPTO_API(crypto_register_aead)(struct aead_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 	int err;
@@ -239,15 +239,15 @@ int crypto_register_aead(struct aead_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_aead);
+DEFINE_CRYPTO_API(crypto_register_aead);
 
-void crypto_unregister_aead(struct aead_alg *alg)
+void CRYPTO_API(crypto_unregister_aead)(struct aead_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_aead);
+DEFINE_CRYPTO_API(crypto_unregister_aead);
 
-int crypto_register_aeads(struct aead_alg *algs, int count)
+int CRYPTO_API(crypto_register_aeads)(struct aead_alg *algs, int count)
 {
 	int i, ret;
 
@@ -265,18 +265,18 @@ int crypto_register_aeads(struct aead_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_aeads);
+DEFINE_CRYPTO_API(crypto_register_aeads);
 
-void crypto_unregister_aeads(struct aead_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_aeads)(struct aead_alg *algs, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_aead(&algs[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_aeads);
+DEFINE_CRYPTO_API(crypto_unregister_aeads);
 
-int aead_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(aead_register_instance)(struct crypto_template *tmpl,
 			   struct aead_instance *inst)
 {
 	int err;
@@ -290,7 +290,7 @@ int aead_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, aead_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(aead_register_instance);
+DEFINE_CRYPTO_API(aead_register_instance);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Authenticated Encryption with Associated Data (AEAD)");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 6caef4827a53..896b42fb4330 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -127,3 +127,28 @@ DEFINE_CRYPTO_API_STUB(__crypto_xor);
 
 #endif
 
+/*
+ * crypto/aead.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_AEAD2)
+
+#include <crypto/aead.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_aead);
+DEFINE_CRYPTO_API_STUB(crypto_has_aead);
+DEFINE_CRYPTO_API_STUB(crypto_aead_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_aead_setauthsize);
+DEFINE_CRYPTO_API_STUB(crypto_aead_encrypt);
+DEFINE_CRYPTO_API_STUB(crypto_aead_decrypt);
+
+#include <crypto/internal/aead.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_grab_aead);
+DEFINE_CRYPTO_API_STUB(crypto_register_aead);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_aead);
+DEFINE_CRYPTO_API_STUB(crypto_register_aeads);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_aeads);
+DEFINE_CRYPTO_API_STUB(aead_register_instance);
+
+#endif
+
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 0e8a41638678..714a110a64bf 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_AEAD_H
 #define _CRYPTO_AEAD_H
 
+#include <crypto/api.h>
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
@@ -178,7 +179,9 @@ static inline struct crypto_aead *__crypto_aead_cast(struct crypto_tfm *tfm)
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_aead, struct crypto_aead *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_aead_tfm(struct crypto_aead *tfm)
 {
@@ -206,7 +209,9 @@ static inline void crypto_free_aead(struct crypto_aead *tfm)
  * Return: true when the aead is known to the kernel crypto API; false
  *	   otherwise
  */
-int crypto_has_aead(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_has_aead, int,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline const char *crypto_aead_driver_name(struct crypto_aead *tfm)
 {
@@ -316,8 +321,9 @@ static inline void crypto_aead_clear_flags(struct crypto_aead *tfm, u32 flags)
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_aead_setkey(struct crypto_aead *tfm,
-		       const u8 *key, unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_aead_setkey, int,
+	(struct crypto_aead *tfm, const u8 *key, unsigned int keylen),
+	(tfm, key, keylen));
 
 /**
  * crypto_aead_setauthsize() - set authentication data size
@@ -329,7 +335,9 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize);
+DECLARE_CRYPTO_API(crypto_aead_setauthsize, int,
+	(struct crypto_aead *tfm, unsigned int authsize),
+	(tfm, authsize));
 
 static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 {
@@ -355,7 +363,9 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-int crypto_aead_encrypt(struct aead_request *req);
+DECLARE_CRYPTO_API(crypto_aead_encrypt, int,
+	(struct aead_request *req),
+	(req));
 
 /**
  * crypto_aead_decrypt() - decrypt ciphertext
@@ -379,7 +389,9 @@ int crypto_aead_encrypt(struct aead_request *req);
  *	   integrity of the ciphertext or the associated data was violated);
  *	   < 0 if an error occurred.
  */
-int crypto_aead_decrypt(struct aead_request *req);
+DECLARE_CRYPTO_API(crypto_aead_decrypt, int,
+	(struct aead_request *req),
+	(req));
 
 /**
  * DOC: Asynchronous AEAD Request Handle
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 28a95eb3182d..8abe35a07fd4 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_INTERNAL_AEAD_H
 #define _CRYPTO_INTERNAL_AEAD_H
 
+#include <crypto/api.h>
 #include <crypto/aead.h>
 #include <crypto/algapi.h>
 #include <linux/stddef.h>
@@ -96,9 +97,9 @@ static inline struct aead_request *aead_request_cast(
 	return container_of(req, struct aead_request, base);
 }
 
-int crypto_grab_aead(struct crypto_aead_spawn *spawn,
-		     struct crypto_instance *inst,
-		     const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_aead, int,
+	(struct crypto_aead_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 static inline void crypto_drop_aead(struct crypto_aead_spawn *spawn)
 {
@@ -157,12 +158,21 @@ static inline unsigned int crypto_aead_chunksize(struct crypto_aead *tfm)
 	return crypto_aead_alg_chunksize(crypto_aead_alg(tfm));
 }
 
-int crypto_register_aead(struct aead_alg *alg);
-void crypto_unregister_aead(struct aead_alg *alg);
-int crypto_register_aeads(struct aead_alg *algs, int count);
-void crypto_unregister_aeads(struct aead_alg *algs, int count);
-int aead_register_instance(struct crypto_template *tmpl,
-			   struct aead_instance *inst);
+DECLARE_CRYPTO_API(crypto_register_aead, int,
+	(struct aead_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_aead, void,
+	(struct aead_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_aeads, int,
+	(struct aead_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_aeads, void,
+	(struct aead_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(aead_register_instance, int,
+	(struct crypto_template *tmpl, struct aead_instance *inst),
+	(tmpl, inst));
 
 #endif	/* _CRYPTO_INTERNAL_AEAD_H */
 
-- 
2.39.3

