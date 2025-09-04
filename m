Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D73C27A476;
	Thu,  4 Sep 2025 15:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001373; cv=none; b=fg0/YsYK4VHQBUwGuIM19g7Yihcl6eqVoZu4nDMWYmW+89x2F2zGN+C3fkvdDAjBr/0vmggQ+C5u/JIjpN/VPHHamtM5ONORRE0lXRHcl6Bq2DUuM+RSRfNDdxrVwylQRSNNDAZCIyGtuW/d2wVEOBR3I0gQUup4leKQi41cYeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001373; c=relaxed/simple;
	bh=e1fC6sYvUv8IFCKnHKkxQ9HPCtyEozVKA7Yv97HfLms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OUTB/ahfq54Fclv7kAdlh0RLw1EWoOdqFo0f5acyXY3V6x6mF8UuGxaQLgLDkl4WgALTJxIqBgaQ3spc+iWm5gcWXOJX1rOuKtFoaPyjY3O4TRgrhzY3WWICTDviY8Q+PxOIj0Vl2Cd/wuUaWoFUTw3rI41I46P/c9aewhGpiFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JfF5jYBW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JfF5jYBW"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftipu026703;
	Thu, 4 Sep 2025 15:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=hvsFM
	YJtmr2yfeVCbTmfbCQWnDv8kmk6RM9Iw7RDaGc=; b=JfF5jYBWViy6BJDtyQjvX
	0VCnwWD6YYFpDBmn+TW13US7EcCtLq5KuDNkk1ifEXKE+JkEFC8z3u8sanHdAqgc
	GYufmt69Wle/9PqILsjvbeHyLlLEpXhBGYSUqRvz+OGCmnl7x78KlwAiLmcNyRG8
	VXf1eAH6Rqe9u0ZuW7RfVVv4x9/WLSJreZj6Xws4lJXuJYREoLtmxKdit9xvoMru
	O/KD4K8k3Ebz4j/+g1xfhc4tWjf2SBt8og/NtCjaKgMnp608UmryQjDzNoy1GOS6
	3ffuVM6WAca/Bijb7MaVRaFdb6whCRRDs7vaVWH1T/qojb9XePclTZ3qB6PZK3TF
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FcVoE040046;
	Thu, 4 Sep 2025 15:55:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtmf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5I000707;
	Thu, 4 Sep 2025 15:55:58 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-16;
	Thu, 04 Sep 2025 15:55:58 +0000
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
Subject: [PATCH RFC 015/104] crypto: pass struct crypto_alg directly to alg_test()
Date: Thu,  4 Sep 2025 17:50:47 +0200
Message-Id: <20250904155216.460962-16-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfX+hUmoN+uQmEX
 GhxrQrVn/FWjyJGxR4jeJSq6+FrHc433kl9FIJ/hXwU1SHeCaDNGNsCCqwYfHLFTHUuznvSGWfs
 GeGkHtiE9R5vJMFfwxkicORHr4ZQsC4tAiYqku23WTW9xV/v5g1S6wgBaqguW8OEeafFED94iZD
 Erly1vPLtmbO3o20wLFH0cCBBvU9rGhKnvd4G6luW6HA2fQOUO5AmQHHH/VS1eUXUMgkEuaPuZg
 EM3OysidlOjswfIIyXnPmm3UV41Hi80k8MJ+rOd15IS6JjcXlnOJyrwGSAHVCdcftLEbYyk9snY
 1tYLduLSdSeITTLL6o3UhNY/nXm7D5TGGi8MnLj4Rt3eBzSbXQkLzLfjH+wZ1f9IeWAHku5hVqW
 fBDJ1YEfa+FP3xahVmzkv4naB8sy8g==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b68f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=bSBNh6IWIqf5RqeBi5EA:9 cc=ntf
 awl=host:12068
X-Proofpoint-ORIG-GUID: oxhYE3j5ji3_pzo-o2DretASA5fLQr-V
X-Proofpoint-GUID: oxhYE3j5ji3_pzo-o2DretASA5fLQr-V

algboss/cryptomgr_schedule_test/cryptomgr_test currently pass the
algorithm to test by name -- stringly typed.

This is unfortunate as it opens all kinds of potential issues with race
conditions and ultimately the question of whether we actually tested
what we wanted to test.

I see no reason why we should pass the algorithm by name except for the
fact that the crypto API itself is stringly typed when
requesting/instantiating algorithms. Maybe there should be a way to
instantiate an algorithm by alg pointer too?

In any case, let's pass the alg directly so we know precisely what
algorithm we are actually testing.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/algboss.c  | 32 ++++++++++----------------------
 crypto/internal.h |  2 +-
 crypto/tcrypt.c   | 18 +++++++++++++++---
 crypto/testmgr.c  | 24 ++++++++++++------------
 4 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 846f586889ee..31df14e37a3e 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -41,12 +41,6 @@ struct cryptomgr_param {
 	u32 omask;
 };
 
