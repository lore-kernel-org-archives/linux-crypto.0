Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E03A40962F
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538626; cv=none; b=ER7SbKSZg2AqcSy2aVefCR4kakFEBbTJ3RcS7SY+Xd0BQpAdo6fsJ4SITLmwy0YZWInL2Ei39rd2tpVmNysd/x2dedzjeqLAcjuY5ZO2jkE95gnmiT7QzOm9u4f1c80I6BkzSuqIwlaZpOQMyqrUgWcbRRPkOFWncDZ9WrtOkAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538626; c=relaxed/simple;
	bh=nXrahgeRXnY/89zkj+RUO4/2X8H3O5dk0g7UmAMnQNQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KjVbqb4O6sZLvMPxiJ4hB1p1IBUe5PS4upQywFLrdpdt8wheCZrjDJe3MdrMbGwSIwvzyehejYIrxu1+uiToyjxf8WcuO1APIN50zVjosuGrJTYncltjmv8v1fWE+E0egEwtx3+i65SjfEvJLekkZapcv0fDB4lRkG8isZMtRBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B4Rlcj4I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RtMwJZsx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B4Rlcj4I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RtMwJZsx"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFhO6T449163
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YVZpJ1aFLyijtCHvXZNuT661btDqxf5yizY1R8hjn5I=; b=B4Rlcj4I/Q1ReUk0
	NNofMjldRKud0CLPkvVxQ7GYqgpg9KwWa3TNWa5imnyqJy4gNRfmwNLfeJZIvQ6V
	2C/dtc5EvlHyNWa/z0PdDR6ULr/9nq88FY6kvjiDNN+dW9FEN5vozvu7cDEbkhnk
	hB0Mb+NVnfE/INR+WnmOPnVi+3wCUklpbIdneB5Dk1zt30TYlxy4RFEjLGIhf3aH
	UDaXAHuDG6pnwTf2euibb6OXFPVz4SrG/7VstTv81YUWu3Av6EGQxHQ+FwhQYcHE
	3tEp/dn3VQMTqLZK7+Zw7vlxIuROA8M0IpnzoYMTcHFoNgs1iLFVS+cv8jp2HjNC
	EB4l0g==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4etfa71et1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:23 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-6c69c788ce7so1477317137.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 08:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781538622; x=1782143422; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVZpJ1aFLyijtCHvXZNuT661btDqxf5yizY1R8hjn5I=;
        b=RtMwJZsxGFA1xt5nQE1ImyLGsKY/SKSjvQ40ny9fPoJKItyQic2Cmed0mbwFo+4ptl
         9LGoL1iu6IzpmmiEM6m8HS4LlOQDNGPi9xnLCYZijbEDxFYfGSFA8B2nNRYfM7wQgOPH
         X1oRzSY4tU+3VYT7Piv5dNNzpUhfIVXBM59qPi3k0jjrrhhoj4ySh+joXPFMoFlo99QN
         XJq1ABh25YAm87nW8ZzsCkJ89jK5lej7N4U9eT3oN0ZdIurobP5yHq78pwznFiiQ9r5K
         bC6kbB4TrOXwMjdrly5yVWFyqhjjg7cZErBUMyVwa8fXCchm6b8W01DG7wrz89lFGOb4
         Q97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781538622; x=1782143422;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YVZpJ1aFLyijtCHvXZNuT661btDqxf5yizY1R8hjn5I=;
        b=VDXcGDLhDzKeKIgyGeyDihu2WwCCGpS7eMOlnCXJOHQBT5bRe26MCdy3b72YlAt6HY
         fbNQ37dN+HCDzZ5IuWA7tX32EEb3JUqcjhcwKDVzm9koNCvdkQMKhvZupLUeUH7gTN2K
         iD/RyCWw4ed1J8HPpL06aH8iwYckWLeq3oKkzWTHuDTwmxrErnoFinJ3fnsZEgXNSkin
         2+4wDrKq+6itgOW7rhZkFWDcSNyQX2uMSGs1g+WV0UXs43ALE0ma6+FJFsZCNWthZ279
         SoBBv9zqcJaxjVwBPgvoCshVqZUFVHvBreiHFhJRg747PFpMeOemj8Uvd7Xdo9BXOy48
         12ew==
