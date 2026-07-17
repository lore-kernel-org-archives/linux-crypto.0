Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CB142F714
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303650; cv=none; b=bwBYSqeFEQWFEm8ziqBtEjGU5Lfz63vKpJMCtKVOVqhamKv+SnwIxyU2M+KAGcZY/e7DSjTlS+vkzTriU4QRn/rPikmuliy2+6naPvfERozYl+Yyzlk1wWs4MAISMqFWVVMhHlOXuWyjHte5daaPWOWnQ6mgUnYkRVc57vwqjgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303650; c=relaxed/simple;
	bh=kG6GqPZEp+/IdHwaQrSkJh60hQWBLC9WceMGchytKzc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=njRTK1udslOpFNb/Bw0pfR1HPmaLrsgYS+ZKiQF3K65oSej7xXNeEfLk+Atj1F0F49HDgXbD5gt5bBcZGN5XyD+9IJkpOys2loq8HIVleHP7OIcdLdNu2xZa5Jsi5C0IPNB3u/IqWDsxsdpxvP10llJ5DGDQDUZ4SZnzr+W7nKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E2UQt0Fq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z5e3KwUe; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E2UQt0Fq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z5e3KwUe"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HFDC2L2126828
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BqAU3pbCskzec+/3Vw5PoL3sZolu37KpVmkDZNMLwlY=; b=E2UQt0FqU/dQl+3D
	mtlw5N1pMJ6qXmP9V24GqtMKZ7qm2mGkT0j6+u4hbHyas+SbY6niNDj+BMEVA/zJ
	lOz5yJTcFnOgORGzdZgtPfbZ1K0o8UVNc35r0DcNEbfA07WcSBvuE8rPlfAUrB1d
	yvHHq1WO2uONpp4yUyQyAogcGgw4TOHHOE0N8RHatOQeqtz4RxIE8mWgo79WrBBH
	v3XXYILHDqmkwLvKuxo02QNWuAgzNUY389/r8HJS1n0chMAS7ZpR0CdqnUKoalDZ
	X1i7Na/hb/n43g6m7ZiQcT76ZvRqaSh++Q4zft7vOIJiaEsBTfEPiIsPRoKpAjwx
	2y5/Yw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffpug05he-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:07 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c26012cd0so137722541cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784303647; x=1784908447; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BqAU3pbCskzec+/3Vw5PoL3sZolu37KpVmkDZNMLwlY=;
        b=Z5e3KwUe/nCkETaxxpmkArDXw91N27DzXLEvTLNqj4PPATUgsghjB3Ij4ZjX1LFrfX
         uKCzvStGS0HOJoetGStvBZdKNcnA5lAVqw5Ioe2xMUCIBMfc/E95iCKgeuwQsQRQ06w9
         4iaSTEhPOqsIlHjuwY24kBSfU0eTbr6hx4nyu3zmPXwd44OYemu8x6b5Lb5csL5+wm7h
         WN54TWuoKVIb3YBajJ1soy0RTQP+pIPVDsOgTMm11ammNwvz2ddtMzsoauclJ2Dsk3gz
         1bFvuwY+2tIikDoh/n4b4mItkin9jObZHq3Ov+ySpfFZ2UTwL7bTq+XEzfV2l5g2MK4H
         EhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784303647; x=1784908447;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BqAU3pbCskzec+/3Vw5PoL3sZolu37KpVmkDZNMLwlY=;
        b=IZElg8x+HX4ddESZ3w4MFHWoXn31h056v1M3umowVdYkfUZyzj3QNzSWTT7e/p6Oxi
         ksmek+FoJiwPEgS3OTsEHfXy5N7Y+CNElF+048OHHan3p5nz35PicTpBIwtskaoqENpj
         HrGeqg5DTl7I6bkgYNlHVkDoYRL0PF1XyhL+gxCyLZdNKFODzNBG+xZ10mZ7kc34l6yt
         Lihe5yclp+IZW7yjtdq+FjxhAAwNv1W20X0M6A7cc24wN9AfRtR8oGXd+jx3a9mbrQHf
         0DjBG9gapKH+xwzVeWTanGne1GxgIV3VuXgwCvse0GivQXisE+Nu81PlLCwACnR9Uy6y
         /y0Q==
X-Gm-Message-State: AOJu0YwVRgM3UHfMlidHPz2XzCu9xWOSmLMIVV3bJ0Rpn6BmV2VQv4dr
	hemgcsYpWdi+tgv0u3v83Ac31+Szopmq07TQmolzEBpD8ClaT+UAmVBXz4ZK6B171hOMkkyt1RA
	ARW9Yq8QEVcER59rnCc9JvrSUxkHEpcpFZNwvbm+Haw8vGS1pCSTRLIHVzARkxwX0o0O/cbB4bD
	U=
