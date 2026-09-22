Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D014D54A7E9
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081887; cv=none; b=qZAGbFxEs85P4rA1Y7Mo2IH7OBrSuBnsBjWJKfMXacq10PVgLmUuebZOmc3rtpsBuJ1NZmLRATJf80xZBQqhqeB+L/DtxS75WLwgbH4ObvtuYlV5roUZItwCglY2LpwvcFRyLKhV7/QOSx81056p0A4ipxAKXGUyTvMGRFd0uFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081887; c=relaxed/simple;
	bh=YpCAU/gxOh6WCk4K4j4tl5j4rP29wWVra07PGc+2iUU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fkOdTbdoBl7/sLa/VWsitvK/XbI7uiysfdUiAOT6+gmnAYpgmpT2s1dUiXThfr0wNJMLdg/3dY6gqgbWVnqcUpK4YDZBTQDuKo7lpCyCcqcEao7VdeqMuYlaOLItrEedJ1rlrKJ+raERyyawQZZhTmWfqKfnIPTdfVjfYnjF5vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aAnUF5t/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DOC87v4B; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aAnUF5t/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DOC87v4B"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPomK134611
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x6SgCCR/AHalnKsDkyEEmSxctIT2a3LccETCeOzrgeo=; b=aAnUF5t/fsrfXx4i
	xQ2ZpxWnxe9SqmjlOzk7kobuFuyDqoaMh5z/547t/aFTVz1EPD2g8nmxud/zxc6d
	80zBVBjeHIZFLO8PGTXrLDA/SPqA8+Vy7Z86a4ba98bQVjnqQSRMbZOAgXrGRjXG
	G5fKZWrL/pmlfMDDC1s06ySoZW35ab6b4FF0toI5gM25/4TsvPWY40x9z5G6eupy
	fqpppbEjmHb79gnYuAIrNq4YqMtCRuCI1F6rRiIDDPaLKlIM8AGaxab8Qk1/L0SU
	SwidKS+JJJ4hIlC+uvofGTotrpc6trMtljGEfjaYLveTvq4wtkl0iH18k8AfQgy3
	nosjig==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gujkja0cc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:05 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5c7b0f8e40bso4426079e0c.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081884; x=1790686684; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x6SgCCR/AHalnKsDkyEEmSxctIT2a3LccETCeOzrgeo=;
        b=DOC87v4BzPRTWzVR6IdNF2FXF3I8pf8MBZiRlF7D/FNYeOkelDplfM0UNLHdp0xR8g
         fw7Zl98YYaMI1Y8b5HlyQN/Mn3KBbgG+dgHiBhSY7nMJ9vUdG61p7uIlddjDVov7Ew/T
         1AcDCKmSbhC3BT59bKivHPkFcJi8JC1rRdJKcaRpjd27/nIjzROZMy8LVLvNuRdXMqHR
         dFfYDsQQRJkL8ADt70A1lzmkECxPHWm0SEGmWr6dqxIXwFMWJykYMHLoPaf00Gdo/6FM
         GIdBdMDihoMiA5ubn/JPoc3Z1NqgJHFBEya/jEiqBVok1rw0uNOS5M5U0kZjwgg795vq
         GZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081884; x=1790686684;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x6SgCCR/AHalnKsDkyEEmSxctIT2a3LccETCeOzrgeo=;
        b=Iijrdgy0XlAqo5Odx3J1pnXGK3ZGGe22FLoXgb9zwslqJJubqhHElrDH/CMAgipu5H
         0qez99bPzE94QRkz5HTHVvcRFY1OGU1B2bkWaMpugvF7ldAA84LJUadfLWTu4BM7Hm5H
         GySeppbrV8jcd+tMKoj641vlktejNZbHz0W0UApNLeZnmyU1QiU15P0ZK4XU4orlgdDj
         J9oTk1YfRcWxOQpmvvhcPlQduQQY7hXiexmYw8ocH0sM8FntYsC1+gigPX47a8q5RwiS
         t9CgNd8sP2BDXEe/DwhpDkAcGpwiCbV0WejsCCQFHCfrjJeZ3p3ZHPvXB3MkPYBjeuQ7
         IAyQ==
X-Gm-Message-State: AFuF++nABe6VgC/YqPyx1ag6WJcAy/o93As0RNoNUMWZPq4/LicVPy9G
	Jnmoh3M8ZNEVC7j/7MzW8/UIersPPHKYXmDW39SONT/wfi9FWzIUAzI0peU7KOIhr7j7FSXK/RX
	kDQDepgpWP2xlvKdUIfjpu4lA21L5B2tPLDOqZsdxV3pVnHY3B8wF3PSdATdkOwWXfcI=
X-Gm-Gg: AYBFou33Eyay9Urj/GMJV4CZykGyealsYU/Dfjgi8aY3i8zp4kkB9gcwWgT/D4yq3TF
	DQPFSVIwFwAOxC2SRHHkT8gLDAalWOlfU0PL1pmmvLM4qV7K5qcfClD89xIw1YULaGQAaL7dVoi
	bwN8u80K5Mi/LY+r03c5KfTySunar+izFgk8mJrYfopeuCtI6tLm+PjmvKEnGcpkqiZ575V7iJj
	wMZqtKOwGfEYGk9FxDSNyN7Y2ff4a6f521WJOtXaxnMHQaeTYw+5lOc0YZMOxl2fhTLzfljJFf0
	56GLaf9i5mTESPvFO6mGXI5DNvHsQz28OKwdChbRKlS87pLEcoK6bQ8kYpXCSOO1LO7wLpAw7sW
	uXtq+Dss+l65bC+4WFg7x267OzgA=
