Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6944640C5D5
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538635; cv=none; b=blYor0MbdLX4ZjowZzI/ed5Cy+dFn69i6p7kNJXNEPgsOMoHwLg1bDFPHF9TpsQqgPwHBj8FNvoIObD0J+LgjSbcq722BzQmeHlJkh4gdNHAzCllYs4503Qke/fiU+4vDfB2f35sXWDZKkgiMOEQtW5yHVG84DmaPpZ6IpFIEDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538635; c=relaxed/simple;
	bh=nnLvBxCmoE+kJ3qTLU88sosyAIgXJMo+XW0592/h4ZI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KwdIj43Jce6fBw3a/OkQp3/UOe83yf4cwlwrd/LjmLJvV1WFFoLyDeBEYicy8aMznneyuEmI7TFufErrhZdT1q1K08i7zfQxTYMYQCA+X/tVvx0ebev2t+0YHK2dQhBd2uErHxs/ZKRIbKc8MXtinIISAUye4nDVrkyFaXsJsSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OkHAzvpp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XwF92Csw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OkHAzvpp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XwF92Csw"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFhIKr3139312
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Fm8aiyh/nfLeo/cW3sdxMAfCrarlRF55XotmJvqvGJc=; b=OkHAzvppJ6bJkTHG
	5Av9rePoQT8dCHUIm9pDWJIIhGXBmOgW/C70CpBEKPV6mKQvOx9hluZeyRBG23sq
	ab765wTz+/ogPqLBQ707JKdkYg6Bs7K/YdyTtvQh7rHcAk36r3IQcdK7AHW6QI2O
	LV5e7pGkAOY1n/3C+TeisQeyVHL2iHe+UWuIFFPszSZ6VUQ0Vrh2ciC4A//74C2+
	J0xzJPXO6Xnwve5fNsYNFQSclXpSVydCisDxQ1lLYIl5pEN0UELry+e45Ecp16Sv
	EZxiomkIRkwdg0u3TyJNYG5HFVskTeq+b8UlpidIbCR6dwY9HbXnRHLAr4rKuy0v
	/g+1GA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ete981q1d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:33 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-91578c374easo624756485a.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781538633; x=1782143433; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fm8aiyh/nfLeo/cW3sdxMAfCrarlRF55XotmJvqvGJc=;
        b=XwF92CswTOqiqdwBc0SXYQGtIDE8cPYt2dtNgJntjbkGPehWF7vZXoebxDcimYnr7e
         Qh2Rt83pWUCrZCgdsCp65BHvE+4lATutOATRT85RO15dRXUzrivhmDsTxrqcrnZn7QNw
         qNB4K/jb+rsYbtC0YvfYRuFM97D3b55iq2rDgMZhEbOsqLYzl5qN6kyvWlmVPVKbzcsp
         S/5JhOVP3JISBt+b9ajLMonItus0OCm9sThSrlwnVEVVmZcLzdnFMrPVbqYLPMoKMEw3
         2XACo1HrK4MmFO9HtzspH377F1pDb33mAE5pVUvnCoUSMIZ68xqlHGlxbGdx3M9ZMBkr
         yHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781538633; x=1782143433;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fm8aiyh/nfLeo/cW3sdxMAfCrarlRF55XotmJvqvGJc=;
        b=dWhp6jamyzvoXuvmVtqGEDAm1J5yLLlNl8Pyr37uAE/GKPycsKPgonk3yQFU+uO18R
         1as92YL4On9xg8Coh+5RTGmB0xGnclvw2Xq1CfBoUlqV1Zsr92kcnwR7yLAGAK1U/0Ff
         B4LJpYD4s28nlrRhZRs4VboK5s8LkeQbNcb6vZO5Z+qZRjPLiXrcOrFRjcelWwFz/Dha
         y77YVwGy1yymgLTN9j7maXUkiR2Hl0E5akuLqF59NwY+eYawOFx4k21hxzf2Qy4UIqS2
         dL5Etyq1ASV6nG4G/nnToM5xTlPFc7CKE63SAT7n7R8k4v/T9SqN7KiYETg2aHyl0iit
         Mu3A==
X-Gm-Message-State: AOJu0Yyxal32jemLKx7ROKg0m4eIC3HozH+Ove1WXLrLA4bNoueBdvLf
	2VRQFiJXjyW5Zcq5tzRc/dSgPvkfCwXkgyowgm0HaLeGn7OyBQZaV0xsVcpMEvsOpe1pxQNZ95G
	XJ0Ll+Zgu6re//fRebH9jioYdxhP4bl04VLAVKYR0V4ZI+FouBj30wubwHJdv7WvGlsg=
X-Gm-Gg: Acq92OG2m5hmrKGZKbQWy4ChjqJ8iTE6imM0D79I3lU74oJZZGYI0Wqv7arTDpCCrHD
	JPkm0tlOZNObQf/HtcaWtyh5VnufhJcoqwY6Y1X1lfCYCCptbqZf74i09+RhFzwgZM+QWTln2gG
	BRQh0ZFZU919+HgFcUcfBoMXdwke7UW/BsbJoFQnygLkPpTPgoLUErWYc14W5dEC0+Uq3RsRMVr
	IZaX5ACdt2ezzQuve8XaNZdSkBAEwbQCulTbSVJDSWmMUSg96G0Obyi12cQL+xf8XhAeAD1Tqqi
	UVLIe0yfhWFibyZCM1Afh49m729ymze6ODQ7c5d20Gfl6dJTXZobbRiemj7cdVyUBjhKQVoPCK9
	9w1+uAclqm7P+tuCnmtX+ONRqWA6VwZUL3hViZPSnJ5hYUvCr5WY=
