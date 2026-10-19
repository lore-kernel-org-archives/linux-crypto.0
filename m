Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050E74D73AD
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421203; cv=none; b=gL4nCyhzJ+6hgyPMOzTzDputIiW3SPLMH0zQBGo1Z71YHgEU8Xcb1RxCZLyKlz56HJ6pa+0ktWVGqe1TajTtipGrhEbtImBWYcE6dPUMyQiyZdnj8Hhf/oNTPHhZGijzlYV0sZ59oG0dsb0t7MqzgrYWtyA7l2LvYlZ3l/xRSY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421203; c=relaxed/simple;
	bh=E5Fbf/QkWWwUjqCC21szVwaaGkNlUMqr3/Wm5W10eRs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZJzRcw8FCPx0AslMBjaR4/pBuUgvxzICFd1FdPQpuBuCHEqrZucEfeQAJR57y9wn1ae9oRECpvEhCNmiGFtwsbcB1bCme2RsvjdLdUyh5rSpj+xu4SvhxZlTlIF7prsRPtm28EdbYRpkEXNYEl25wTSpL/nr/sVT7g7ohzGBRag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LDQTci4y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ov0SLQ4j; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LDQTci4y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ov0SLQ4j"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JE0dbp2081641
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t+RbyfjZ7LBBQKh9pD9wNxpuKWrOuAih17ZkNLZnWO8=; b=LDQTci4y6e7TXQww
	nm+cvTQAM1UvEMCGuTSEJj36EKdZrtXfyHZaP4gHvYCjh9l4sl8cLFO4aBpyXmrR
	7FsUFZ5oRKgH0VbadJIWqdk/w4wAGSmLqO6nwdLItV75GqVTkG9JcZHZlG1qFJY4
	BZvb+bJl7aAoGrPprZeMDkMEPbacS/X/Q7/k+BccxlKxtNgyvyTx3PY7/DgWMRb5
	NGCFHsEktkan6FGvNbocyfAwS1ACi1Pi4FyNwOz7D3I46a9pkDixCaH+1Sa6K7+5
	BbLXfaQihqjGUqo7BOm27GDrKPDFWm0tSSLcw9co24HH5rb9bawXTsNPLo/mWclk
	ebSTbg==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdf4rhpnh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:39 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5eac74b0596so958426e0c.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 07:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792421198; x=1793025998; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t+RbyfjZ7LBBQKh9pD9wNxpuKWrOuAih17ZkNLZnWO8=;
        b=Ov0SLQ4jcBH+bGf94lg0WResJQO39WUtfu5D8eM3bq20IcMqUnMn9vuh34s1L7ulTk
         +wxXKbr5xLn45iRJ2qIqrsl4D/Vls7/JoVVJipg8c10fGrySffwZ36qCTC0GRXitJK35
         ZycAO+XHKyLQFegVFC/lzToJwHjaLAKVWgppa/J4C2FtuY0kfCFHTtRLNNXDclvD6nfi
         G2FrhCHhV/EyFSlFoMYbxgia0SDfGStzpJZYHVZ6cqINcMIJtUb0ryHVHx53nkKVZISf
         RBnrymjP1l5tBkgu3l879B4WZ2RDZMKdk6r9x3DJdi5zKJ8tKI2HEIvPyaJJyNz23PyI
         hZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421198; x=1793025998;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t+RbyfjZ7LBBQKh9pD9wNxpuKWrOuAih17ZkNLZnWO8=;
        b=jA6SUeBy1xrhv9+WY1NDT4MuFM0q0RQ2IMRoJHp4qxWVPYRTmmtYS+qFhV9aRrfhAu
         h9JX0iX437blY1IqT5ML8F3TtbbuWyje/CdEaC1Y2NxCbwd278/I8lqau0/IqmOPW4Ix
         9xhmoMimRd+L71/5x3A9hYb1yFdvI3j/hJcUdREy2Z1VdVUjiMLTwzUe1J+f2KrGBTaL
         TJEYQegEaGPdE5JlPxJQjM5r3luW/8Kz47GWA0VLBY7l+4OdGXg69QRkQtR2IugOjFc1
         Em7R2YoX1VfBrdCGTG6tK4F3JbaZ3zAINtHn1y9SZfsJ9s9DNzg14rk5cwZlmdSq20NV
         AniQ==
X-Gm-Message-State: AFq9FYJUYywS0VhmqS1Mz0mw4mByNzxJKy+6k3HrXZMENT4IpnPyuWkN
	89ecX0u46g9eu5LUYLVM4FuddSnL/63LNF/OnJpe+Lax2snqTTewAEIcXManxMZWCtqXGiHNRIN
	7S0B6x2K7UkOyIg1atzT5K1CgRMDsiZFS9PvRwPjNv3atbUHr5zZvM0KykrRms+X//Y8=
X-Gm-Gg: AYBFou3SkbQa2GlyAdVtHPt9u93QyqLjm6AdF+flQJuZ7dihqcwHKFmwP9FTtuwnvy2
	kupqKhK8mGQVqWTQulyen93Of7KtZifFtNf1+bqOBtSTdpJYYGIcdmSpEWyKgxpxEimJ7empe+n
	KaiQHxHUxmZ1vBWRedli9/miZN80wmyFcYR9pRBM7fHBnuqAxPf4Kpf+X3MFf5nBNe0vVZEUhUa
	9Wleaa/zFAA51zzhZ3achrrRlJpeJZafSfhhkVFOZAa46xPCLTBkvO0ptDuiVIPbrabBFGtvmwx
	JCkQ9nxbnHf51+MZFBk83m9A/12e7cDeanTgMIuQlPtypGmQ4GdwyserR2InTYOoRcGoEWXmb7J
	dOFMDCj++vhH/QBiPdHJMOzHaVUat
