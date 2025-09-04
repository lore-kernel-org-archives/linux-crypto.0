Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2705C21638D;
	Thu,  4 Sep 2025 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001382; cv=none; b=QsJFctBNH0O511B7FmlUn4QEXHMbJlGQxc10gTcuNQuR/ag/SsC7EZmPTR+OZ15SXc5R3TMYYb5D7FSilylC3/oJYeRii05r/42pHEl7JfsRNObu/bbvNebwsEM7gdH5f3XW9iSNkCtgHCgaVK317Or2qhwah+TEe6zZFz791H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001382; c=relaxed/simple;
	bh=X9sddZ4f1Ec2gQa6K6pBL/Ed5R3wsaC8KQHJgwxWMAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tVPXr3nm1JmC6O/uBY3IcyH1I09f1HH15Nv5xrEAcAYyo9YToXdxIXemLCHh+79vn/xpotwtTeCvvPgCqMNINunOyGrsDA/zQ9vBmN00Po3TJ7AuEoy+IVKLwv/VzEot0w94SVHdiAOKlmEbW9PE6fiyhFYdQryNHBkVOfI5WZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WWB+sAur; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WWB+sAur"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtkPZ009123;
	Thu, 4 Sep 2025 15:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=xh7LH
	4crIsn6yDKd5kGW45C2hA4z07Uf5415OEVfkAY=; b=WWB+sAurGwVfxJkL4qhw1
	so1oTPyk6bxRFK63iyfvYZxq3zOBH+FLSNZNSfKLjoiGOwL2xjUVn64J2FtD62oU
	JXPS1gNWfJEYREP0uQxLuzTU58eIBKQSoCZhnJWLEXKZlq7/8iRyszQ60MFXoGRk
	woW/0M3YfFAqFnEgo5+1+lUPzM/Nu1HKLxP5SsuPXDUSUMSFLSj6JwSojL41j/ia
	TF6ia6qsznx8kBBRo9yloVUpbYDvkLkjb99vpbrPC2iqFbkRE7cJIDEzmAbghoFU
	kNPYrHCV9mBUuGQoTl1WsFBBEtj0W3VR7CMEDS2U5mP3UMJcnTm+bVPuS8JnjXpc
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt003s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FcVoH040046;
	Thu, 4 Sep 2025 15:56:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:06 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5M000707;
	Thu, 4 Sep 2025 15:56:06 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-18;
	Thu, 04 Sep 2025 15:56:06 +0000
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
Subject: [PATCH RFC 017/104] crypto: testmgr: check that we got the expected alg
Date: Thu,  4 Sep 2025 17:50:49 +0200
Message-Id: <20250904155216.460962-18-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: lNsY8CZVm6gVX3Eh7LwP5_7XKX7ukGDv
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b697 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=PJ1paTDLKTrQ9FBj_50A:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfXydbRwU/F6yzO
 IXmDkLlcoxqKKniFEV3iGLCjGKLS18cYU7W6Pfe/NzU9D8NZ4M+EPBMZ5SEaeWak2rNDdEcIiyl
 rcqpu1w4WQ+K0JLo++yD2MMAaRvbjuWHhhwsgEO/92FNyV3PlbN6ErNBZx6UTzIm8iCejYhZQ5k
 DReJTcXixyv3t7QE55c1SbvpOM0rcwNRCsOfQVoYf2E84XNbakHHqE/OjXQAUrP0+z8PwZJrX67
 sTJCHCgtB+klF0VeZ63D/sWm7ufUwYJZy7YFDK2f8B0EmmICdeti5vPgClPUOf4xuz4lsfXmnuR
 WE0T1FsqF8aabg+eyZqvwAamQDjhKY+LlzL7WkeLrLvuNo2/MWlAImYC6lsIXgPo+PkLmpXouIS
 blMnEP8ZKGdroMJ1Sc/qBH1epMmmSg==
X-Proofpoint-GUID: lNsY8CZVm6gVX3Eh7LwP5_7XKX7ukGDv

