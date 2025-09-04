Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8160D283FF8;
	Thu,  4 Sep 2025 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001591; cv=none; b=T7eSgTo3P2FrjARz7BHDTadN9jr09Ha4mxro16nLCd+3x134zHA0epdBhmO8P7hBMKwI/2cyFgHV2OCVmgz1FnnzmqAB1ZG7N4w7avJ/jsaXCmUg5r/CGxR5ZYaYopmNBGRTDbQuOWudmcqdgc78DSJS4IbT5GjGHmydZz5kp/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001591; c=relaxed/simple;
	bh=5EnhCOB6fkRetWN4iWekzV5LdKjtzd7nLYJk48PFhLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HyeGAsFPIUHRRHVSifGqdaO6doIcihvCgsxVtMOu5SXAcX4RYblMWg9bzLnRgWdARipaFlxawMJD94EC5IU4qK+E7KdEIDMrcAJx5ALlJj2z3dHaioCz6JQLnTJKkq2O7MIhCbsAhJ5q+fJd3spxonLRssw1nqeeo4Nql6TGBxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S1maYJF8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S1maYJF8"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtonZ009162;
	Thu, 4 Sep 2025 15:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=0WjDf
	9ISjXaXnA1vvRtJvFrbmb7pUfWX7Q7fKv5iVn4=; b=S1maYJF8LN1cRwTIwPxq7
	LGlVeteoeIRUIGvN365M6jxSfDv3MmnoiNEy5Law7/Tuc8+slLSeO8yy7wSNb8sz
	aHLvP5d6dUyAENZblhsb4ZSFJLqQcu1y2UtQ5S/6cXxEuErb4UvAdQYupT37gF4d
	jSK/NjESApmFA5uT7M+1jd0j+wm03fXQ1O7PRWepn6phpHsWMPHtB7oS+KyfupTH
	bmcYItd2RSI6rlR9zDhm0Z4a56W6nFdKTIg6ZRfqfvtdmS0X1YLnLqhCPZeQjgUM
	Od10U+m5Aht2dygU92iiiFaC/9FgeZmSkre2ypNkn1BQgaA+c7SZy1PCySgxyWxX
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDegY040212;
	Thu, 4 Sep 2025 15:59:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx78000707;
	Thu, 4 Sep 2025 15:59:36 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-71;
	Thu, 04 Sep 2025 15:59:36 +0000
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
Subject: [PATCH RFC 070/104] crypto: fips140: convert crypto/shash.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:42 +0200
Message-Id: <20250904155216.460962-71-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: vw9u5Eno4J1cQtrvdqnUwz2bWUVU_yj1
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b76a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=4GdsGrEFWVkbR4aBJNEA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX5Fzj9T/AiFGH
 HSCa+Dpa3PoZY7qbbzUNyS0CQVoPEBCr3i2gmTmUh/84hHyWLvHTSQygVyHS3Y7ihA0AyEHi0gG
 r8RhHPBqYDb3VuVOvZ0ZtyVR2ZcDVPgcP9ryK1iaWumW3nmwGynqEy+2hbBUUd+F3UZsAlbJmue
 bHwUhLY5d2uOYQeSdtamWr0agoQSLINXPGx8tkMOARclEVPzFEc6O2+UaqbcDJ9bhxWrx1elasC
 hWUj6cQ4tayQFnnZcTZlwWG6pSccKJL6GdKVGcNp+xyHo8ZSigsqix6b2r2w441iSr6ISO7eXRV
 NMbT1SmCWihoE3kaw1Cu8PEUiyhEN4zHpFdJ/8vBrGOha5Xu2pKgeCQVTxXbTMuzALRQ9/bVHhR
 W3oAA6RcYeoGReTu1T9P6C7ZPVsQAA==
X-Proofpoint-GUID: vw9u5Eno4J1cQtrvdqnUwz2bWUVU_yj1

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_HASH2 --source crypto/shash.c --header include/crypto/hash.h include/crypto/internal/hash.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c           | 33 ++++++++++++++
 crypto/shash.c                 | 80 +++++++++++++++++-----------------
 include/crypto/hash.h          | 45 ++++++++++++-------
 include/crypto/internal/hash.h | 43 ++++++++++++------
 4 files changed, 133 insertions(+), 68 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 2567c6d6622f..eec551e120e2 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -511,3 +511,36 @@ DEFINE_CRYPTO_API_STUB(crypto_sha3_init);
 
 #endif
 