X-Gm-Gg: AfdE7clsuuzm0lvJTkCHuCczzH1nbEuZgLCF6gp8G24aBm8awrPHXlPX2v0vvtAc0Vy
	YdDOADxqw1eLKsR0wmRtSIUuy3VOhwyi2sxdzHTYThPsObXo+ezAO3oHDZhCur3qGzYLpdas6LR
	2rs2YPEEWb1jTuhhPJ8SjTowPrRqWmTd+pwgryAqCVM608v1noNSjY+XOt0p4MQtqpkLx/2UGEk
	ngZzYxlhTRxV3P2aJSHNvnF81lGrSjt4VW1JfOvsb08dkhAohmH46STCmRsux4AI+VL/p052pk2
	y5NaDOaXNYCsLcx0ip2oGDro4aph2OeApvFay8jj8qk2g7mNuzciV0mTsCNLp6xuv5/VWwUQPRv
	DapQd6aflqNJmINjtg+OkRcvY2K/owA==
X-Received: by 2002:ac8:59d4:0:b0:51b:ff45:bc82 with SMTP id d75a77b69052e-5213daa1d49mr29753671cf.54.1784303646762;
        Fri, 17 Jul 2026 08:54:06 -0700 (PDT)
X-Received: by 2002:ac8:59d4:0:b0:51b:ff45:bc82 with SMTP id d75a77b69052e-5213daa1d49mr29753311cf.54.1784303646252;
        Fri, 17 Jul 2026 08:54:06 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a2511sm47057095e9.1.2026.07.17.08.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:54:05 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 17:53:35 +0200
Subject: [PATCH v6 6/8] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qce-fix-self-tests-v6-6-455775fe5f6c@oss.qualcomm.com>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
In-Reply-To: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4152;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=aSgSggZNKFSkUSCkcp8Nh3YxGdWoKOMXm3+FN8YtSM8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWlANcIan0mYcl0bQ36zNm+24DZ6d1E7cMzGcL
 ZDK/XMAHHGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalpQDQAKCRAFnS7L/zaE
 w2lqEACVEKuAW9MOhdKzseFGSfB4mdWmYLoKC43REEe5ZxmHmHDJwCHxbqMzCMGFsF+WrYYstjw
 syeUn2+jyIPlp7r7KAZ0/afkO+nj7If/KqiwpCivbphzw2HNg9Xk4oDtUFs9CgjC2wssHK9ql0F
 5KLVjqe52fEvGm8u0jzo5KhmEK5xbVDzIdjpDDpgNNU4Vhk+g5rQLSNt52g7g895PMLvPxaXW8X
 DaC6P7UhJ20arNUBKNDgSfJOpVpHVEfBSU3T7Z96Y8NRy5Pvc+Zuajzk7RrMM8ed4eDcRpz6IYH
 HKh7f2kvAi00YRE+qB6924GA8GbMyWBMqD9B34thzYqVJh+qW05bd2tEhVHJEEYiyEWjpIQS/4G
 WYmr4mjGcLv+g2y7GXWd3i2nJnXhH7R6fKSfXzO6ygrM0E7/aRVI5JUFVr5nBiNY7RgLifxKSdm
 BDrwE3c6GPgh62UiwSUpvkUPIhGDcNXizuUVlVbUrpnGakA0nfHphzN7K7Yrjle8tQUcz4H4hhj
 iM8EtdkiKOHbspetzwiodpDagLPPjuuE7Iyvrd26Lf8kAumuyfTcelBmHdZeRNh0n8mHevw5z7X
 0aWXLaaDECOgg5F3QU4f2CJk4EhBaxHhYLDfPV8jJtzMFzvAHUiMTNd6eqVpREfFLVnQLdkmltn
 QIKTQwmlTiu0ycw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX0M3Pku8IxrDk
 aIl4rEvCGYJPwsNACUsnvO1piffApMNvE0s3cGJqp+VHITZvvjZIjZRECPnhCbZJXtNn21u2+Ki
 VjQhQMinSdZHsYkefy8V2bzUOwjOnrPoyCrRtDH2UZQbXBQz4Zo8kEX/VVISPfcaPT2SQSa7vCF
 UaSrxyMiSsHm/XNQUuo47R5R/k42cZubWQ7ftMYVq0XNd/apfrF7wfdwi/X01rCazNG37Nlchw/
 5J2kJ7u5ndKnbsFvR5AOHrNpcXhWOCY1/R+pZ0G8ZeXAL5AnSeebOuQEDbbYXwpCBlp4o+PWlDX
 7U2/wG45BP7S7uD+YqK1L1eQiQv6P9gHRSn0/6cBMsgcWvCfDx2QMj3s6aSJIQYGu0drebIGb6d
 KSz89Jk4OaX9OjBQUMM6i+kJbhT7X9fNAt8HyZDc1pObb936h/1z74TpuT/68l+5xED37haE+LH
 tSiGABJvCvIXEZ54xog==
