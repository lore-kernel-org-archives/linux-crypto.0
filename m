Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92982E06DE;
	Tue, 17 Jun 2025 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167892; cv=none; b=Wa9OSORk22C4xPDbl21BkmqFDlHfas1of5VS+kVAY19SbZV5MGeuQQad22fx3UP1l+ZTffx2FvDPzQ4t/Hc6UrOLRZHjVt2c/BBywKhepyThhDkPogYiKvmUHGln4QIGQRWCQRWlplh/3MupdJ4GiGH54+NkZImwgEwGNK3C1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167892; c=relaxed/simple;
	bh=pYge/XjA7thdWFumeNsmtHe7qt5ghqwoyC/uE5uVxY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRE5vFh6zOIAPkS5FjU0zoML0AWRPFRiAKj05/pJI/yVO+/93stM0ZShMWzjl4Jtelo8lNVAQZnXGM1bv5gjl0dfgbjOdQJuVojOIGCjQ0iSTBUQBpXxU9ZtQhd2F1FzVH5COCoeUuOl4y1DsMXClv6RkRM2KOpUSDAEZxrsMN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YmIl+dIM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YmIl+dIM"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H4S209026479;
	Tue, 17 Jun 2025 13:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iYgLU9BHwa12zUhJH
	da5ks7Vsb48Q176HJG3sXv6Who=; b=YmIl+dIM2LQhh9LmxgqoKr2tuAtVr8iwr
	/nwaRAnG1XF3i3PPpXCgYUERX3gzr65G5WBIzqt7fSkjyDzQp030TcD96zmxnmtI
	ukgB/JfN1NOkXP+lxRzvlAfonufbxFy3ThMm11dOPzcimEj7pqb0YJGBxJ09wkGY
	CtPHeQWz80WEWpSnV07WMnJ1RTPdAAn0cqP5pAfGhmEtKckdlpfY7ZMY37KSOxiu
	h3FP0hUpgQ9jk9nPBgfOT7W4IEehEuv3PhhlfQlwJg/MhIdbONV4lMfIG1zAqaZk
	N+HxIfTlLPwxn/r9fpeR4hLThOnVGBSaStsqW8/nFoAxMNpBP68Qw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r206ut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55HD1mVZ025804;
	Tue, 17 Jun 2025 13:44:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 479xy5sug4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55HDihFU37486994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 13:44:43 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7918B2004B;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2585020043;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.71.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v12 5/6] s390/crypto: Add selftest support for phmac
Date: Tue, 17 Jun 2025 15:44:39 +0200
Message-ID: <20250617134440.48000-6-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aQxc30kKaHdSNapx1KTpUjSr_lEldVLW
X-Proofpoint-ORIG-GUID: aQxc30kKaHdSNapx1KTpUjSr_lEldVLW
X-Authority-Analysis: v=2.4 cv=AqTu3P9P c=1 sm=1 tr=0 ts=68517150 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=yASr4jyFyl_JLoGKBVkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDEwNSBTYWx0ZWRfX2n2ueEpsCqer VmJlAAasW0zxe5a+8ARR4grvAMv2E0qwjDOuE3pUvbj3fVm1tF+ZIOa/+fs2R1qOOdy92RMX1Vn akxwnyIChw5U9qhiBw1Ul+HaAF2BlNJjDPdtr2IgTiufYfTeYgDT20ciTSeTFLueSIzIuvz8rbA
 DtlX6RQWUqSo9NOGX35WQWZbH0kekDkzwbQLaz4c+HQRf8Tm/ltCg1v49vs7VnOYDRvSgcBgSlL HDBP4ZPV6cdNXhdFHcV2ZVXy+axZ5V/q08JVdy8YaFbrPPDMtRZ0RC5ksq21tM9thFOBZ8ubzJG /HiOCEbFypn1pavhvQWjzElcB2OdZNRThdDagPQxrgjgKhUlGEBbCBXAztOGiovp6cBq6qDegus
 8WCsq8q6wsw/av4cMDiv1H0eEx6xGtwccyTwGO4yZI+wR/DYGtlJroxVU6y9rrAE2q3RdEa9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170105

Add key preparation code in case of selftest running to the phmac
setkey function:

As long as crypto_ahash_tested() returns with false, all setkey()
invocations are assumed to carry sheer hmac clear key values and thus
need some preparation to work with the phmac implementation. Thus it
is possible to use the already available hmac test vectors implemented
in the testmanager to test the phmac code.

When crypto_ahash_tested() returns true (that is after larval state)
the phmac code assumes the key material is a blob digestible by the
pkey kernel module which converts the blob into a working key for the
phmac code.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
---
 arch/s390/crypto/phmac_s390.c | 137 ++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 8473af47f5b9..90602f72108f 100644
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
@@ -623,8 +731,30 @@ static int phmac_setkey(struct crypto_ahash *tfm,
 {
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int tmpkeylen;
+	u8 *tmpkey = NULL;
 	int rc = 0;
 
+	if (!crypto_ahash_tested(tfm)) {
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
@@ -667,6 +797,7 @@ static int phmac_setkey(struct crypto_ahash *tfm,
 	}
 
 out:
+	kfree(tmpkey);
 	pr_debug("rc=%d\n", rc);
 	return rc;
 }
@@ -861,6 +992,12 @@ static int __init s390_phmac_init(void)
 	struct phmac_alg *phmac;
 	int i, rc;
 
+	/* for selftest cpacf klmd subfunction is needed */
+	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_256))
+		return -ENODEV;
+	if (!cpacf_query_func(CPACF_KLMD, CPACF_KLMD_SHA_512))
+		return -ENODEV;
+
 	/* register a simple phmac pseudo misc device */
 	rc = misc_register(&phmac_dev);
 	if (rc)
-- 
2.43.0

