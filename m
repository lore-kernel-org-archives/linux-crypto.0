Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E464E40961E
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538623; cv=none; b=jpZFVECs4Vs9tTv7sn4PZkALeIbvdaB57ueEPUilv9Lom8aLlCgDL9VvYoIoOOaWc2NGLMHmdqA/MgrfaGINwcHD+wb+IMNbahTofBoax2iXgWN1NQdkf2Xc07uz3rvho/JGYz/aVNA2TiDtfMdagHspbO2KJ5q4iLb/zeMEFeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538623; c=relaxed/simple;
	bh=gUz7eng+5EeisfywucJX9HX2YwWCzYjd8apsIj5JM0A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OzVx9lXHGP7SB4glF6u+mbcA4QcZYPxw/dNnKjAihNcpS9lppD7kO52U1uHf+2vgtfOX2sUNeyxEQsGIPFUVYCStdFOn0DVMrKfmxnPxAabq9MOoHoTek6a7w6mfzXKS109dUhH5v3H87VB+8Pt7puDcTYHIBN91sGrOtKX5l/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hYZoRNyU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IecVgbGD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hYZoRNyU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IecVgbGD"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFhM4W430424
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yiQAnvelUev4FMwTQSK7Ww98/yvliSzHli9X6AXfEso=; b=hYZoRNyU+dVqAdbu
	5aaXKoANe8nzgc1HLbbD9HfgoLjt5zyTGMcSylJencvZk3Xrm3BNaFEMnr0Szjx5
	LY/Jul3aB1r3kkjGOxjRpcB76+XctlW/QM8A0f8BYGZMvbZcGtwowNTUSeceMohk
	523oTJataIrkNx+kYKPTyIPoOOA7Eq9oglX80sQ0695D7aGPUTSq+fPVUCZhZ7zW
	6KjWtbxM173R4/4yim3u8O3hH/pSP9yttzAsvKn1esz/jysOO9jZRy0d+68xmgAL
	3OAq0de4etSTkxfScsGrY2AAXrhPb8f6LR29FJXScefLCoAePbu5HJu+9OJJsDbm
	41qyKQ==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eteyd9hn6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:21 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-6cfc66167c4so959587137.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 08:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781538620; x=1782143420; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiQAnvelUev4FMwTQSK7Ww98/yvliSzHli9X6AXfEso=;
        b=IecVgbGDjFOQvBQCJf/GQbaClGlIvbLwPN0+rijcUTSLvqvFpTkOsuJ+cbPrZZQbJV
         u8lU4PpkL+nygRppsJ1xXOsmYYtnxK+2P0ZEPKi1xRy6PdWjPCGbrR3DPHZhGvpGTOcq
         sbkkWcpHYYY0PCqmmOPTiZ5J+P2RYfeDSWejElrovdculzTWnc5A7NqV54xwnpqCsjY/
         TF3fNa/dDFm9P9/ZQjO6v1IotE/Hf52NUoFMQzjHSDK1MHO5gebqpcrHyNIJhBKir3ON
         rWAd+ZtAXiIy9P//4XXX261lX2L77Pu9H+L7lHCF3XtiSJQn+LHphwBanrorcabV9ulS
         RUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781538620; x=1782143420;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yiQAnvelUev4FMwTQSK7Ww98/yvliSzHli9X6AXfEso=;
        b=bFDW1/Sj97FqKAbcrNGOgNiWSM8zQdaXLqm3+iTo4SIXs4l34XQiXWTBAFZfKt9g8K
         7ibF/kXHqPmE51PcXxAhfHVjQ5Doxs7RhHqTR27rU20ud6uacO3FIUvAp9brfW3ss1++
         UyZeriHX941iIwnLMz06msZfHxFj+reu4Mh7nt9R2332pN6RSsxrl3vYvg8C2DHYsKgb
         TPCiS+Oz9fT4XAYj8bfzM1bwCFddZIjyUnZAoiS3A6YudcBYUFdkh9ofBf6tQCeR5wzs
         q7MtXe1UhLS8FzqN2dgRJrrOwWyq70ig1E5aEWyev1DNNyYm44L3f7M2Fgz019+rf3P8
         y4yg==
X-Gm-Message-State: AOJu0Yy7nH+V0vSSWfM/x5CgdM8k876afGz8TEw8v3rZ0zYXPoixsE5J
	XIOy8ps9N0BvDH/wN/gSVosMhwTaSyhsGoQbfjUqjxc8sjhlkqq+Zpvo5ECzh1mAdiBd/yzY0BX
	rm01TnKxTFUkYz5iODrDYYLUO9rgOFgqhR/dVlhEDHoMydmMUDxQhItnrCKnlmq8qhxrnE/FbsQ
	qg4Q==
