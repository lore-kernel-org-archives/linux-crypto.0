Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4F748CD78
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045303; cv=none; b=kGgXtUmon8uETEU2GDdKkjPtSQt7D0hazaiTliBupn9XiJmfqn7t7J4rABo2zAi/PtAcS484weDU6YRhHp9/8pj9OKi6bSujtskOps7HbJPzGSByAOLgoUy1DLtHK+WODO0lNwSIePzUi3k57CBLDDnYCsQ5jhB65wTzDjuGCKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045303; c=relaxed/simple;
	bh=c+p6s9yVI0Yq+ycRUv6lRoOCSIgxZ5LCLv0Aqa3oIhA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h9RsbWCn58jWmcVPTOHRfFEgPH9ujw/teNH02Q0aSG2zAf60gZcp9AyG2aVfmbjokQmyaAL316HN1GnOIPDTZ/lQ88He3Nig7g5rOWXUhH16iVfcSerhmN5wtZXhrkEZd+uRhg/rNDBI687A/2tFwvx+TXrwIrfy7I3y2TKwFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j/zu8NBD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EDOHD2uL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j/zu8NBD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EDOHD2uL"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7lbb244968
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	relBmYOFO1X/TjoPGlxLYddWYAexqzPnTlPv4wKY+6A=; b=j/zu8NBDplKfFUpL
	TAoC/Ri+PfVEgkZSNvUVQSYHBe//57LS89YpLcbJYj5Q3SsmciFDRFZKW1dYnMpe
	mzDm2dniDmHzSxklPb5WOVIWpOJYCxWR6V28eotCG1a+xSR6x3xSo/dDCG5dsRdQ
	ZC4O1pz2wZYoM1u7F7yuVT0z15A45LPO7WRAArZav6olBOSRbxYU2ecyoAzXaBcn
	qmxtYUzDNIp+iMYDamrPIWRGi5Xf7SCXTzTFM4EZR9APzhC2MCnXTN9VK55VTsjW
	sa18zBg4ew+NMOw2tillchvH3zHX3kUOzZWKQnnIsZ3bXE6trjuKRvVut5iT8VP9
	B/NugA==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyfkyyv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:39 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-75116a48926so5926541137.3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045299; x=1789650099; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=relBmYOFO1X/TjoPGlxLYddWYAexqzPnTlPv4wKY+6A=;
        b=EDOHD2uLEqWg/zmR5MhRLf4tYKlAncjQuPoGCKeVvvtWbOwr1ucf33XQzsHIlacZLx
         QOJ/GjksWTdzORh7QAPWyLJWfpHodg9l+vR2wP+U2vgp5dwSnN8v3sWsJ3vXUsPmBy23
         nhOn4MslOexuPJ6srTEaHpExQaM0QawGwNvO0i4tPz74aa4odHMtZKWMXdVqz2VZU0An
         kM9S63ee6eedOnHrRtsHj6X8VDEuoJUfmZsZeemfMGhbtNV+TdZIxXrEhvZPVUx3/qeg
         jL4eDynt7C/tExtyrAI8BUJZ7SCglwT1tIQ0uXH4Q324rxoKdgZ6PiJjDpurBinAwMtb
         O1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045299; x=1789650099;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=relBmYOFO1X/TjoPGlxLYddWYAexqzPnTlPv4wKY+6A=;
        b=TmPOPhcr2lB0a4vlQ1crBIcfwHBBCOUHyZA6f2CvT9AjVnhcMlZjd3U5K0j1zZ71zY
         l5pfgTpWjx6IgXEoO6uqYlqS3leBrtxzF9fobf/Oox1yFSv0Kh0GpnEbIxOh+h3TN2GF
         j+Iorg2LzD4d4DmTPF5Z6C3bpwTb1Z27ogrEwl4V6HSC88OlWnzL+v/XP+1cVwEYmYHD
         pLZw/yKBROhxr9Ezny5xaCeICuJeo2c7djcUuiNvvciXq1cgZmPLcGlh4dLakDmg43FQ
         ZtwDn3j9zis/QulfAlOjZzr/nuBCIPmvimuvm8ncw3xWXNq9/Sz3NmRwC2bPYWaqFxVZ
         vmEw==
X-Gm-Message-State: AFuF++m0HfQwsqz/AIOyY+bFuRj7tEWc80160Vu6SX2tV79MpIa5ONa8
	uffICPShPp+ATCpsqqClNzvE7hdc8Hj6hImSm5fTFXg6pcpyXFyv4ZN/YpjnkCJ71mJNxLjSha4
	ldQl/4++0ZayVcSUbEI2MP4GHInrXSDL6k/VMtXkqYBvQjL7E9HnMYE5Vsku7VOwwDzo=
