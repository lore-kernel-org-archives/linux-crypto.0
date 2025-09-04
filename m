Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC827280E;
	Thu,  4 Sep 2025 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001336; cv=none; b=gI3KceN7h5kZMf6BTmCgths/IxPV7NYPRPj4MGBMLHz4xqAkx49a2wLSw4+ryIehgoPSn093M179uCP+qMbA4+oEdYHpzNWnm+Mo1w3EKJZCf+hjkIMlXNGNeCLPSA43KjQsIZQs18Sj/S2x+b88/tqjP1HBSnmPSa9/QzE66Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001336; c=relaxed/simple;
	bh=rUCDzmgc+UMXnc8egbB+yLEBW3HVtk5KnKKOBBo/5w4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Any3m+lwNjhCmMi+2CDaAF/MQ15Pu64EbFhxnnT6X9XumR7YBGO7Kvr/nuM9LNxXaWZwyAiK/ZXOzZ0t0+CtK4ky2eXIkFt+A+9anc5dyRibSjDI+OuWof6uPaZEsbwsSZpHIJ535Wcu9+8AcMX6lsNMinISIaqUfNYz5AWmF8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iOHGg+ve; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iOHGg+ve"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FjxLY006551;
	Thu, 4 Sep 2025 15:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=YduG+
	Y3SwSKkqrMmxImLmq2DLrYFGDbKxWh+DfVsj6Q=; b=iOHGg+veSwizoq7RaaGzO
	/bPu7CQakGJUOzsuz4OPFmoAiw7l2Y2C3Kqyd8Acjhv9gMkmn7OkFJxLbL2JAO+q
	qznxDixzGksFajE6focbdXbGGOt7ycoe8G2BhcJ8moZlpTqBmiuyZnDkfK9TCwHk
	Mk4SAmLS0bbuSmpbSoPrNtXg4Mew46+038EFo1lpQGY9Su8STa6GfzNmcsuSUUEL
	32Ykm6uDmY3jpU6Rmdd9m0zP+wSdk6hpSEYIcQIK42ZCQtuWAkIdlHZLMJW4qjg/
	uSCeVOMXsfA1+99FwNJW4u/CYfa8hYf75/so6yaP3tU1khx3hd20wcHLhyj+OeuA
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd01ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fednu040082;
	Thu, 4 Sep 2025 15:55:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtm1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4u000707;
	Thu, 4 Sep 2025 15:55:20 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-6;
	Thu, 04 Sep 2025 15:55:20 +0000
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
        Vegard Nossum <vegard.nossum@oracle.com>,
        Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
Subject: [PATCH RFC 005/104] crypto: hide crypto_default_rng variable
Date: Thu,  4 Sep 2025 17:50:37 +0200
Message-Id: <20250904155216.460962-6-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX4PfWiDDP7+K3
 KipDHtqqtXtcAmVk+jhPqua1euk1C+CsY89BWj6VCe+mpoQEISFd3+i1PsnBY44xX2tvwg0ZYLF
 UPbeFsaKSIokJ1vheDnUPVUGAcHb8t4bvzYNjuB8m+MFnt3f0sMNif1pBM6KPBMYIFbYCqQSf0F
 Z8AUMlve1Dm9SZkCL2N+CjbLU4VMOrYa/hjh8VO+7Lml9lJERfRzY2/R53Awy4TVdJ79cQ2a3LM
 +0f52LuW70oO0mwTj57UzU1Wnb8UDipztMMps8ox/NeKoajrnD5yuLdRBhYc88D58i/tNLxWrbk
 JC9VuWEGicRTmegP9FHvQ0qT94iOtZABXDYh+Bbyb4y12HzQDSpNZ6mVihfvZUo0RX4vNsn7fnk
 G2yF0vDaxy0gS62vL1akcvl9+IvZLg==
X-Proofpoint-GUID: HH0BmzD_i7xk0WVBM2mQPTgOXpueE-nA
X-Proofpoint-ORIG-GUID: HH0BmzD_i7xk0WVBM2mQPTgOXpueE-nA
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b66a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=TLK7jzU0I5Iz9611FlwA:9 cc=ntf
 awl=host:12068

De-globalize crypto_default_rng and make it accessible only through the
crypto_get_default_rng()/crypto_put_default_rng() API instead. The users
need to call these functions anyway so there is really no point in
having it as a global.

I opted to take double pointers as arguments (and return an error code)
so we can do basic API misuse checking.

