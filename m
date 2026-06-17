Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE23F4A3403
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781711430; cv=none; b=oUnFqQ3R5CJSIDz7oErpXIUmb3KQOjlei1wXraFOAh0/uyKwyXyj2TMDRkrLwcjGEQXxAY7ohb1XtpDbCeG98tPj5+4efIlvTOBzSHb13B5rq8SNAPWFdI1lEJHYQY6NBZibiTlEV92/8Y+tupWmVRFH2EJINJsy+Bu5CA9NDqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781711430; c=relaxed/simple;
	bh=/1SiZawXnz/qPfQH5CCAe1vfcwxTpmb+bksRPXQlLzs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HV0rReeIl6nNoDbN6eit0i9puop/OOEBf95hwc+GAMojurTds+h395HktQSRL1li6KADQMDk9n6jxB+u4DTo5Y8Rg9HpJ0kufzPxuljDXcOuQgWA0D+nLpEZ3Yp0nGUV3UvWyyL/OYXzEpnkBb5U4HQ860YQGyfj6Vg/3tomfXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=krwcJxbl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DIuTZg6C; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="krwcJxbl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DIuTZg6C"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HFQ0Xs2959888
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vFU8OlVKWXQ6jY8WUCxd5dQmeVWbkz55pVwe1y1Cf6s=; b=krwcJxbl/0QOxTrM
	ST+kwS/U8PTZDJdugG38FVdbegz1M61hs78t18K57yiuFShR/ILalH9w+Cqoxlt3
	TLWLli0LZMrJBnGzLYfw7HUodEpJAxlzNO2P3JDmpTTJUtfu7IkkiRt1H0ZS02Ms
	h9f3+6y3X48Q2MluueuUWDNXTjAIfAHqYPx0AdUcemEQ7yoXg6TwWsBCkjT1a9DB
	jGKGk3giOo6MuqkUOfrfTuPMhwk+9Dy0vpWVjQBlQrhHM8XcS5YZ+Sn8YA8Dm8Xd
	sjzWboBdvlMmlDZl+wotDYfJlhUW27B5vaEf3eT7IK1zJwA6D4UFGfTO2FWr1/A6
	6GYaDA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4euees4028-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:10 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-71f4e6ff16eso5223443137.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781711410; x=1782316210; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vFU8OlVKWXQ6jY8WUCxd5dQmeVWbkz55pVwe1y1Cf6s=;
        b=DIuTZg6CT1eIUy9jFora74mkkYknJ7dc2/dJ+pOqEhNVmpmDn0d7pw/UqP04YFueQr
         dCWPrn0rbZNL0VaCPIcJyFDgpAAg5Cq9dvs9jNFxIl6E9PJ7jU8J6c+ftzCJV91ep/Ur
         p7EUpzo1dmZGyLiV2cMjm7nuJk1xzEFjvnXWAeu4EITfLte1yK/eaJxAXkw+jmNa/v1O
         2q+4Zwgh6PuakDN4eXrJ/KNE5Wr7irw5wdEkPcB8Xk+ZcIbBVZH086p/ltL/FBgAdrHl
         671tuQtqXKFpdsxwpN8mFEytv53M0gqEv0OaMQteYVqouBgyBDcOWL0WwzV5nYkyFCde
         nv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711410; x=1782316210;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vFU8OlVKWXQ6jY8WUCxd5dQmeVWbkz55pVwe1y1Cf6s=;
        b=R/3bQWA6QyaHUZQW/vOCqo7QH5J0i9Zplr9ohV1unc+dJSrHjO02pUw335vZyvth8P
         sqnO9jNKenaxgwOUk9mCrnD3gUY5DJYDkkLY3HSiRzDcNi/7Ka3tx7J+QMpFbiGoQnIe
         8OeRRbWg49VU9/0V9Ge3sW1VwW2EHVlfle+HbNOUqoMFABAnPt+LKR3QsQ/47/1yPF9K
         /fa0ZAuS5YfIc4RhvRITvJtZhVLNgPzFzQeANL1s6AIfMF6FXs2F8jQO82NTNW019XBy
         7JgGwd+myfZKV0F+hyePCrLFhG77MSrqQHwEf2wKyuCtOVQRiXaHoiSLnl+o7skVbDVk
         LIyQ==
