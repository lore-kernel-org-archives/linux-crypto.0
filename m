Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E340E4908C9
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045310; cv=none; b=IpGhmlKGtzl1jEtl4XY/vsaBcBN+ZAeeYXRrQYDxqVXAUKmL2I8tbSyDlXtXjISpNsHdnx5mfCSBI18QlLEVyCCxQm0EjAEmDccL9UI935Bn0ZnnCdIpmCz366aTMZ56tmZVAtSFSvAhNgc9HuDp5Lu2G7brpRL5N8IZb7SbBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045310; c=relaxed/simple;
	bh=KW1xboFDIw7GUw5/K1L/QGR8hCZPAPAXS2iVODYVr6I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o//ieNY4WlN6/6xwU1I77znw9dYC250OwH4/mSqtfgbkB8ofQCE8+0vD15Fyml4I0TrEUB3dLS2OHL+U8meBIdKw/IC+bpuze1ia3JM8MQiO0fGkIszRMYj0ePcZyBN47Bg+CPaXUu7DoKucKbX+RKYVdYWMGlFdUtk7TP9wEhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PhSy16JG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gNB1UM1e; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PhSy16JG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gNB1UM1e"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7kbt1242013
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7EU+wkow0wdDIWrKXMXcNY/o+lSeS9qvjpj3PNv9N8s=; b=PhSy16JGud3aN7Ip
	AajNj3x+7TjwIXShzDgfhQFg/k2CkB/mpnV/gXBBxNPwU6i35orUQxTdOjbuqQYO
	w2kvHD+jsePLgSvADwNNRAenyh7SQxPCv5ghlsnuG3c+cDNWArWvPqiR3LExXItd
	5KAOkwYjjbQ6juGcQ/FmkVgJkdeYgD3WX5Y+/prmmgX5t3fNkFdE+ho8sax3dkIY
	x2YHFC+KIYzKuIyVLiroEluZN/20z8dtm9MGdVll8A4hZ1GAxena8bMcvMoTKK/t
	md7ZyLhd0BMrUfqqdUEQswhY+k/KchyKzgVk5J2OulkZgUC5UG7U5NcBGw/QaSdW
	cMRvPg==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrcjs7eg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:44 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c7b0f8e40bso7496163e0c.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045304; x=1789650104; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7EU+wkow0wdDIWrKXMXcNY/o+lSeS9qvjpj3PNv9N8s=;
        b=gNB1UM1eLQIIf/rPiikHFaCrAy/YfUl9M7tH0BVkcHV+qo643R1Jl3yc123kyEaoHE
         DN1qEhf/uwv3vkB1Kf8wA/paixesc9B1iJ0TUGNTQXTNN0K47SkAgsbO9xzbak3NMvaM
         PXIoZr3UiRzbsmetW7urY5ynYX8Mt+bVZPY95l0FdIQMwOU6/mMuzHryaX8cfm4eIMmY
         EK+paQ/dmEuekgH/do3vUchphLrrgkbi5LvrMR+cp4CtR3+fu7IRUQA1I8sVimac+081
         Rmi2qlW4uwRKUADSIWehcwcCp4p4MqA5qA+qajJbmR0FexQySRpAnvRYSdfW5Axfpjds
         Y/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045304; x=1789650104;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7EU+wkow0wdDIWrKXMXcNY/o+lSeS9qvjpj3PNv9N8s=;
        b=ooD+nTiLenjfTyJbXW195+iqxWJe4p29CAarUTgE2lY3zNW5HqTeh18/6u5Njhdbij
         WrWkDWoVtl+yqj6mLPqUqAa/Cpce+QwHjDcHdF5eWPanVADRYAyxCZ01G6XO/AEY6fCn
         B/8z1FNU1GMrRjJWtL+RX3a/sD/Oe4d8ZVmiqSG8fPlK7aqSW0lzNhAUPnm6GeTvt9DJ
         NOE2g/Fd8jnP3XcgwhevpNIqMAsooIN2cwRhRRogeicDc8aukQuF3X9wfYhCAOGxOznx
         1nit4FyDuRi7oH8EQgKASRcCx7mrETMUaxUvfjqbpiqcG2dNh1iQGQwl1Fxty1tDOrNZ
         s1xA==
X-Gm-Message-State: AFuF++lQO/OMetLATvSV5Hs00SPpH8MdVjefyuYbPrC5mlfuGy3P8FRQ
	DHu8Ss1N+9h7eloWAfX+I+6HeA9oC5WkIBh2lY1Qb5EUAg/+J/KlTCLip3iE4YqSVPwGasiz7Le
	hUEksH+S6OBJ4EVDVEZNxJpIkGmJpoyygaaOLr6Qe2ZX/Z9g+RoS91ClREsCQEtHYdkQ=
X-Gm-Gg: AYBFou2IG4bbrsmb3bA774kkXnwjQAeTJAgUlu+e0+F7tsZ+GFNlNNrQZZnykV4C5o3
	mDtRt6yXsv/ZLfdRJ1dD3Tz8mqEx45yrGpV++XVmHejPQxPQjbr42oQSYXMKa8cfHeR8fuDl2a3
	HJf/nKxIOtJd2Xf0jZK/t4VqgihqiokSygEa1tZX3P0fKqNtds/012vFekZhn5P/XOz1vUgUKqi
	gUTjKCEIH91X6c3ALrT2mhD71kval0gEGGTB90oWQJXlTeFglT8HGjgyFvEJSCC5+r1PIJjkC8S
	9/JZOdg8lSfYqtsb5S5DUAOWXk8Dx3m7M85nF1ybcqBZakmgukmH52eStObNQEJn6KMFMouZeBF
	x1EAsjWTo0LnYDbNpTLNvY2wCCiLg
