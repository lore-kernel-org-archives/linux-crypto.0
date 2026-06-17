Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592ED2E7F38
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781711428; cv=none; b=jbNabM8GRfuwW6plgnUJoNC8g+oGUGioUpDpMzrXstUcHgWlTZuEgf3h6scI3vkK6gCF+YqWstoZFaOlIWku+jwTJRPsRoXVpkvC8ExDCqnJNpLsR/r0CN6/y3iSzOr6zOur3W416RcQ/RFrtb+/K0MoyJObYTxAQyWDuFvg8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781711428; c=relaxed/simple;
	bh=+jSSnKBCewKu2gGq3nZqT1p+QKl0eV9583wFNZZdHdE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WtatsbduN8McwU8TbwYBD7sJzmUaYBMpgmmGUaiBXugYmZ9qXxu+9tRvYDG+a45rQAR7QoaK50LjM8Wl5rRqv+PZ7HgIpwpWUV8Em/iwmzHKu2aMuEV/6VDLI9lT03FjNo2LsLxk9RTBFS+RHJefLLIcVnfCIFo9dMQI0LNqIQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N/HxbGBx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W61lymsm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N/HxbGBx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W61lymsm"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HFOxdd2541712
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MqQoQ693d9+FFoh/y5iAKv5cizC/RsqLEfYPTEBH9Ps=; b=N/HxbGBxaZtXlncN
	V5Lo+6q2kYo3H/7NbfIUhXWwknGbz+itmlYIrsRr6Lmf71m/LzMh1IJNg1OCS66Q
	5+EitSgGZTZeqnzIqTkgB6VX7FKHjIbuose2Byyndy+ktVSuJyLpc6yPPkzs7duM
	Q0xo4nXhOxh4g0NK4CwbQiGwNLGfbiw90mD3QFE7TXv78fieX+x2p9oapeYLcgkY
	fetqd64Qa2l6tPuU/NJx/U4nxeLyXFmNTwCknRzKnhqvmzgnzt4pUPdaNKCAZKeJ
	ff3dGcrbryUjIMmWE24opK6UdcjmDaNUG12rF22luod6Jq7stz5KbupPu9Lqb/vm
	/50Ksw==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4euef240hm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:09 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5ab02fb3054so4052555e0c.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781711408; x=1782316208; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MqQoQ693d9+FFoh/y5iAKv5cizC/RsqLEfYPTEBH9Ps=;
        b=W61lymsmpNxwBkr1S0LIG75Lztf73FUTd+2lz7whiiALXlqu6pK0HZAX/l+ZIAOCHx
         eXkkhShWw4JamoSYCHHVvVyUnEemQRolwH0m9U+U+5/b1aAiWwm6BPGsIGPD/2x6MxAN
         Y2NDHwcE79iHhpKQb2VAn4iGJoIfRwtow03OSi83cvAJmDumdu5KV+q8tczWL89V4zU1
         Htu1UsFReL/QnMqcWB0UDLU84alX7cqOlfGXIg89ZABDoqzjRG2+4f63TkDi+9zqhjmD
         /DvItOAy1ZuKmk29Qr/TnboonAQDXH7tfuEVFrtB8nH6yK3C+tnWBOSJTkRLPVFW250M
         T3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711408; x=1782316208;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MqQoQ693d9+FFoh/y5iAKv5cizC/RsqLEfYPTEBH9Ps=;
        b=S2w8akZB/Ope+S1hLZaTLiPBkezFZSb0kPtWCpoFsX0p8BileRcgjHibitHMnVPVTt
         p4o425p6GUo9mE8fC9MRGd2DIiCsk96x0nd3itxIBEgH2xXU1CvOWWwmwGhp2ZE8z1ed
         UVa+l2NRYdSHb8+SCWycmK4uDvW75n5NTKPkRuMazfDBsOcmYUKCYiauh70jvSThvPeu
         DlTNNbEYE/2/xbYwrdE/Yv8hfUdtnodUbV5O9sg2TJjoPogX01VTn+3AjaTkvjI9ix1S
         IqRzh/A3B2SFGondinprQb9yMliAiFS+hAwPkrs6eSwCZb5fqzOjQGZyU5UaWbf7EHjt
         9Szw==
X-Gm-Message-State: AOJu0Yy1FiTGo9zL73HHnkBNHdRA2lg4FUtzPpQocCjEnZXkLVpJzbl8
	essQbf5RsQosf75L4WABFB7fZnPLbikXG0rAFRFbhRsSBqbQfypw5vut/e6ccrh/WXTrY+Mozdd
	x/2IqPKk1CfPAhRpqlwDqhLgLFs18nZckmip9hMm3GFNCjfybs+S43F7f99Q1XqYNWfg=
X-Gm-Gg: AfdE7cmj5nxOPvkkmJ91iWcjktbfE1N9q7/5m7PnCnUBocfNJOm58iJZ04ypp45LsxR
	7+slimTcZgAvdOjREP7uY2xckNjebuIHzl14ePNTgVNbO5Tj7oW2+hF4zatBLOv8BoOdpdizlVo
	Dlc3fw2Nr2B9PoztYp/s1GSMTyCjpBfAUngkgFj6g+T9xVphk8wSMKMzLfQSpMa3whT4Jih1v0r
	74bDT/4IPeG1xIh8QaRTLjkaT232+nQIfDz9wqQPlxLu2EA6ggOFgyfXnfo5oE8s9IUvS1ey4Kz
	Xt0YsB5QQ9Kj4NVgSQofImpa1MEtLLC1JEHczzGa74JMc3/4lRCnl494lX1BmNZa1T6V9iiRiNP
	DcDJ8Ezm5F6N8d/uqF/ezQMHasF+OWzqkE7hIUyDG