X-Gm-Message-State: AOJu0YypsIqXk4FkzKbo6V7yP1jteKPnk6L85FnjqQcbV5OZ8q1HJ4Bz
	LCfXrbq0oLZBZ7vyBiYSbCKvxVo8RvRBXaDq/TEPNVtf7wh7hdbCR5EhOxb8GdquL/e1jBhkXfg
	mhRXts/ft7mO69tj1BrbUiDshZYNd9Zr9gVWP4lBSKgFF8IqFNsBN/edDmMLANjUYUdU=
X-Gm-Gg: AfdE7ckN6ZZbx7vXcISBk0hnl0tWotGFru5YyaDEGFFAiCT7bmJLk7rbg7ejOw1a5Bp
	1nmETR8rmDLpjLkH7ilcH+11WulbjO6c3NmQgQHLdLfHYQQ/deEQRowKNg1NMgUYfFShL2mCKHn
	JtD8poGrs8/oBycrTIRx2lEBdOWIGbfsBR/oxvAQ31dz2EXHOAxzou2EMGq1mrciIEqLtX31AuZ
	mIdhvHDNO24/cFlRsiuLWA/zd1xKdkpIrUXtO8z6YqxTFm7I0SIXI37LnrCNF4NYditO0qSrKMW
	yfZncSjt7y6OTYoGibwVVx+wRsorFShsCGWY0glYIT5/cMmEFXHRAWihU6vvnxM5SR91CvsFCY4
	DSGRyfgt9HtveTGwTAKwV4Y2ssByMdlfgavQnCGv4
X-Received: by 2002:a05:6102:570b:b0:639:4bb7:c916 with SMTP id ada2fe7eead31-7245d425b71mr2699087137.3.1781711409922;
        Wed, 17 Jun 2026 08:50:09 -0700 (PDT)
X-Received: by 2002:a05:6102:570b:b0:639:4bb7:c916 with SMTP id ada2fe7eead31-7245d425b71mr2699049137.3.1781711409473;
        Wed, 17 Jun 2026 08:50:09 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c856:25e5:e249:5e0f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa8b423sm168913195e9.11.2026.06.17.08.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:50:08 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Wed, 17 Jun 2026 17:49:37 +0200
Subject: [PATCH v3 8/8] crypto: qce - Use fallback for CCM with a
 fragmented payload
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-qce-fix-self-tests-v3-8-ecc2b4dedcfd@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2849;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=/1SiZawXnz/qPfQH5CCAe1vfcwxTpmb+bksRPXQlLzs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMsIdFgJkC+uxUUrYZVHZb27slLcQXse1Xe5yp
 huJxJP7Ln2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajLCHQAKCRAFnS7L/zaE
 w/XND/9c4Zl8fbjJrD6/faOiYpmShxOHo85y5cpBkhF5l16gv8nr0y66XKzdakMKaGmUiVFHQBk
 cXBkzLRjprNwXHxzHJY1IFYdcIWLhMx+F9zBSDLkw6w2+3EPZqsNj7eXUwOTWdOlJnEsYFbJOeV
 oPq2mqeOUuLX0VBsY6GQKNFXrfvbx3W3f+ConbDpQ7L3HmjXHmdTwIqvvLWwm18xftKi+5DtN0S
 zVDSMK6BWp/3ZiKSytH5wlSPLzCwpf2JGgOzqDrpae72zTFbdrvg4EPxldx+cG3gu4exFVAonTj
 GDq843HrCWNdHe4VHDw2M11D1VxpUVWxP8R3UvP7kQB2aQBzIbYYrbynHTIhBmQAZ4CtsFP7W1j
 z05M/IxEMJxdCqtgmeq+egcmbIbZFZzn8mbLZ5A0Cev2qryygXw00DlrKX+/AkzB0x/xJdI0dzr
 S894x5XwlLkxFagNEXTpX5zLkTtKnX77yGHzQ5U+haPi74H4Tw4yTNopmUFzcOKU6soXnocxozP
 j6KzCE4EP/6K43ZaWMRY68RyMLO3VCr7NUX94rWnXdrxdaA9dPUF9S7+DrZkIqw4VNuEz4/jT5r
 0AQI+Sj8MrcBIMSRGHzJm/Siry4tcxjnVRmEZb3ciKzBVT+B9VHhj7ZI25voKkxloYw5jkiJLwi
 wG9sJ6JbX+aSk8Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: rOFYFO9kvwgn1EYKQezOmFum4NdPeCsM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX6gSyAllG6ZWy
 oVTA3qXqKEExKSnWMKUTBT3mvtU5yCGiHHNJeVcmDx0S0Ym+4naZxyajszzjPMIF2i/VZYWih5R
 Mv0/Z0NWP2t6CVjUmvEl/a7vN7e3Lof77VJbgkXs+tw9C4yicKC2CJ0ApueVvYVW+fTEAcZWxz9
 2Bv4thDUHWZPmJ7r4/Mr1yS17v1/QNwhcQbR6f47y7JdYzFrv16jXg8iN2fpMAxMbhbmgT7bVl6
 88/p+f/Di2HzSdrDWJD1vGX0yqm9n1m3ubJEpKU5WeiBE+MMaGC52oZf6sLg+g5l7+CGXCzHvyA
 gNjFagp6M2E5NBJGxm3zQ7EMhH+0SUy7keflsGy9tK47/ceJ5aMKHJi8lzZpyMxXJYAjyNvbDCu
 WAWbpRrlDsnZUdmdjbLenSXpV71w81mwx3xVAoZMfQCEMyal3ffJyxTBBmQiwbOXcD08/QFQ12n
 Ze7DEkoGwgS4YPNwOnA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfXwHRmFvNsqnG/
 B2hfVCVUh5gsuLYQPmnlKQFTmPX32ttQlOFQ8aXfInY6o8NAShydGs2/39apSM2x4OlvMuSnzy7
 e5lrl31gZ9p67rgjJFlohsEgRWLr0+I=
