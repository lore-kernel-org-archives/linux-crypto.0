Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46143B5837
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782134327; cv=none; b=OPD8SSXp5QbPfX4ION+0sAHCmTsASiPkckz6z5kjO3eZkaraAFJKtsYxQca8yTc7E/VjypcAlM4/eyhSn3tWjATLpzRqoPxI1jziXhc4TOXZwcIFwOCofrUXg1SxlpIIRIwwmbN/j1x7OoJEapuFI+KX6ncyRr4wuocIw1DkNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782134327; c=relaxed/simple;
	bh=awXQ/brJfB9B4O7BSeRN3xqg4Q8yglcr7LBVBZ0rKKk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k/b++Mv+lvxWLlTwofjB3E1bhSLp7mtlxRddSDhW+V0tisRDm5Wpx9Sk4s0sXtSmtJM+ZmQcypwdgUTyjm3S1lW7cqxVz6mnz0sPeRtmHB8FWPLEj8cWDFr/Nkcdj5e8643pDv7m/zLUqAtMAUzhbn83mVZjrcA8aGrSCLThGO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G/PEP2X2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NSqK6G6Y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G/PEP2X2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NSqK6G6Y"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MDG6qR1283585
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WSPAKkfSBcG7L+ITRQk41ncN8ei+Eb7mybQoEJRwyog=; b=G/PEP2X2wtbTbxYE
	B0NeEZX9Nul+sgy/YkwpzQzCBwY1BHaqTwqfpzUdVRLMy/886rrdrkGPdIzDUfXi
	sW+RuQS5WsJjWuNNrBCdwaJ4BeMLPBQxcvmL8WMhKd7c0wC6cDKaNLNq0QQxZfue
	N2jc+Cp2AuId+RACZRrvUJfyNVIwkEv4rH73IXiUxBkZGjhgkqiku+tQghLWG2km
	q8OkA7lG8bhD7gqPdoNXCs3KaoPUmKR+jh+sJvU8JLf02ri5KSnEN+OazPBqvZ7C
	Oj01Zsy7GpFuQSwppXKmM19Jmu3ppeLNxdyVeu5377/XzEu8gr9ZlQ1+jKIlbBCg
	4ZgVjA==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey5n401cb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:44 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-48e2ce64834so661474b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 06:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782134324; x=1782739124; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSPAKkfSBcG7L+ITRQk41ncN8ei+Eb7mybQoEJRwyog=;
        b=NSqK6G6YLrn0gMecRlU5cDQCuFdiTnfRYHXRo0YmDkXYHGNS+rf3NA8Wk+lCVIFcjb
         jMAy5xKxvBMCK4Plcbk7HN9rwEGgUS1PeBq2vQeREPa4r6P4dS8HimuiCstPSjlFB+A5
         wkfPLoyzhikfm9mkAFYuhL8KaRqsKq/szV+0HPUCjjCBQVxSULVf8BIzcTMwxyIQ2aRd
         UvSpthKv8bCSRpm28vtqNy+zjHb4CvRbS6rHLfVa5qs+LA3GUZ6y0YOWq/TV2hWJ6SSv
         6mO4VLy7rfVd9elBEMWzsjyMcAzd4IgNoFw2FGUDTnSnLWY9vu/ets/XWuoAw5/r93o0
         agrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134324; x=1782739124;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WSPAKkfSBcG7L+ITRQk41ncN8ei+Eb7mybQoEJRwyog=;
        b=G4km1JbbiBHw/8YgCT1X+XKj16UnD/noYZJR8elTF3OP3PzhosmZzlEb6eT8iCnA8P
         cZnbHTR0Jwn+ejvbq78pQQKqxR4CFFzv0B33hbRlRwvhq87jI0P0FRyy2Hb2Ctkwu2S5
         6jvHTHT/alAWwSziJ+CGRMP7rAFQZzISyDL30OkHxF66UVx4/9JbBVqH3ucuFeMijMW4
         +9SGoUy0UBKiTVCalyLTCqw5mzVzEvpVk1UPAflWJBVP0HzpYpyx5//Tm6Dh+7vvUGY0
         ma4t6egwwQx+aazw6FEVhEANRgJWKn9gewBhglhGk5DhGZQXjGqyxXCKDKlSDcS4Gasl
         tULw==
X-Gm-Message-State: AOJu0YwOhv9kY/Z7WwyNZaU9HOh6OFnQY3F1NyJkQklxZdmetCWNn/KY
	rNkAhtCWsuG/VXrJdvgLxUUb3yjE3fnW8gwu4I9sPLgimLIe1X7gL/kStYnlk7qlFZJQT7jYhNd
	Ql7RJOxcJMz/PrT53KPQekt9kg5cz8l5x4E6OBONf4Jw4N6nsqQHgFM4hVYDLM2hmpa4=
X-Gm-Gg: AfdE7cnijI4d0xygQP/HZxw9bwbllf8o3swqgormv7REt8adbSutYdkS6MbS0lcg+r6
	L8Hd4bct8alPZ6Xx1uIcPDQPx3Y+OIpzSfLcuR7GKS/fMgU0ebVvJT19AsPlB9erjhY/VFaVH78
	YicASPhNWEJ6eyc3pEbY4YBiGHq5jeL52kYJSKajkXBlZjgvNEr5WGGSoQaQGsjdAv3mXhgiRSY
	v3FvdO+2w6+l4AuhVzh8GZL/aMvq9V4U2mF5yohmrAYFljxyl9Tn424KfXawOHy3EjoZgyN2unq
	tcR8nzT6KnMUeriKGXV7dlG/wDrJT/KLE7VVMQUBgb6tMc12+0/VXjJwi5lsk2a0VYqyvzQXTub
	sBJq9GT+MYidkSguus9rFeVPKhzj1IfTI4s3p8sgS
