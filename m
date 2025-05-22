Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD08262FEA;
	Thu, 22 May 2025 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904286; cv=none; b=XYgvgxX2B2HdjmMrONEEZ15pIFfp1EseNLQFzM29sXIq8acEdKD1dYjUjY7E9DmGonlf6IRSnFnIc7MOh+S9OHSVnRZVdL3qzfFMmEXuv4bTr19Y3ZDDvYs1UltChCa5g1aUTEGb8jpTclg0tlvSmdw/F8ea6TmGBseRFCn8lUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904286; c=relaxed/simple;
	bh=5nFrjSaqinwvz6Wtj2wnI+yFguXhehoeoaBZrAenYy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTXZeymlSj84kZUuKZ0QFZ1zBR2zJngLtNpY0iyk1Teie+u5pOsx+aU6Dg2WTNtS6yR2dPFF2IJKxIm6GnHdAzet/OO9Pdv/UgD9gEtKtk1eifT7J80rsH3CJUtDq21AoIPZKr1h6nyYAmO3yMF9s5abmT3GeByjgJ9EKf6IVsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TBZ+US2z; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TBZ+US2z"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M8pVKI002866;
	Thu, 22 May 2025 08:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/hUdsTS5zZH4lKrBw
	1ENmF1NgxrO+AECDGrtEbVdXVY=; b=TBZ+US2zB9gfiaJCH/tkZ7eu8Amm9Q4Bn
	WNB2LGjamwYbEvjDWNXpuPjS61ibfcIWrSCGMSo5+D4TuOQr4R9QFaKho3mtpT4L
	PBnEP0gxUmeXQMc+bm8vxLQMlMZsNjLa8WtYk5YhSGNm7xvQO7eTRLld6R3U2F1G
	FkROQOjhCScpMxNBnIDvyw0hl7ghT8SJRW1jkfDz0ZQwEHXNT/4HlYpCQI8Fqmep
	dXhGLOIUbOlQz+FUSQOzMNtCEZ5eHLjuN62GE2yu//ti4xEkiKFm1wzos1ITO7vn
	rdycL8sCDJ9lb0pTp/TztHabWaasUAQdJQxITp/+byHJineuCNlyA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t0sjg0w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5IxNd031977;
	Thu, 22 May 2025 08:58:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwmq8nyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M8vva028443134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:57:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D53020040;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20D5820043;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: [PATCH v11 5/6] s390/crypto: Add selftest support for phmac
Date: Thu, 22 May 2025 10:57:54 +0200
Message-ID: <20250522085755.40732-6-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250522085755.40732-1-freude@linux.ibm.com>
References: <20250522085755.40732-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfX9z3+0dg0oFF2 +s6m1VJjuXjsWbYyqxcl/hm8+MRCGaVL7X64I5cTJfQYz/V9pouezW159YyB7jLceexDyBtEOME /nsMXhfK2k9VCyTQSuURACF195Sb/O0plqdfByX88uHMjAEwDG5xaVXlJa8Vc5eRDpQaKBpYvsq
 5E7qqFr0POap9lQIRTimBEmd6oluZ93jhSLD0fTn1lpL0WZ9FsUuDD1cPxXUDVY4EbdClfxthNe oPeopqI8ERbbQq39y+Q+Swyeiiv/6ZdhhPmqIAjdNzwMl6v8Ckyvm46W5bwoOvhztqBlO5UEFdL MOoQj3CUu/1WJ/KtQ8eD0/3SRYqVMHMCJz+5tStmnf/c27xn9XXoCIvVknzR2pLtOI84zDcU4Tc
 oXR/1TXUm6MqRIFOJPJEAanE+lDULM81FYIRu4GREzexJfQXyBTZhers+X/tdwVvaJvNd5vl
X-Proofpoint-GUID: QaM-n7jYmux_5ma-wf-dxld5sXDg95Ap
X-Proofpoint-ORIG-GUID: QaM-n7jYmux_5ma-wf-dxld5sXDg95Ap
X-Authority-Analysis: v=2.4 cv=HcAUTjE8 c=1 sm=1 tr=0 ts=682ee71a cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=yASr4jyFyl_JLoGKBVkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220086

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
 arch/s390/crypto/phmac_s390.c | 143 ++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index b61454dedf0a..b1ca1fcbb927 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -176,6 +176,114 @@ struct phmac_req_ctx {
 	bool final;
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
  * phmac_tfm_ctx_setkey() - Set key value into tfm context, maybe construct
  * a clear key token digestible by pkey from a clear key value.
@@ -616,9 +724,32 @@ static int phmac_setkey(struct crypto_ahash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+	struct crypto_tfm *tfm_base = crypto_ahash_tfm(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int tmpkeylen;
+	u8 *tmpkey = NULL;
 	int rc = 0;
 
+	if (!(crypto_tfm_alg_get_flags(tfm_base) & CRYPTO_ALG_TESTED)) {
+		/*
+		 * selftest running: key is a raw hmac clear key and needs
+		 * to get embedded into a 'clear key token' in order to have
+		 * it correctly processed by the pkey module.
+		 */
+		tmpkeylen = sizeof(struct hmac_clrkey_token) + bs;
+		tmpkey = kzalloc(tmpkeylen, GFP_KERNEL);
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
 	/* copy raw key into tfm context */
 	rc = phmac_tfm_ctx_setkey(tfm_ctx, key, keylen);
 	if (rc)
@@ -661,6 +792,7 @@ static int phmac_setkey(struct crypto_ahash *tfm,
 	}
 
 out:
+	kfree(tmpkey);
 	pr_debug("rc=%d\n", rc);
 	return rc;
 }
@@ -854,6 +986,17 @@ static int __init s390_phmac_init(void)
 	struct phmac_alg *phmac;
 	int i, rc;
 
+	/* for selftest cpacf klmd subfunction is needed */
+	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_256))
+		return -ENODEV;
+	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_512))
+		return -ENODEV;
+
+	/* register a simple phmac pseudo misc device */
+	rc = misc_register(&phmac_dev);
+	if (rc)
+		return rc;
+
 	/* with this pseudo device alloc and start a crypto engine */
 	phmac_crypto_engine =
 		crypto_engine_alloc_init_and_set(phmac_dev.this_device,
-- 
2.43.0