X-Gm-Message-State: AOJu0YwEBDNoWTHUQFK2qz+FZuBnknFlzU7QdwhMOCZZIPIpWDgQOuuj
	aDma/jZ60R5za6kYmuoERGhOPaTcey+875Gh677lXLDVSUj2GMqr2NBJIzN3mMiEj6x/aE6HcOl
	eArkO94XG5SL87h77qTZhXXaZUWaiYyjjVjFAdfvDCUzObrg8+a/forD9NgFJNSPPI5M=
X-Gm-Gg: Acq92OFxsHUTgFxuKm3Ruy1vtjGxXyuhGM24RWdktvDe4fUnNyiqL5WkA7pyK3K/9xw
	aY5l4jEUR4YpjYV/J6xoXBsSW3n/xY8LVL3F1k7E1YEQViT30vrE9rqZdYAr0Meg64nJEtIhuwm
	PSprtty95RL9vDZY24C1+FkEIlapczuOL39BcoBHfLUX3hE1+eQOdIbJNdr7XOImHoC9mjmfDAy
	Ng4IlUpYHE27ITEYBVsnXUrzHnw4dSeJ0FuYrjWAPB0BSnKq/cHdvNxPJHLGBV59+IBqnb1GPsK
	Vv9SzuQ/AWPPWyytbM+Euq6XN6wyXOITolb6n93kHrSd5NM939H3u8Zk2BSw5/z572b4W+P775d
	TWL1HH1yLVv0BS+XqrRYwMpwPeCg2rjB9WnxtapG4VoD5+JjZJu8=
X-Received: by 2002:a05:6102:688f:b0:631:26f6:7009 with SMTP id ada2fe7eead31-71e88de1b5bmr6928381137.26.1781538622307;
        Mon, 15 Jun 2026 08:50:22 -0700 (PDT)
X-Received: by 2002:a05:6102:688f:b0:631:26f6:7009 with SMTP id ada2fe7eead31-71e88de1b5bmr6928367137.26.1781538621860;
        Mon, 15 Jun 2026 08:50:21 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:7fe3:eaf0:5a0b:2610])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm38643032f8f.10.2026.06.15.08.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:50:20 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 17:49:53 +0200
