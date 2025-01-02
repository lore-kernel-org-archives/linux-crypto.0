Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5639192B89;
	Thu,  2 Jan 2025 09:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735811187; cv=none; b=mztEs/0P3IWJjwCi0q9nCR8EdvYJV2i3cd9JhcbCdsqXProjMHu0JeP/TB1ALOfwTShuGe6T6GxLTqdlV4a0be65saFuUPFZcPQ9Ax5DO8WUSejn2eg+ohoH3KEJLHtOI+aTtDqBlLvUMReoPQ4KH53FTpBa8Ep2FvPvAZ8QRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735811187; c=relaxed/simple;
	bh=umM8wNgp37Q2grbeOtXCEKLQLs0LPxP6pRkQB46gXPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnOIqXgdtanccuuMk7Bjk0eY2ZT5pR1/B+4+aN5u5kB9N3fRFAx6ArmsOa6vxwjmJ4f0hvGQfaauWqOvsjKlJNdW1+O48isd32b2Xqj64RjJbWcgpJASWSEjtog0PQgKZUzNVXptVqOxfXm0EFPKdj2F8gz/7VvBFNrLPMpVVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=elIisGb9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="elIisGb9"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50285gwT014776;
	Thu, 2 Jan 2025 09:46:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=u8OyPDHUt/e9x+Z2J
	NgmZyMqYzkfNgis59tgA1SA5R8=; b=elIisGb9ckqelq+Ahvy8/bXccfNW2V3tW
	IoTPzQN3N1yUY0hSCWVy5QgvPdNC8Mr0hpNfzw1iWjRtb+4YRVbUrtPeNDEfAHVp
	kKOJRjHeUSsg8cHMLlMLwwgXLaY91fw3pvdUt0E5zpcqyByyNpLEWL9CFONw/n7I
	qhBBrGWX2zgYJSsNy42rQCddjsAU+TfFDY7xlx8P3cw7Kitox7CvXlrVoZb3lSFv
	rw9jKDR+ahN60qxzmUJ0uFGvJ37J5WulNdCHo8gASaPb3rb/w03FGgchWPx0IrwF
	H6/YugefLptBW72KJwNiy2ltojU/aS/ZPe/DGxWn1EH9bOYxgociw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43wq0289y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jan 2025 09:46:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5024h4S9016661;
	Thu, 2 Jan 2025 09:46:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43tw5khfkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jan 2025 09:46:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5029kHCo56820028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Jan 2025 09:46:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9435E2004D;
	Thu,  2 Jan 2025 09:46:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45A632004E;
	Thu,  2 Jan 2025 09:46:17 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.11.208])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Jan 2025 09:46:17 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v9 3/3] s390/crypto: Enable phmac selftest invocation
Date: Thu,  2 Jan 2025 10:46:15 +0100
Message-ID: <20250102094615.99181-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250102094615.99181-1-freude@linux.ibm.com>
References: <20250102094615.99181-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N1uPCkdJ-g5x-CIGgkfSkC5L1aBFAFU8
X-Proofpoint-GUID: N1uPCkdJ-g5x-CIGgkfSkC5L1aBFAFU8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501020081

- Add a little helper inline function
    crypto_tfm_alg_get_flags()
  to crypto.h to retrieve the alg flags.
- Add key preparation code in case of selftest running
  to the phmac setkey function.
- Add phmac selftest invocation to the crypto testmanager.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/crypto/phmac_s390.c | 144 ++++++++++++++++++++++++++++++++--
 crypto/testmgr.c              |  30 +++++++
 include/linux/crypto.h        |   5 ++
 3 files changed, 174 insertions(+), 5 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index b2b389e94a37..3d80168775ab 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -112,6 +112,19 @@ struct s390_phmac_req_ctx {
 	struct s390_kmac_sha2_ctx sha2_ctx;
 };
 
+/*
+ * Pkey 'token' struct used to derive a protected key value from a clear key.
+ */
+struct hmac_clrkey_token {
+	u8  type;
+	u8  res0[3];
+	u8  version;
+	u8  res1[3];
+	u32 keytype;
+	u32 len;
+	u8 key[];
+} __packed;
+
 /*
  * kmac_sha2_set_imbl - sets the input message bit-length based on the blocksize
  */
@@ -132,6 +145,101 @@ static inline void kmac_sha2_set_imbl(u8 *param, unsigned int buflen,
 	}
 }
 