-struct crypto_test_param {
-	char driver[CRYPTO_MAX_ALG_NAME];
-	char alg[CRYPTO_MAX_ALG_NAME];
-	u32 type;
-};
-
 static int cryptomgr_probe(void *data)
 {
 	struct cryptomgr_param *param = data;
@@ -172,22 +166,21 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 static int cryptomgr_test(void *data)
 {
-	struct crypto_test_param *param = data;
-	u32 type = param->type;
+	struct crypto_alg *alg = data;
 	int err;
 
-	err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
+	err = alg_test(alg, alg->cra_driver_name, alg->cra_name,
+		alg->cra_flags, CRYPTO_ALG_TESTED);
 
-	crypto_alg_tested(param->driver, err);
+	crypto_alg_tested(alg->cra_driver_name, err);
 
-	kfree(param);
+	crypto_mod_put(alg);
 	module_put_and_kthread_exit(0);
 }
 
 static int cryptomgr_schedule_test(struct crypto_alg *alg)
 {
 	struct task_struct *thread;
-	struct crypto_test_param *param;
 
 	if (!IS_ENABLED(CONFIG_CRYPTO_SELFTESTS))
 		return NOTIFY_DONE;
@@ -195,22 +188,17 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 	if (!try_module_get(THIS_MODULE))
 		goto err;
 
-	param = kzalloc(sizeof(*param), GFP_KERNEL);
-	if (!param)
+	if (!crypto_mod_get(alg))
 		goto err_put_module;
 
-	memcpy(param->driver, alg->cra_driver_name, sizeof(param->driver));
-	memcpy(param->alg, alg->cra_name, sizeof(param->alg));
-	param->type = alg->cra_flags;
-
-	thread = kthread_run(cryptomgr_test, param, "cryptomgr_test");
+	thread = kthread_run(cryptomgr_test, alg, "cryptomgr_test");
 	if (IS_ERR(thread))
-		goto err_free_param;
+		goto err_put_alg;
 
 	return NOTIFY_STOP;
 
-err_free_param:
-	kfree(param);
+err_put_alg:
+	crypto_mod_put(alg);
 err_put_module:
 	module_put(THIS_MODULE);
 err:
diff --git a/crypto/internal.h b/crypto/internal.h
index b9afd68767c1..702934c719ef 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -65,7 +65,7 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
-int alg_test(const char *driver, const char *alg, u32 type, u32 mask);
+int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask);
 
 #if !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) || !IS_ENABLED(CONFIG_CRYPTO_SELFTESTS)
 static inline bool crypto_boot_test_finished(void)
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d1d88debbd71..b69560f2fdef 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1436,16 +1436,28 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
 				   false);
 }
 
-static inline int tcrypt_test(const char *alg)
+static inline int tcrypt_test(const char *name)
 {
 	int ret;
+	struct crypto_alg *alg;
 
-	pr_debug("testing %s\n", alg);
+	pr_debug("testing %s\n", name);
 
-	ret = alg_test(alg, alg, 0, 0);
+	alg = crypto_alg_mod_lookup(name, 0, 0);
+	if (IS_ERR(alg)) {
+		/* non-fip algs return -EAGAIN or -ENOENT in fips mode */
+		if (fips_enabled && (PTR_ERR(alg) == -EAGAIN || PTR_ERR(alg) == -ENOENT))
+			return 0;
+
+		return PTR_ERR(alg);
+	}
+
+	ret = alg_test(alg, name, name, 0, 0);
 	/* non-fips algs return -EINVAL or -ECANCELED in fips mode */
 	if (fips_enabled && (ret == -EINVAL || ret == -ECANCELED))
 		ret = 0;
+
+	crypto_mod_put(alg);
 	return ret;
 }
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ab7c6724d36f..25aadf5b6690 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #ifndef CONFIG_CRYPTO_SELFTESTS
 
 /* a perfect nop */
-int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
+int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
 {
 	return 0;
 }
@@ -5782,7 +5782,7 @@ static int alg_test_fips_disabled(const struct alg_test_desc *desc)
 	return !(desc->fips_allowed & FIPS_ALLOWED);
 }
 
-int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
+int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
 {
 	int i;
 	int j;
@@ -5798,7 +5798,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
 
-		if (snprintf(nalg, sizeof(nalg), "ecb(%s)", alg) >=
+		if (snprintf(nalg, sizeof(nalg), "ecb(%s)", name) >=
 		    sizeof(nalg))
 			return -ENAMETOOLONG;
 
@@ -5813,7 +5813,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		goto test_done;
 	}
 
-	i = alg_find_test(alg);
+	i = alg_find_test(name);
 	j = alg_find_test(driver);
 	if (i < 0 && j < 0)
 		goto notest;
@@ -5838,17 +5838,17 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		if (fips_enabled) {
 			fips_fail_notify();
 			panic("alg: self-tests for %s (driver %s) failed in fips mode!\n",
-			      alg, driver);
+			      name, driver);
 		}
 		pr_warn("alg: self-tests for %s (driver %s) failed (rc=%d)",
-			alg, driver, rc);
+			name, driver, rc);
 		WARN(rc != -ENOENT,
 		     "alg: self-tests for %s (driver %s) failed (rc=%d)",
-		     alg, driver, rc);
+		     name, driver, rc);
 	} else {
 		if (fips_enabled)
 			pr_info("alg: self-tests for %s (driver %s) passed\n",
-				alg, driver);
+				name, driver);
 	}
 
 	return rc;
@@ -5857,7 +5857,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_LSKCIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
 
-		if (snprintf(nalg, sizeof(nalg), "ecb(%s)", alg) >=
+		if (snprintf(nalg, sizeof(nalg), "ecb(%s)", name) >=
 		    sizeof(nalg))
 			goto notest2;
 
@@ -5873,14 +5873,14 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	}
 
 notest2:
-	printk(KERN_INFO "alg: No test for %s (driver %s)\n", alg, driver);
+	printk(KERN_INFO "alg: No test for %s (driver %s)\n", name, driver);
 
 	if (type & CRYPTO_ALG_FIPS_INTERNAL)
-		return alg_fips_disabled(driver, alg);
+		return alg_fips_disabled(driver, name);
 
 	return 0;
 non_fips_alg:
-	return alg_fips_disabled(driver, alg);
+	return alg_fips_disabled(driver, name);
 }
 
 #endif /* CONFIG_CRYPTO_SELFTESTS */
-- 
2.39.3

