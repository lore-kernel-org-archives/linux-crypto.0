Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4531C31CA4C
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761726339; cv=none; b=OoFcim45jf8PrnfaCCRd4LdTkwu5KpUqut1W9gNuELea36EqvXm9afHt42tR3L4oPceWVwbtDdnAALwaKTEbnjppQj0AgC+7yyNqrb8vqXRqo6x5qfbyzYZvzvYmFSBmhDkWK69h4d4qOzWBcQEulrkbIHfHmNUWZG0Kv9uMtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761726339; c=relaxed/simple;
	bh=oaGswpRr8TZuO8BqEDJi0dGYIU2tgB1owqLnPNSrMcc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=obO3Baq7nIB/T1e3qGhyo69XN3mv2+eCsE4IuExe1a6C8QrasKdcH5/4oZnrHyKnYfXLFhqqAq5RyDHszWM6fKbmHYn8iEV6W7+gWMIgRV9kA55E3+9+QB3tZZe3oQ9cYyUBlDhYa07J01z0H3RbrMEE/8pprfdlZfFQdOlP28s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B736Mhe7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EohylcG6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B736Mhe7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EohylcG6"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59T4v5CW3755485
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=/mjtL41D3+Je2IaYCzcV27
	gHgziKWyKCpwABs2uRZvE=; b=B736Mhe7hWTcwNbV2frTK75CrX8B1dEc8d3xtc
	mrqfuSWot/EXPp44rOO3z8qkueniKKHoACkI+MziYjgCobgOKhvzYx3Lit0lNJnD
	2822mY49OedG++AOgXu/RECpU24DC1CPFLsy9fKj3fbZlhv2suzaTbcDudDoTWS8
	RhG0818kKIjLpDXOQbdUXJUNs9BxhfrSTaMPCfyJSddGppQVQpWK5bmZb3JXhFoN
	gm0OBUfwCfTxwPRETJNsfG8v60oi8DVyRcisS8WlXYlWUgDcDwA3pPzXyNQwmy5B
	dFYAwC3WXKWJejTREOr21av6RepWcA1ArASuHjSpGYrN2I4A==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a34a0hs7a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 08:25:37 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7a2878dca50so9599050b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 01:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1761726336; x=1762331136; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/mjtL41D3+Je2IaYCzcV27gHgziKWyKCpwABs2uRZvE=;
        b=EohylcG6xP2e3YJHKM7iYYA9hxMG2Nxs4mKPbQgwJ0tMFjMP958QaK8iWmU+W7v3vy
         dCBRP0DMda0e2bkYm+LaoJs6e1/nWBsRf6nI0xV40Nyx3viQupvBLW+nVih+xlAe0O6z
         BIGCxOBAsfsCb2gQo1VuByW2IL3QKcMEatGgf/7f9vV13ouoKeW4R37AtzhxITYHVnBX
         soLu2Ijl+OqhyjZDQ/MnIWxXxAdct8IhSfWfoMxHol7GqF40TnzR12KTlYclDjxUNv75
         +tQx/5ryzt9oriXF9/HKeQlL/2gpLZF3ZlkxaWtABEMGsl2hoTp77gea1slnvl5zpMjT
         qj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761726336; x=1762331136;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/mjtL41D3+Je2IaYCzcV27gHgziKWyKCpwABs2uRZvE=;
        b=Xejmt57FcXljuLNzKMGaZz2fuxQdXP8bLcMupYpZF1zovZHMwcdQ7EsaHdaSqMr9xu
         sJaZKIN6mFYeVguSvVOqmrwTxsBGJinMYj1OjutI2f3jL0VHCRcskGt6/+KpDol3USh9
         98iq6k4RQNFzJYH/pKYg6I4Q8xdgbIgRRALa233LCwtCIpBte6ctYL1KpGxtgcvobIqt
         fHv0ZQKE9Pa6fwlWAMB5F2vae1mKxcncGntUB1IpV/tshr2DhwZcP1BowChDIy34gcWH
         pxXL9WpeobySSODLOHd5u6EzhMgsd0DtldUa7e35VKkvfJ0SZOlbsoe/wmZUl/2PhJio
         dXew==
X-Forwarded-Encrypted: i=1; AJvYcCUUrKSwQhrR+tJgshBsLTVLlAiMimPzgkiBThXE7YgWTL3lxnettgqg6UQEPFe9F13NaJD726EfPBLcCwk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7LU+khee0FxzEjBKl2aonhQLq2d3Pjfa3vdrrHJThXFM614on
	s/plErikm3Rs8sYF+dSKKN0nbNaeRlOr3C+K2bLvuo9oqfGCNv801vwXCT4F5nfPQ5riqtUTgaQ
	8+M2FtTnqPN7xmPlbFNmUy+OkM2USQ12Fydb0KPIROFQeUpMyu8Rxpj0s13R8dVxVU80=