+static int hash_key(const u8 *in, unsigned int inlen,
+		    u8 *digest, unsigned int digestsize)
+{
+	unsigned long func;
+	union {
+		struct sha256_paramblock {
+			u32 h[8];
+			u64 mbl;
+		} sha256;
+		struct sha512_paramblock {
+			u64 h[8];
+			u128 mbl;
+		} sha512;
+	} __packed param;
+
+#define PARAM_INIT(x, y, z)		   \
+	param.sha##x.h[0] = SHA##y ## _H0; \
+	param.sha##x.h[1] = SHA##y ## _H1; \
+	param.sha##x.h[2] = SHA##y ## _H2; \
+	param.sha##x.h[3] = SHA##y ## _H3; \
+	param.sha##x.h[4] = SHA##y ## _H4; \
+	param.sha##x.h[5] = SHA##y ## _H5; \
+	param.sha##x.h[6] = SHA##y ## _H6; \
+	param.sha##x.h[7] = SHA##y ## _H7; \
+	param.sha##x.mbl = (z)
+
+	switch (digestsize) {
+	case SHA224_DIGEST_SIZE:
+		func = CPACF_KLMD_SHA_256;
+		PARAM_INIT(256, 224, inlen * 8);
+		break;
+	case SHA256_DIGEST_SIZE:
+		func = CPACF_KLMD_SHA_256;
+		PARAM_INIT(256, 256, inlen * 8);
+		break;
+	case SHA384_DIGEST_SIZE:
+		func = CPACF_KLMD_SHA_512;
+		PARAM_INIT(512, 384, inlen * 8);
+		break;
+	case SHA512_DIGEST_SIZE:
+		func = CPACF_KLMD_SHA_512;
+		PARAM_INIT(512, 512, inlen * 8);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+#undef PARAM_INIT
+
+	cpacf_klmd(func, &param, in, inlen);
+
+	memcpy(digest, &param, digestsize);
+
+	return 0;
+}
+
+/*
+ * make_clrkey_token() - wrap the clear key into a pkey clearkey token.
+ */
+static inline int make_clrkey_token(const u8 *clrkey, size_t clrkeylen,
+				    unsigned int digestsize, u8 *dest)
+{
+	struct hmac_clrkey_token *token = (struct hmac_clrkey_token *)dest;
+	unsigned int blocksize;
+	int rc;
+
+	token->type = 0x00;
+	token->version = 0x02;
+	switch (digestsize) {
+	case SHA224_DIGEST_SIZE:
+	case SHA256_DIGEST_SIZE:
+		token->keytype = PKEY_KEYTYPE_HMAC_512;
+		blocksize = 64;
+		break;
+	case SHA384_DIGEST_SIZE:
+	case SHA512_DIGEST_SIZE:
+		token->keytype = PKEY_KEYTYPE_HMAC_1024;
+		blocksize = 128;
+		break;
+	default:
+		return -EINVAL;
+	}
+	token->len = blocksize;
+
+	if (clrkeylen > blocksize) {
+		rc = hash_key(clrkey, clrkeylen, token->key, digestsize);
+		if (rc)
+			return rc;
+	} else {
+		memcpy(token->key, clrkey, clrkeylen);
+	}
+
+	return 0;
+}
+
 /*
  * Convert the raw key material into a protected key via PKEY api.
  * This function may sleep - don't call in non-sleeping context.
@@ -680,6 +788,10 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
 			     const u8 *key, unsigned int keylen)
 {
 	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+	struct crypto_tfm *tfm_base = crypto_ahash_tfm(tfm);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	int rc = 0;
 
 	if (tfm_ctx->keylen) {
 		kfree_sensitive(tfm_ctx->key);
@@ -687,10 +799,26 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
 		tfm_ctx->keylen = 0;
 	}
 
-	tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
-	if (!tfm_ctx->key)
-		return -ENOMEM;
-	tfm_ctx->keylen = keylen;
+	if (crypto_tfm_alg_get_flags(tfm_base) & CRYPTO_ALG_TESTED) {
+		/* no selftest: key is always a key token digestable by PKEY */
+		tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
+		if (!tfm_ctx->key) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		tfm_ctx->keylen = keylen;
+	} else {
+		/* selftest running: key is a raw hmac clear key */
+		tfm_ctx->keylen = sizeof(struct hmac_clrkey_token) + bs;
+		tfm_ctx->key = kzalloc(tfm_ctx->keylen, GFP_ATOMIC);
+		if (!tfm_ctx->key) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc = make_clrkey_token(key, keylen, ds, tfm_ctx->key);
+		if (rc)
+			goto out;
+	}
 
 	/* Always trigger an asynch key convert */
 	spin_lock_bh(&tfm_ctx->pk_lock);
@@ -698,8 +826,9 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
 	spin_unlock_bh(&tfm_ctx->pk_lock);
 	schedule_delayed_work(&tfm_ctx->work, 0);
 
+out:
 	pr_debug("rc=0\n");
-	return 0;
+	return rc;
 }
 
 static int s390_phmac_import(struct ahash_request *req, const void *in)
@@ -816,6 +945,11 @@ static int __init phmac_s390_init(void)
 	struct s390_hmac_alg *hmac;
 	int i, rc = -ENODEV;
 
+	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_256))
+		return -ENODEV;
+	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_512))
+		return -ENODEV;
+
 	for (i = 0; i < ARRAY_SIZE(s390_hmac_algs); i++) {
 		hmac = &s390_hmac_algs[i];
 		if (!cpacf_query_func(CPACF_KMAC, hmac->fc))
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f5f48ab18c7..e753a68be861 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5539,6 +5539,36 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.cipher = __VECS(fcrypt_pcbc_tv_template)
 		}
 	}, {
+#if IS_ENABLED(CONFIG_CRYPTO_PHMAC_S390)
+		.alg = "phmac(sha224)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha224_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha256)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha256_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha384)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha384_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha512)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha512_tv_template)
+		}
+	}, {
+#endif
 		.alg = "pkcs1(rsa,none)",
 		.test = alg_test_sig,
 		.suite = {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b164da5e129e..8b37d381cd97 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -472,6 +472,11 @@ static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_alignmask;
 }
 
+static inline u32 crypto_tfm_alg_get_flags(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags;
+}
+
 static inline u32 crypto_tfm_get_flags(struct crypto_tfm *tfm)
 {
 	return tfm->crt_flags;
-- 
2.43.0