X-Received: by 2002:a05:620a:4804:b0:915:86a4:6685 with SMTP id af79cd13be357-917f01b5abamr1795356585a.13.1781538632611;
        Mon, 15 Jun 2026 08:50:32 -0700 (PDT)
X-Received: by 2002:a05:620a:4804:b0:915:86a4:6685 with SMTP id af79cd13be357-917f01b5abamr1795351085a.13.1781538631971;
        Mon, 15 Jun 2026 08:50:31 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:7fe3:eaf0:5a0b:2610])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm38643032f8f.10.2026.06.15.08.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:50:30 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 17:49:57 +0200
Subject: [PATCH v2 6/8] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-qce-fix-self-tests-v2-6-dc911f1aad42@oss.qualcomm.com>
References: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
In-Reply-To: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4085;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=HicLkGLfvSPRNrvWhEWmXa/fqc3LjiTYu70yQpf8b4U=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMB8yCUAwgQqdhMcN1MPApSu+ebPnTh/5Ci2Rm
 kdi/4WtCZ2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajAfMgAKCRAFnS7L/zaE
 wyiaD/90vy48Tv1h8ulqFzqONQqjumWrmA4DrgnJMg3AvrxW3TjyK2o9L/PPmROrGJWIjLgiCCZ
 QeHjjj0P3+SorKiVVcK9hYi2Of97A7VmqnAynggPMfD0YJjnZTqCmSWq8O8bg+vz/PeZzwV0wzk
 fmyE8OPeKeQq2XeUC43nfwl5b5JLYtAxpkysPguLlimn8xYFazPItN/LCPcIZ1a2S4mDgqr/LLW
 jXy1wBEz778Pm1ThfzPS5+V2R69IF3F2CQW/7eoueYquDblJXA144DSMzedKveyxoG3QmEDZeLf
 Wj4ICd/gVLL5YAiQo9/olhvEihr90vQCGf1IYkjcTVk/LTk2/sBgvtx2ou6ocwvS07HYQ/E5xxs
 PDiuY8bPJiQmXKH4/Fu0DS0tHFccxyaXkT2tgYf9BGz5VhRkkBOpgcvD07/UrBcHWQXcygVMlGl
 5U7ud2SU4bnOGI/bz0BjjrsFm/3mICh6SBsiGjabObJeD5ROiCT9A5TLv7qPZPrVL9asMlhYHwL
 qHKzTzi2G/vZiEHJK6FxcQS7Wsr69XKhT3AbhVx5I7+oLi0AtqYFM76xM3diAY7xZuAM3h913o3
 2tTXOs+X5v+xX4270n5utoM1qx/0E4IlD9ZgIpqlIHiXSs0mqigL4xTaFoNEnwK9ZWWcLPz9t6O
 8ECOymxiIIMrc3w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=V5tNF+ni c=1 sm=1 tr=0 ts=6a301f49 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=tpKvEUOkdOp8HkJiz7sA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: oVZkP65r4ALFHJfDWdMdWZL3tHtKU0sv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX0bu4j7rBtQhL
 3WpRRxeU3oNxwP97ahT/Jiscld64nVLZ/mwekED4xPqdfAsHtsvvgm4HSFIWuu8Z8NSU9WwRwXo
 saSrNiR/h4KSA5/iVTYwvN42Th5tW2s=
X-Proofpoint-ORIG-GUID: oVZkP65r4ALFHJfDWdMdWZL3tHtKU0sv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfXytfo/it5uji0
 C+/ypuB8zoJ0q/I2DX0QfeaBOv3Ws0qPcTXa4KEam5BsVdB2wKRmuXwiHaF6FsaQNnErU7gsjb/
 zwlemzrga6jMJmdDd9H7+vU71SLIxhqsYCc1nhKHIuUKs16VqoJ0MHCnYPBP3n5ScSiXGJZshN3
 ITbNSrYTE28ozp1yYjyO3OJ+Kj6E3vVUD/wfIPqgmMmeP72Xxntp4XqYkx2ZV+A2Zo1dzxGh4lQ
 EMHku+qf2hFDlHknR75tKkqF1+mwwQm3bU0o7yjhVgZP87FdDHEJTOu4gVy3Q0z0OmGSGrBEcet
 2biNNSD3zZtP+jl0p75vZga6WzpDnQpDgttHmZK0I2DGkmVyQk4WAljIJRh1XCXjKZDsKz4nZsI
 /EZLq3nBDSdl5sNKV92oReZxieuZajzZKrTZ708molzo4lEyLCiej5CMiSI9wbgPvd113MjASFf
 UX8uV/oi61I/JyxwibQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150167

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
index cf34278da30b1ffccf230ed194faae2352cb8550..e152a5b559c373b1bd6730a019bbd55609bc45d1 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -14,6 +14,7 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/xts.h>
 
 #include "cipher.h"
 
@@ -196,14 +197,17 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
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
@@ -279,13 +283,15 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

