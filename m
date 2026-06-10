Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5598834B1A7
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781070856; cv=none; b=l3hENhEJ3rWV5A5erZDCBiTGIG8qVU4VI9wJmjBL3uBUZRNRHN1vZwVKL9vOgY2vMvIFvPfhWvrAxnypJmOqIbNWPgc5LufTpq6HfaYnUg51PoBKugCYdZNy4dniM9p8LDJN0xc5Fd0Z7s2eISin4wkfLZ5cz5mYzwljafVtQTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781070856; c=relaxed/simple;
	bh=mvyd7QXo5Pn2uhq0NJV0Q0P072HsXKULRifWb7YxThk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fYInR3Kj45ne0zjKPuegY3w7XwN+8lVJQv7Z8FTwpa/7nBARtbIeB7xK9DFUx67TFKYfxuRVOLt58DCGulS2W9AT1b0EaXTtMwocgSEmH0PnvMcz1GP5Mr5/mBZDgZd36fOkCvl2zDwF7AVBK0gSg+3/v48APo3y6DJqUX/6Wxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g0VMXOBm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h4Aekahq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g0VMXOBm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h4Aekahq"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A2ek373999751
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ull92GEuB/9QqoFhRIs7hs1YWJ8Iv9duCP/H11KRLOM=; b=g0VMXOBmzhXF8Dde
	lW6Kxz9dbhO+ktIEVrB0KrB8OMI4v1RwVsBbpBdzliJypcVBq/VCt/SGHf3SENUQ
	h0D3SHqyzvJKAJFgA2YjXTcuP4BoaQjlkzc4Iy+JyQbbjgHBLJmIGHGORonu9Iz0
	DMUMjFctfWReEWbvOCcwqllKRqYeiOXV4AFD6S+xLCXxQdJQXOvWn6nE4mlkN776
	NJ/fxovA3HAkPGmESB9z3rze9QFu2UiC7oL09fA7bObOXtUJVinPwcV79Ga0Phrf
	5o8ELAkw6SE/x9KJgeesIRG77cwc/YD9C3acc1s+n4QpeKuY2JTmR/VX6olMG+of
	TNaAbA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epxuvgp1u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:14 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8422b1354edso7454290b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 22:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781070854; x=1781675654; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ull92GEuB/9QqoFhRIs7hs1YWJ8Iv9duCP/H11KRLOM=;
        b=h4AekahqDbBWZMa6Xnw92ZRU0618PZv+j97ocYMSkG0/Hr0BUQmv5Q6w5aZlljJX6C
         X2nI0i6nsoToFuX6z9rGw9RjtILlEY9UFi7Cy9gTsTi4YlytX4Po48WDOEZnnDjULd92
         xUlKP3WJPvaM9N1/EcgRXW6OJaVR+3E+lwWQH2HeMs8NDgojQg2nZkzgD5TEUZiYWglS
         iU5iS7L4Sy3UoVRMUX3kXP4UG416rWdf+fKkW9ZV/z7obewoH2tMxpmr7UCdjPtqDudO
         2yNtvUcX+VNwM4PQOIc/d2LA9pX61WjCgSgLGHQE1IofcxeEn6ErmQbmjDuvV85+a+oL
         nvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781070854; x=1781675654;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ull92GEuB/9QqoFhRIs7hs1YWJ8Iv9duCP/H11KRLOM=;
        b=hPnOigdOHoofdawTFoAZVTczgnki0CJO1x5AJRG+NwajthE4xkpONEaHMkYFV1pw13
         dNcaaMrYUMFtir9Yu0ylHGckZS8aWcseQpJLKq3X3pMhE5+rqWamfy2dXsmfVtV2ndbr
         YTSbqimOAtaSU+DIj7mzaz/IAqRkGSyv4Rnv3el/tEbFSdDN1d6V2X0OIhoPLFj1FAOb
         bPGhJ7i0pAVLBBt4t0nytJeJmAYQl414ukHb3zXITkHOdW8cdCevszACL2e0QJjj7wkC
         IPB8nvKBRJQXUEHvONhgTgdcki/Ug0gSvzp7HmuChaD2aS2QFA/k0dtoSGhThKyJgmGF
         IYPA==
X-Forwarded-Encrypted: i=1; AFNElJ/CjfjptERXzfFOQbbYkXmL5qW9S0WIKQABQpz1ghIiM2e2VkbfOvnxdpDpoy5CQN7CYCFJ+q24kizRhLE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRqrfqmRFZEZqVejc3G4+MwuV2ifbJFFQv7S7WJHe0wjxGdZTP
	M6KqD2weMrZWZ3/0stJm+qZo2rCdhJSVdaRmw0XLD26qhSbcOEkxOxPM9ZaBpcFg62ss/O/Kjfe
	PTOJKY3OnRat2QYpyOw5sP6QkKmfLziZyeVNJne+z6TodYFcipW210kTdqMsovCcojYI=
