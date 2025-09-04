Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0636280334;
	Thu,  4 Sep 2025 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001432; cv=none; b=rWgUM7uKkQDwl3f+nqF8OGuB0G9cWK889R04z5u5TKzV6/QgzqspsQRtFCWJXKKqLMOKSZKt/c0WnsFkVd4ki2U/LGQlWauNGu28avMgZmgvAgevTzdqPz6CQtFZWa4mL5Fz1v3hRF9pc3P3LsxcxbU+BSb9oTSJsxZtFvJiKZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001432; c=relaxed/simple;
	bh=std4Z70zM+ZDM4MaU+ujno5hDP18ODygUI6xnrhwKdY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qhXCezTf0m89n7jIBrC1+ySFLeFG5MX3K9kC+loiYoJ4IpOndoBNJxjOgubMdenJSYpqJcJnIf7QMT3a59dnOzdsN5WDkuERg9dRpCkr02AJIASkrIf/3+Xii8+6ILp8QqRoNz6xaubleGK7xe3I71U6iK77C2KDHpMm40sVn6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L97S5OIR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L97S5OIR"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmEt023970;
	Thu, 4 Sep 2025 15:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=IY2Ir
	M8HJ+MZtKOBQKf77y6/x/WOkVOxs1UL2MAM9VY=; b=L97S5OIRD8kZzjKnB/59U
	X2hXfcSdMtxKql+eTwfrhT2i3SoIjFKtKFw9EjzQOPSKcU8u9NloqpFzM+YV44eG
	ND4o7Ll3XFacPTD7je91GELl2FqfkvT29KXBF0MlbUdFqrJcSqKDEcaFPhls8VQ7
	CGwVfLBNJRLzRtxfwY8tcE/6yjcaaRlAdLWeyeaAIqP9bb+RgtUGydH3S86xjiGw
	8HvrJhHuKDDN46x/58/wPUn0SCKBUlycArG6HaohDLOEWhvsGz8GLZleVIYdWDj2
	tSI4BHmVlPwZgtU37zyuCPe/0CFloEVQT+eJeoIVNmJiCv2lGDKoFLcS0OxJ9HuJ
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd024t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F4nZR040080;
	Thu, 4 Sep 2025 15:56:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtnfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:56 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5o000707;
	Thu, 4 Sep 2025 15:56:55 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-32;
	Thu, 04 Sep 2025 15:56:55 +0000
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
Subject: [PATCH RFC 031/104] crypto: fips140: convert crypto/ahash.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:03 +0200
Message-Id: <20250904155216.460962-32-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX0OS5ATdJliOQ
 q2B6npNk+LDwGGd65IzRkVMbRgvX/cWvkCHLXFDmODHE7ARESvTVZfmpllGxh/B88QhQyu0Gq8r
 cS8TRBFmxJ/86puv9VCUZS5M+QzQE1V2ILflithTS/qV5sBk3P78f0zbsv/QJ8G1cVqoZ200yfj
 g/J4pkJPX9J/YoX+3DH+4cj0qCiuBOyaTrFurXkUaxcKd0+5emK8dz+P4ze3x4U+YguE+BRXrG1
 lRCr3ShfSAQglJGoZxQzchtCwNORi5xvi6OA61vTtKq38OF4fBAbUuPkHPfHFM6rEjtRaZ25+QN
 qcPbWltoiOEoj2I4vQmBO00SI10xiDfdL9ElVv/n4dGyWuVKOL/puzSPzPrYpzeEqCFg6+ROnuj
 QsHP4qj5vgzI2CBbLGsGU1mN92HGZQ==