Subject: [PATCH v2 2/8] crypto: qce - Fix HMAC self-test failures for empty
 messages
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-qce-fix-self-tests-v2-2-dc911f1aad42@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5620;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=nXrahgeRXnY/89zkj+RUO4/2X8H3O5dk0g7UmAMnQNQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMB8tJ0Z57rNmqCjrrq5iW/OGgSEtdu8SmdfJ1
 vJm2d08KWWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajAfLQAKCRAFnS7L/zaE
 w3G+D/4jgxFZ1I7TR5PRqXLNb2n7zwhNRXlEYUDrfUB0FyL9r9UbAkNwO59Uz+6Zpr1/TYF63ow
 jeqt0tkYY8EGGRzCOb5fEEc1GRpjvLgEZV2HTpULQiRlz6C3a5Ev6OhtO0XEzcO5gHIuwiaj9xV
 04awRxCT0KFkYIC12sa/1ye/5RH7D0G1ATPFmWUSKpFDI1513MXcqagZuAqTNm6J9mTOTwO2ajm
 bxWufbj0xYhLyfKPfwQS1W9jhVwGcTu13MxtfdVacKyduzUtgG30osu9AyMbeH8d88SQ3+ofH+E
 oHvckFAek6NRpcHi7yeIITvKYWwimQKmgpn1eocfMNYAWnkRLf7TAFjt8wI95xaLepK0ju4BfuD
 KRhC2OD/fYz6SAiAH8UuNG01XkifaYQ/D3lFRAqZxt5LzZ7BLnd4K1teAf5VUZA7Ur6dtXidrPK
 LR6Ww9irjvL77L9g6MkiB0gYmmutGqqXexq6Ca4SjZzdAUZeP4ZYe4mGUhOYQFJMCuqIJ+fw8HY
 dSUrBx3VN58i9VC3TmjUJ7lrA1tUD1lVVK708Y/clt+s7c+0iTIZOrZVF4GcN80w8KP1AXyvQYB
 TYjoa38mhxmkNjeKXfEo/EjWeADV3wIoUM0r1VZ2QPWrx5g3VtngPB5rnxdTwgomshjrXnKCFup
 4oAA46HkA4bL5WQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: GSpyH2WDNaxdAV9ZCBEDA3SPEPYdNIVc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfXx/LNXVaYa0Vx
 +OX+fo2RdC7garTsY1v2tWwhkxaayPlpD738OMrSPqThPF1Q/zvJ24qcmK/+mGpWBHWAjWLYa63
 eApA5w2dvIK5EdnbCTHfM+T2P53HPNo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX8fXu3P4OChAr
 JPH1tTFTJJUwCS5MINWE0t97z9GvNXCqzUyB+lGqciUVRaQ6of3zkE92dqPaXRcL4F80k9HAHxb
 Xsq/JxeEhOQuQs6ZpjPAGyfSHqDVAXKGlQuX4oB7ML9gvqauLjCYItdKdSC0eb2IYygNAfNcesH
 Ao5pyWp1KOVxnaEFBysHhmrY1OxDOKxe+xheisUhZny+OZp1oZRidj5ZzMq1Rx/Qm0NSjy9Dplj
 nob4PMTqiDI3+lUCNL8iRooAsBHegR/PqF8eVfNYWUkE8LPbGskJuAZYuRhol1KobIhixw8aviQ
 6VIh8AxCTLHf5JdX/VIAWIrs9DibgdmKGGvbPXzWpNrhJvjwIFFZeJ7yr/bWIinc2KJRsVgyqYH
 vqtd5F4la5KoQJ19A+cvsc9e8sg6zeTs8kKTTvvpu9yHsLQp6i+ZrqRdE5qhbsVFOt0pZZwRnrk
 vIeIwZVWkiDADGGELZQ==
X-Proofpoint-GUID: GSpyH2WDNaxdAV9ZCBEDA3SPEPYdNIVc
X-Authority-Analysis: v=2.4 cv=AN2yTM5Z c=1 sm=1 tr=0 ts=6a301f3f cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=p9FZT9qupOX1he3wxJcA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150167

BAM DMA cannot process zero-length transfers. For plain hashes this is
handled by returning the precomputed hash of the empty message
(tmpl->hash_zero), but for keyed HMAC the result depends on the key and
cannot be a constant. As a result, hmac(sha256) produced an incorrect
digest for an empty message and the crypto self-tests failed.