X-Gm-Gg: Acq92OFdTiEYFWS11CmvoW8X0XeWrwJPbwf1wkXyLjf9h2OgoJ2RvL6qLFEus0A6BT1
	bVOENIkv63wUM4xbU/MmH+Y5eqVz+znyDKq8iH81jfw93U1J9K9+BYzZ80qqk4I5OdDaCIgbA+8
	PMVWsDILxG5GWAKVHJ+uU8ZKK1W4gxXidtuOmpvNud5ZEL65YC8SCDV8jzl0TYuo3/Vh4GChzUn
	bhsiSllPKPwjZ6KSzt9cYbg8Qw9o9+ywWZqLC52uZNVw71b/4W779fo51lcjc74xJqiJaBi+gfX
	f88/fK28MAfkGXzNQbKcQlPTxy6+tlPRZpSqva1+cP1eZ+slECaTKzfTyFoMuiORXKNmARPG8ap
	XySr3NkZulFFv2Th85gWmzVEnAtUJWcQauZtb0xWhdNUMis34RMkWBEW/V8dSZDjezQ==
X-Received: by 2002:a05:6a00:b90b:b0:82a:6461:6d15 with SMTP id d2e1a72fcca58-842b0f49acamr23141427b3a.46.1781070853957;
        Tue, 09 Jun 2026 22:54:13 -0700 (PDT)
X-Received: by 2002:a05:6a00:b90b:b0:82a:6461:6d15 with SMTP id d2e1a72fcca58-842b0f49acamr23141408b3a.46.1781070853526;
        Tue, 09 Jun 2026 22:54:13 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282221086sm23687470b3a.10.2026.06.09.22.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 22:54:13 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Wed, 10 Jun 2026 11:24:04 +0530
Subject: [PATCH 1/2] crypto: qce: Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-qce_selftest_fix-v1-1-1b0504783a46@oss.qualcomm.com>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
In-Reply-To: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@linaro.org>, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: I5bn3M0XSGohBHPxDL5eFxXkAk9NuJnN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA1MiBTYWx0ZWRfX5tkryAB1Nvhv
 B03/yyJUqO3SXnGfVt7UcySuU3uQ1D4dITfnRYyws+u9gPYk6dBxx1y4W03jllnNNWvx99rGXTq
 tu5zqEsKMJrA7xUBb9miQKZM1SFNPCvRvmZWuxig8j+p/2Rnh7yNwbsMYG63SqFs85eBz9chm7X
 fc26cMTfRbVAWAqsPlD4nPDxpYdgxAebOH+P+xs6B+AUf9zmLkIig+MhROvkX0nWmW6EdE4F1sL
 GHJdv6GohKpKxeoCE6wJSAjKawfe0q+wQS2sjBm+x/+LcxwlRIyK+1HZRBRO3UD+FcIam7Bd+iu
 UO/rbVDBnxKY+Xdca3YLoaBO7ygPkN1r5R4/LVylglwUi2NFRif3GUcSo0CWAOUOz6ZHLIC/6YV
 XoNE+IPpMX0sDDPJkQkphbnkj+FWb4GxlQQTKQe1pziNav8dY6HeOk4rKPNaqTcD+QCNiIil9Is
 hv53TFzJbT2SMNdr7FA==
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=6a28fc06 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=09uMWaUiLw9_HUPRBkgA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: I5bn3M0XSGohBHPxDL5eFxXkAk9NuJnN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100052

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

Fixes: f0d078dd6c49 ("crypto: qce - Return unsupported if key1 and key 2 are same for AES XTS algorithm")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 drivers/crypto/qce/cipher.h   |  1 +
 drivers/crypto/qce/skcipher.c | 20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index 850f257d00f3..daea07551118 100644
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
index db0b648a56eb..224693a831f5 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -13,6 +13,7 @@
 #include <crypto/aes.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/xts.h>
 
 #include "cipher.h"
 
@@ -180,14 +181,17 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
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
@@ -287,12 +291,14 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * AES-XTS request with len > QCE_SECTOR_SIZE and
 	 * is not a multiple of it.(Revisit this condition to check if it is
 	 * needed in all versions of CE)
+	 * AES-XTS for weak keys in non-FIPS mode.
 	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
-	    req->cryptlen % QCE_SECTOR_SIZE))))) {
+	    req->cryptlen % QCE_SECTOR_SIZE))) ||
+	    (IS_XTS(rctx->flags) && ctx->use_fallback))) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,

-- 
2.34.1