X-Gm-Gg: Acq92OEsQw2z6LXzn5RH2rbvITUzGtwKy+LsVm6bdvokLqmPvDYm1ldbhN0uyNTxzz9
	NQoy/uR/XtpwGV9ciM07ftuRYANm8Bp5QGjUaAtHNiNdHBWnTjEIOFtdsPAxZkuGjaQcdIStzW+
	9ijIeNvGkKZy4FIHVqmUlgkjT6E4qP1jxzOkKmt4Fvr6EO/2Q9JymidUFcHFvIVt9ThgjZeh8fq
	3bm0Qd2jd9GInm8jQqbTJUFS4ay7kvg3Vfa5CoJgvQwzPDdHVtmcN/UPpbzHmWcK0ftmK9okZuj
	vNgfQ4lyfN+nzZsyL3+q0apLSBhOeDGP5Nq6n58l1mYtulPojTQ83DJULVH6/C9fhcXjclaCNHd
	sPBqnfFnPEpKgiaUWi+5g/wyUwaxQ18JQhKVAEGTY/dFr2JWDBMo=
X-Received: by 2002:a05:6102:5a87:b0:6c8:aed:ca95 with SMTP id ada2fe7eead31-71e88c3d357mr7729289137.13.1781538619967;
        Mon, 15 Jun 2026 08:50:19 -0700 (PDT)
X-Received: by 2002:a05:6102:5a87:b0:6c8:aed:ca95 with SMTP id ada2fe7eead31-71e88c3d357mr7729255137.13.1781538619426;
        Mon, 15 Jun 2026 08:50:19 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:7fe3:eaf0:5a0b:2610])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm38643032f8f.10.2026.06.15.08.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:50:16 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 17:49:52 +0200
Subject: [PATCH v2 1/8] crypto: qce - Remove unsafe/deprecated algorithms
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-qce-fix-self-tests-v2-1-dc911f1aad42@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13388;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=gUz7eng+5EeisfywucJX9HX2YwWCzYjd8apsIj5JM0A=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMB8s1rXKQfHba0GydG7LGxObS2QtW/M7yUBVA
 wE7GjnHfciJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajAfLAAKCRAFnS7L/zaE
 w1REEACZxHEL1pt89DvxhcgyU8+7h8pMOCIjVP8miQtztGO5hMcNQ5bvVlAGUG1y4O0DQdKBfR9
 kRhmokbfOFEQtzmLQLxdr9/Sq3Y96Da4M09j4hRsgRyA9ZVoa9hCw3Bql0amMay2Wnms5PHzggr
 snH+uJl8lKvHdQMf52Pq26AqIF59r61RUDKh0qHqYhvabGBMIjStWaqm6zyng8Z2npm9k4MMvNU
 O0tyBTZyhr27lpzaDthnzW2erD++cAJ4ahRp/MIiTlRTLOnrfaImNswlo4JNJ98bt7ZvXRu93vh
 Wj/VVqZ6DPC1zyi+piom+ucZ2kAN4EBANo7o4tWTTlVXZ7eDCi/lp2n6uu0LHN6Q75TCvJNilln
 cXrhUeSU15Yau1hUrkgwtOxBmtC08J3lkwqq/b4iHXUQS9Fo1n9xPGV3L0xGDS71NQmdFz0/sP5
 4B6uOaL997Rdwst5Zm7d9oVMx+pFVBrYqzchmVLkNyvQPebsgjacaCWE0+5FKp2I/dA8RpxCybg
 GnoLcj4FlIkmhL5eSIcU0R8yNnL1ANnu6n5aj1AboxecLKDTQ88m90RpUStqqDticQxbwfoJQAh
 qqElv660GOemuglzg3iMmGWH7o/OYyZGxZaUgvznfoUYi8+PT/YnFphDs3dt27jYde2v+ahkBZY
 D49FBP40unZG4fw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: FKZ6c8Vw4PLxQHgbMUWumHS9P-Xb5xeH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfXzWDje+OPnBgz
 D81Xv0Z7hdlvfBYnZK8996hYUPH29PTkrShDMvw8wGd70jUB5/wOce1mKtX/nAtkWmXSXKSf/Kn
 5AVeH9UqXCNkiGGAxJGwlkvxX2CE0m0=