X-Received: by 2002:a05:6122:881:b0:5c5:db2b:5baa with SMTP id 71dfb90a1353d-5c7ed7cba16mr23879181e0c.6.1789045295649;
        Thu, 10 Sep 2026 06:01:35 -0700 (PDT)
X-Received: by 2002:a05:6122:881:b0:5c5:db2b:5baa with SMTP id 71dfb90a1353d-5c7ed7cba16mr23876494e0c.6.1789045286926;
        Thu, 10 Sep 2026 06:01:26 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:26 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:47 +0200
Subject: [PATCH v7 06/12] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-6-cdbd2718af14@oss.qualcomm.com>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4152;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=LHxn8qZQ7172JYTQczFIpOi+jAmwYv5eGxN5U2DeL2I=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoPgcYYNiS9bUT7TKZOvXgiycY+xCV/pgRGj
 9yf2ltWAsKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqDwAKCRAFnS7L/zaE
 w1sIEACsCiS++eDUogxIPE2LIXSNpcedycPtCM2m5ypQYo0berGKN7DnBkEt62W0a6zrMGKwx7w
 ifuQwMzYrEJHbkcA6siFI8kgNIn1ogCka5vvbHmLRmj7TCo4MGVaIJz2t7CE6rcBtH3lShR2mLQ
 EgD0VWSw0wEQcuAKBB8/MU28JXRDirKeIcuyqzmAt/Vv5JWnc0ETq9MwKs79e9VntK9D+XTgCCW
 Y0xNniIyWz2CC611h8tHPylhx2lNGJlMMhxZ/7sHQbqbgO9mXcUoWKnu180tse4Mv0HMXb+XkLJ
 c5+AK6dsKpMKMtSyL3cTjGiusL1HOzvpWdrDDOg4vQE3vX7wcgWffRjgTeJrTi8m3unLgVMYwA+
 HMB1urFNmPRWzzB4buwpHiPOyH1mpOBIa5aP5WXPI3YOUOOO2MiEeF2zM4x6Y1JCXs0v24VMkQU
 ao1dCjmNLy1ymqSwHt6Z+L38iGCQkoq5/3dbdRYA1jciT3jlfYcy7BGsv3iQqi7CXcqb0aFFxzj
 CO4F1om6lfNtEQ4WrLuOrxe4QKVbPC//oQwpHwnTfOLF5O8zrccrHxyY3AO3QuR9IQ60rwEN8Rx
 84UbgCqSTSNMy3/AQ7bFSz0poa6gU2aSqLEQRhg0zdu1DshnJIoCWUtNwTE90yKsA6POk5BqnSl
 QfT5+JYR3phTK9w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfXx7zzmWrPm5wd
 0vB69NZVc/lpDGNw82bbFLmNy/aQ4doQxkjtvJU06KK1gqYSOIoDUAk5sat+zqSENelYPg+aR8W
 0dObfqC+d37wRFD3eMsCFvYHxxed3jk=
X-Proofpoint-GUID: Cq5teENdUynPpTMoxuVB-ql9y5xrmeGT
X-Authority-Analysis: v=2.4 cv=aef0Dhot c=1 sm=1 tr=0 ts=6aa2aa38 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=tpKvEUOkdOp8HkJiz7sA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX55g2sf5YKOEP
 +fnUKmLMQ+YTOBoW+Q1U0LAemn+fRxWHkmFEu6vcz8pqRr8jSp4fiMFhRH2PycJFDGin/dcvuKu
 TqQLMr8EgZ5hJizq0Cjn56WLR3seA98i+TY8i0AvpMsJTcB06lKu3q4CeHy5eJQb28W2acTuZCW
 vzZmSiy9xsqfP4OkT8qnypJse/5+cG9TLSYRm4tyAius4Zqbv5CUPYzxc63V+XLUDr3JyT3y3Na
 ZkZIY66Dr1bezTNk4FomjorkfczuOunrbD//sVWvPwp8UaWYi5/cBLEMCdkI8C4V52Y7b1fm2AO
 /6Vzj6LoMAORxblOry4HFNkWMPFDl/xyy1njH76FTIfzRYTbfnAq9Y1u3R1a9nL+Pa16G9ulfJ4
 I8dNbO7sGK0YBjF8dcz9ngCanojayTcJvX7EcF5deYaKkf8FrhGYJopumbtBnk++xnLlSzd6mdf
 u2qm1P6nMNc1fB3o6oQ==
X-Proofpoint-ORIG-GUID: Cq5teENdUynPpTMoxuVB-ql9y5xrmeGT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100156

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
index 4b7545e6aed220b7fb5af7dbf20ab47db5d1d180..35bd59656931c5f12614405490f1e254849b9eb5 100644
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
@@ -261,6 +265,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * AES-XTS with key1 == key2 (not supported by the CE).
 	 * A payload fragmented across more than one scatterlist entry (the CE
 	 * stalls waiting for input in that case too).
 	 */
@@ -270,6 +275,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
 	    req->cryptlen % QCE_SECTOR_SIZE))) ||
+	    (IS_XTS(rctx->flags) && ctx->use_fallback) ||
 	    sg_nents_for_len(req->src, req->cryptlen) > 1 ||
 	    sg_nents_for_len(req->dst, req->cryptlen) > 1)) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);

-- 
2.47.3

