Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350B3352FAF
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777019733; cv=none; b=jW0UiSGLZYkqZiCdN5xiMo3q5sH1yL0+QxQMZYyIEkmYCsiRuDnzz7s16sYVhfrwCrWjM6P2ivp4UlAFOJWOuaNvr5O6IG4mrUtVxB2eAU/zqlRh/RYv/nYOzzgTLYgcGPX6xgcqn4jE4QMGuwFKYxeOlFrj699IQLXhUrOq2BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777019733; c=relaxed/simple;
	bh=gWiGMmGQbBe18ffsU4L3hPUa0ko8xrTojxRmhL3FHzo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GiuWeKbVpJNbGtgw68jUvbpfzj51WNbc/P30pGDJKuvhi4MCCeZf7HUZ+DmZ1pqrGnRzKf0xPe2Pw0F8XmDcbaUSZvV87DvILVi0noMDkpIm9YRh+TqbUp2YgE06FveQJgpMaJwEXNx54krvDBm2OAnUDGEDhfnrWJ7HBzZL50M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OHAxppWO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dxY6gDaW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OHAxppWO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dxY6gDaW"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63O8NZoi4012134
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=rNli9NxWLRttENa7rW5FZM
	vDeSsOpn5Sj86spOosc64=; b=OHAxppWOoDsuJS2xyl+p6bynmDH/9RYG/Ad0Mm
	ZDGgwwQQH3BKNF5DWH6fPst7MG9hA+M5pm2wJVFGaaCMphBHv1JRDA1dPEpntNha
	httLh0JlZQ2JGMqHE48hO/f7RYbzOGzvBvyZ0PdMK8VR/6dO7sy/U2WQLWf8LWgq
	YC8p85IfGacdYp0r+vhInERszvEFF9B94JdYyE/OTnHzJnEQFipNO2SoRH7pvFoP
	L7IkowHqPjQNcdfhyRcctQBwmevZk+x74XX3CWKldKBKyKgXOWyELcHotFhaB4tQ
	t3HTEsVz0u7aqo5okPDC+oQjvIbzPxu6FmWXWKEe/lnufwSg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dqpq9udh4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b4654f9bb6so79994645ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 01:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777019727; x=1777624527; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rNli9NxWLRttENa7rW5FZMvDeSsOpn5Sj86spOosc64=;
        b=dxY6gDaWtCAzObXml9ex1inbOx6rbxEYdxmGVli1aR3YISXemzGJBoA9zOTBA4XAfi
         AEjCfAbBFSPwQreGAR0IW/iRgRci8dfjk2OYSdCVYOa0iFyUUfdlOtBVwUCR8tY20vmj
         P52ny926J5XPKlsF06WXg68IgtWp4aDe5KEZllvgnaMldzByY8TBQFU04A/RrT/ZuxB6
         U1gpSii8waY8NMfjF8IFiCiAkGF0tycCTQilBsOeO3eXMLvu0FhxYUNO2PyT5sgNmAqi
         Mvm7GKalQCgZmS7xoF+fEyamGO/w3wgcR7T6bGb6kqOEOssbDN7ZYjJihU9O65uvJh/+
         fkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777019727; x=1777624527;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNli9NxWLRttENa7rW5FZMvDeSsOpn5Sj86spOosc64=;
        b=cxQMcc/jnMxcY1zkfyLfk2364mvejR9iPnyR2v5+oW7RlXJc6HuZ6Wg1W89rAFd+DG
         cDDk2yKWEgqVFIRhQz45/hQFil7t4pfd+4m0+HABnPhIm68XGCxSBZWPvilRJqJyj1fF
         W7fUb/4xSfXZ8gXJPmAPeR+czedOtDT78YykA0SPQS1QgxYtgWM7fw0/RoVAhor+/J8P
         FrdDsaAu2l7Qqy0U2QN3KVEeOEU77/6Sdh3HWc2efJdERnprlbSvsFj76diov1wxecBv
         TArOYLqRKEJ/lt0fCcMEcqBLuje8a6NvZBEEBpxRdmjt7nwF4S7e6ycR/xNY8xwfbINB
         6QWw==
X-Forwarded-Encrypted: i=1; AFNElJ9WSeUtQD3idws5VG+qwXPU0qSov2HJ6peFQJaz98F6itf3zu0/6zmBaVm9UgjnGF27NNieTYvo61tkGIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLumuTRxDaYBlvKPh5tu8kpM3lbh2rcwpu1i9QpXWQB0HMgxGz
	xLrux5RXuUqszZXSTwKLzGtyGCNB/ukW2FkA1r7LOJHVmHXHaxeesl3j6l34QMEc7RWtUfhIhaj
	HCFtKrjmBS4xKLP5dp10hqTQSWl0LWr6Ka1lZzOihdC41Nr+bM01sY8NVKES67/ll75A=