Reported-by: Sriharsha Yadagudde <sriharsha.devdas@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/dh.c                                    |  8 ++++----
 crypto/ecc.c                                   |  8 ++++----
 crypto/geniv.c                                 |  8 ++++----
 crypto/rng.c                                   |  9 +++++----
 drivers/crypto/hisilicon/hpre/hpre_crypto.c    |  8 ++++----
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 14 ++++++++------
 include/crypto/rng.h                           |  6 ++----
 net/tipc/crypto.c                              |  8 ++++----
 8 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 8250eeeebd0f..1d80213574b3 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -352,6 +352,7 @@ static void *dh_safe_prime_gen_privkey(const struct dh_safe_prime *safe_prime,
 {
 	unsigned int n, oversampling_size;
 	__be64 *key;
+	struct crypto_rng *rng;
 	int err;
 	u64 h, o;
 
@@ -389,12 +390,11 @@ static void *dh_safe_prime_gen_privkey(const struct dh_safe_prime *safe_prime,
 	 * random bits and interpret them as a big endian integer.
 	 */
 	err = -EFAULT;
-	if (crypto_get_default_rng())
+	if (crypto_get_default_rng(&rng))
 		goto out_err;
 
-	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)key,
-				   oversampling_size);
-	crypto_put_default_rng();
+	err = crypto_rng_get_bytes(rng, (u8 *)key, oversampling_size);
+	crypto_put_default_rng(&rng);
 	if (err)
 		goto out_err;
 
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 6cf9a945fc6c..c9f82626177b 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1525,6 +1525,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
 	unsigned int nbits = vli_num_bits(curve->n, ndigits);
+	struct crypto_rng *rng;
 	int err;
 
 	/*
@@ -1545,13 +1546,12 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
 	 * This condition is met by the default RNG because it selects a favored
 	 * DRBG with a security strength of 256.
 	 */
-	if (crypto_get_default_rng())
+	if (crypto_get_default_rng(&rng))
 		return -EFAULT;
 
 	/* Step 3: obtain N returned_bits from the DRBG. */
-	err = crypto_rng_get_bytes(crypto_default_rng,
-				   (u8 *)private_key, nbytes);
-	crypto_put_default_rng();
+	err = crypto_rng_get_bytes(rng, (u8 *)private_key, nbytes);
+	crypto_put_default_rng(&rng);
 	if (err)
 		return err;
 
diff --git a/crypto/geniv.c b/crypto/geniv.c
index 42eff6a7387c..0b18240ac813 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -109,18 +109,18 @@ int aead_init_geniv(struct crypto_aead *aead)
 {
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
 	struct aead_instance *inst = aead_alg_instance(aead);
+	struct crypto_rng *rng;
 	struct crypto_aead *child;
 	int err;
 
 	spin_lock_init(&ctx->lock);
 
-	err = crypto_get_default_rng();
+	err = crypto_get_default_rng(&rng);
 	if (err)
 		goto out;
 
-	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-				   crypto_aead_ivsize(aead));
-	crypto_put_default_rng();
+	err = crypto_rng_get_bytes(rng, ctx->salt, crypto_aead_ivsize(aead));
+	crypto_put_default_rng(&rng);
 	if (err)
 		goto out;
 
diff --git a/crypto/rng.c b/crypto/rng.c
index b8ae6ebc091d..2a246e1a0918 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -24,8 +24,7 @@
 #include "internal.h"
 
 static DEFINE_MUTEX(crypto_default_rng_lock);
-struct crypto_rng *crypto_default_rng;
-EXPORT_SYMBOL_GPL(crypto_default_rng);
+static struct crypto_rng *crypto_default_rng;
 static int crypto_default_rng_refcnt;
 
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
@@ -107,7 +106,7 @@ struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_rng);
 
-int crypto_get_default_rng(void)
+int crypto_get_default_rng(struct crypto_rng **result)
 {
 	struct crypto_rng *rng;
 	int err;
@@ -128,6 +127,7 @@ int crypto_get_default_rng(void)
 		crypto_default_rng = rng;
 	}
 
+	*result = crypto_default_rng;
 	crypto_default_rng_refcnt++;
 	err = 0;
 
@@ -138,9 +138,10 @@ int crypto_get_default_rng(void)
 }
 EXPORT_SYMBOL_GPL(crypto_get_default_rng);
 