X-Authority-Analysis: v=2.4 cv=QrJuG1yd c=1 sm=1 tr=0 ts=6a301f3d cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=91fC_bt6uKvsHZUn1M4A:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-ORIG-GUID: FKZ6c8Vw4PLxQHgbMUWumHS9P-Xb5xeH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX7VxTHCpREDZ0
 bIe6NVllCgchAScWGWRxEwos+x6QjDHFjQRbK3vGiKS1meBzbaIvhJhp2RqqCDqG+d5h3VK/Tsi
 h0ELOeLXeic+a/JDhvrfEyrZ117dcdW7uHPV7z+KOvKtW7EIILxHRjTWpzhck8v3q+0hEVpG4sy
 m+vW8TVgWrlZZMQZHdXh4IAFlUdX1xpBAHlpFnGx/9HW2N+tnuKfX0LoguWnyK3j+D3QpoDaW5+
 nGitf/d9kgHJ6pT1tNj3MkkeUiu8jMRY7R/lHsxIMfsIjEGX3noWibOl7OcBHmouOxVLYM1WHeb
 Z5fuNN1XvSE4nQI1D6FXCR4E6ugaN3fnR3qLpgjOIivdJ9+HPnzLbFoO2LZ/BUhd7C3ErkRzLbN
 Ok39nTgVUeGS7hMFmkES+JWuhV9FjQFkqRM6HdptV6dqJ3dC/Sy7RPHDNv18BQDQU0HqKFHdsok
 +PpGI2gQTTtUdpWcvSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150167

Remove algorithms that are either unsafe or deprecated and have no
in-kernel users that cannot be served by the ARM CE implementations.

AES-ECB reveals plaintext patterns (identical plaintext blocks produce
identical ciphertext blocks) and should not be exposed as a hardware-
accelerated primitive. DES, Triple DES and HMAC-SHA1 have been
deprecated for years.

Remove ecb(aes), cbc(des), ecb(des3_ede), cbc(des3_ede), hmac(sha1) and
all AEAD variants built on these primitives. Also clean up the - now dead
- code, flags and constants.

Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c     | 40 -------------------------
 drivers/crypto/qce/common.c   | 27 ++++-------------
 drivers/crypto/qce/common.h   |  7 +----
 drivers/crypto/qce/regs-v5.h  |  1 -
 drivers/crypto/qce/sha.c      |  9 ------
 drivers/crypto/qce/skcipher.c | 69 +------------------------------------------
 6 files changed, 8 insertions(+), 145 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 03b8042da9a1b4aebdc775ad8ab912abc7b2383d..6a511e5d7f6290a1df0093e463f39f5f2db25f88 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -592,7 +592,6 @@ static int qce_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_authenc_keys authenc_keys;
 	unsigned long flags = to_aead_tmpl(tfm)->alg_flags;
-	u32 _key[6];
 	int err;
 
 	err = crypto_authenc_extractkeys(&authenc_keys, key, keylen);
@@ -607,21 +606,6 @@ static int qce_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int
 		err = verify_aead_des_key(tfm, authenc_keys.enckey, authenc_keys.enckeylen);
 		if (err)
 			return err;