X-Received: by 2002:a05:6122:6d10:b0:5c9:c60e:3a48 with SMTP id 71dfb90a1353d-5eaaa941aebmr2385199e0c.20.1792421198040;
        Mon, 19 Oct 2026 07:46:38 -0700 (PDT)
X-Received: by 2002:a05:6122:6d10:b0:5c9:c60e:3a48 with SMTP id 71dfb90a1353d-5eaaa941aebmr2385173e0c.20.1792421197588;
        Mon, 19 Oct 2026 07:46:37 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1e7657d4dsm98504635e9.2.2026.10.19.07.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:46:36 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 16:46:08 +0200
Subject: [PATCH v12 4/4] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-qce-fixes-skcipher-v12-4-046e6be9bd83@oss.qualcomm.com>
References: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
In-Reply-To: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3273;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=3NHJ8gPshpVtGyKCy26VLa5sqfEiAXE+L5r0hvyOoY4=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq1i1DVmtrnemOVK74NOscJG4hmetXBpiqN0oqs
 zpV+apUYzmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatYtQwAKCRAFnS7L/zaE
 wz0BD/9yVOeylX3NVOmaz7C0ipSLnPraEBm9wR9nWWSBFR1RIw7H7yc0e02y/PoeyEcjsnQSnn6
 EuAhgw/FEJBF2N1Grzmy+suD9Jqgg2h7GhQOeutD2p/t8THZWQptwHL0SsQoiPAdY2DMsG6I/FE
 4PxKOgDPhEBeqOyjsWTc8nhqXesZjML/lvz0FKTiUdm0tTyZdWQmas5DFcxRSQqcgY7cgygdqKY
 6Qb0pBsBd2GWMmYUX75zldeV3PXZFpTaE2rbYz5NLxlo9lfVoyOASGZPUtRwtC9ybUqUXIGHwr3
 V444Fp41voR/aNXiIY8IuxeMfsBrmmfmITgQ48RtTsPuGtiTZ2badsKjofyg+gzeCoSqw8QD7dp
 OIa+Hy6U6t/50ZPg8v3IqG4TOavoOcmtpsYCOwVAIIwcPa/+OmFq6dci3RSibTFw93Mp8DGwpLN
 Xc2sSwuzGDrh/Ud2iQnKkWeerAsEwaAMfWDIBHCy1XhabOZAh1QsUBSPfO8ywuwau+uL3Pms+3T
 2eZu9ZAu2oujAd7Q6wQFCnPVTpf0AbKEIFAJsRtHBjkD+XCYQs1EZYeyCNm5t2CLPmUnC9dUzhD
 k97Ytt47Oa2VcXOP4bqFAdl85b3iRa1mQaUJQFO1oRA5NoaQAh+r4roD7llYgU0R7JnVAann4kP
 Y0hS5UfZP3lqInQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: XIlN7bur5sOru4F4hKwEP6QdqcXI2vu4
X-Proofpoint-GUID: XIlN7bur5sOru4F4hKwEP6QdqcXI2vu4
X-Authority-Analysis: v=2.4 cv=H7NOUOYi c=1 sm=1 tr=0 ts=6ad62d4f cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=09uMWaUiLw9_HUPRBkgA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1OCBTYWx0ZWRfX0tmtWrSeycQS
 uCKOuQtjLmQLKdTsDve7v2b5iJhgLRFM8FCHa93snpbUobEG7Hm2UpK4xoPTHeaoiVqcOn2/N7D
 5n8xaC8IEFDvx6pGcIYf+O3zf3+5DzYNeUpKiXfcibbeT0BE5VPZOhsNXig6C7OAdmCSCA4hk0P
 wGa7ZU60VXiyHl7lyZus7VVU0iTGwx1JboO5M7Xm1STTIylYP8daR6Xz53QigsTcPYSGELKB2BP
 ElwWgWMaHBZgjMECriSP8rslbq7eC6H8P8pvZp6ay/Kj65h+VLM69S8I46PpJPAGuh7gpzYCjIQ
 zgrPzA3mzfxmswuXXFJ5Nbxj+c9BpxN/xBb85pYydbbqCSe3c0YL1w/ZTP2+5FGjVljLwQkmHxo
 WJIYuJ/Y7cCZx902/708CdEnZRJbT10Ckn5G9uSTstmSqe/OdfX8u38eHSK37JuBRob2z7Grx/o
 6fn2nRrAynSmWTbvNJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1OCBTYWx0ZWRfX+jbbpVjrsvES
 W5eomJO2cb4Bs9E3WHl4xxnS+pv1JyCNbpjynY27RZl1gKuPPneHwgA45eZ3f8b0fX7GU7OtxWG
 P3qYYd2Lgwo7YewqIPn/cYEiIhRe+gk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_04,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610190058

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
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 6a8d642c40a36974231bc4aa2717a5378f17134c..79f764429edc469a4f06319b0113afefc96a5ae1 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <crypto/aes.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/xts.h>
 
 #include "cipher.h"
 
@@ -179,14 +180,17 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
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
@@ -255,6 +259,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * AES-XTS with key1 == key2 (not supported by the CE).
 	 * A payload fragmented across more than one scatterlist entry (the CE
 	 * stalls waiting for input in that case too).
 	 */

-- 
2.47.3