X-Gm-Gg: ASbGnctk9S4o7F1ZOogvm6p0N1XzMEbhArqaVlVGRXQUjoICvh8sXhF1dqJXP4fy5J/
	gub985Dxj1d/uTwkyq4SJFxpTkt/BMPIgnhjmd6Tv2BhUut3lkTBoIeBEiG3vfTOjyXIvvPx5sP
	BX1V2xeOYesKBEFi9JBuJYtRnKUp8rW42PbNkehMotTaJ8b1PJMep6rt+BwolA+vBf63+ZunXVO
	UuI7XKLCs+xuzNP6zT6Ym01eNiRgteOoGxAEcZQCwGyXs6UEgdgjn+sLYsOx2QAEydMDhnMiKEY
	aREHGaTdAjgRGsYX0y38qXMH2xz1MY+A5zYMP+22cosb9Jf0lrkuOA0421tGLUAKP1H0Is3dap7
	JPwECpE8zIb7iFDb6bIkOPQSsNPIG5Eg2WU/3tSqKZm53cCf5jA==
X-Received: by 2002:a05:6a00:18a3:b0:7a2:7a93:f8c9 with SMTP id d2e1a72fcca58-7a4e50fe6e0mr2420611b3a.27.1761726336220;
        Wed, 29 Oct 2025 01:25:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdwu9I2TQE4JgtPGfiqtZCT47MqLwqdVwhg+Uadc9SFPOftHSOYAWImtgiupnpmZjF5bK2kQ==
X-Received: by 2002:a05:6a00:18a3:b0:7a2:7a93:f8c9 with SMTP id d2e1a72fcca58-7a4e50fe6e0mr2420568b3a.27.1761726335699;
        Wed, 29 Oct 2025 01:25:35 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414049a44sm14158850b3a.35.2025.10.29.01.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 01:25:35 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Subject: [PATCH v2 0/3] Add Crypto support for Kaanapali SoC
Date: Wed, 29 Oct 2025 01:25:28 -0700
Message-Id: <20251029-knp-crypto-v2-0-b109a22da4f7@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHjPAWkC/02NQQ6CMBREr0L+2pL2FyR15T0Mi7Z8pFFbbJFIC
 He3sHIzyUtm3qyQKDpKcClWiDS75ILPgKcC7KD9nZjrMgNyrAVHxR5+ZDYu4xQYoURpulqdSUI
 ejJF69z1ktzaz0YmYidrbYVfkOe61waUpxOW4nMVePuxcYfVvnwXjrFK6F41GKUxzDSmV749+2
 vB6lTmg3bbtB5Tn69fCAAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761726334; l=960;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=oaGswpRr8TZuO8BqEDJi0dGYIU2tgB1owqLnPNSrMcc=;
 b=X3lmcORf+EZ90MJ8+JpDraYpCGMhWn2vOWakg3T9ruTOHHwYTI9h+cC7lKL6ArP2wufZlUgS9
 NrlAeG49+3zBJ7l2D6B8XObJDwZx21qSnGF7mRKEE31R4hppXJnbTmJ
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Authority-Analysis: v=2.4 cv=HvZ72kTS c=1 sm=1 tr=0 ts=6901cf81 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=q5Rk1KLrLtMTd6biEZcA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: miXAWAnp9z6BLOLxnXUzVORJUN39WcPe
X-Proofpoint-ORIG-GUID: miXAWAnp9z6BLOLxnXUzVORJUN39WcPe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDA2MSBTYWx0ZWRfX0QpbEz43z2lZ
 wxfgjASIj/zdZBWNH0hVjmhBliSV5Biu++0E3/konm4KYGEHh9tsznKB1LvTd0GBzP6HbufozDf
 YWVpbIlRAsnMklGTr9FLwrSc0+RAFvTIE6CpBzxJzEcX3v+Ad29N39SPnOTnmWnLHIpELtsoY3K
 +Kp7ahWRN+atkfVBiul3OwnpE2IYzzjgbMXBYRgBaM1+Oac8rn8eTdO+PiyEE9tvCTG6bg7oUcn
 /hW2b2zs1n1J/SSQqy0gucC9TzJ1fOuKctXZcyOC2h+3qKCa3mgD/PGFrqQzRzxcjWl9VIR0yh7
 TDfT7IGbaGbp+HubG5prh5ShtkQuHcq2d7InJom/wDfCvD2umBEqXNgQ5/itYeERf44Ue9cdf1r
 xAA99Q1WsU6NPC7fLmDPJyQz3MATQw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2510290061

Add Crypto support for Qualcomm Kaanapali Platform including True Random
Number Generator and Qualcomm crypto engine.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
Changes in v2:
- Fix title and commit message in patch3
- Link to v1: https://lore.kernel.org/r/20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com

---
Gaurav Kashyap (3):
      dt-bindings: crypto: qcom,prng: Document kaanapali RNG
      dt-bindings: crypto: qcom-qce: Document the kaanapli crypto engine
      crypto: qce: fix version check

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml  | 1 +
 drivers/crypto/qce/core.c                               | 3 +--
 3 files changed, 3 insertions(+), 2 deletions(-)
---
base-commit: aaa9c3550b60d6259d6ea8b1175ade8d1242444e
change-id: 20251029-knp-crypto-e2323bd596e3

Best regards,
-- 
Jingyi Wang <jingyi.wang@oss.qualcomm.com>

