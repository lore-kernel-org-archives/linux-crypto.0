Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0F28312F;
	Thu,  4 Sep 2025 15:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001377; cv=none; b=YqOF/+QRxxBjdvHAvPZiTUNjSZAvWwV7oQniDMQK3w1ccNom7M08+/mILpLnRCTgdg0NedUIEv130SoyQSSvy3XR5y2cVgxGHZU9WqAAztw8+4Ic6ilmdwyWABfgR7uRjXzwmValnWAUk+dBiMLIcroKNIzb22upC6xistFE1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001377; c=relaxed/simple;
	bh=IP7FEbyi7c6PmDcnWdA+mpra5E7lkFEghJ7H2D3fM24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SRWHR9F+uGYYYLkAVW18Suv6y4qV0GVk5A/GFZuJGpAB8I2chpreTBqKjYqOfjK++0fw2VW/UwzwhJ/lnO5GnRnOtfNmyH/xksd5xUZywD6x6BmeD9ca1gga95wHZU0trzKl62ShrVQ6cvQXLILrel+78UfpJ8tBvTqnu4qYL98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KGjcorQl; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KGjcorQl"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiT5023828;
	Thu, 4 Sep 2025 15:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=NeQaK
	XcqG7XVG6gUFEgIWVqvF8CsF1YrjIHF9KdBSPY=; b=KGjcorQlNYmn3zca0xKRL
	p+uEocr99HhTDdbHHSvQq489otIUfPT8111Rf438wa7FSPlzjabjOgB5mPXdzPKM
	ejyUNQxtv2XeGKNVBLpBPndh9dDqhXV9kgix/wOpKvjM08vAKxhhM2y+D3Jl/FRf
	AgafN3ERCf8a7yKd6dLZYt9PLKyB2OtSLUpK+pHdZ45twUaTEMkrfqWeIF/B04ch
	DlvvkAQXdZi9vKa/nwomtuwGdNt2LEzMXrS5a17fXBWmgVEUqkMOpTqbiKWk3Gbe
	/1h+818H9TtTKNUfkapoLCGZJKfc1AkgPVSHVxGz5ttmzweE8S2BEKu4J683dmEO
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd0229-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584E4NNq040030;
	Thu, 4 Sep 2025 15:56:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5K000707;
	Thu, 4 Sep 2025 15:56:02 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-17;
	Thu, 04 Sep 2025 15:56:02 +0000
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
Subject: [PATCH RFC 016/104] crypto: alg - add CRYPTO_ALG_FIPS_PROVIDED flag
Date: Thu,  4 Sep 2025 17:50:48 +0200
Message-Id: <20250904155216.460962-17-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX3Zlcm9moDJ3u
 B+PHmujbD/CPI6D54PPRkxLu/mgs/UYWY2RJck9B4BxpZ7IPo8smmTlNTFbQf39p6905XwZH+i9
 X9UZVwUPZvq5spW1023flUw9PHas6rRChCNLmiT/FikkUmBCZ2Sbw3ji8TxKYFVLJEOHaxKcpHr
 m3kU18ZC9ykGwDIaX3bYAmh8kAN5pmZZA45HCf0AHqiGqtzHTEXSCbuuvmGJhsKkqwnS4SBNG5G
 0B9DDJ38CuQAt3Ms/0iEj5QlIQofy532P775i2RevAE2Pj3uayZX/JfrnpyVng01YJKVZiWxVQo
 +kIpYmoB+pGpZSpN3T2OzWFpUSFpFpkswu81OVeL+XBCGZgfWz8/mMuyJUEfWeqzXE8yeg41WEa
 GNrC55mb2N6NCiB1NyEQw04dh8+4/Q==
X-Proofpoint-GUID: pMDOaH6FggC5LyuDrG2RNv07pHdTlGW7
X-Proofpoint-ORIG-GUID: pMDOaH6FggC5LyuDrG2RNv07pHdTlGW7
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b693 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=NCOpwGM-EK6jTyeMJ5IA:9 cc=ntf
 awl=host:12068

Use a new flag to record whether a particular algorithm is provided by
a standalone FIPS 140 module.

Note: This does not mean the algorithm is "FIPS approved" or even "FIPS
allowed" -- it simply means the algorithm is implemented within the FIPS
module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algapi.c        | 30 ++++++++++++++++++++++++++++++
 crypto/testmgr.c       | 22 +++++++++++++++-------
 include/linux/crypto.h |  8 ++++++++
 3 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 54b8d4acd651..29076797a938 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -450,6 +450,9 @@ int crypto_register_alg(struct crypto_alg *alg)
 	if (err)
 		return err;
 
+	/* Blatant API misuse */
+	BUG_ON(alg->cra_flags & CRYPTO_ALG_FIPS_PROVIDED);
+
 	if (alg->cra_flags & CRYPTO_ALG_DUP_FIRST &&
 	    !WARN_ON_ONCE(alg->cra_destroy)) {
 		unsigned int algsize = alg->cra_type->algsize;
@@ -463,6 +466,13 @@ int crypto_register_alg(struct crypto_alg *alg)
 		alg->cra_destroy = crypto_free_alg;
 	}
 
