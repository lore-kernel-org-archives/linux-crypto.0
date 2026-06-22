Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE43B4404
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782134330; cv=none; b=uFEl3dKqA82TKuUiHEfE1r175NKxDptvk1KcPlOGqUtjFIgoQfgTpdb3zhRn4KJii3vRqlgjwd820YzEMGHXTY97q8nUL39Thu8DlJ76daYbp7Nd2euezjmzPLzNEKuDiCHAaNARLhFdRN3tyBvYvH4JU8h+xk7ado6EMbXz0KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782134330; c=relaxed/simple;
	bh=q9N7xvaeFpdxSCk21VylCtI8nPZtUNdJ9Z4Mvdcp2Gg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aQHEfc7BJc6NdHmnq2ahyMjNzr0+WuL/3x0keTB6zHd8PeT2J7gzLNrGD7dXww/+u0bPc4msuJ4WG7GF02dn9rpDdMqNbd+9sNeLMIC/rjP0mlwUR4HPsIHOyBTIIi36NI+5QOLiDZgX0jhRbbtZ2OlnELMocEWZfJ5STbG2TU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=imYVXZnm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XfVmItBb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="imYVXZnm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XfVmItBb"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MDGD6i1283778
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	onHSjGInX0rV0mVGlTmmcWeekHeD6EjKdPIS+Vcr65E=; b=imYVXZnmfus0Y5vg
	NJBWVRzQjk+Wx18IZAbgTjry76RlylG2T2hN4Qm6i0rleHQc5c1gi5beR7sHWZ1i
	1Z5aZwrpYrCoiQtSQsupf3Euyo8Ae5AqPq87pL8vMCQckQaNaWyMHEW6r2aIg/lE
	p+2jg4cAH+DedSB/jv37awNxCBJVx4GpPLU5l54upkiqhCz4QpYPE6IcuG2CvhMI
	3MlpoMZ6vIpQWFW48h+4GxaaO/L6HDhq/zeDLTi5nqAh+LCIfZ4JkQ4LJ/p4c0KF
	niL9vHL2ToFkaLiOme6lG0gtj+DKY3H91HwQ64uZT0rm/KJNlP98+A3/zu9Gw42r
	tuzO1Q==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey5n401cs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:47 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-96388871d70so4758458241.2
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 06:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782134327; x=1782739127; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=onHSjGInX0rV0mVGlTmmcWeekHeD6EjKdPIS+Vcr65E=;
        b=XfVmItBbU8QkhjJdBgkVAvNmN4QcWMyALFWfE4OrRjnzCJw8HWElqNk6D5U7tepTOr
         pK1zYdHDBf/dUCQX3OoDlrGlX2hPepQxW+lhqTu746vEOvZgbhRV5s4e+88ImEs2TgWb
         gxUwe2HKyaHou1OX8W2MlfnZnEwDAqULs4hVsNBvwE+ecMjJYY8nb47tn7McQypfv040
         Mmx3BOuYOZZkQN9nEqpNQEeg9Ly0AsR4gTdqcrwVeyk7lud6M6+3jpvCp34JpChHqp50
         UtBDv/pwQudCR2PExlknPRYM+iRj3OzrOA3QtLxn5LgV6kNAPXZDkK4E8vzRhNfSIy/6
         GMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134327; x=1782739127;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=onHSjGInX0rV0mVGlTmmcWeekHeD6EjKdPIS+Vcr65E=;
        b=Js8RyBvTfKS1yKpAQ717wZiKHZo/LEv0xcxOE6sjRuTeO2y5zIo4B1pt12pqgT8VtD
         asyxCNBIZ6T9vqJPYBD6BUiw8V/Wu+fxEVbEi9/FGVJSjMdK4LB3l5xwNIUvsNK3OnLk
         2/ReyeTs1pObdiMDyF4rwVrWwt1poCJCpbLR0hQrhtwwfb5A42Ybf9Xzjr6ECq3k4zGK
         5leHM7a94Ru08ucgCZaSBGc+HQ8bGKablt9kvRkicL4hSE6JP6p9/qCsh+j17bFF3wHG
         Dhe71xOzWBxsk93Lu+i12NeqUN2yoC5MFBYem9Ss1HGs1Z4ewYHRIJ5JmnI4NSrl5Hcn
         ImDA==
X-Gm-Message-State: AOJu0Yzp7F/Lw/Obck88SiO93+3JykLHdUf6xlX0uJhJnKpW6xEi7/dC
	iPl1wwYHKLY+N1jka7ihDTh2SSy3HyxFfbD7XZoshFqJgB6Pz5mPrNVNFLF451MeonrTVX+3ob5
	ghOz/tyhTXVLu2xivZfMuWXVzo6eI88zKIuATHi03eXGYOcAhsWpJoVTu4LlMnk5yvnE=
X-Gm-Gg: AfdE7ckc9ghXqexscnvExsTSpwN2qaKK5CxUBCYizpKwAPYyWSnZLDGQsVCjDsxJWG3
	ckcKlVjMZhKMm1GuirB4Nvqa4Wmg69iGsPgENZfupcZ/W0rW8NJxuh8cnlxQICdxfHQ7qJXfkqY
	IPOImRrOtuAu+Lr48mzLyasR+PAK0nQ/FE/oin6LvPWsGs6ocFoSBNjDXKZfpZEseiTZaiSh8uZ
	jBrxGPXhj39uFXF6gTRrdmOycDbepyHytPS0MAqPkZm120LNr4PwLaL3eC1DKPBOOd8NDdLxgAZ
	9T/24jTOZidIoGYoYz/SCBpSvPim/kWItKwL9oRbo9aPKEaoXQG9FWw9+itlNImQD/L9Fpmx6p2
	vBJ9I7PHyOX6M5umgkvZp9O9YgSkOBo2feQNjhHHU