X-Received: by 2002:a05:6102:b05:b0:632:88f6:d6ae with SMTP id ada2fe7eead31-7246ced958emr2598267137.22.1781711408318;
        Wed, 17 Jun 2026 08:50:08 -0700 (PDT)
X-Received: by 2002:a05:6102:b05:b0:632:88f6:d6ae with SMTP id ada2fe7eead31-7246ced958emr2598231137.22.1781711407892;
        Wed, 17 Jun 2026 08:50:07 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c856:25e5:e249:5e0f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa8b423sm168913195e9.11.2026.06.17.08.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:50:07 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Wed, 17 Jun 2026 17:49:36 +0200
Subject: [PATCH v3 7/8] crypto: qce - Use a fallback for CCM with a partial
 final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-qce-fix-self-tests-v3-7-ecc2b4dedcfd@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1563;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=+jSSnKBCewKu2gGq3nZqT1p+QKl0eV9583wFNZZdHdE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMsIch8tpiBStthDAUU24QVMgye77JzbUAq5Op
 qWCBpfAnlmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajLCHAAKCRAFnS7L/zaE
 w+39D/wM+9RDENz4MqxtM2MPVmtn6p2LDKcYrIUoafXXJuRjUfaefZrg7OUwKEMkF4IZjJ5R8fR
 LjOJlT3RcYLFe58nFc0SiC10sTCXBuZzJ/6vYWkRFw8SUsvr8dyBTCbD+MiOpQWTx8zU8+3wjbe
 YhXZ4kCYcYSnRlnJMLGuP0U+0cczoJCTm+x9NxYo4+HifutPKIloCdlXJSedI1xX5PKkUWiivlF
 ggUJ7/haBIpR4/t1s8lFNLa/25Ony0gJwCojf2sK1i9/At68oNXYnEMBMteZCmU9WQeszMVc2dk
 PJxKiC12gy2bm/jrEA7i+zCxClqUlfLk5KGCutTRGu5dltmvol8xd73aEB5aqx5sSAOy9jYZnvM
 /9fj2aRLKSg4rFWeCxff9Y3gTLM0SwIYE0p2gOJ6KLU+1XXGSsIx0KCT2f2TJNhiCg13hbu9Tfx
 SS9OHW2jrBo+k/2RA9qXUIsiSTgbprvpE5SNupDBrUoVnjuLEVoGOeDZ6D0+rbHBdW6Rqw2KXoU
 atEUfQ426HPuaF76wThsq6uO/o4FNZbpLPJva+SfRz0N25iFG0RrvVyP6F8Y6PqibELUc23zbh7
 3I3OUmWR5K+NlT6C80VzOCoJG0/TP31QRdpg2zsqO/9Qrt0qt6moKK/WyJtLsaTq9bVivnTcBVB
 sKu4nxWFnmb7gbQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX1eyoG0WM6N9j
 8X6gdPtXM5gSJ5wYGxH59WWe3o6TmC/IAAFvoQQvoWn38+hnCUcfW04xFgqo/Vs5XvDdQ6lxkZn
 XNx9g+QizVt6+ZOUkxQMFQQ5PnU+3aA=
X-Proofpoint-ORIG-GUID: G3zguekNzbXvR_CIZ8lkABdQ55eYRVvd
X-Proofpoint-GUID: G3zguekNzbXvR_CIZ8lkABdQ55eYRVvd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX1n5v/g29XuvY
 uao0no5/wCrHeHgtshHcNo1/rmV1PDaNHwN3wlHOBHr6aE2x4syabHKZbo6Ki44fsKO4MvOyh3a
 E4jVXXSPkU9pNrSkhvpg1e1QpebTtLu/aEnvDlozJpWRBN8uxy7nAQqugCe3FnAn5vSi2xfViXx
 VlumNlF8weezDVJrR9XAn58osRrQoTUfIpC1BBK6VDXLGmNYUL+B/ywlMn82dBlW+/znkkQl2Xe
 vu0qDpNLyaGw2MkjzKUJTPorlht+BnsAEisBvQYHk/j8Q6uVLcpgDuhT2yG6tXSrKz/LaH1RRgV
 9zZ0r4/suuhqM8/treBsDfSx9c8PvtMXjYxrfxf/VyARt0CgBbdTicQttxbVU8sB6TJ/WVm8lBY
 Ak/tWSr4jqS19z0wO/2CRT7NBjsDPTj8cYr+3C/mkvHUfgFhrJLL2MmG0LZfiPESd+nScLxSGlK
 jPqihlCvl65wRdJlg0w==
X-Authority-Analysis: v=2.4 cv=acpRWxot c=1 sm=1 tr=0 ts=6a32c231 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170150

CCM builds on AES-CTR for encryption, and the crypto engine stalls on a
partial final block just as it does for plain ctr(aes): a payload whose
length is not a multiple of the AES block size leaves the operation
incomplete and fails with a hardware operation error. This was caught by
the ccm(aes) crypto self-tests.

Force the software fallback for CCM requests whose message length is not
block aligned, reusing the driver's existing need_fallback mechanism.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 336614a11377e0be246817da584296124f4de5d8..4fa018204cb628c112f64c45ff6c7407df73b945 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -514,6 +514,14 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 			ctx->need_fallback = true;
 	}
 
+	/*
+	 * CCM uses AES-CTR internally and the CE stalls on a partial final
+	 * block, so a payload that is not a multiple of the block size has to
+	 * be handled by the fallback.
+	 */
+	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
+		ctx->need_fallback = true;
+
 	/* If fallback is needed, schedule and exit */
 	if (ctx->need_fallback) {
 		/* Reset need_fallback in case the same ctx is used for another transaction */

-- 
2.47.3