X-Proofpoint-GUID: Aw1Md9YqC6-A9BGdzhcM7KVzwZTCL7WS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX6clO3lM6F1Sv
 Kb1IQWWic0/5CbGAr9N2Dn/21JD6h7siYpJkhoIrUuoWKHy9lkaMHKRJkR7yvweTa664B/eZdb3
 3vkMrV8QgRNl1w8/dNSeGoDDTrNYUyw=
X-Proofpoint-ORIG-GUID: Aw1Md9YqC6-A9BGdzhcM7KVzwZTCL7WS
X-Authority-Analysis: v=2.4 cv=Q63iJY2a c=1 sm=1 tr=0 ts=6a5a501f cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=tpKvEUOkdOp8HkJiz7sA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170162

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

The QCE hardware does not support AES XTS mode when key1 and key2 are
equal. The driver was handling this by unconditionally rejecting the
keys with -ENOKEY(-126), regardless of whether FIPS mode is active or
the FORBID_WEAK_KEYS flag is set.
[    5.599170] alg: skcipher: xts-aes-qce setkey failed on test vector 0; expected_error=0, actual_error=-126, flags=0x1
[    5.599184] alg: self-tests for xts(aes) using xts-aes-qce failed (rc=-126)

In general for weak keys,
- If FIPS mode is active or FORBID_WEAK_KEYS is set: return -EINVAL.
- In non-FIPS mode, Accept the key and encrypt successfully.

Since QCE was returning -ENOKEY for non-FIPS mode whereas the
expectation is to encrypt content and return success, the selftest saw a
mismatch and failed.

There are two problems in QCE behavior:
  * -ENOKEY is returned instead of -EINVAL for the FIPS/weak-key
    rejection case.
  * key1 == key2 is rejected even in non-FIPS mode

Fix xts-aes-qce behavior by using generic helper xts_verify_key() to
reject keys early with -EINVAL for FIPS mode active(or FORBID_WEAK_KEYS
set). For non-FIPS mode, since QCE hardware cannot accept the keys, use
software fallback mechanism to encrypt the data.

Cc: stable@vger.kernel.org
Fixes: f0d078dd6c49 ("crypto: qce - Return unsupported if key1 and key 2 are same for AES XTS algorithm")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/cipher.h   |  1 +
 drivers/crypto/qce/skcipher.c | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index 850f257d00f3aca0397adc1f703aea690c754d60..daea07551118d444d2f749588bdfe2ae2c6c553f 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -14,6 +14,7 @@
 struct qce_cipher_ctx {
 	u8 enc_key[QCE_MAX_KEY_SIZE];
 	unsigned int enc_keylen;
+	bool use_fallback;
 	struct crypto_skcipher *fallback;
 };
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 4779218d4f33a07331c510abf0d6d23e7e70d102..3df583b1a56ec371e556fd00e7930d9fc4447ce0 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <crypto/aes.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/xts.h>
 
 #include "cipher.h"
 
@@ -194,14 +195,17 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 	if (!key || !keylen)
 		return -EINVAL;
 
-	/*
-	 * AES XTS key1 = key2 not supported by crypto engine.
-	 * Revisit to request a fallback cipher in this case.
-	 */
 	if (IS_XTS(flags)) {
+		ret = xts_verify_key(ablk, key, keylen);
+		if (ret)
+			return ret;
 		__keylen = keylen >> 1;
-		if (!memcmp(key, key + __keylen, __keylen))
-			return -ENOKEY;
+		/*
+		 * QCE does not support key1 == key2 for XTS.
+		 * Use fallback cipher in this case.
+		 */
+		ctx->use_fallback = !crypto_memneq(key, key + __keylen,
+						       __keylen);
 	} else {
 		__keylen = keylen;
 	}
@@ -262,6 +266,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * AES-XTS with key1 == key2 (not supported by the CE).
 	 * A payload fragmented across more than one scatterlist entry (the CE
 	 * stalls waiting for input in that case too).
 	 */
@@ -271,6 +276,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
 	    req->cryptlen % QCE_SECTOR_SIZE))) ||
+	    (IS_XTS(rctx->flags) && ctx->use_fallback) ||
 	    sg_nents_for_len(req->src, req->cryptlen) > 1 ||
 	    sg_nents_for_len(req->dst, req->cryptlen) > 1)) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);

-- 
2.47.3