X-Gm-Gg: AYBFou0eg6vf59JkCf9LYhEjSEW5/ui2gvya/cfCi6e6znX3r2I8f8G2ODttPlB3jcV
	87scZghfpDuVIhKO9NVoNE9lRwuGzUm919/+NzvF/6WVabntt+IJLyZ7LgjpEVdqjZmvXra6LUn
	IpB+t5u+4A4jNXzoNQXyiCcqJSY/9dNHJev6iVRb9jxxFiehNePMvrc+zTiu1JFTnbo3jKzx6FS
	R+QWubkW3XMLB/KKmRH2owv7g3TYRdcO860A85p68ZMdbabLUfWy7uvv2ZtElwWzx9rbnD08nCq
	R/mhaHB/dc3gVoF4wYAouMWdXTmJdEsl0a8TTuKhx6VoBc9m5P5RZht37GCenLNk5Yf0voqazur
	z+Ct5OqWfVa21p38zYkLuS0XGUdjp
X-Received: by 2002:a05:6102:508a:b0:785:d308:cc2e with SMTP id ada2fe7eead31-790782135b2mr3093054137.9.1789045293967;
        Thu, 10 Sep 2026 06:01:33 -0700 (PDT)
X-Received: by 2002:a05:6102:508a:b0:785:d308:cc2e with SMTP id ada2fe7eead31-790782135b2mr3092851137.9.1789045291582;
        Thu, 10 Sep 2026 06:01:31 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:30 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:49 +0200
Subject: [PATCH v7 08/12] crypto: qce - Use fallback for CCM with a
 fragmented payload
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-8-cdbd2718af14@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2908;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=c+p6s9yVI0Yq+ycRUv6lRoOCSIgxZ5LCLv0Aqa3oIhA=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoRbRuzkoShNdtafGIAgnA0xnyF+lEcp06+H
 kgD2ZQkLDeJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqEQAKCRAFnS7L/zaE
 wzP2D/9hGuL67BDBK626TexNAQhxhQOnt3xU/y99CgCzBWmniHe1EDoxiWB76ijWDYnK747FI+k
 IO7qzuXvb1Foj5AIuSK0Pz2SG5PNBUJbYcYH5zdcDAwUSM14bvjp09Fl5ptswMbH26GRlsODQzc
 Su56Ayh8sTqVIQa0s6VQM0ZDBthULVt8Bssv35qIElmbr1apZH5yjuoG3Jdw2gyEreNflamLF7C
 t1fHgRXt/gHEXtO8hqnMbfDrWGaVImdamkDEUkIZSgfVcFn9bMlV77uOv2QbcAUjb7tmWFrx/3N
 c47YTXni1YPv7E+oFfB38W6UPS6NnS0kL/9yIuimyojopjkeI7baUu+8KydaWvEH7fDmEcO/YWz
 c7liyBbY1tZWuFuy71GQSh+fWLaYigze1Mqh78IsJPqrRadfxpmj0ue77sMo5madqR+DuSw8M69
 jEuWER8BOOlkLqZ3abvl6YZT1iLMnwN+M+OqBIvxVixvh7b7SSl183xvqzPDMflyOA5yu9CJ8jp
 dVgHnbwgDIrfTume4n6SAyuMWR76VpQkgZiNlD5cT4TL7jrIWoukQ2V5sJnWtcGM6kZTyvHn0gs
 cg3eqiTPQ+XBnQyHziymbJTSsj9NhfWeX2lVRpQuOFFGyYMqpWyQnJe06kwD88ytRq8fKcUEyPv
 bKJTCYgwQmUxP6w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX7AejQrn95GId
 5DNw+q4DTB7AjxpCPtETDCqJ3MCkyFelVszkU3zv7xBYg8g4/ZIzw799ZEoG7QAqS31aBd8KqL4
 E3gC3HnnMGiXc9K+sxvd+ZM6GU1dbuM=
X-Proofpoint-ORIG-GUID: y4z3gTAzQbi73oXtwAvMXwDCP66fe6Y_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX21kx5qg8watU
 PBKaesae9chisTVMjwzFMwq7NTCS09WkrtHyutXBd/ym8W8VtXN18p77XweFb6Rstw6cwCQSbjH
 7i8UXObwpmAG58tloGciQJXNY+++A8am4YODZyunOIEZDNLjpsaZ8Ql1wkTwUtQGW5E2TqIP3sq
 3Y6gNXXLl8ETni1pIAs/wOA//JBi+T98GwpZAM9Nph9pT6K09O2LKqum9wMP7yD/eSs0PelIYaI
 3W8H9+G1Ml7UkhRFcUXsyUK4soLFF05ljcXy4j2raYsgKLLlwC4xaoai0WDcagD07/aTnTUNl93
 cWXIQtt3soB1PSO89fyzhSaBhoeAWC3xC/px91GlFrJBIOioy9SWXW0bnJ3i9mm2J9ILQAHMn6S
 NEbtetnADoovl708rqNVUp2U+wMgw3HersAM6zxbiLLu3kNZpp9WUPKCkpezHm1XvqxFgqnFjka
 AwuTfsFD9vPXPv4g+hw==
X-Authority-Analysis: v=2.4 cv=H5pOUOYi c=1 sm=1 tr=0 ts=6aa2aa34 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=phyxH6jkQibGXiXynFEA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-GUID: y4z3gTAzQbi73oXtwAvMXwDCP66fe6Y_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100156

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
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index ddae743903229f248d1dc7037c4ae78537476563..bcd505579556c4d54b793d280a6a7f819ba573c9 100644
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