X-Received: by 2002:a05:6122:a5cb:20b0:5c9:c60e:5cf8 with SMTP id 71dfb90a1353d-5c9c60e6106mr4431577e0c.22.1790081884150;
        Tue, 22 Sep 2026 05:58:04 -0700 (PDT)
X-Received: by 2002:a05:6122:a5cb:20b0:5c9:c60e:5cf8 with SMTP id 71dfb90a1353d-5c9c60e6106mr4431562e0c.22.1790081883761;
        Tue, 22 Sep 2026 05:58:03 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:58:02 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:23 +0200
Subject: [PATCH v9 08/14] crypto: qce - Use fallback for CCM with a
 fragmented payload
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-8-b1aa742e79af@oss.qualcomm.com>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2908;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=YpCAU/gxOh6WCk4K4j4tl5j4rP29wWVra07PGc+2iUU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsns9tW+msfotN7ObK5bdVyb/2O/lX81u6V4ca
 uPlj7nYgq+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7PQAKCRAFnS7L/zaE
 wy73EACvaJuqYGZfb+m2zogj83eX2D6otZ5mOpBlMgGX8q2C0+bfwKb3Tn8NXHwRwC6KyjaIunY
 p78OxEQ9azhzFmN0/eGo9ywGzyvBfYSKPs0C5GRwAFvWc7lc5zOzGj8R/bICdcZDpiS8dBBDQwf
 AzHWZUozwCuFa/QjI8TMBeOlZeJCz1Sgm0nodtJcX3O6slWzHEZl+/eJvDbj4dlIS/R/avfn23v
 mGPHi+KlC/8CXeRTle8Nrd4mkF0CVSMDZzJG10ycV1OuVHJJUfgT3St2mFgbK+WO4P+/hcUsOCb
 eBJr+mIPFKGbX5mCLMY55SNraWHhQ+eZ3wAJ9+8Vo2Av2xXOAXCm0I3GfpFdganpiLXUjMMXJ9c
 8tb4UnE2ZDtiTm6/xWSRGpQx8iAFhH0Yc+bXc1zT751QfSTxHEOR0KM+0PTruKS7fQgw/NHs6VU
 1dpe7yBGjceG3eZwmX0625mei0mNcjPn4703qW8Iit99OAsD/U7bgcuAMqsdBapnRyXdbyRaADK
 LUNVHz/B9mcgfFtkMEUEKdhQuXs6wku/ozZebHZBrw7CQ8zozNep/CUGNRJmd7MrtGOi2P7oorH
 Ug2PPVfL1U2tFpvmxMMKTkVX+sMb2wP+fKEAOoNVnlbsKUezULwX/cwPz99WDqNPLJiKqzrwBws
 RvK00xImvqFACKQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: ym0UrRmbc7N8f1fv2ejD08Pin5-Nzrpk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX4aW2tRbhsoDp
 r2prVtMRe/lb8sOPbnXjp0Q4zdRemEMVvAJj62lCmEfpvbI6tgk7lJE6Xvunk392KUDywhRA4uT
 mKgQuZtQeXlh0wS54iLK6zlMB94/e82njypHhIDMRIAwxqAhf700UKSz1/7JaDRoTHVMHHHM33x
 Vuts2Ybdz5M3bVo/E5DHjmmlB+P0kEVL2ojAlA1F0PKPJHA7/7NvPelyTdwwU5tS47QRJhKsTm+
 TOYoUgjNWskta246FkWPpsbTzPqiQeDhi9oaCs+AgxMMBgshYfghqXVhBXENnUunLOgZZ2z9IgC
 QEBBnY0KpeVWES275h1+OyAMv2+1gJQkSq+Bmko7CRcaVyNwM+RPhd+c9eKJuaqxQ4OGeBmZyXg
 H1EP1RnqZX0DqdH2ZemTOM3O9tQjHCNgPCv3q456H9fvUe0CoDdncj5fR2dqk5NCbo7uRqP5zEr
 svuU2lAvu3p1sidU8ng==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX+sNxicU1RSjI
 zp1HiguPgU+QTIWUzGrnzQ183FSimqwKbtqmto2n6QyGhDxtvIuQcvF7hVyxIbPcpBJeP03ZY6C
 aORK41+QkgrnZuCAglFZ68rZPU4xs2w=
X-Authority-Analysis: v=2.4 cv=SuAFe/O0 c=1 sm=1 tr=0 ts=6ab27b5d cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=phyxH6jkQibGXiXynFEA:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-ORIG-GUID: ym0UrRmbc7N8f1fv2ejD08Pin5-Nzrpk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

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
index 02e1a7684a7e51ea7ccba0660eea97a17589c3f2..37199cb50744fa3932e3404448689451b0004b77 100644
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