X-Authority-Analysis: v=2.4 cv=KeTidwYD c=1 sm=1 tr=0 ts=6a32c232 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=phyxH6jkQibGXiXynFEA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-GUID: rOFYFO9kvwgn1EYKQezOmFum4NdPeCsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170150

The crypto engine reliably processes CCM only when the message payload
is a single contiguous buffer. The associated data is already linearized
into a bounce buffer before being submitted, but when the payload itself
is split across multiple scatterlist entries the engine stalls waiting
for input and the request fails with a hardware operation error. This
was uncovered by the crypto self-tests, which feed the algorithms
randomly fragmented buffers.

Detect a payload that spans more than one scatterlist entry (in either
the source or the destination, skipping past the associated data) and
route the request to the software fallback.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 4fa018204cb628c112f64c45ff6c7407df73b945..9ff8fe2a7efcd2734e4ff029744961a7b1101013 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -498,7 +498,8 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	struct qce_aead_reqctx *rctx = aead_request_ctx_dma(req);
 	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct qce_alg_template *tmpl = to_aead_tmpl(tfm);
-	unsigned int blocksize = crypto_aead_blocksize(tfm);
+	unsigned int blocksize = crypto_aead_blocksize(tfm), authsize;
+	struct scatterlist __sg[2], *msg_sg;
 
 	rctx->flags  = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
@@ -522,6 +523,27 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
 		ctx->need_fallback = true;
 
+	/*
+	 * The CE reliably processes CCM only when the message payload is a
+	 * single contiguous buffer. The associated data is linearized into a
+	 * bounce buffer before being handed to the engine, but a fragmented
+	 * payload makes the engine stall waiting for input, so route those
+	 * requests to the fallback.
+	 */
+	if (IS_CCM(rctx->flags) && rctx->cryptlen) {
+		authsize = ctx->authsize;
+
+		msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
+		if (sg_nents_for_len(msg_sg, rctx->cryptlen +
+				     (encrypt ? 0 : authsize)) > 1)
+			ctx->need_fallback = true;
+
+		msg_sg = scatterwalk_ffwd(__sg, req->dst, req->assoclen);
+		if (sg_nents_for_len(msg_sg, rctx->cryptlen +
+				     (encrypt ? authsize : 0)) > 1)
+			ctx->need_fallback = true;
+	}
+
 	/* If fallback is needed, schedule and exit */
 	if (ctx->need_fallback) {
 		/* Reset need_fallback in case the same ctx is used for another transaction */

-- 
2.47.3