+#ifdef FIPS_MODULE
+	if (alg->cra_module == THIS_MODULE) {
+		alg->cra_flags |= CRYPTO_ALG_FIPS_PROVIDED;
+		alg->cra_priority |= 4096;
+	}
+#endif
+
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg, &algs_to_put);
 	if (!IS_ERR_OR_NULL(larval)) {
@@ -666,6 +676,9 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	struct crypto_larval *larval;
 	struct crypto_spawn *spawn;
 	u32 fips_internal = 0;
+#ifdef FIPS_MODULE
+	u32 fips_provided = ~0;
+#endif
 	LIST_HEAD(algs_to_put);
 	int err;
 
@@ -673,6 +686,9 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	if (err)
 		return err;
 
+	/* Blatant API misuse */
+	BUG_ON(inst->alg.cra_flags & CRYPTO_ALG_FIPS_PROVIDED);
+
 	inst->alg.cra_module = tmpl->module;
 	inst->alg.cra_flags |= CRYPTO_ALG_INSTANCE;
 	inst->alg.cra_destroy = crypto_destroy_instance;
@@ -692,6 +708,13 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 		fips_internal |= spawn->alg->cra_flags;
 
+#ifdef FIPS_MODULE
+		if (spawn->alg->cra_module == THIS_MODULE)
+			fips_provided &= spawn->alg->cra_flags;
+		else
+			fips_provided = 0;
+#endif
+
 		crypto_mod_put(spawn->alg);
 
 		spawn = next;
@@ -699,6 +722,13 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	inst->alg.cra_flags |= (fips_internal & CRYPTO_ALG_FIPS_INTERNAL);
 
+#ifdef FIPS_MODULE
+	if (tmpl->module == THIS_MODULE && (fips_provided & CRYPTO_ALG_FIPS_PROVIDED)) {
+		inst->alg.cra_flags |= CRYPTO_ALG_FIPS_PROVIDED;
+		inst->alg.cra_priority |= 4096;
+	}
+#endif
+
 	larval = __crypto_register_alg(&inst->alg, &algs_to_put);
 	if (IS_ERR(larval))
 		goto unlock;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 25aadf5b6690..1dfd37761a4f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5771,15 +5771,23 @@ static int alg_fips_disabled(const char *driver, const char *alg)
 	return -ECANCELED;
 }
 
-static int alg_test_fips_disabled(const struct alg_test_desc *desc)
+static int alg_test_fips_disabled(const struct crypto_alg *alg, const struct alg_test_desc *desc)
 {
 	if (!fips_enabled)
 		return 0;
 
 	/*
-	 * Only allow FIPS-allowed algorithms to be tested.
+	 * If the algorithm is completely provided by the FIPS module
+	 * we still require it to be allowed accoding to our test table.
 	 */
-	return !(desc->fips_allowed & FIPS_ALLOWED);
+	if (alg->cra_flags & CRYPTO_ALG_FIPS_PROVIDED)
+		return !(desc->fips_allowed & FIPS_ALLOWED);
+
+	/*
+	 * If the algorithm is not provided by the FIPS module, then
+	 * it must be FIPS_NON_CRYPTOGRAPHIC.
+	 */
+	return !(desc->fips_allowed & FIPS_NON_CRYPTOGRAPHIC);
 }
 
 int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
@@ -5806,7 +5814,7 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 		if (i < 0)
 			goto notest;
 
-		if (alg_test_fips_disabled(&alg_test_descs[i]))
+		if (alg_test_fips_disabled(alg, &alg_test_descs[i]))
 			goto non_fips_alg;
 
 		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
@@ -5819,9 +5827,9 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 		goto notest;
 
 	if (fips_enabled) {
-		if (j >= 0 && alg_test_fips_disabled(&alg_test_descs[j]))
+		if (j >= 0 && alg_test_fips_disabled(alg, &alg_test_descs[j]))
 			return -EINVAL;
-		if (i >= 0 && alg_test_fips_disabled(&alg_test_descs[i]))
+		if (i >= 0 && alg_test_fips_disabled(alg, &alg_test_descs[i]))
 			goto non_fips_alg;
 	}
 
@@ -5865,7 +5873,7 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 		if (i < 0)
 			goto notest2;
 
-		if (alg_test_fips_disabled(&alg_test_descs[i]))
+		if (alg_test_fips_disabled(alg, &alg_test_descs[i]))
 			goto non_fips_alg;
 
 		rc = alg_test_skcipher(alg_test_descs + i, driver, type, mask);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index a2137e19be7d..737e53a642d4 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,14 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/*
+ * The algorithm is provided by the FIPS module.
+ *
+ * NOTE: an algorithm can be provided by the FIPS module and not be
+ * approved, depending on the exact parameters like key size, etc.
+ */
+#define CRYPTO_ALG_FIPS_PROVIDED	0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.3

