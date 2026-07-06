Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72848379EE1
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346078; cv=none; b=AtHzrZPStIji6xM0mZDc4+Rhc8nlRl2bkXpS665KHW79r8GfJ+OCqnwRNuap1wkQeCFd+1bdX/MypZ3TCo/lYrScMqd6XU5Nb/hTwjgo2L3KiL/76OYGP2lDq6fXnKXgkI2oAKzib9tifYGcEDA2ISPdq8Ukkp5CAfvY4umJ+cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346078; c=relaxed/simple;
	bh=awXQ/brJfB9B4O7BSeRN3xqg4Q8yglcr7LBVBZ0rKKk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CRSBpyBsk7QSJdlLO2qqlSlua7CCLWT9owIfWTFyymn9i1eIcckRvskEdnxnfMi3PC/BA78fm4iaWn0pGbHYmGLXqZhHGKM0OpAVcc/pzab8nYaTcdPuWa8+EQslLZa/D3Bw+C95+D2ef6ZZ7MsIGuYHqO2wkCBDgUehMsZ7s44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EWy8DPUV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CaUJQhdy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EWy8DPUV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CaUJQhdy"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxDmn238262
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 13:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WSPAKkfSBcG7L+ITRQk41ncN8ei+Eb7mybQoEJRwyog=; b=EWy8DPUVmPeZazej
	8UxWkOZoD3IZYB62rbTYIZ2WAKxhuHfZgsn+pvJ+64c1afzVVVZ3rTfpZ4iMdLi6
	M3ufR8LJeKr5W9ljNVYzOkQRfJ3s3Pu8I6zRiBbr6WxNtcQG32cGGYxGO9EUJIJ1
	iEwi2q+0wLwMJ1j/Z5IzEzHotDVYxRQN/btIBnnD2l94nVJ20oioNiMlA1d0nJQT
	vvp4Fz4mnRtc6Ufr3twJFwKUkbFhGAFHw6/ATrOoEo/qjIc0XoJrSoyelDjXdWXK
	qyWooHeGO4PLmaBLsf87SrSBKF9t2Jrtn5F7hW7iDMaDKgXNwoIPi/lmVYVsTLgb
	AZJkHA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88t899gb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 13:54:36 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e8004d60eso487679885a.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 06:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783346076; x=1783950876; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WSPAKkfSBcG7L+ITRQk41ncN8ei+Eb7mybQoEJRwyog=;
        b=CaUJQhdyVWkl65xyCPyvpHIj6kIb8Tc9fS7PXg3eeCwezaW+Zet6h6MSiZvISnlUeN
         QeNm8y2HTND339QiFC9AcWs4Ey3rfi2XJwuP6lNexyF9aetRcgBclH5K7zuNXWImIQlT
         ShgAa69m+INLx0yde/jmLxsh/uwp79ie/FG2ozWGzgF1INoQtlfSJr0GGFDjYTgnhH3b
         6HR/fbvgW3MnSCLBZFkhZpVZa46iosw8vZFXnk0/kfJOqLrzCKz/KuOPTv6E4hfRp4fN
         GUZCB9NNIe6iuSfP18muIKVguwVH4VoMqvVQU+y1BkuAvE+t5XyHZ0o2gqajEDcmIM3P
         jOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783346076; x=1783950876;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WSPAKkfSBcG7L+ITRQk41ncN8ei+Eb7mybQoEJRwyog=;
        b=IllZVdTYxVCakj/HSqykawu5CcnYpPgEBzvRt/f+CF3GXsfm+/tbQpHiwA2brYS/N0
         hGiE2EkHsKni89nULcE+9Fv9fX+7lwytoLwN6b5bwvI4/Rg2EBxxftNmXVA8VNcmh/cP
         EXw/ya2wCZQ05HV8kjzbL56hvMb7tOxvI28MU6P5LgfSyGpGyOTPhyEiMLh1uuyNmsyx
         +sdkuOIh1yGMngoakXoWrBSieuQSGrOtjlIMOuNWO9x/ZP1w3P08zcK8bIKm8j6Mv3Qc
         /HpCIlX7K8wcwLvlWJMOPj5Lwr+i5/SGf4RhAGJvdSxc9A3cVOonpameQP8bKCAOAxdn
         lVrA==
X-Gm-Message-State: AOJu0Yxzvgn+tv/3S+Sqj0wK2SzHMmGn7exJBEmGBfX34i3MibQ4fn9k
	gZ/SYsRUXSupKKbrQ6KdRNv0BM1uyR1Jz6Ti7m71Ewsz2uAckXsbz+C3gWbf7nymwGdKxrbX6tM
	xYBnNQYxWvki7Pyf0O/TISS1LXvti3HQgdtgh3klCpGt4ubWXfn12A+y52zBDrNKjcB0lOesJKt
	I=
