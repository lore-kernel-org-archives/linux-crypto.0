Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46744A33E5
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781711424; cv=none; b=VkOBWiT/l0YMYGf0JF3oeaoJ6fwPeJitGhkjj+x/76y6X+x6AdnCx7MiB4AXzWd1RdCT7dQ2rom9GhFsP+Vd9prjLbH3LeY0Xx1+BLXeSTQXBAO2HnA+BkMEugeaBR56aIESRyXwBEQ/O2LytJPoVtmcszfHdbRbe15zrbjuN6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781711424; c=relaxed/simple;
	bh=2QD1at917VHfOQZ1FFL8/A7RYZ001LMVPGzvMxVSjrY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WRTmQ1yp3ZlCzF1zmutf1KAqfP+Lpf2G1ghn6vx/GNB97EKkCYSlKXcudZEOtQu/qQpsln0pikSltcKIaP0sB/J6OEUbPImS2SnU1Tai5JEaykjavM0KoECVUWAhgMEuCq74EUjOTOis/phVJ/rErfW5vEm0S+8HXpkk7pIVeOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LTZ2r4Av; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TaUOiNkm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LTZ2r4Av";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TaUOiNkm"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HFOi3r2541352
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0i/236+32Uviug69CXy7TUPGH2NTZVCBU7yo4A1KEOY=; b=LTZ2r4AvufypMFpk
	xZX6YZSfae+BjjucKLzygZCvSDO0/cg0KZEV1lFTn8W18eug7+peXZfLwnnBLn/B
	hhOLOCBhxvFEU7b17bh2ZCW2qvFptQLBifjq9H6eN8ZYvp022bW9MZNWTyRZlzuk
	tl4TswKAcND0fdQ/WU0d2Io3HUpSSoNJy8s62Hyri5vBZbUht/0uebyjV9K62f8o
	SXfWZ0e/l4YM0CEuN00io3EQW+iPmJZ0d607MuTvXZWZPFAlIgAO4hzrn/lAWBD+
	xyx90u3AOD2HRyeDkffZ8cM2v+X/PfA3GI/rNz8GUX4DXU3pfEuEj5NTjq6tdf1b
	zJx2Yw==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4euef240hf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:06 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5ab02fb3054so4052495e0c.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781711406; x=1782316206; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0i/236+32Uviug69CXy7TUPGH2NTZVCBU7yo4A1KEOY=;
        b=TaUOiNkmkZtNDz4s/ddWsj9nxlQjhGyC+CxPCZ2ta+Lfoov3RMHsqmSOv7VuA/REaL
         dU1CfaMz8H3DrW3CMk/zgewjzlSk2/CXrs5JwbCMeJ3DTOX5souKC0f562Hv0zM5f091
         zeJpcEDP6Vv2hNPFzLI3HSpowIdE5QTq9U2ype+3RC742Yh9ehJE4kIagrZBOQe3OHB3
         xci2v5IQ+RAv6hNTurEVbc2zg3oQqqz4D+7j9PsZ/4YJiP/2TcIxCsOwxWzZTCCA0hrE
         le8BkshQN2nYs7jWEEzmI3QtK/s74+asjxhFRohnzyAxfPnxlLKcmpvNUdZ6aWGtNDrJ
         CEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711406; x=1782316206;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0i/236+32Uviug69CXy7TUPGH2NTZVCBU7yo4A1KEOY=;
        b=MiMt+OPq/psiriRF2vPX3Awq290HEW/8s+ilAYxSAmEC0i6EtD88rHQ+n8Rc0/5wvC
         MmZ6l+XaN8462seGI83+r8U+hIbFXVruI9rvlCFlOrtmh//JQhYoQRDj00sxIfnFvs0E
         e7p4KnBFM1a1zawwiau7jnILOeao+l+vPdcYCNfXx4lkMMR46XPVb0G7o2Ztbi77GUj5
         nByFSHSRqXRS2AA1+q+kzOeNpRFphuhMrDKXYiY8a/H0n2TCUROMrCjlW5QozB2Cmr8B
         vhQf+G/Q3fQfp0DeVYyy9jhHT1e8kwrzWihZDQgQf1HZTVlbXoMY88IN04m8VLWR046y
         uwRQ==
X-Gm-Message-State: AOJu0YzWwzboN5LhzGpIKUIcYaLDPbGzXUXtK4sGJ+8fu6iS3qpIv2MN
	p64bV3iqdnRhai/osNrWlHtsqhKCsidwLz1avwprI1VtLdvfPIHgd5d83N1rqk8bVPxB9OJJON1
	juqaRa2JK+cz3siX2xjSJI6hEVrXZTjNB1rWLbmujZ5nxdXXSNRxhJDMQi8CnYYqcs/Q=
X-Gm-Gg: AfdE7ck38cwyEjeb5n1+OFiIxnvmPzHH41hieEKEGDAOHzn7sVTnktIvrSq1V/cz6o5
	cF7iTqzxjYsMq+jBMlceUBpC1rPCGXAQMFsi8LXR+FnmU/jHtXVuNfVZnr/Gwxa77AXNw73mLwS
	+CcdIrq+vsq3t/0KIPE3cIyWDFWeUcKQ7yicnRroY/2Ed/hU61Xj+srwAHXTMsq7MqiuwfsZPG5
	Ux5E7zi0AheLT582fr0nlgupLxFxrmMkzRn0m5UQRRUI0svzUWK7cfXCK4tTfJxkIfkfh5F9oG3
	jpPK6HPGu11Q9WjOy2dF3OZNyO/0ZbQn1DShmUZDjJmd0ud+LRG+UZokZC9OWkZ++DUSjhH1i0D
	GsJojI6wdQ8xpNxIxiSj3+lPkBVg9YqEa0raThhON