-	} else if (IS_3DES(flags)) {
-		err = verify_aead_des3_key(tfm, authenc_keys.enckey, authenc_keys.enckeylen);
-		if (err)
-			return err;
-		/*
-		 * The crypto engine does not support any two keys
-		 * being the same for triple des algorithms. The
-		 * verify_skcipher_des3_key does not check for all the
-		 * below conditions. Schedule fallback in this case.
-		 */
-		memcpy(_key, authenc_keys.enckey, DES3_EDE_KEY_SIZE);
-		if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) ||
-		    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) ||
-		    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
-			ctx->need_fallback = true;
 	} else if (IS_AES(flags)) {
 		/* No random key sizes */
 		if (authenc_keys.enckeylen != AES_KEYSIZE_128 &&
@@ -693,22 +677,6 @@ struct qce_aead_def {
 };
 
 static const struct qce_aead_def aead_def[] = {
-	{
-		.flags          = QCE_ALG_DES | QCE_MODE_CBC | QCE_HASH_SHA1_HMAC,
-		.name           = "authenc(hmac(sha1),cbc(des))",
-		.drv_name       = "authenc-hmac-sha1-cbc-des-qce",
-		.blocksize      = DES_BLOCK_SIZE,
-		.ivsize         = DES_BLOCK_SIZE,
-		.maxauthsize	= SHA1_DIGEST_SIZE,
-	},
-	{
-		.flags          = QCE_ALG_3DES | QCE_MODE_CBC | QCE_HASH_SHA1_HMAC,
-		.name           = "authenc(hmac(sha1),cbc(des3_ede))",
-		.drv_name       = "authenc-hmac-sha1-cbc-3des-qce",
-		.blocksize      = DES3_EDE_BLOCK_SIZE,
-		.ivsize         = DES3_EDE_BLOCK_SIZE,
-		.maxauthsize	= SHA1_DIGEST_SIZE,
-	},
 	{
 		.flags          = QCE_ALG_DES | QCE_MODE_CBC | QCE_HASH_SHA256_HMAC,
 		.name           = "authenc(hmac(sha256),cbc(des))",
@@ -717,14 +685,6 @@ static const struct qce_aead_def aead_def[] = {
 		.ivsize         = DES_BLOCK_SIZE,
 		.maxauthsize	= SHA256_DIGEST_SIZE,
 	},
-	{
-		.flags          = QCE_ALG_3DES | QCE_MODE_CBC | QCE_HASH_SHA256_HMAC,
-		.name           = "authenc(hmac(sha256),cbc(des3_ede))",
-		.drv_name       = "authenc-hmac-sha256-cbc-3des-qce",
-		.blocksize      = DES3_EDE_BLOCK_SIZE,
-		.ivsize         = DES3_EDE_BLOCK_SIZE,
-		.maxauthsize	= SHA256_DIGEST_SIZE,
-	},
 	{
 		.flags          =  QCE_ALG_AES | QCE_MODE_CBC | QCE_HASH_SHA256_HMAC,
 		.name           = "authenc(hmac(sha256),cbc(aes))",
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 54a78a57f63028f01870a3edeb8e390f523bb190..b1f8cf7e0d22ff3c19bb92bdc0154ed403f4c2f1 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -115,7 +115,7 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
 			cfg |= AUTH_KEY_SZ_AES256 << AUTH_KEY_SIZE_SHIFT;
 	}
 
-	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags))
+	if (IS_SHA1(flags))
 		cfg |= AUTH_SIZE_SHA1 << AUTH_SIZE_SHIFT;
 	else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags))
 		cfg |= AUTH_SIZE_SHA256 << AUTH_SIZE_SHIFT;
@@ -126,7 +126,7 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
 
 	if (IS_SHA1(flags) || IS_SHA256(flags))
 		cfg |= AUTH_MODE_HASH << AUTH_MODE_SHIFT;
-	else if (IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags))
+	else if (IS_SHA256_HMAC(flags))
 		cfg |= AUTH_MODE_HMAC << AUTH_MODE_SHIFT;
 	else if (IS_CCM(flags))
 		cfg |= AUTH_MODE_CCM << AUTH_MODE_SHIFT;
@@ -191,7 +191,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 	else
 		qce_cpu_to_be32p_array(auth, rctx->digest, digestsize);
 
-	iv_words = (IS_SHA1(rctx->flags) || IS_SHA1_HMAC(rctx->flags)) ? 5 : 8;
+	iv_words = IS_SHA1(rctx->flags) ? 5 : 8;
 	qce_write_array(qce, REG_AUTH_IV0, (u32 *)auth, iv_words);
 
 	if (rctx->first_blk)
@@ -243,15 +243,12 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
 
 	if (IS_AES(flags))
 		cfg |= ENCR_ALG_AES << ENCR_ALG_SHIFT;
-	else if (IS_DES(flags) || IS_3DES(flags))
+	else if (IS_DES(flags))
 		cfg |= ENCR_ALG_DES << ENCR_ALG_SHIFT;
 
 	if (IS_DES(flags))
 		cfg |= ENCR_KEY_SZ_DES << ENCR_KEY_SZ_SHIFT;
 