X-Proofpoint-GUID: jNMMDal2WC-z-Ckhcs0qPiW8t9Ekdpwj
X-Proofpoint-ORIG-GUID: jNMMDal2WC-z-Ckhcs0qPiW8t9Ekdpwj
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b6c9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=KMallS4dWECZ2Jfgwz4A:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_HASH2 --source crypto/ahash.c --header include/crypto/internal/hash.h include/crypto/hash.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ahash.c                 | 108 ++++++++++++++++-----------------
 crypto/fips140-api.c           |  40 ++++++++++++
 include/crypto/hash.h          |  52 +++++++++++-----
 include/crypto/internal/hash.h |  65 ++++++++++++++------
 4 files changed, 177 insertions(+), 88 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a227793d2c5b..f344a43a3f89 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -99,7 +99,7 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 	return hash_walk_next(walk);
 }
 
-int crypto_hash_walk_first(struct ahash_request *req,
+int CRYPTO_API(crypto_hash_walk_first)(struct ahash_request *req,
 			   struct crypto_hash_walk *walk)
 {
 	walk->total = req->nbytes;
@@ -120,9 +120,9 @@ int crypto_hash_walk_first(struct ahash_request *req,
 
 	return hash_walk_new_entry(walk);
 }
-EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
+DEFINE_CRYPTO_API(crypto_hash_walk_first);
 
-int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
+int CRYPTO_API(crypto_hash_walk_done)(struct crypto_hash_walk *walk, int err)
 {
 	if ((walk->flags & CRYPTO_AHASH_REQ_VIRT))
 		return err;
@@ -148,7 +148,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 
 	return hash_walk_new_entry(walk);
 }
-EXPORT_SYMBOL_GPL(crypto_hash_walk_done);
+DEFINE_CRYPTO_API(crypto_hash_walk_done);
 
 /*
  * For an ahash tfm that is using an shash algorithm (instead of an ahash
@@ -168,7 +168,7 @@ static inline struct shash_desc *prepare_shash_desc(struct ahash_request *req,
 	return desc;
 }
 
-int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
+int CRYPTO_API(shash_ahash_update)(struct ahash_request *req, struct shash_desc *desc)
 {
 	struct crypto_hash_walk walk;
 	int nbytes;
@@ -179,9 +179,9 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
 
 	return nbytes;
 }
-EXPORT_SYMBOL_GPL(shash_ahash_update);
+DEFINE_CRYPTO_API(shash_ahash_update);
 
-int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
+int CRYPTO_API(shash_ahash_finup)(struct ahash_request *req, struct shash_desc *desc)
 {
 	struct crypto_hash_walk walk;
 	int nbytes;
@@ -200,9 +200,9 @@ int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc)
 
 	return nbytes;
 }
-EXPORT_SYMBOL_GPL(shash_ahash_finup);
+DEFINE_CRYPTO_API(shash_ahash_finup);
 
-int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
+int CRYPTO_API(shash_ahash_digest)(struct ahash_request *req, struct shash_desc *desc)
 {
 	unsigned int nbytes = req->nbytes;
 	struct scatterlist *sg;
@@ -239,7 +239,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	kunmap_local(data);
 	return err;
 }
-EXPORT_SYMBOL_GPL(shash_ahash_digest);
+DEFINE_CRYPTO_API(shash_ahash_digest);
 
 static void crypto_exit_ahash_using_shash(struct crypto_tfm *tfm)
 {
@@ -287,7 +287,7 @@ static void ahash_set_needkey(struct crypto_ahash *tfm, struct ahash_alg *alg)
 		crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
-int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+int CRYPTO_API(crypto_ahash_setkey)(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	if (likely(tfm->using_shash)) {
@@ -317,7 +317,7 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
+DEFINE_CRYPTO_API(crypto_ahash_setkey);
 
 static int ahash_do_req_chain(struct ahash_request *req,
 			      int (*const *op)(struct ahash_request *req))
@@ -368,7 +368,7 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	}
 }
 
-int crypto_ahash_init(struct ahash_request *req)
+int CRYPTO_API(crypto_ahash_init)(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
@@ -386,7 +386,7 @@ int crypto_ahash_init(struct ahash_request *req)
 	}
 	return crypto_ahash_alg(tfm)->init(req);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_init);
+DEFINE_CRYPTO_API(crypto_ahash_init);
 
 static void ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
@@ -440,7 +440,7 @@ static void ahash_update_done(void *data, int err)
 	ahash_op_done(data, err, ahash_update_finish);
 }
 
-int crypto_ahash_update(struct ahash_request *req)
+int CRYPTO_API(crypto_ahash_update)(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	bool nonzero = crypto_ahash_final_nonzero(tfm);
@@ -489,7 +489,7 @@ int crypto_ahash_update(struct ahash_request *req)
 
 	return ahash_update_finish(req, err);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_update);
+DEFINE_CRYPTO_API(crypto_ahash_update);
 
 static int ahash_finup_finish(struct ahash_request *req, int err)
 {
@@ -521,7 +521,7 @@ static void ahash_finup_done(void *data, int err)
 	ahash_op_done(data, err, ahash_finup_finish);
 }
 
-int crypto_ahash_finup(struct ahash_request *req)
+int CRYPTO_API(crypto_ahash_finup)(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	int bs = crypto_ahash_blocksize(tfm);
@@ -561,9 +561,9 @@ int crypto_ahash_finup(struct ahash_request *req)
 
 	return ahash_finup_finish(req, err);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_finup);
+DEFINE_CRYPTO_API(crypto_ahash_finup);
 
-int crypto_ahash_digest(struct ahash_request *req)
+int CRYPTO_API(crypto_ahash_digest)(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
@@ -575,7 +575,7 @@ int crypto_ahash_digest(struct ahash_request *req)
 		return -ENOKEY;
 	return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->digest);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_digest);
+DEFINE_CRYPTO_API(crypto_ahash_digest);
 
 static void ahash_def_finup_done2(void *data, int err)
 {
@@ -624,7 +624,7 @@ static int ahash_def_finup(struct ahash_request *req)
 	return ahash_def_finup_finish1(req, err);
 }
 
-int crypto_ahash_export_core(struct ahash_request *req, void *out)
+int CRYPTO_API(crypto_ahash_export_core)(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
@@ -632,9 +632,9 @@ int crypto_ahash_export_core(struct ahash_request *req, void *out)
 		return crypto_shash_export_core(ahash_request_ctx(req), out);
 	return crypto_ahash_alg(tfm)->export_core(req, out);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_export_core);
+DEFINE_CRYPTO_API(crypto_ahash_export_core);
 
-int crypto_ahash_export(struct ahash_request *req, void *out)
+int CRYPTO_API(crypto_ahash_export)(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
@@ -650,9 +650,9 @@ int crypto_ahash_export(struct ahash_request *req, void *out)
 	}
 	return crypto_ahash_alg(tfm)->export(req, out);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_export);
+DEFINE_CRYPTO_API(crypto_ahash_export);
 
-int crypto_ahash_import_core(struct ahash_request *req, const void *in)
+int CRYPTO_API(crypto_ahash_import_core)(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
@@ -663,9 +663,9 @@ int crypto_ahash_import_core(struct ahash_request *req, const void *in)
 		return -ENOKEY;
 	return crypto_ahash_alg(tfm)->import_core(req, in);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_import_core);
+DEFINE_CRYPTO_API(crypto_ahash_import_core);
 
-int crypto_ahash_import(struct ahash_request *req, const void *in)
+int CRYPTO_API(crypto_ahash_import)(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
@@ -681,7 +681,7 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
 	}
 	return crypto_ahash_alg(tfm)->import(req, in);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_import);
+DEFINE_CRYPTO_API(crypto_ahash_import);
 
 static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
 {
@@ -816,29 +816,29 @@ static const struct crypto_type crypto_ahash_type = {
 	.algsize = offsetof(struct ahash_alg, halg.base),
 };
 
-int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
+int CRYPTO_API(crypto_grab_ahash)(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_ahash_type;
 	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_ahash);
+DEFINE_CRYPTO_API(crypto_grab_ahash);
 
-struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
+struct crypto_ahash *CRYPTO_API(crypto_alloc_ahash)(const char *alg_name, u32 type,
 					u32 mask)
 {
 	return crypto_alloc_tfm(alg_name, &crypto_ahash_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
+DEFINE_CRYPTO_API(crypto_alloc_ahash);
 
-int crypto_has_ahash(const char *alg_name, u32 type, u32 mask)
+int CRYPTO_API(crypto_has_ahash)(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_ahash_type, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_ahash);
+DEFINE_CRYPTO_API(crypto_has_ahash);
 
-bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
+bool CRYPTO_API(crypto_hash_alg_has_setkey)(struct hash_alg_common *halg)
 {
 	struct crypto_alg *alg = &halg->base;
 
@@ -847,9 +847,9 @@ bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 
 	return __crypto_ahash_alg(alg)->setkey != ahash_nosetkey;
 }
-EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
+DEFINE_CRYPTO_API(crypto_hash_alg_has_setkey);
 
-struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
+struct crypto_ahash *CRYPTO_API(crypto_clone_ahash)(struct crypto_ahash *hash)
 {
 	struct hash_alg_common *halg = crypto_hash_alg_common(hash);
 	struct crypto_tfm *tfm = crypto_ahash_tfm(hash);
@@ -917,7 +917,7 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 	crypto_free_ahash(nhash);
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(crypto_clone_ahash);
+DEFINE_CRYPTO_API(crypto_clone_ahash);
 
 static int ahash_default_export_core(struct ahash_request *req, void *out)
 {
@@ -981,7 +981,7 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	return 0;
 }
 
-int crypto_register_ahash(struct ahash_alg *alg)
+int CRYPTO_API(crypto_register_ahash)(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
 	int err;
@@ -992,15 +992,15 @@ int crypto_register_ahash(struct ahash_alg *alg)
 
 	return crypto_register_alg(base);
 }
-EXPORT_SYMBOL_GPL(crypto_register_ahash);
+DEFINE_CRYPTO_API(crypto_register_ahash);
 
-void crypto_unregister_ahash(struct ahash_alg *alg)
+void CRYPTO_API(crypto_unregister_ahash)(struct ahash_alg *alg)
 {
 	crypto_unregister_alg(&alg->halg.base);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_ahash);
+DEFINE_CRYPTO_API(crypto_unregister_ahash);
 
-int crypto_register_ahashes(struct ahash_alg *algs, int count)
+int CRYPTO_API(crypto_register_ahashes)(struct ahash_alg *algs, int count)
 {
 	int i, ret;
 
@@ -1018,18 +1018,18 @@ int crypto_register_ahashes(struct ahash_alg *algs, int count)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(crypto_register_ahashes);
+DEFINE_CRYPTO_API(crypto_register_ahashes);
 
-void crypto_unregister_ahashes(struct ahash_alg *algs, int count)
+void CRYPTO_API(crypto_unregister_ahashes)(struct ahash_alg *algs, int count)
 {
 	int i;
 
 	for (i = count - 1; i >= 0; --i)
 		crypto_unregister_ahash(&algs[i]);
 }
-EXPORT_SYMBOL_GPL(crypto_unregister_ahashes);
+DEFINE_CRYPTO_API(crypto_unregister_ahashes);
 
-int ahash_register_instance(struct crypto_template *tmpl,
+int CRYPTO_API(ahash_register_instance)(struct crypto_template *tmpl,
 			    struct ahash_instance *inst)
 {
 	int err;
@@ -1043,9 +1043,9 @@ int ahash_register_instance(struct crypto_template *tmpl,
 
 	return crypto_register_instance(tmpl, ahash_crypto_instance(inst));
 }
-EXPORT_SYMBOL_GPL(ahash_register_instance);
+DEFINE_CRYPTO_API(ahash_register_instance);
 
-void ahash_request_free(struct ahash_request *req)
+void CRYPTO_API(ahash_request_free)(struct ahash_request *req)
 {
 	if (unlikely(!req))
 		return;
@@ -1057,9 +1057,9 @@ void ahash_request_free(struct ahash_request *req)
 
 	ahash_request_zero(req);
 }
-EXPORT_SYMBOL_GPL(ahash_request_free);
+DEFINE_CRYPTO_API(ahash_request_free);
 
-int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
+int CRYPTO_API(crypto_hash_digest)(struct crypto_ahash *tfm, const u8 *data,
 		       unsigned int len, u8 *out)
 {
 	HASH_REQUEST_ON_STACK(req, crypto_ahash_fb(tfm));
@@ -1073,14 +1073,14 @@ int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_hash_digest);
+DEFINE_CRYPTO_API(crypto_hash_digest);
 
-void ahash_free_singlespawn_instance(struct ahash_instance *inst)
+void CRYPTO_API(ahash_free_singlespawn_instance)(struct ahash_instance *inst)
 {
 	crypto_drop_spawn(ahash_instance_ctx(inst));
 	kfree(inst);
 }
-EXPORT_SYMBOL_GPL(ahash_free_singlespawn_instance);
+DEFINE_CRYPTO_API(ahash_free_singlespawn_instance);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 88858a1f9915..530195c057eb 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -163,3 +163,43 @@ DEFINE_CRYPTO_API_STUB(crypto_aes_set_key);
 
 #endif
 
+/*
+ * crypto/ahash.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_HASH2)
+
+#include <crypto/internal/hash.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_hash_walk_done);
+DEFINE_CRYPTO_API_STUB(crypto_hash_walk_first);
+DEFINE_CRYPTO_API_STUB(crypto_register_ahash);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_ahash);
+DEFINE_CRYPTO_API_STUB(crypto_register_ahashes);
+DEFINE_CRYPTO_API_STUB(crypto_unregister_ahashes);
+DEFINE_CRYPTO_API_STUB(ahash_register_instance);
+DEFINE_CRYPTO_API_STUB(ahash_free_singlespawn_instance);
+DEFINE_CRYPTO_API_STUB(crypto_hash_alg_has_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_grab_ahash);
+DEFINE_CRYPTO_API_STUB(shash_ahash_update);
+DEFINE_CRYPTO_API_STUB(shash_ahash_finup);
+DEFINE_CRYPTO_API_STUB(shash_ahash_digest);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_export_core);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_import_core);
+
+#include <crypto/hash.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_alloc_ahash);
+DEFINE_CRYPTO_API_STUB(crypto_clone_ahash);
+DEFINE_CRYPTO_API_STUB(crypto_has_ahash);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_setkey);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_finup);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_digest);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_export);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_import);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_init);
+DEFINE_CRYPTO_API_STUB(crypto_ahash_update);
+DEFINE_CRYPTO_API_STUB(ahash_request_free);
+DEFINE_CRYPTO_API_STUB(crypto_hash_digest);
+
+#endif
+
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index bbaeae705ef0..c9d6ee97360e 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_HASH_H
 #define _CRYPTO_HASH_H
 
+#include <crypto/api.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -307,10 +308,13 @@ static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
  * Return: allocated cipher handle in case of success; IS_ERR() is true in case
  *	   of an error, PTR_ERR() returns the error code.
  */
-struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
-					u32 mask);
+DECLARE_CRYPTO_API(crypto_alloc_ahash, struct crypto_ahash *,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
-struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *tfm);
+DECLARE_CRYPTO_API(crypto_clone_ahash, struct crypto_ahash *,
+	(struct crypto_ahash *tfm),
+	(tfm));
 
 static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 {
@@ -338,7 +342,9 @@ static inline void crypto_free_ahash(struct crypto_ahash *tfm)
  * Return: true when the ahash is known to the kernel crypto API; false
  *	   otherwise
  */
-int crypto_has_ahash(const char *alg_name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_has_ahash, int,
+	(const char *alg_name, u32 type, u32 mask),
+	(alg_name, type, mask));
 
 static inline const char *crypto_ahash_alg_name(struct crypto_ahash *tfm)
 {
@@ -464,8 +470,9 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
-			unsigned int keylen);
+DECLARE_CRYPTO_API(crypto_ahash_setkey, int,
+	(struct crypto_ahash *tfm, const u8 *key, unsigned int keylen),
+	(tfm, key, keylen));
 
 /**
  * crypto_ahash_finup() - update and finalize message digest
@@ -478,7 +485,9 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
  *
  * Return: see crypto_ahash_final()
  */
-int crypto_ahash_finup(struct ahash_request *req);
+DECLARE_CRYPTO_API(crypto_ahash_finup, int,
+	(struct ahash_request *req),
+	(req));
 
 /**
  * crypto_ahash_final() - calculate message digest
@@ -512,7 +521,9 @@ static inline int crypto_ahash_final(struct ahash_request *req)
  *
  * Return: see crypto_ahash_final()
  */
-int crypto_ahash_digest(struct ahash_request *req);
+DECLARE_CRYPTO_API(crypto_ahash_digest, int,
+	(struct ahash_request *req),
+	(req));
 
 /**
  * crypto_ahash_export() - extract current message digest state
@@ -525,7 +536,9 @@ int crypto_ahash_digest(struct ahash_request *req);
  *
  * Return: 0 if the export was successful; < 0 if an error occurred
  */
-int crypto_ahash_export(struct ahash_request *req, void *out);
+DECLARE_CRYPTO_API(crypto_ahash_export, int,
+	(struct ahash_request *req, void *out),
+	(req, out));
 
 /**
  * crypto_ahash_import() - import message digest state
@@ -538,7 +551,9 @@ int crypto_ahash_export(struct ahash_request *req, void *out);
  *
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
-int crypto_ahash_import(struct ahash_request *req, const void *in);
+DECLARE_CRYPTO_API(crypto_ahash_import, int,
+	(struct ahash_request *req, const void *in),
+	(req, in));
 
 /**
  * crypto_ahash_init() - (re)initialize message digest handle
@@ -551,7 +566,9 @@ int crypto_ahash_import(struct ahash_request *req, const void *in);
  *
  * Return: see crypto_ahash_final()
  */
-int crypto_ahash_init(struct ahash_request *req);
+DECLARE_CRYPTO_API(crypto_ahash_init, int,
+	(struct ahash_request *req),
+	(req));
 
 /**
  * crypto_ahash_update() - add data to message digest for processing
@@ -564,7 +581,9 @@ int crypto_ahash_init(struct ahash_request *req);
  *
  * Return: see crypto_ahash_final()
  */
-int crypto_ahash_update(struct ahash_request *req);
+DECLARE_CRYPTO_API(crypto_ahash_update, int,
+	(struct ahash_request *req),
+	(req));
 
 /**
  * DOC: Asynchronous Hash Request Handle
@@ -622,7 +641,9 @@ static inline struct ahash_request *ahash_request_alloc_noprof(
  * ahash_request_free() - zeroize and free the request data structure
  * @req: request data structure cipher handle to be freed
  */
-void ahash_request_free(struct ahash_request *req);
+DECLARE_CRYPTO_API(ahash_request_free, void,
+	(struct ahash_request *req),
+	(req));
 
 static inline void ahash_request_zero(struct ahash_request *req)
 {
@@ -913,8 +934,9 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out);
 
-int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
-		       unsigned int len, u8 *out);
+DECLARE_CRYPTO_API(crypto_hash_digest, int,
+	(struct crypto_ahash *tfm, const u8 *data, unsigned int len, u8 *out),
+	(tfm, data, len, out));
 
 /**
  * crypto_shash_export() - extract operational state for message digest
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e39456de57e4..c3f9ca511cf5 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_INTERNAL_HASH_H
 #define _CRYPTO_INTERNAL_HASH_H
 
+#include <crypto/api.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 
@@ -75,26 +76,42 @@ struct crypto_shash_spawn {
 	struct crypto_spawn base;
 };
 
-int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
-int crypto_hash_walk_first(struct ahash_request *req,
-			   struct crypto_hash_walk *walk);
+DECLARE_CRYPTO_API(crypto_hash_walk_done, int,
+	(struct crypto_hash_walk *walk, int err),
+	(walk, err));
+DECLARE_CRYPTO_API(crypto_hash_walk_first, int,
+	(struct ahash_request *req, struct crypto_hash_walk *walk),
+	(req, walk));
 
 static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
 {
 	return !(walk->entrylen | walk->total);
 }
 
-int crypto_register_ahash(struct ahash_alg *alg);
-void crypto_unregister_ahash(struct ahash_alg *alg);
-int crypto_register_ahashes(struct ahash_alg *algs, int count);
-void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
-int ahash_register_instance(struct crypto_template *tmpl,
-			    struct ahash_instance *inst);
-void ahash_free_singlespawn_instance(struct ahash_instance *inst);
+DECLARE_CRYPTO_API(crypto_register_ahash, int,
+	(struct ahash_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_unregister_ahash, void,
+	(struct ahash_alg *alg),
+	(alg));
+DECLARE_CRYPTO_API(crypto_register_ahashes, int,
+	(struct ahash_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(crypto_unregister_ahashes, void,
+	(struct ahash_alg *algs, int count),
+	(algs, count));
+DECLARE_CRYPTO_API(ahash_register_instance, int,
+	(struct crypto_template *tmpl, struct ahash_instance *inst),
+	(tmpl, inst));
+DECLARE_CRYPTO_API(ahash_free_singlespawn_instance, void,
+	(struct ahash_instance *inst),
+	(inst));
 
 bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
 
-bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
+DECLARE_CRYPTO_API(crypto_hash_alg_has_setkey, bool,
+	(struct hash_alg_common *halg),
+	(halg));
 
 static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
 {
@@ -114,9 +131,9 @@ static inline bool crypto_hash_no_export_core(struct crypto_ahash *tfm)
 	       CRYPTO_AHASH_ALG_NO_EXPORT_CORE;
 }
 
-int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
-		      struct crypto_instance *inst,
-		      const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(crypto_grab_ahash, int,
+	(struct crypto_ahash_spawn *spawn, struct crypto_instance *inst, const char *name, u32 type, u32 mask),
+	(spawn, inst, name, type, mask));
 
 static inline void crypto_drop_ahash(struct crypto_ahash_spawn *spawn)
 {
@@ -152,9 +169,15 @@ static inline struct shash_alg *crypto_spawn_shash_alg(
 	return __crypto_shash_alg(spawn->base.alg);
 }
 
-int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
-int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
-int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
+DECLARE_CRYPTO_API(shash_ahash_update, int,
+	(struct ahash_request *req, struct shash_desc *desc),
+	(req, desc));
+DECLARE_CRYPTO_API(shash_ahash_finup, int,
+	(struct ahash_request *req, struct shash_desc *desc),
+	(req, desc));
+DECLARE_CRYPTO_API(shash_ahash_digest, int,
+	(struct ahash_request *req, struct shash_desc *desc),
+	(req, desc));
 
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
@@ -357,7 +380,9 @@ static inline unsigned int crypto_shash_coresize(struct crypto_shash *tfm)
  * Context: Softirq or process context.
  * Return: 0 if the export creation was successful; < 0 if an error occurred
  */
-int crypto_ahash_export_core(struct ahash_request *req, void *out);
+DECLARE_CRYPTO_API(crypto_ahash_export_core, int,
+	(struct ahash_request *req, void *out),
+	(req, out));
 
 /**
  * crypto_ahash_import_core() - import core state
@@ -369,7 +394,9 @@ int crypto_ahash_export_core(struct ahash_request *req, void *out);
  * Context: Softirq or process context.
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
-int crypto_ahash_import_core(struct ahash_request *req, const void *in);
+DECLARE_CRYPTO_API(crypto_ahash_import_core, int,
+	(struct ahash_request *req, const void *in),
+	(req, in));
 
 /**
  * crypto_shash_export_core() - extract core state for message digest
-- 
2.39.3