X-Received: by 2002:a05:6808:2389:b0:48a:a666:e55f with SMTP id 5614622812f47-48aa666e5f2mr9608885b6e.32.1782134323807;
        Mon, 22 Jun 2026 06:18:43 -0700 (PDT)
X-Received: by 2002:a05:6808:2389:b0:48a:a666:e55f with SMTP id 5614622812f47-48aa666e5f2mr9608849b6e.32.1782134323326;
        Mon, 22 Jun 2026 06:18:43 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dea2:c31b:2872:1bd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd30078sm294083835e9.7.2026.06.22.06.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:18:42 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 15:18:14 +0200
Subject: [PATCH v4 6/8] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260622-qce-fix-self-tests-v4-6-4f82ffa716c6@oss.qualcomm.com>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
In-Reply-To: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4133;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=mUG51visYbQ+wh2a+16DhppioDJ/WPq+z6OvDSGkWVw=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqOTYhnfnrNzT8Y13oWcPqQHrizQczcv4HVkIRB
 QsMiZ2kXmaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajk2IQAKCRAFnS7L/zaE
 w/VsD/sG1+oMUdZqcIlfPSuCsvNS8Pq4oH/221VefzXJtWwLHDRxsUVvhMcssnWLJtu/j2Fnswa
 oHh4zz+mQEJ48mto559/+08cMlWFBcwSAftVLXVCCzS64gBm30IeetigjMdmzPAzFgIg/XmmGyu
 +YB5bkGwpWAkhKZjQkEWlGLfciTGEeKXfm2GLnTNp0kms2o/2VkY6gWFLB8RsLnNFCe5/5GvMDN
 roUntYH6ye83QFJxKlcnpFkLgFjSGaGzdMEsGZoW5WEyjHr8btYfYO5gdjMWP5/LjzMYvQhE9/j
 SvSJYyRa2vh/MhVwF1lWiZSXsIIPyQcQzQ9dds35j7v34Q8N5hQ9RyP24pnBtoxiC60u7LySndX
 dxFKCtyER2CaeBI3RiMpPANYpcauCyzIwYMxRBiUQvwr1r1IMMgeAkEjUpvF64DeTF5EDqopmEm
 lNpRGqNkSxI0/KOcnQFQNSQF0UDHDj9QjAsvO1v1i6GHCypQArxfnoIt5yAdk5Q7b9bKuu1gkgN
 LZwZWVVVBl3zTjXVbdAMFr5pvnC7DsQm3U5E8+DingVyaHvFPT+jlFze+1LHjtXQRpN+O5up5Cs
 w5JOt0ejDAu38YGhdZeShKXzLxqTxSMarTymub8sW6epOcLrTVpK68+AuewJy+pjGGP5gLWcYrA
 29o/YuctKL4eLfA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfX2Rxx6QKXd9G1
 H5nnrtJ7wtjsP7se0SOITY/1duXbpa4E9QuJllz9t48C+cc+zoAELnwtzAceoHUcxHIWjj3as0b
 XTytK9P12PS4yHvZgUF+syp2WGuKPFo=
X-Authority-Analysis: v=2.4 cv=R8Uz39RX c=1 sm=1 tr=0 ts=6a393634 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=tpKvEUOkdOp8HkJiz7sA:9 a=QEXdDO2ut3YA:10
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-ORIG-GUID: rBoKlJrDT5moI3BD5fir13p9C2NSJLgP
X-Proofpoint-GUID: rBoKlJrDT5moI3BD5fir13p9C2NSJLgP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfX5XeqVK4TOIZf
 CBJf7hmBiSYm8dqEiJZ7PEmTxv5MmlwKtQU1eV7vL5f2CkH7n7v2rjSWZH/qm9oqGlb1ZfdkjHw
 PPmxd7jA/U/JGjX9SxIT1+TQKvyLDVmF8zS6D3afJeqGF2ELRKkMHXfgm0Oz/X1SEp1pXLVkVju
 F9J1uAv4dl4PCDLOvpFjwRwT9MwF8KArdCAItU+aIblYRQDAIDkotuFmyK00eNbPe/sALOpbGJc
 9bM10vD2fqnNL6SHsC+rhg51+rxgoB3ZrtDB/ozJMlBKLV+mdIuynBdm3WoU5hbdjQCH+iLauuJ
 RPw2QaC6zL5PQ4uBQLO7bthDyD/HoUa33gn4hO/CUVCBYlFIyqhMETqrGsv+za4Vb16a7QH4lBm
 5kyDIsyCBqLKDm5oM+lONsoMwcaP4McqNRc/Qt5SgMMFKJn18WrGYI10x69NNH8fW+Y+WtI0hyM
 PdhJ+qAB+/mUVQQJZjg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220131

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
 drivers/crypto/qce/skcipher.c | 20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

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
index 54ff013e24317cd4d7a0dcde88cef8268db784c9..6d5784760673074179eef47a1faadfab898a76f9 100644
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
@@ -262,13 +266,15 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * AES-XTS with key1 == key2 (not supported by the CE).
 	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
 	    (IS_CTR(rctx->flags) && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) ||
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
-	    req->cryptlen % QCE_SECTOR_SIZE))))) {
+	    req->cryptlen % QCE_SECTOR_SIZE))) ||
+	    (IS_XTS(rctx->flags) && ctx->use_fallback))) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,

-- 
2.47.3