-void crypto_put_default_rng(void)
+void crypto_put_default_rng(struct crypto_rng **rng)
 {
 	mutex_lock(&crypto_default_rng_lock);
+	*rng = NULL;
 	crypto_default_rng_refcnt--;
 	mutex_unlock(&crypto_default_rng_lock);
 }
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 1550c3818383..48872721214c 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1380,17 +1380,17 @@ static bool hpre_key_is_zero(char *key, unsigned short key_sz)
 static int ecdh_gen_privkey(struct hpre_ctx *ctx, struct ecdh *params)
 {
 	struct device *dev = ctx->dev;
+	struct crypto_rng *rng;
 	int ret;
 
-	ret = crypto_get_default_rng();
+	ret = crypto_get_default_rng(&rng);
 	if (ret) {
 		dev_err(dev, "failed to get default rng, ret = %d!\n", ret);
 		return ret;
 	}
 
-	ret = crypto_rng_get_bytes(crypto_default_rng, (u8 *)params->key,
-				   params->key_size);
-	crypto_put_default_rng();
+	ret = crypto_rng_get_bytes(rng, (u8 *)params->key, params->key_size);
+	crypto_put_default_rng(&rng);
 	if (ret)
 		dev_err(dev, "failed to get rng, ret = %d!\n", ret);
 
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 59308926399d..a79e6549740f 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -223,6 +223,7 @@ static int kmb_ecc_point_mult(struct ocs_ecc_dev *ecc_dev,
 			      u64 *scalar,
 			      const struct ecc_curve *curve)
 {
+	struct crypto_rng *rng;
 	u8 sca[KMB_ECC_VLI_MAX_BYTES]; /* Use the maximum data size. */
 	u32 op_size = (curve->g.ndigits > ECC_CURVE_NIST_P256_DIGITS) ?
 		      OCS_ECC_OP_SIZE_384 : OCS_ECC_OP_SIZE_256;
@@ -230,12 +231,12 @@ static int kmb_ecc_point_mult(struct ocs_ecc_dev *ecc_dev,
 	int rc = 0;
 
 	/* Generate random nbytes for Simple and Differential SCA protection. */
-	rc = crypto_get_default_rng();
+	rc = crypto_get_default_rng(&rng);
 	if (rc)
 		return rc;
 
-	rc = crypto_rng_get_bytes(crypto_default_rng, sca, nbytes);
-	crypto_put_default_rng();
+	rc = crypto_rng_get_bytes(rng, sca, nbytes);
+	crypto_put_default_rng(&rng);
 	if (rc)
 		return rc;
 
@@ -490,6 +491,7 @@ static int kmb_ecc_is_key_valid(const struct ecc_curve *curve,
  */
 static int kmb_ecc_gen_privkey(const struct ecc_curve *curve, u64 *privkey)
 {
+	struct crypto_rng *rng;
 	size_t nbytes = digits_to_bytes(curve->g.ndigits);
 	u64 priv[KMB_ECC_VLI_MAX_DIGITS];
 	size_t nbits;
@@ -512,11 +514,11 @@ static int kmb_ecc_gen_privkey(const struct ecc_curve *curve, u64 *privkey)
 	 * This condition is met by the default RNG because it selects a favored
 	 * DRBG with a security strength of 256.
 	 */
-	if (crypto_get_default_rng())
+	if (crypto_get_default_rng(&rng))
 		return -EFAULT;
 
-	rc = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
-	crypto_put_default_rng();
+	rc = crypto_rng_get_bytes(rng, (u8 *)priv, nbytes);
+	crypto_put_default_rng(&rng);
 	if (rc)
 		goto cleanup;
 
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index f8224cc390f8..816f255adcd3 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -57,10 +57,8 @@ struct crypto_rng {
 	struct crypto_tfm base;
 };
 
-extern struct crypto_rng *crypto_default_rng;
-
-int crypto_get_default_rng(void);
-void crypto_put_default_rng(void);
+int crypto_get_default_rng(struct crypto_rng **rng);
+void crypto_put_default_rng(struct crypto_rng **rng);
 
 /**
  * DOC: Random number generator API
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index ea5bb131ebd0..6b085fd383b0 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -368,13 +368,13 @@ int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info)
 static int tipc_aead_key_generate(struct tipc_aead_key *skey)
 {
 	int rc = 0;
+	struct crypto_rng *rng;
 
 	/* Fill the key's content with a random value via RNG cipher */
-	rc = crypto_get_default_rng();
+	rc = crypto_get_default_rng(&rng);
 	if (likely(!rc)) {
-		rc = crypto_rng_get_bytes(crypto_default_rng, skey->key,
-					  skey->keylen);
-		crypto_put_default_rng();
+		rc = crypto_rng_get_bytes(rng, skey->key, skey->keylen);
+		crypto_put_default_rng(&rng);
 	}
 
 	return rc;
-- 
2.39.3