Allocate a software fallback ahash for the HMAC transforms and use it to
compute the digest whenever the message is empty (in both the .final()
and .digest() paths). The fallback is allocated in a dedicated cra_init
for the HMAC algorithms and is excluded from matching the crypto engine's
own algorithm to avoid recursion. It is kept keyed in sync with the
hardware transform in .setkey().

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/sha.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/qce/sha.h |  1 +
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index dc962296139da334c00237e44290356023cd7420..00e1a8f6d4ec905cfb035db958a71566b1abb0a7 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -274,6 +274,36 @@ static int qce_ahash_update(struct ahash_request *req)
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
+/*
+ * BAM DMA cannot handle zero-length transfers. For plain hashes the result of
+ * an empty message is a known constant (hash_zero), for keyed HMAC it depends
+ * on the key, so compute it with the software fallback.
+ */
+static int qce_ahash_hmac_zero(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct ahash_request *subreq;
+	struct crypto_wait wait;
+	struct scatterlist sg;
+	int ret;
+
+	subreq = ahash_request_alloc(ctx->fallback, GFP_ATOMIC);
+	if (!subreq)
+		return -ENOMEM;
+
+	crypto_init_wait(&wait);
+	ahash_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &wait);
+	sg_init_one(&sg, NULL, 0);
+	ahash_request_set_crypt(subreq, &sg, req->result, 0);
+
+	ret = crypto_wait_req(crypto_ahash_digest(subreq), &wait);
+
+	ahash_request_free(subreq);
+	return ret;
+}
+
 static int qce_ahash_final(struct ahash_request *req)
 {
 	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
@@ -284,6 +314,8 @@ static int qce_ahash_final(struct ahash_request *req)
 		if (tmpl->hash_zero)
 			memcpy(req->result, tmpl->hash_zero,
 					tmpl->alg.ahash.halg.digestsize);
+		else if (IS_SHA_HMAC(rctx->flags))
+			return qce_ahash_hmac_zero(req);
 		return 0;
 	}
 
@@ -321,6 +353,8 @@ static int qce_ahash_digest(struct ahash_request *req)
 		if (tmpl->hash_zero)
 			memcpy(req->result, tmpl->hash_zero,
 					tmpl->alg.ahash.halg.digestsize);
+		else if (IS_SHA_HMAC(rctx->flags))
+			return qce_ahash_hmac_zero(req);
 		return 0;
 	}
 
@@ -344,6 +378,17 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	memset(ctx->authkey, 0, sizeof(ctx->authkey));
 
+	/*
+	 * Keep the software fallback keyed in sync - it is used for empty
+	 * messages, which the DMA engine cannot process.
+	 */
+	crypto_ahash_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(ctx->fallback,
+			       crypto_ahash_get_flags(tfm) & CRYPTO_TFM_REQ_MASK);
+	ret = crypto_ahash_setkey(ctx->fallback, key, keylen);
+	if (ret)
+		return ret;
+
 	if (keylen <= blocksize) {
 		memcpy(ctx->authkey, key, keylen);
 		return 0;
@@ -401,6 +446,36 @@ static int qce_ahash_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int qce_ahash_hmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ahash *fallback;
+	int ret;
+
+	ret = qce_ahash_cra_init(tfm);
+	if (ret)
+		return ret;
+
+	/*
+	 * The fallback is used to compute HMACs of empty messages, which the
+	 * DMA engine cannot process.
+	 */
+	fallback = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+				      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fallback))
+		return PTR_ERR(fallback);
+
+	ctx->fallback = fallback;
+	return 0;
+}
+
+static void qce_ahash_hmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_ahash(ctx->fallback);
+}
+
 struct qce_ahash_def {
 	unsigned long flags;
 	const char *name;
@@ -479,7 +554,14 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
 	base->cra_alignmask = 0;
 	base->cra_module = THIS_MODULE;
-	base->cra_init = qce_ahash_cra_init;
+
+	if (IS_SHA_HMAC(def->flags)) {
+		base->cra_flags |= CRYPTO_ALG_NEED_FALLBACK;
+		base->cra_init = qce_ahash_hmac_cra_init;
+		base->cra_exit = qce_ahash_hmac_cra_exit;
+	} else {
+		base->cra_init = qce_ahash_cra_init;
+	}
 
 	strscpy(base->cra_name, def->name);
 	strscpy(base->cra_driver_name, def->drv_name);
diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
index a22695361f1654cc94325ec5d886a158fa4bfb9c..5ba6b786f450cbae52988cb39cd68d5795fd19db 100644
--- a/drivers/crypto/qce/sha.h
+++ b/drivers/crypto/qce/sha.h
@@ -18,6 +18,7 @@
 
 struct qce_sha_ctx {
 	u8 authkey[QCE_SHA_MAX_BLOCKSIZE];
+	struct crypto_ahash *fallback;
 };
 
 /**

-- 
2.47.3