X-Gm-Gg: AeBDieuaB352EkGgQqvmgPtUrWt5pRnVlxOFfD19hOeN/iLSIR4V4nP8ZH9tMLXOkif
	AZppdE+XHAGGCLSHu/dThHuPiKxnkS/GGZEWHh/1g8C0UKtDDS09qBd8WIQLbKkEPiyTC1e1Zoj
	kiYdSXgEQi7iKf2h/ODWVu9xED2GPKOQvO0VPPkJKKGXo7lceJpUsTIon71Tgahn7jJSO2F+qxG
	Jz6SsOVZLf0Lm4yqG8zy0fSYIEelqhImGry3+XvODfYrhlJbPWeXA+MXmYhKXrmznjNuPfd7c8p
	jbNowfAdZ2z6maeYh3C+9YPOWCSgBsoTGdl+lxNZmuTDeqy5m4oQwZttRMW1ubsLGftwFayHOA1
	A+FwFr88A+uG4RBhByvVaqZqAAi6pA0ByLlIVtit+rl6FT+nM6eNWBOT8Ng==
X-Received: by 2002:a17:902:8603:b0:2ae:6092:8d93 with SMTP id d9443c01a7336-2b5f9f9469cmr247750615ad.28.1777019727262;
        Fri, 24 Apr 2026 01:35:27 -0700 (PDT)
X-Received: by 2002:a17:902:8603:b0:2ae:6092:8d93 with SMTP id d9443c01a7336-2b5f9f9469cmr247750295ad.28.1777019726761;
        Fri, 24 Apr 2026 01:35:26 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm211389495ad.72.2026.04.24.01.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 01:35:26 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v2 0/2] Add TRNG support for Glymur SoC
Date: Fri, 24 Apr 2026 14:05:06 +0530
Message-Id: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADor62kC/4WNQQ6DIBREr2L+uhhQJG1XvUdjDOBXSQRaUFJjv
 HupF+hmkjfJvNkhYjAY4V7sEDCZaLzLUF0K0JN0IxLTZ4aKVoJyJsg4b3YN3RLc2KGTakaLbiE
 1a9hVidugtIQ8fgUczOcUP9vMk4mLD9v5k9iv/atMjFAiqFR66HnDaf3wMZbvVc7aW1vmgPY4j
 i+f+TyEwwAAAA==
X-Change-ID: 20260416-glymur_trng_enablement-31518b69fbca
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777019721; l=865;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=gWiGMmGQbBe18ffsU4L3hPUa0ko8xrTojxRmhL3FHzo=;
 b=swVv+9inHaLQJijV73JP/+R3A1MqHF5qjmMhiKnp+YAEkkMKbnHwXmUBESvlk1LR/16Bq5Px1
 m5cPKfvCbtZAn4ger+a8c7mC7GMVTDLJV+CWPuzD8OyAQMpVor/wQ0F
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDA3OSBTYWx0ZWRfX1HfGiVNcdt7S
 7oUKkjJIgVVvxmmyZUlK0Z9TB2z6kucqAXeGUDiykDJRiQGL7fXi0clXIJSP/DqyveAS5bvEZmz
 H0xitMrsdE0nEuT90CX7usTQdZMB6p1mnAApKGCmabf5CnXRniE1Wny2lOCygTeS4GuSi3rmwXj
 7bZfy5gGa4KhQ4Hy58mqjnUgFr61gyws/tUkzf8FVTInk2n9CfQa4fKxIH47pBewRPwrtLNxcjq
 0DltUAvKAq49Ck35kTOZAJEn4kijAxI1yFPObuOx44Y+o0b6HF0IeQv2RWEh6vEmoeW8tobMwAP
 9FB46lyjtqhXrHgqw4tUUaASydPA47rYsykv/GfRva0d62Kgm/j3jxF99lkjlm/8vogIHvun6er
 +c5Gch3CmVr3LduFZIKPzPhYvm/lQxEvZPWZpjGVgg1BVcfWolingNrBWiZNo9kPmWLQQZzUgOk
 y1LlQUcsqqzgKNu4Wgw==
X-Authority-Analysis: v=2.4 cv=FPMrAeos c=1 sm=1 tr=0 ts=69eb2b50 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=kES01Y3mVqZ45jXFSuIA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: Vt3f3Zt06WZYc997e_zOpBQLXZm3lpf0
X-Proofpoint-ORIG-GUID: Vt3f3Zt06WZYc997e_zOpBQLXZm3lpf0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604240079

Document and add the device-tree node to enable TRNG for Glymur SoC.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Changes in v2:
- Padded the address part to 8 hex digits with leading zeroes.
- Collected Reviewed-by tags from Konrad and Krzysztof.
- Link to v1: https://lore.kernel.org/r/20260416-glymur_trng_enablement-v1-0-60abcfd45403@oss.qualcomm.com

---
Harshal Dev (2):
      dt-bindings: crypto: qcom,prng: Document Glymur TRNG
      arm64: dts: qcom: glymur: add TRNG node

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 arch/arm64/boot/dts/qcom/glymur.dtsi                    | 5 +++++
 2 files changed, 6 insertions(+)
---
base-commit: 936c21068d7ade00325e40d82bfd2f3f29d9f659
change-id: 20260416-glymur_trng_enablement-31518b69fbca

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