X-Gm-Gg: AfdE7cliJ5B/zqIgkGrow0cNISDenUmER7YDSakcAdQMtRix5YLEWRCm+RiX1qZUnCh
	1J/GuaA5L2emLef6mJcbKf0+FZABdWFqk48xIFwHaUwGOBjiiqe8NW8AVf5jVun73vhkhhWKd1Y
	jud6GRx+QHyNzmHD+n1VTDHfcJ16+8fWYsKYT0lAiDEJFqub9LfL8XBS4LtCf+irWzveDyRoWer
	h7ncJ4eLVcw1ApFJKq+pxQxUJVwDfMCPuvAJ14RgqOWLvV0mTc9/l5qlXRvIbj23kWh6Qj+s9J0
	GyP7fmFbDjbBn2B+yglXedsFu4FWVu1eHG5+91y93w4bpyFiRJUoxayvxRr0QDbuRCcz3z56x/K
	o9seqoL1jZjUR27pdiUJJ79x2d3egQQvKtqBz2bUB
X-Received: by 2002:a05:620a:4542:b0:91c:ac0a:690b with SMTP id af79cd13be357-92ebb54cd97mr89499085a.17.1783346075640;
        Mon, 06 Jul 2026 06:54:35 -0700 (PDT)
X-Received: by 2002:a05:620a:4542:b0:91c:ac0a:690b with SMTP id af79cd13be357-92ebb54cd97mr89390485a.17.1783346059650;
        Mon, 06 Jul 2026 06:54:19 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:86f0:c42b:ef4c:d3bb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63ba971sm619805145e9.13.2026.07.06.06.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:54:19 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 15:53:56 +0200
Subject: [PATCH v5 5/7] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-qce-fix-self-tests-v5-5-86f461ff1829@oss.qualcomm.com>
References: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
In-Reply-To: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqS7N+9xWGOvh8J6nnK2keRqxOiduOyABq0mfnf
 8snoBaHSxuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakuzfgAKCRAFnS7L/zaE
 w52HD/4rcLQieogmFpH0mB5/k22vmWi+cWveC2sn4J9RwSUWydqUfnN6lZ35u/p3xzhzxzzYf1p
 QjXT3R5e44oUW4ERo6UAzEAkM48LxMESeW2OxT1KBY43NO2nFA2nqnbeAotnSsYNzISLR7xRQx5
 GYuX5VihbOpP9NH7sc7+qSV33LQRu/FPEhKbVUnrHD5zDgToHZ4isD1DoWI3k+855LZ6uFpcauB
 XSgIEUq9SI6CC0undGv0eFXjorKSql+X/i/CQgeI91/IrojI2DNY7C7NzqxSw3ltEbAcYGFx2VL
 vh5Z6pWcYoyQl7h6IFfWvBZUxr/XMMJ8KJNNsk7UFPnz3H4z0Ih9CqcoC3VKaA3Hv15bbgsVM0+
 Eoq9XE102p7BO1LNLlWXVO5ut79AEqklvHNjNMBTu5RqPI6T+/V2nSGBqzeJkPgkMuFoFMyTfUl
 qDGLmIposhnFIIb+wMQKtJd3IkXlgdC+GTrr9gqclcHuA8/Vax5DyT57d8kA3XDWpA9RH70tZsf
 OtyQRhOnHe0LlEZwZkcUJaXHSzSeuPjzhpc2cu9dmcv7EpA2nSkRa3QyQhwKrczR3QOjlo5V91S
 qFRvec72HGQSHVNWGa16PEq1eKkrf0Wvy4SH80ffNc/+G56Rjdq1EFuoYKeSZ5q70caeIDehoHd
 z7qRXe2s9UX9kKQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX2JnH8/hCh8CP
 rkl1Gf4fNXpHjpfmnK7438HqtzHdgnk1fE0lk3K7aPV5PDR9qJsJbC8/tLUcbKFrsWy8ClYPmEr
 lKkw+uhbxHRA62JHziz8O/ZvTCrV1rY=
X-Proofpoint-GUID: kFc0j4gHhMlPXT7a0t8DswkT5UOueM9R
X-Authority-Analysis: v=2.4 cv=C6zZDwP+ c=1 sm=1 tr=0 ts=6a4bb39c cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=tpKvEUOkdOp8HkJiz7sA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: kFc0j4gHhMlPXT7a0t8DswkT5UOueM9R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX6j6sHBC0XtVI
 8Y+oq1L9K99h6pagvNFZO0FgFDZwd7dkfwKtkMpQu9dl9QQ3NAJtRgmNKpMhd/BLBvccUc9tkgV
 CiSQjVcQOqDgtRB+DMJHLKVx1PJGciIO49ukGDjwtI8MmPb/ClKVjLI6B3vK8AOVunvroMy8W9d
 MTmNPaa1yP4Bgt94ry1LG8ifE6MwtOqJs+I21dYoNkmoZZUSFwDddbgSX8umOdXRRIO5s1lmXd7
 qXBJSZ1gmWVCCE1ljTwqQN54l6bqkenBgSMwdRP7173sLjU/9Nl5YINipi9xT7ARlTk2Xy2wVdF
 3dkk5pEkRhSbYuMYnOVyqdQd2N/eLmgtSn22gGwUbYTWBwi1EW7n7//bHvUyfSb6I7ljUL3uJ1O
 lK0jE8YvPZ1lKADdlK+V9/bfmbkJE7Ggm7yV65IzRYpZPK6ZXJTuggyRojJiZd0im8838wQQAzQ
 5Xfu8H//z3LBjK7/yvw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607060141

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