alg_test() is testing a specific crypto algorithm, but does the lookup
by name.

Add a new helper, check_alg(), to be called after allocating your tfm,
to verify that the algorithm we are actually testing is the algorithm
we meant to test.

This is vitally important so no races or other shenanigans can cause a
test to be scheduled for a particular driver and end up actually testing
a different one.

Note that if this warning ever triggers, it indicates that there is a
problem with how algorithms are registered/unregistered and how tests
are scheduled, as it should normally not be possible to end up testing
something you didn't mean to test.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/testmgr.c | 130 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 102 insertions(+), 28 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1dfd37761a4f..35626ae18c60 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -158,8 +158,8 @@ struct kpp_test_suite {
 struct alg_test_desc {
 	const char *alg;
 	const char *generic_driver;
-	int (*test)(const struct alg_test_desc *desc, const char *driver,
-		    u32 type, u32 mask);
+	int (*test)(struct crypto_alg *alg, const struct alg_test_desc *desc,
+		    const char *driver, u32 type, u32 mask);
 	int fips_allowed;	/* see FIPS_* constants above */
 
 	union {
@@ -1914,7 +1914,18 @@ static int alloc_shash(const char *driver, u32 type, u32 mask,
 	return 0;
 }
 
-static int __alg_test_hash(const struct hash_testvec *vecs,
+static int check_alg(struct crypto_alg *expected, struct crypto_alg *actual)
+{
+	if (actual == expected)
+		return 0;
+
+	WARN(1, "alg: expected driver %s, got %s\n",
+		expected->cra_driver_name, actual->cra_driver_name);
+	return -EINVAL;
+}
+
+static int __alg_test_hash(struct crypto_alg *alg,
+			   const struct hash_testvec *vecs,
 			   unsigned int num_vecs, const char *driver,
 			   u32 type, u32 mask,
 			   const char *generic_driver, unsigned int maxkeysize)
@@ -1942,6 +1953,11 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		       driver, PTR_ERR(atfm));
 		return PTR_ERR(atfm);
 	}
+
+	err = check_alg(alg, atfm->base.__crt_alg);
+	if (err)
+		goto out;
+
 	driver = crypto_ahash_driver_name(atfm);
 
 	req = ahash_request_alloc(atfm, GFP_KERNEL);
@@ -1960,6 +1976,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	if (err)
 		goto out;
 
+	if (stfm) {
+		err = check_alg(alg, stfm->base.__crt_alg);
+		if (err)
+			goto out;
+	}
+
 	tsgl = kmalloc(sizeof(*tsgl), GFP_KERNEL);
 	if (!tsgl || init_test_sglist(tsgl) != 0) {
 		pr_err("alg: hash: failed to allocate test buffers for %s\n",
@@ -2005,7 +2027,8 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	return err;
 }
 
-static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
+static int alg_test_hash(struct crypto_alg *alg,
+			 const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
 	const struct hash_testvec *template = desc->suite.hash.vecs;
@@ -2036,14 +2059,14 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 
 	err = 0;
 	if (nr_unkeyed) {
-		err = __alg_test_hash(template, nr_unkeyed, driver, type, mask,
-				      desc->generic_driver, maxkeysize);
+		err = __alg_test_hash(alg, template, nr_unkeyed, driver, type,
+				      mask, desc->generic_driver, maxkeysize);
 		template += nr_unkeyed;
 	}
 
 	if (!err && nr_keyed)
-		err = __alg_test_hash(template, nr_keyed, driver, type, mask,
-				      desc->generic_driver, maxkeysize);
+		err = __alg_test_hash(alg, template, nr_keyed, driver, type,
+				      mask, desc->generic_driver, maxkeysize);
 
 	return err;
 }
@@ -2673,7 +2696,8 @@ static int test_aead(int enc, const struct aead_test_suite *suite,
 	return 0;
 }
 
-static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
+static int alg_test_aead(struct crypto_alg *alg,
+			 const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
 	const struct aead_test_suite *suite = &desc->suite.aead;
@@ -2695,6 +2719,11 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+
+	err = check_alg(alg, tfm->base.__crt_alg);
+	if (err)
+		goto out;
+
 	driver = crypto_aead_driver_name(tfm);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
@@ -3230,7 +3259,8 @@ static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 	return 0;
 }
 
-static int alg_test_skcipher(const struct alg_test_desc *desc,
+static int alg_test_skcipher(struct crypto_alg *alg,
+			     const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
 	const struct cipher_test_suite *suite = &desc->suite.cipher;
@@ -3252,6 +3282,11 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+
+	err = check_alg(alg, tfm->base.__crt_alg);
+	if (err)
+		goto out;
+
 	driver = crypto_skcipher_driver_name(tfm);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
@@ -3517,7 +3552,8 @@ static int test_cprng(struct crypto_rng *tfm,
 	return err;
 }
 
-static int alg_test_cipher(const struct alg_test_desc *desc,
+static int alg_test_cipher(struct crypto_alg *alg,
+			   const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
 {
 	const struct cipher_test_suite *suite = &desc->suite.cipher;
@@ -3533,16 +3569,22 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 		return PTR_ERR(tfm);
 	}
 
+	err = check_alg(alg, tfm->base.__crt_alg);
+	if (err)
+		goto out;
+
 	err = test_cipher(tfm, ENCRYPT, suite->vecs, suite->count);
 	if (!err)
 		err = test_cipher(tfm, DECRYPT, suite->vecs, suite->count);
 
+out:
 	crypto_free_cipher(tfm);
 	return err;
 }
 
-static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
-			 u32 type, u32 mask)
+static int alg_test_comp(struct crypto_alg *alg,
+			 const struct alg_test_desc *desc,
+			 const char *driver, u32 type, u32 mask)
 {
 	struct crypto_acomp *acomp;
 	int err;
@@ -3555,6 +3597,13 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 		       driver, PTR_ERR(acomp));
 		return PTR_ERR(acomp);
 	}
+
+	err = check_alg(alg, acomp->base.__crt_alg);
+	if (err) {
+		crypto_free_acomp(acomp);
+		return err;
+	}
+
 	err = test_acomp(acomp, desc->suite.comp.comp.vecs,
 			 desc->suite.comp.decomp.vecs,
 			 desc->suite.comp.comp.count,
@@ -3563,7 +3612,8 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
+static int alg_test_cprng(struct crypto_alg *alg,
+			  const struct alg_test_desc *desc, const char *driver,
 			  u32 type, u32 mask)
 {
 	struct crypto_rng *rng;
@@ -3578,15 +3628,20 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 		return PTR_ERR(rng);
 	}
 
+	err = check_alg(alg, rng->base.__crt_alg);
+	if (err)
+		goto out;
+
 	err = test_cprng(rng, desc->suite.cprng.vecs, desc->suite.cprng.count);
 
+out:
 	crypto_free_rng(rng);
-
 	return err;
 }
 
 
-static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
+static int drbg_cavs_test(struct crypto_alg *alg,
+			  const struct drbg_testvec *test, int pr,
 			  const char *driver, u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
@@ -3608,6 +3663,10 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 		return PTR_ERR(drng);
 	}
 
+	ret = check_alg(alg, drng->base.__crt_alg);
+	if (ret)
+		goto outbuf;
+
 	test_data.testentropy = &testentropy;
 	drbg_string_fill(&testentropy, test->entropy, test->entropylen);
 	drbg_string_fill(&pers, test->pers, test->perslen);
@@ -3656,7 +3715,8 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 }
 
 
-static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
+static int alg_test_drbg(struct crypto_alg *alg,
+			 const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
 	int err = 0;
@@ -3669,7 +3729,7 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 		pr = 1;
 
 	for (i = 0; i < tcount; i++) {
-		err = drbg_cavs_test(&template[i], pr, driver, type, mask);
+		err = drbg_cavs_test(alg, &template[i], pr, driver, type, mask);
 		if (err) {
 			printk(KERN_ERR "alg: drbg: Test %d failed for %s\n",
 			       i, driver);
@@ -3839,7 +3899,8 @@ static int test_kpp(struct crypto_kpp *tfm, const char *alg,
 	return 0;
 }
 
-static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
+static int alg_test_kpp(struct crypto_alg *alg,
+			const struct alg_test_desc *desc, const char *driver,
 			u32 type, u32 mask)
 {
 	struct crypto_kpp *tfm;
@@ -3853,10 +3914,16 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+
+	err = check_alg(alg, tfm->base.__crt_alg);
+	if (err)
+		goto out;
+
 	if (desc->suite.kpp.vecs)
 		err = test_kpp(tfm, desc->alg, desc->suite.kpp.vecs,
 			       desc->suite.kpp.count);
 
+out:
 	crypto_free_kpp(tfm);
 	return err;
 }
@@ -4022,7 +4089,8 @@ static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
 	return 0;
 }
 
-static int alg_test_akcipher(const struct alg_test_desc *desc,
+static int alg_test_akcipher(struct crypto_alg *alg,
+			     const struct alg_test_desc *desc,
 			     const char *driver, u32 type, u32 mask)
 {
 	struct crypto_akcipher *tfm;
@@ -4036,10 +4104,16 @@ static int alg_test_akcipher(const struct alg_test_desc *desc,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+
+	err = check_alg(alg, tfm->base.__crt_alg);
+	if (err)
+		goto out;
+
 	if (desc->suite.akcipher.vecs)
 		err = test_akcipher(tfm, desc->alg, desc->suite.akcipher.vecs,
 				    desc->suite.akcipher.count);
 
+out:
 	crypto_free_akcipher(tfm);
 	return err;
 }
@@ -4132,8 +4206,8 @@ static int test_sig(struct crypto_sig *tfm, const char *alg,
 	return 0;
 }
 
-static int alg_test_sig(const struct alg_test_desc *desc, const char *driver,
-			u32 type, u32 mask)
+static int alg_test_sig(struct crypto_alg *alg, const struct alg_test_desc *desc,
+			const char *driver, u32 type, u32 mask)
 {
 	struct crypto_sig *tfm;
 	int err = 0;
@@ -4152,8 +4226,8 @@ static int alg_test_sig(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int alg_test_null(const struct alg_test_desc *desc,
-			     const char *driver, u32 type, u32 mask)
+static int alg_test_null(struct crypto_alg *alg, const struct alg_test_desc *desc,
+			 const char *driver, u32 type, u32 mask)
 {
 	return 0;
 }
@@ -5817,7 +5891,7 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 		if (alg_test_fips_disabled(alg, &alg_test_descs[i]))
 			goto non_fips_alg;
 
-		rc = alg_test_cipher(alg_test_descs + i, driver, type, mask);
+		rc = alg_test_cipher(alg, alg_test_descs + i, driver, type, mask);
 		goto test_done;
 	}
 
@@ -5835,10 +5909,10 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 
 	rc = 0;
 	if (i >= 0)
-		rc |= alg_test_descs[i].test(alg_test_descs + i, driver,
+		rc |= alg_test_descs[i].test(alg, alg_test_descs + i, driver,
 					     type, mask);
 	if (j >= 0 && j != i)
-		rc |= alg_test_descs[j].test(alg_test_descs + j, driver,
+		rc |= alg_test_descs[j].test(alg, alg_test_descs + j, driver,
 					     type, mask);
 
 test_done:
@@ -5876,7 +5950,7 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 		if (alg_test_fips_disabled(alg, &alg_test_descs[i]))
 			goto non_fips_alg;
 
-		rc = alg_test_skcipher(alg_test_descs + i, driver, type, mask);
+		rc = alg_test_skcipher(alg, alg_test_descs + i, driver, type, mask);
 		goto test_done;
 	}
 
-- 
2.39.3