X-Received: by 2002:a05:6102:15a9:b0:633:3040:ca5d with SMTP id ada2fe7eead31-7245da81133mr2503891137.9.1781711405606;
        Wed, 17 Jun 2026 08:50:05 -0700 (PDT)
X-Received: by 2002:a05:6102:15a9:b0:633:3040:ca5d with SMTP id ada2fe7eead31-7245da81133mr2503851137.9.1781711405091;
        Wed, 17 Jun 2026 08:50:05 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c856:25e5:e249:5e0f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa8b423sm168913195e9.11.2026.06.17.08.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:50:04 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Wed, 17 Jun 2026 17:49:35 +0200
Subject: [PATCH v3 6/8] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-qce-fix-self-tests-v3-6-ecc2b4dedcfd@oss.qualcomm.com>
References: <20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com>
In-Reply-To: <20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4074;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=Z6ypwKanEzjNE5ILHL6Sr+FU2/1s8+CILGLtPtABFCM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMsIbgbJRyM1SL7/IRyPeLefrTlVeUZKYxcUpq
 T+60xv4kl6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajLCGwAKCRAFnS7L/zaE
 w5iDD/4wFpsj7SRMnRJGvw2fPaGz4bGVZ64y2nkitN8T6RNjmoLN4XgGSklIpcGOKb1Ng349zDg
 CZ6PHTcap9Xqa5jBzsdrBQzd/TDWDUeWJJ+WbX768EF2f11oszyg8n/rfiff1jrdDluFmFA17Y9
 r2UzDtXL8nZietQyPkPF4WqRrgs5VtKFuqUTRlJyBL0RNAOADnWFU8HPhNdAQ2rFZub0mbItNGQ
 XmBEFvEYAyrXB7WZEFmqbMTd8ug5pHnyQRT/V83AUewlHSk3e0sm7ETdurprKIcHaij8hpniO+8
 uN+I16dNkFYFfEfDlkoP0BukQLRmhwU6LjYnlaiLzl+6mbiJUwpouAmioiGn7TYTtI01FerMLkU
 ozOP8wBzH42CzrMcVOF7DHxt8v4M14HtASQEseJ2uA3VHiuv70MbozR5enqTCYlb43p7+4k7YoS
 XoEkJ3P5QNfjycLXJ5wE0RACUgrxOs2Ys6oEg0Bo62SFxbChriUTg/YKx9T/82zRqnU3xtzsyIx
 E6gPwtIAHjlWDeDp7CzHqi+sdvPZwiQglG9CxxmlGdWTI1PJmponCcybu0ahZ/BuLeTiAd9+56K
 ekLf5ax0jr3taF4PhBGqjkZbxZX9AeqyGBuu6K3vBNIiev0Kx8RRDNH1e2FTCz8iPXQ0UBACycZ
 pkU+F1a4uNYHKhA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX6IivPs4AzACC
 0ktUUi+V4NI3n9ayM+hX3hZaXhoqOKbKWo4G7HXPTW7fbdoho15v4VBC5d/lcI/OsgytyuPjiZP
 a6UPZYuIxp0o7j6nl6G6sVDdZefNGis=
X-Proofpoint-ORIG-GUID: jbtKKNVkkkGLau79aMQUmLI0_kVCQ03P
X-Proofpoint-GUID: jbtKKNVkkkGLau79aMQUmLI0_kVCQ03P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX58lJA0BcgSqx
 HQlHYtpSy326XtJlyGkZEDsixj1TgTeyrtk8GAiOi9u/u1UaFzTW4tUMdonP9ND6BbgFNhfe9mP
 CC8v/sHcqbk5v0EmFmdBJJwTBgEScYs8ZeBgGQduUi8xzvNAvvSE5L/5emTKGvHbq5EYoz1Ei1g
 dY8PTFe14R2OkKcF9koR4kMhon/b67py4p1CyJtZnxc+x7AP34vVroxnuI20zXc2/Kd9nIXr4V/
 6p/weqjiAvxFTsXxLHGosdRScMnHHAAvRw7wmdPDYcxB8YxJVtiCXgoCVPeIzEScneL5IViluQO
 xB8OYiLZ/+ZYbVQ7g47njeOq21OeX1x4KZrtqnHQX54h+DBsErhkD256d2vab8RVjhqikmbnnpo
 4fzTgjX1GTWoHipMfvO8G3wnXd3qnfZB/XXmir2YuAfEnma59p5JfmAQDHo25EHi3wHg9MjrVQq
 xFHNL2D79f9QdUYvRMA==
X-Authority-Analysis: v=2.4 cv=acpRWxot c=1 sm=1 tr=0 ts=6a32c22e cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=tpKvEUOkdOp8HkJiz7sA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170150

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
index 118a6878a76b1e86534f60e5d2058b99a689302e..9c1ce69adab8309737e15a50826505898340bcd9 100644
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