+/*
+ * crypto/shash.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_HASH2)
+
+#include <crypto/hash.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_shash);
+DEFINE_CRYPTO_API_STUB(crypto_clone_shash);
+DEFINE_CRYPTO_API_STUB(crypto_has_shash);
+DEFINE_CRYPTO_API_STUB(crypto_shash_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_shash_digest);
+DEFINE_CRYPTO_API_STUB(crypto_shash_tfm_digest);
+DEFINE_CRYPTO_API_STUB(crypto_shash_export);
+DEFINE_CRYPTO_API_STUB(crypto_shash_import);
+DEFINE_CRYPTO_API_STUB(crypto_shash_init);
+DEFINE_CRYPTO_API_STUB(crypto_shash_finup);
+
+#include <crypto/internal/hash.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_shash_alg_has_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_register_shash);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_shash);
+DEFINE_CRYPTO_API_STUB(crypto_register_shashes);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_shashes);
+DEFINE_CRYPTO_API_STUB(shash_register_instance);
+DEFINE_CRYPTO_API_STUB(shash_free_singlespawn_instance);
+DEFINE_CRYPTO_API_STUB(crypto_grab_shash);
+DEFINE_CRYPTO_API_STUB(crypto_shash_export_core);
+DEFINE_CRYPTO_API_STUB(crypto_shash_import_core);
+
+#endif
+
diff --git a/crypto/shash.c b/crypto/shash.c
index d45d7ec83a8c..9f154cebbb95 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -47,11 +47,11 @@ static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
  * when CFI is enabled, modules won't get the same address for shash_no_setkey
  * (if it were exported, which inlining would require) as the core kernel will.
  */
-bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+bool CRYPTO_API(crypto_shash_alg_has_setkey)(struct shash_alg *alg)
 {
 	return alg->setkey != shash_no_setkey;
 }
-EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);
+DEFINE_CRYPTO_API(crypto_shash_alg_has_setkey);
 
 static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
 {
@@ -59,7 +59,7 @@ static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
-int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
+int CRYPTO_API(crypto_shash_setkey)(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct shash_alg *shash = crypto_shash_alg(tfm);
@@ -74,7 +74,7 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 	crypto_shash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_shash_setkey);
+DEFINE_CRYPTO_API(crypto_shash_setkey);
 
 static int __crypto_shash_init(struct shash_desc *desc)
 {
@@ -90,13 +90,13 @@ static int __crypto_shash_init(struct shash_desc *desc)
 	return crypto_shash_alg(tfm)->init(desc);
 }
 
-int crypto_shash_init(struct shash_desc *desc)
+int CRYPTO_API(crypto_shash_init)(struct shash_desc *desc)
 {
 	if (crypto_shash_get_flags(desc->tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 	return __crypto_shash_init(desc);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_init);
+DEFINE_CRYPTO_API(crypto_shash_init);
 
 static int shash_default_finup(struct shash_desc *desc, const u8 *data,
 			       unsigned int len, u8 *out)
@@ -119,7 +119,7 @@ static int crypto_shash_op_and_zero(
 	return err;
 }
 
-int crypto_shash_finup(struct shash_desc *restrict desc, const u8 *data,
+int CRYPTO_API(crypto_shash_finup)(struct shash_desc *restrict desc, const u8 *data,
 		       unsigned int len, u8 *restrict out)
 {
 	struct crypto_shash *tfm = desc->tfm;
@@ -183,7 +183,7 @@ int crypto_shash_finup(struct shash_desc *restrict desc, const u8 *data,
 	return crypto_shash_op_and_zero(crypto_shash_alg(tfm)->finup, desc,
 					data, len, out);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_finup);
+DEFINE_CRYPTO_API(crypto_shash_finup);
 
 static int shash_default_digest(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
@@ -192,7 +192,7 @@ static int shash_default_digest(struct shash_desc *desc, const u8 *data,
 	       crypto_shash_finup(desc, data, len, out);
 }
 
-int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
+int CRYPTO_API(crypto_shash_digest)(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
@@ -203,9 +203,9 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 	return crypto_shash_op_and_zero(crypto_shash_alg(tfm)->digest, desc,
 					data, len, out);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_digest);
+DEFINE_CRYPTO_API(crypto_shash_digest);
 
-int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
+int CRYPTO_API(crypto_shash_tfm_digest)(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out)
 {
 	SHASH_DESC_ON_STACK(desc, tfm);
@@ -213,7 +213,7 @@ int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 	desc->tfm = tfm;
 	return crypto_shash_digest(desc, data, len, out);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_tfm_digest);
+DEFINE_CRYPTO_API(crypto_shash_tfm_digest);
 
 static int __crypto_shash_export(struct shash_desc *desc, void *out,
 				 int (*export)(struct shash_desc *desc,
@@ -235,14 +235,14 @@ static int __crypto_shash_export(struct shash_desc *desc, void *out,
 	return export(desc, out);
 }
 
-int crypto_shash_export_core(struct shash_desc *desc, void *out)
+int CRYPTO_API(crypto_shash_export_core)(struct shash_desc *desc, void *out)
 {
 	return __crypto_shash_export(desc, out,
 				     crypto_shash_alg(desc->tfm)->export_core);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_export_core);
+DEFINE_CRYPTO_API(crypto_shash_export_core);
 
-int crypto_shash_export(struct shash_desc *desc, void *out)
+int CRYPTO_API(crypto_shash_export)(struct shash_desc *desc, void *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
 
@@ -256,7 +256,7 @@ int crypto_shash_export(struct shash_desc *desc, void *out)
 	}
 	return __crypto_shash_export(desc, out, crypto_shash_alg(tfm)->export);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_export);
+DEFINE_CRYPTO_API(crypto_shash_export);
 
 static int __crypto_shash_import(struct shash_desc *desc, const void *in,
 				 int (*import)(struct shash_desc *desc,
@@ -284,14 +284,14 @@ static int __crypto_shash_import(struct shash_desc *desc, const void *in,
 	return import(desc, in);
 }
 
-int crypto_shash_import_core(struct shash_desc *desc, const void *in)
+int CRYPTO_API(crypto_shash_import_core)(struct shash_desc *desc, const void *in)
 {
 	return __crypto_shash_import(desc, in,
 				     crypto_shash_alg(desc->tfm)->import_core);
 }
-EXPORT_SYMBOL_GPL(crypto_shash_import_core);
+DEFINE_CRYPTO_API(crypto_shash_import_core);
 
-int crypto_shash_import(struct shash_desc *desc, const void *in)
+int CRYPTO_API(crypto_shash_import)(struct shash_desc *desc, const void *in)
 {
 	struct crypto_shash *tfm = desc->tfm;
 	int err;
@@ -309,7 +309,7 @@ int crypto_shash_import(struct shash_desc *desc, const void *in)
 	}
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_shash_import);
+DEFINE_CRYPTO_API(crypto_shash_import);
 
 static void crypto_shash_exit_tfm(struct crypto_tfm *tfm)
 {
@@ -386,29 +386,29 @@ const struct crypto_type crypto_shash_type = {
 	.algsize = offsetof(struct shash_alg, base),
 };
 
-int crypto_grab_shash(struct crypto_shash_spawn *spawn,
+int CRYPTO_API(crypto_grab_shash)(struct crypto_shash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_shash_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_shash);
+DEFINE_CRYPTO_API(crypto_grab_shash);
 
-struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
+struct crypto_shash *CRYPTO_API(crypto_alloc_shash)(const char *alg_name, u32 type,
 					u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_shash_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_shash);
+DEFINE_CRYPTO_API(crypto_alloc_shash);
 
-int crypto_has_shash(const char *alg_name, u32 type, u32 mask)
+int CRYPTO_API(crypto_has_shash)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_shash_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_shash);
+DEFINE_CRYPTO_API(crypto_has_shash);
 
-struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
+struct crypto_shash *CRYPTO_API(crypto_clone_shash)(struct crypto_shash *hash)
 {
 	struct crypto_tfm *tfm = crypto_shash_tfm(hash);
 	struct shash_alg *alg = crypto_shash_alg(hash);
@@ -443,7 +443,7 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 
 	return nhash;
 }
-EXPORT_SYMBOL_GPL(crypto_clone_shash);
+DEFINE_CRYPTO_API(crypto_clone_shash);
 
 int hash_prepare_alg(struct hash_alg_common *alg)
 {
@@ -529,7 +529,7 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	return 0;
 }
 
-int crypto_register_shash(struct shash_alg *alg)
+int CRYPTO_API(crypto_register_shash)(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 	int err;
@@ -540,15 +540,15 @@ int crypto_register_shash(struct shash_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_shash);
+DEFINE_CRYPTO_API(crypto_register_shash);
 
-void crypto_unregister_shash(struct shash_alg *alg)
+void CRYPTO_API(crypto_unregister_shash)(struct shash_alg *alg)
 {
 	crypto_unregister_alg(&alg->base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_shash);
+DEFINE_CRYPTO_API(crypto_unregister_shash);
 
-int crypto_register_shashes(struct shash_alg *algs, int count)
+int CRYPTO_API(crypto_register_shashes)(struct shash_alg *algs, int count)
 {
 	int i, ret;
 
@@ -566,18 +566,18 @@ int crypto_register_shashes(struct shash_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_shashes);
+DEFINE_CRYPTO_API(crypto_register_shashes);
 
-void crypto_unregister_shashes(struct shash_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_shashes)(struct shash_alg *algs, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_shash(&algs[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_shashes);
+DEFINE_CRYPTO_API(crypto_unregister_shashes);
 
-int shash_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(shash_register_instance)(struct crypto_template *tmpl,
 			    struct shash_instance *inst)
 {
 	int err;
@@ -591,14 +591,14 @@ int shash_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, shash_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(shash_register_instance);
+DEFINE_CRYPTO_API(shash_register_instance);
 
-void shash_free_singlespawn_instance(struct shash_instance *inst)
+void CRYPTO_API(shash_free_singlespawn_instance)(struct shash_instance *inst)
 {
 	crypto_drop_spawn(shash_instance_ctx(inst));
 	kfree(inst);
 }
-EXPORT_SYMBOL_GPL(shash_free_singlespawn_instance);
+DEFINE_CRYPTO_API(shash_free_singlespawn_instance);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index c9d6ee97360e..3476f6209a22 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -765,12 +765,17 @@ static inline void ahash_request_set_virt(struct ahash_request *req,
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
-					u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_shash, struct crypto_shash *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
-struct crypto_shash *crypto_clone_shash(struct crypto_shash *tfm);
+DECLARE_CRYPTO_API(crypto_clone_shash, struct crypto_shash *,
+	(struct crypto_shash *tfm),
+	(tfm));
 
-int crypto_has_shash(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_has_shash, int,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 {
@@ -894,8 +899,9 @@ static inline void *shash_desc_ctx(struct shash_desc *desc)
  * Context: Softirq or process context.
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
-			unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_shash_setkey, int,
+	(struct crypto_shash *tfm, const u8 *key, unsigned int keylen),
+	(tfm, key, keylen));
 
 /**
  * crypto_shash_digest() - calculate message digest for buffer
@@ -912,8 +918,9 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
-int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out);
+DECLARE_CRYPTO_API(crypto_shash_digest, int,
+	(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out),
+	(desc, data, len, out));
 
 /**
  * crypto_shash_tfm_digest() - calculate message digest for buffer
@@ -931,8 +938,9 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
  * Context: Softirq or process context.
  * Return: 0 on success; < 0 if an error occurred.
  */
-int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
-			    unsigned int len, u8 *out);
+DECLARE_CRYPTO_API(crypto_shash_tfm_digest, int,
+	(struct crypto_shash *tfm, const u8 *data, unsigned int len, u8 *out),
+	(tfm, data, len, out));
 
 DECLARE_CRYPTO_API(crypto_hash_digest, int,
 	(struct crypto_ahash *tfm, const u8 *data, unsigned int len, u8 *out),
@@ -950,7 +958,9 @@ DECLARE_CRYPTO_API(crypto_hash_digest, int,
  * Context: Softirq or process context.
  * Return: 0 if the export creation was successful; < 0 if an error occurred
  */
-int crypto_shash_export(struct shash_desc *desc, void *out);
+DECLARE_CRYPTO_API(crypto_shash_export, int,
+	(struct shash_desc *desc, void *out),
+	(desc, out));
 
 /**
  * crypto_shash_import() - import operational state
@@ -964,7 +974,9 @@ int crypto_shash_export(struct shash_desc *desc, void *out);
  * Context: Softirq or process context.
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
-int crypto_shash_import(struct shash_desc *desc, const void *in);
+DECLARE_CRYPTO_API(crypto_shash_import, int,
+	(struct shash_desc *desc, const void *in),
+	(desc, in));
 
 /**
  * crypto_shash_init() - (re)initialize message digest
@@ -978,7 +990,9 @@ int crypto_shash_import(struct shash_desc *desc, const void *in);
  * Return: 0 if the message digest initialization was successful; < 0 if an
  *	   error occurred
  */
-int crypto_shash_init(struct shash_desc *desc);
+DECLARE_CRYPTO_API(crypto_shash_init, int,
+	(struct shash_desc *desc),
+	(desc));
 
 /**
  * crypto_shash_finup() - calculate message digest of buffer
@@ -995,8 +1009,9 @@ int crypto_shash_init(struct shash_desc *desc);
  * Return: 0 if the message digest creation was successful; < 0 if an error
  *	   occurred
  */
-int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
-		       unsigned int len, u8 *out);
+DECLARE_CRYPTO_API(crypto_shash_finup, int,
+	(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out),
+	(desc, data, len, out));
 
 /**
  * crypto_shash_update() - add data to message digest for processing
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index c3f9ca511cf5..29b51abc1bad 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -107,7 +107,9 @@ DECLARE_CRYPTO_API(ahash_free_singlespawn_instance, void,
 	(struct ahash_instance *inst),
 	(inst));
 
-bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
+DECLARE_CRYPTO_API(crypto_shash_alg_has_setkey, bool,
+	(struct shash_alg *alg),
+	(alg));
 
 DECLARE_CRYPTO_API(crypto_hash_alg_has_setkey, bool,
 	(struct hash_alg_common *halg),
@@ -146,17 +148,28 @@ static inline struct hash_alg_common *crypto_spawn_ahash_alg(
 	return __crypto_hash_alg_common(spawn->base.alg);
 }
 
-int crypto_register_shash(struct shash_alg *alg);
-void crypto_unregister_shash(struct shash_alg *alg);
-int crypto_register_shashes(struct shash_alg *algs, int count);
-void crypto_unregister_shashes(struct shash_alg *algs, int count);
-int shash_register_instance(struct crypto_template *tmpl,
-			    struct shash_instance *inst);
-void shash_free_singlespawn_instance(struct shash_instance *inst);
+DECLARE_CRYPTO_API(crypto_register_shash, int,
+	(struct shash_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_shash, void,
+	(struct shash_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_shashes, int,
+	(struct shash_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_shashes, void,
+	(struct shash_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(shash_register_instance, int,
+	(struct crypto_template *tmpl, struct shash_instance *inst),
+	(tmpl, inst));
+DECLARE_CRYPTO_API(shash_free_singlespawn_instance, void,
+	(struct shash_instance *inst),
+	(inst));
 
-int crypto_grab_shash(struct crypto_shash_spawn *spawn,
-		      struct crypto_instance *inst,
-		      const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_shash, int,
+	(struct crypto_shash_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 static inline void crypto_drop_shash(struct crypto_shash_spawn *spawn)
 {
@@ -408,7 +421,9 @@ DECLARE_CRYPTO_API(crypto_ahash_import_core, int,
  * Context: Softirq or process context.
  * Return: 0 if the export creation was successful; < 0 if an error occurred
  */
-int crypto_shash_export_core(struct shash_desc *desc, void *out);
+DECLARE_CRYPTO_API(crypto_shash_export_core, int,
+	(struct shash_desc *desc, void *out),
+	(desc, out));
 
 /**
  * crypto_shash_import_core() - import core state
@@ -420,7 +435,9 @@ int crypto_shash_export_core(struct shash_desc *desc, void *out);
  * Context: Softirq or process context.
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
-int crypto_shash_import_core(struct shash_desc *desc, const void *in);
+DECLARE_CRYPTO_API(crypto_shash_import_core, int,
+	(struct shash_desc *desc, const void *in),
+	(desc, in));
 
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
-- 
2.39.3

