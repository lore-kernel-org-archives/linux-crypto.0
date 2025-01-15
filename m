Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534F2158DC6;
	Wed, 15 Jan 2025 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736958162; cv=none; b=ezC2d2QlvBxKn5aX11bN7BZzlPsZ+WxH8/iNccON139XrwMroUHyLHJt8kvA3hewibT4qBrROE14Bl5GNlfwZdsm/LDuY3XVGdl8YMqNb+Gz5sZmg/zpgQHEekbkNg51Q+YyZL82elRid7Ao57Z9e034UrN278PC0DNAqp38i2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736958162; c=relaxed/simple;
	bh=p5ZpTr4sbDrte3PsdrsB3cROgFOE+iMcJSrgT+WCXsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAGi/cUIyPipAYCal5f7yhkkdDp4Nm8OXXPLbG0lkMbb2dVfuq0jKNFS7B7wFyS3mh1VpzONF/ODtqBRKA3OX6WFVPGGCoa94l7zL2EiT8se15QgJJkFikx3wCejfLdLtY6FM1cUAxTd6OvgWq6bQoa3zpDuTyl8tBVOxKmlqxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fM9zID86; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fM9zID86"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FGK9CG020367;
	Wed, 15 Jan 2025 16:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bNHWQSMCBCudm6w0E
	4mZexLnvtJzgLOtBCMsqtokzhw=; b=fM9zID865EYJkbj9lcYeEsv/57J+eg3sJ
	MLVcZlMObo5Gbd93a9Z35NxpXP9nxYRuBVhrJnN+sjWNUVwdsMzMDALrk6TSMuCJ
	ou06Ri+Ms0MOndRBXlwx6tAGBaIzMns6ff3hXB4+vGJHovNzQpiYfFuuDHj7kdv4
	SL67VrGsHDio6ayPokvpNl6hgN+whZX/IoXJYGT01SuOYFcjtXYrwGRVCTPwx0XM
	8nWzT3PQqP28Ay5AigN8n10hpPr7tT1oOitYrKehLVSbdT1A+bEYkq4CQccqnZCc
	iduMyMkS6cffvS4ARKk5bnMjCB+BY1D87t/o4fo2P9ZY1KdOIzYOA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4461rbkwkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FEscFq017003;
	Wed, 15 Jan 2025 16:22:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fk965f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 16:22:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FGMXxo29950386
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 16:22:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBA9E20040;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 874AE2004B;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.28.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Jan 2025 16:22:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v10 4/5] s390/crypto: Add selftest support for phmac
Date: Wed, 15 Jan 2025 17:22:30 +0100
Message-ID: <20250115162231.83516-5-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250115162231.83516-1-freude@linux.ibm.com>
References: <20250115162231.83516-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZbsM7EgdYrY07bYnSMx7lZSbDx7MIIS6
X-Proofpoint-GUID: ZbsM7EgdYrY07bYnSMx7lZSbDx7MIIS6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_07,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501150119

Add key preparation code in case of selftest running to the phmac
setkey function:

As long as the CRYPTO_ALG_TESTED flag is not set, all setkey()
invocations are assumed to carry sheer hmac clear key values and thus
need some preparation to work with the phmac implementation. Thus it
is possible to use the already available hmac test vectors implemented
in the testmanager to test the phmac code.

When the CRYPTO_ALG_TESTED flag is set (after larval state) the phmac
code assumes the key material is a blob digestible by the pkey kernel
module which converts the blob into a working key for the phmac code.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/crypto/phmac_s390.c | 151 +++++++++++++++++++++++++++++++++-
 1 file changed, 147 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index b2b389e94a37..5123664e4d2e 100644
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
@@ -680,6 +788,12 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
 			     const u8 *key, unsigned int keylen)
 {
 	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+	struct crypto_tfm *tfm_base = crypto_ahash_tfm(tfm);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int tmpkeylen;
+	u8 *tmpkey = NULL;
+	int rc = 0;
 
 	if (tfm_ctx->keylen) {
 		kfree_sensitive(tfm_ctx->key);
@@ -687,9 +801,31 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
 		tfm_ctx->keylen = 0;
 	}
 
+	if (!(crypto_tfm_alg_get_flags(tfm_base) & CRYPTO_ALG_TESTED)) {
+		/*
+		 * selftest running: key is a raw hmac clear key and needs
+		 * to get embedded into a 'clear key token' in order to have
+		 * it correctly processed by the pkey module.
+		 */
+		tmpkeylen = sizeof(struct hmac_clrkey_token) + bs;
+		tmpkey = kzalloc(tmpkeylen, GFP_ATOMIC);
+		if (!tmpkey) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc = make_clrkey_token(key, keylen, ds, tmpkey);
+		if (rc)
+			goto out;
+		keylen = tmpkeylen;
+		key = tmpkey;
+	}
+
+	/* key is always a key token digestable by PKEY */
 	tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
-	if (!tfm_ctx->key)
-		return -ENOMEM;
+	if (!tfm_ctx->key) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	tfm_ctx->keylen = keylen;
 
 	/* Always trigger an asynch key convert */
@@ -698,8 +834,10 @@ static int s390_phmac_setkey(struct crypto_ahash *tfm,
 	spin_unlock_bh(&tfm_ctx->pk_lock);
 	schedule_delayed_work(&tfm_ctx->work, 0);
 
-	pr_debug("rc=0\n");
-	return 0;
+out:
+	kfree(tmpkey);
+	pr_debug("rc=%d\n", rc);
+	return rc;
 }
 
 static int s390_phmac_import(struct ahash_request *req, const void *in)
@@ -816,6 +954,11 @@ static int __init phmac_s390_init(void)
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
-- 
2.43.0