X-Received: by 2002:a05:6102:3e83:b0:631:4580:6a46 with SMTP id ada2fe7eead31-72a1f0b92efmr8615625137.17.1782134327190;
        Mon, 22 Jun 2026 06:18:47 -0700 (PDT)
X-Received: by 2002:a05:6102:3e83:b0:631:4580:6a46 with SMTP id ada2fe7eead31-72a1f0b92efmr8615554137.17.1782134326599;
        Mon, 22 Jun 2026 06:18:46 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dea2:c31b:2872:1bd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd30078sm294083835e9.7.2026.06.22.06.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:18:45 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 15:18:16 +0200
Subject: [PATCH v4 8/8] crypto: qce - Use fallback for CCM with a
 fragmented payload
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260622-qce-fix-self-tests-v4-8-4f82ffa716c6@oss.qualcomm.com>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
In-Reply-To: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2908;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=q9N7xvaeFpdxSCk21VylCtI8nPZtUNdJ9Z4Mvdcp2Gg=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqOTYjW9T8sppX96eyisuYzkoe3JNaDn4WMmdho
 FPQ9WH0OG2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajk2IwAKCRAFnS7L/zaE
 w/FSEACVBB35BQRHhUTcT2GPng6TFcQ9ybU4wACiYxJbO1A0uKBQV76pZIyooPg+Aq1i4BBlgPJ
 rt5zfuYZEwFpEpYyel+47bqWU20NHCav7zFlJbhckdpDS14dOFVDcClR8jvniz1Mena4+3jbx2J
 YtLlwkLgpdgnhbPiTMxWjKO+OhnMp2Uy1mx9wrVDdLGdh2E1yin0ZC27qpPiMrDSQFJdxhPFie4
 EKxEgqUwMfOQTtaiAkkp1QLWQLK+0E9DpfO+HAv72amR0J86eXv20DTtd6iCA2aIFq9ttnwi6oZ
 DO/qgYs8BaTXArOjWrvg02ttwOjPIzXc3QMYzufliSTsbfQ/rtq3i5zLqcauqLziKb5KB+N+iuI
 xKfXZutqzSHsJNbWDwZ+/zzZtnRDHVRQiLWuC+zyUNGITgb0OFgF+dT18rYCEZ/Tl7jUP72o0Js
 AbdT4CUmmecOm4pQoZWLOoL87lcE8djwga+Rjx/vis3YMUZB9jDHK3bT3eWruR3RKxJPxxN2vZc
 nAF03YzaWb+WxuUeIp6MzVb5lhgWAEfj2gZePpKDikIlHuLXRRI10/igYZPb80TZg1bakdwz7zk
 B1IWsYSH8FyZws6ZWiXu2Qi76os+I4O5tLstt/nXYMzCqI7Tps3INaHNkbksiDg0qX6aMfx116I
 oIIKxfD33DELzwA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfXxY/9cO9yCvT7
 NnkSvMDhF4Y6uvXQ2EvtMDIWWwKtmFcXy8hUItOC3I8V2uXsUKI4N81LmkycAezmZIOqoWitaVJ
 d/nelLUrEvPXsinTl5G9dOHyQZQ4ibc=
X-Authority-Analysis: v=2.4 cv=R8Uz39RX c=1 sm=1 tr=0 ts=6a393637 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=phyxH6jkQibGXiXynFEA:9 a=QEXdDO2ut3YA:10
 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-ORIG-GUID: IBVslZSztRIV-0-6m4YvsWnIFW5ZSA1n
X-Proofpoint-GUID: IBVslZSztRIV-0-6m4YvsWnIFW5ZSA1n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfX7s8UXVVwLYnj
 a4DuEOWoYIrbbkIwDtk8KgyS81oLWhYj6I4ASKoSClyw0eqNi1O/QVCjHKGvoq8r2+WY0RHxr/e
 2Vm0SLivyFIuchrahbSOeVWNI2yXzjbCJ90oYWlc6xn8INOg0ikAUAQvqDQj6DTJEJEpl4osWd9
 DHelrHXbEWSKi0P79dWHTqSRSUbmoUjqD9MZX5h3ou598GP2BKe8aJgBSRKHbFkxm/BFs9XdXzb
 lHdVbo5/rIbssBir1uwH+0AwILEC+bb9eSf9CtT2ZIw01Ws9Cw8J/D/VMrwguj3EvjRysWGEVf9
 nd64KTojIAWO4qmFR+bUSC39UhCMq+C7rorcfBQAiV0wvUDL7Yb7zkWO140UWk2uHMUUTJinUC2
 JQcsyWe5tpsFixB2DOBVlayC7h7pv954CImsuYFxvhbe2JTA/tDI3yjE4S1mgA6rSWvoMylAugz
 2NlcuAUXjEF5HCU3xOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220131

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