-	if (IS_3DES(flags))
-		cfg |= ENCR_KEY_SZ_3DES << ENCR_KEY_SZ_SHIFT;
-
 	switch (flags & QCE_MODE_MASK) {
 	case QCE_MODE_ECB:
 		cfg |= ENCR_MODE_ECB << ENCR_MODE_SHIFT;
@@ -343,9 +340,6 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 	if (IS_DES(flags)) {
 		enciv_words = 2;
 		enckey_words = 2;
-	} else if (IS_3DES(flags)) {
-		enciv_words = 2;
-		enckey_words = 6;
 	} else if (IS_AES(flags)) {
 		if (IS_XTS(flags))
 			qce_xtskey(qce, ctx->enc_key, ctx->enc_keylen,
@@ -393,10 +387,6 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 #endif
 
 #ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
-static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
-	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
-};
-
 static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
 	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
 	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
@@ -473,13 +463,8 @@ static int qce_setup_regs_aead(struct crypto_async_request *async_req)
 	/* Write initial authentication IV only for HMAC algorithms */
 	if (IS_SHA_HMAC(rctx->flags)) {
 		/* Write default authentication iv */
-		if (IS_SHA1_HMAC(rctx->flags)) {
-			auth_ivsize = SHA1_DIGEST_SIZE;
-			memcpy(authiv, std_iv_sha1, auth_ivsize);
-		} else if (IS_SHA256_HMAC(rctx->flags)) {
-			auth_ivsize = SHA256_DIGEST_SIZE;
-			memcpy(authiv, std_iv_sha256, auth_ivsize);
-		}
+		auth_ivsize = SHA256_DIGEST_SIZE;
+		memcpy(authiv, std_iv_sha256, auth_ivsize);
 		authiv_words = auth_ivsize / sizeof(u32);
 		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);
 	} else if (IS_CCM(rctx->flags)) {
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 02e63ad9f24557c2238caa70b0ec521d49da4f13..c96d907d524725e7738d199a1d345d943d2ca360 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -34,13 +34,11 @@
 
 /* cipher algorithms */
 #define QCE_ALG_DES			BIT(0)
-#define QCE_ALG_3DES			BIT(1)
 #define QCE_ALG_AES			BIT(2)
 
 /* hash and hmac algorithms */
 #define QCE_HASH_SHA1			BIT(3)
 #define QCE_HASH_SHA256			BIT(4)
-#define QCE_HASH_SHA1_HMAC		BIT(5)
 #define QCE_HASH_SHA256_HMAC		BIT(6)
 #define QCE_HASH_AES_CMAC		BIT(7)
 
@@ -59,17 +57,14 @@
 #define QCE_DECRYPT			BIT(31)
 
 #define IS_DES(flags)			(flags & QCE_ALG_DES)
-#define IS_3DES(flags)			(flags & QCE_ALG_3DES)
 #define IS_AES(flags)			(flags & QCE_ALG_AES)
 
 #define IS_SHA1(flags)			(flags & QCE_HASH_SHA1)
 #define IS_SHA256(flags)		(flags & QCE_HASH_SHA256)
-#define IS_SHA1_HMAC(flags)		(flags & QCE_HASH_SHA1_HMAC)
 #define IS_SHA256_HMAC(flags)		(flags & QCE_HASH_SHA256_HMAC)
 #define IS_CMAC(flags)			(flags & QCE_HASH_AES_CMAC)
 #define IS_SHA(flags)			(IS_SHA1(flags) || IS_SHA256(flags))
-#define IS_SHA_HMAC(flags)		\
-		(IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags))
+#define IS_SHA_HMAC(flags)		IS_SHA256_HMAC(flags)
 
 #define IS_CBC(mode)			(mode & QCE_MODE_CBC)
 #define IS_ECB(mode)			(mode & QCE_MODE_ECB)
diff --git a/drivers/crypto/qce/regs-v5.h b/drivers/crypto/qce/regs-v5.h
index d59ed279890621a8e2e6f4cdb20692dbf39f1461..11a6f3db3ffd05b97a2b9fc0989d954a904c4cd5 100644
--- a/drivers/crypto/qce/regs-v5.h
+++ b/drivers/crypto/qce/regs-v5.h
@@ -285,7 +285,6 @@
 #define ENCR_KEY_SZ_SHIFT		3
 #define ENCR_KEY_SZ_MASK		GENMASK(5, 3)
 #define ENCR_KEY_SZ_DES			0
-#define ENCR_KEY_SZ_3DES		1
 #define ENCR_KEY_SZ_AES128		0
 #define ENCR_KEY_SZ_AES256		2
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index a3a1a205aaf8559a04809936e2a3b7d564c16c53..dc962296139da334c00237e44290356023cd7420 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -430,15 +430,6 @@ static const struct qce_ahash_def ahash_def[] = {
 		.statesize	= sizeof(struct qce_sha_saved_state),
 		.std_iv		= std_iv_sha256,
 	},
-	{
-		.flags		= QCE_HASH_SHA1_HMAC,
-		.name		= "hmac(sha1)",
-		.drv_name	= "hmac-sha1-qce",
-		.digestsize	= SHA1_DIGEST_SIZE,
-		.blocksize	= SHA1_BLOCK_SIZE,
-		.statesize	= sizeof(struct qce_sha_saved_state),
-		.std_iv		= std_iv_sha1,
-	},
 	{
 		.flags		= QCE_HASH_SHA256_HMAC,
 		.name		= "hmac(sha256)",
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 1fef315a7105c869e7fc6a60719087b721e78bb3..eff80ad5cb943c5b2e1e293c723bb1b31102b006 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -224,36 +224,6 @@ static int qce_des_setkey(struct crypto_skcipher *ablk, const u8 *key,
 	return 0;
 }
 
-static int qce_des3_setkey(struct crypto_skcipher *ablk, const u8 *key,
-			   unsigned int keylen)
-{
-	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(ablk);
-	u32 _key[6];
-	int err;
-
-	err = verify_skcipher_des3_key(ablk, key);
-	if (err)
-		return err;
-
-	/*
-	 * The crypto engine does not support any two keys
-	 * being the same for triple des algorithms. The
-	 * verify_skcipher_des3_key does not check for all the
-	 * below conditions. Return -ENOKEY in case any two keys
-	 * are the same. Revisit to see if a fallback cipher
-	 * is needed to handle this condition.
-	 */
-	memcpy(_key, key, DES3_EDE_KEY_SIZE);
-	if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) ||
-	    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) ||
-	    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
-		return -ENOKEY;
-
-	ctx->enc_keylen = keylen;
-	memcpy(ctx->enc_key, key, keylen);
-	return 0;
-}
-
 static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -359,15 +329,6 @@ struct qce_skcipher_def {
 };
 
 static const struct qce_skcipher_def skcipher_def[] = {
-	{
-		.flags		= QCE_ALG_AES | QCE_MODE_ECB,
-		.name		= "ecb(aes)",
-		.drv_name	= "ecb-aes-qce",
-		.blocksize	= AES_BLOCK_SIZE,
-		.ivsize		= 0,
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-	},
 	{
 		.flags		= QCE_ALG_AES | QCE_MODE_CBC,
 		.name		= "cbc(aes)",
@@ -405,33 +366,6 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.min_keysize	= DES_KEY_SIZE,
 		.max_keysize	= DES_KEY_SIZE,
 	},
-	{
-		.flags		= QCE_ALG_DES | QCE_MODE_CBC,
-		.name		= "cbc(des)",
-		.drv_name	= "cbc-des-qce",
-		.blocksize	= DES_BLOCK_SIZE,
-		.ivsize		= DES_BLOCK_SIZE,
-		.min_keysize	= DES_KEY_SIZE,
-		.max_keysize	= DES_KEY_SIZE,
-	},
-	{
-		.flags		= QCE_ALG_3DES | QCE_MODE_ECB,
-		.name		= "ecb(des3_ede)",
-		.drv_name	= "ecb-3des-qce",
-		.blocksize	= DES3_EDE_BLOCK_SIZE,
-		.ivsize		= 0,
-		.min_keysize	= DES3_EDE_KEY_SIZE,
-		.max_keysize	= DES3_EDE_KEY_SIZE,
-	},
-	{
-		.flags		= QCE_ALG_3DES | QCE_MODE_CBC,
-		.name		= "cbc(des3_ede)",
-		.drv_name	= "cbc-3des-qce",
-		.blocksize	= DES3_EDE_BLOCK_SIZE,
-		.ivsize		= DES3_EDE_BLOCK_SIZE,
-		.min_keysize	= DES3_EDE_KEY_SIZE,
-		.max_keysize	= DES3_EDE_KEY_SIZE,
-	},
 };
 
 static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
@@ -455,8 +389,7 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 	alg->ivsize			= def->ivsize;
 	alg->min_keysize		= def->min_keysize;
 	alg->max_keysize		= def->max_keysize;
-	alg->setkey			= IS_3DES(def->flags) ? qce_des3_setkey :
-					  IS_DES(def->flags) ? qce_des_setkey :
+	alg->setkey			= IS_DES(def->flags) ? qce_des_setkey :
 					  qce_skcipher_setkey;
 	alg->encrypt			= qce_skcipher_encrypt;
 	alg->decrypt			= qce_skcipher_decrypt;

-- 
2.47.3

