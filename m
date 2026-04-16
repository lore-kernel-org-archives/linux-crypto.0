Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A833B7757
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342394; cv=none; b=hP4d9h11SQpo6WD6zocq3PaUk/3yTDVQDmrg98DxEpS4s0jX8Wnth8ORT6vzdYYvdZq+lbxPvZc1lUuVJ4+1UWh4Sf7K9Wh24lm1IwyvDa6pjenNUvnUWZy5D1yj4fcDEJLiJvypHph4AdN+Pjn4vDbgX0M8a3YKDQ+gEWMfAc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342394; c=relaxed/simple;
	bh=kjNsbbAnPOWPulYetNt2ZDY/hOhxvWSIpvkr0u4y45o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LI73VUhdIK4a/qX8j31X0E0w9EuyGLNeUGqmKkvsc6odzDWu2ScSRW388sb9f39VCYU2H/wAXQ2DlTAGAP0lYCG+T0EWA7g3Y8rKU+i6RLdGWGwXiWBBBj7kbUXowOuH57xLk7NaQS03544f+/Vn2GkrpLD47bMxkC5gRhH+nhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nPwKySPt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ctiw6NnD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nPwKySPt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ctiw6NnD"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GCBKjb2651836
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oT3Z8KkeKnk8nY9vPJQHBiOQiJXSF2BmoMm4sJGTvYs=; b=nPwKySPtbV29bhEb
	0ZF4M/m5gSraytVO5hYisHzt7VSEi8JYyzTITlbUkwhPY3qi77gtbTOWtELiGzsG
	y+ogS16Qy7ymmtFG0NePx/NDl7u9Lf0LCAfy7C/hFqrJImIltr+E7C2h32jvNnxz
	rfPKGBJ+9QDhKBA//DrZo4up/EhF2xw8TEpc+KrUfoprNfUD5EEj91wd7nzZwJ7E
	zmUqiH3Ieuq9un2+u7KoirCKt5+OZyzIOI466NSDuua2rVqTl/fwVXOFD1f8w6AV
	tjUaRbi88izcWmiXjyptZZb0RkA+8Yyff+JV6OTBzI4BImuuhBcWbujiEs577oOG
	TN3vGA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djtfuh8r5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:26:32 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b6097ca315bso12697101a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776342392; x=1776947192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oT3Z8KkeKnk8nY9vPJQHBiOQiJXSF2BmoMm4sJGTvYs=;
        b=Ctiw6NnDhN1jLJ2wftB9SCzFv/e3D7HpFFW7PZBJyxPAfMiQsco8vbmYpKYsPo3ouV
         3Oz5WHQKlHEiHCru29dvq3seEu4+Q0Wm2SIbUgRS2my7tey/mQ+Swkl3LABjBwltSy3X
         WaQj1VIgCQLbN5CW+Uxcqfp0K5jJPs3gWbo5rS4t9mSly6h2P1QjjhNfmQzmjvSTkJNQ
         Dwb4UB+dCWiF5zTfQnVO0VHEOJLrKqhKmZZtJovl9j9xFZyorKgBwQ+h5ANd6isy7VUy
         Xbnz+Af6ehcAssDxd6W2tEzkwvOaEjVMgoqjdoXCCaVt/9agIBgNR7NODw6E7UzPT5Wz
         eZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342392; x=1776947192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oT3Z8KkeKnk8nY9vPJQHBiOQiJXSF2BmoMm4sJGTvYs=;
        b=KErh5aUk6VvWgMUgWw0Dk0LJPK609Th3wEoV3/0IDzsEBfF7x41Pgh13mVJCKsSNKq
         mntzzGZBw1nq4fEXOdIUmyj77aN5c1ycsJGQjz6wGKi1FiabhDV7rWMTHSoLZzlBr/Jz
         96rfa17r1UvQmxmT7nD9rt2T2fANJ87LctEncUxRxZaSCSqSCsBsVg5GHIebeAlfDa5J
         5BB5RLyDHA/u65MyMI1QYwPpWJQxX/gH1bvz7OluJzteQ9vnnQ093xNXHMgQKddVuN2a
         J5j49sfaAj0kNqQnSiPvbIjTyA8jeQsT9yjlOfWo7yuP1Z37mWxTF9rE5LyNfCVUryJB
         AleQ==
X-Forwarded-Encrypted: i=1; AFNElJ+zHPdl87XVJqQHc3SeGMih7K8jPFXMP6pyNeApel+HELzDH/1ItYzS58iVRaQu34JwN+/qhK4oX6JFdQM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxClbBUGeid8raLLrNaKzjaoddZS6Nyb0uWfny+yb/Siv5MKZlt
	JAaQbI7N0lxniYoVSwtYHBZI7jsRHegB7WaWUqM4t74pxJEaHo2MPPT35JnQTpwB+67ZV1onGfN
	iX6L+Cn9qkHnHd0r5drPvRLkJIliPwExSiSRWrgBXb4+wlGHNRuYBP5cnQCiDNZM+JVc=
X-Gm-Gg: AeBDieuCiN3ZY+MS1tZNBsyDvMO3hgde255Ae1cNBYDu0yb/hX/bwsLUYuCmZ18v3OO
	6rzVNnWdL3N1FTp54SsgT1Z3/rKdfGN6ZPFmYauWxKYMWN8lOYi7lrUfqDUx2kx2KjjgCrTLpKm
	40m/iU3JKFiW9DmanTNnvC+d5rLr7ABA0rKacu7hMfRzAKfqI9Xre//IiVraEkVRDNe9GfGEhY9
	NVFwfLKEtKuM1zcusdhZKntl2r9FgdW8rxETwVhZHCqvOsYj3o8F212FSTN0nBOqnPIVHSrA6L1
	W5hUyM1MpJdkruL3GumeU+DmQVNwJZmWweDAAmvRZY3Xc7qH+yWZ9a/D1mtzarhMCUk/PSF3DTP
	aN7G9NMO/G77oak53kQSYHHkPy4PoUppL2Nfvjs74vwB+wjWG9dkbLBKTMg==
X-Received: by 2002:a05:6a00:4218:b0:829:af4a:5ebc with SMTP id d2e1a72fcca58-82f0c1d9bb7mr24470659b3a.7.1776342391851;
        Thu, 16 Apr 2026 05:26:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:4218:b0:829:af4a:5ebc with SMTP id d2e1a72fcca58-82f0c1d9bb7mr24470635b3a.7.1776342391402;
        Thu, 16 Apr 2026 05:26:31 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0b56sm6227542b3a.37.2026.04.16.05.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:26:30 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:56:12 +0530
Subject: [PATCH 2/2] arm64: dts: qcom: glymur: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-glymur_trng_enablement-v1-2-60abcfd45403@oss.qualcomm.com>
References: <20260416-glymur_trng_enablement-v1-0-60abcfd45403@oss.qualcomm.com>
In-Reply-To: <20260416-glymur_trng_enablement-v1-0-60abcfd45403@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776342376; l=795;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=kjNsbbAnPOWPulYetNt2ZDY/hOhxvWSIpvkr0u4y45o=;
 b=TCQkWlAyI6ZWfX11Ipg2FDPp7BfXrvk8GlM07IqZY7QC8A8dbTDcuKDFGYejvRT7ZvTEtH9TS
 0tCoM5hEbBMByjKtNS0xNeKUwrFeHR/Ac9mBoW+Yy6bGvTfqJUUcdru
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: -wkhdea9ZtiAcJxO9PZGg8jp97jP0uVr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExOSBTYWx0ZWRfXwyS4GLO3t16M
 /OWOPnyu25K2f57jiOkPQ0fTV8gUW2kJzDat1lIRsfqbBEvum2gzXtrN2q6xLni3QCyGleBioNN
 GHcJiMCl7/hJbMYYuzjD34oVtmbYSlaOnmvmQerwhZCpbPsg6XHpNOCxuRf2FDLVJQ/bJTPHMNz
 tzoyGzGxaOv4L9sj+LsyVHlT8M7L48SmRnXuXSLWzF/kWidtMKA/ltHVdHIeGzJC5aUfqkLbruE
 Ju09Gcl8zDcI+qebxyzMMrTGwDKlSMUtzkX0FcROzv5PhlhHv3nRyIVT+5K17Rpn0vGuH34R38e
 VuMHmtyprk0lXQYLAwwcffXMkoFVvNgIFM9v9ouLiVPYBfBuIbk4QNV3YJ06jp3KcobZyWtpoW6
 FxzolT1XeTW9an6BSAsOxB+63RTi9dA92czYd4dAQDwM6AhyqGkS2tYW57lJmcl7stTVaAUYWc3
 94dpsR/JwSl5909sdLw==
X-Proofpoint-GUID: -wkhdea9ZtiAcJxO9PZGg8jp97jP0uVr
X-Authority-Analysis: v=2.4 cv=KrF9H2WN c=1 sm=1 tr=0 ts=69e0d578 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=XSQ5iGHSRndYU6rLgXUA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160119

Glymur has a True Random Number Generator, add the node with the correct
compatible set.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index f23cf81ddb77..c9d46ec82ccc 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -3675,6 +3675,11 @@ pcie3b_phy: phy@f10000 {
 			status = "disabled";
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,glymur-trng", "qcom,trng";
+			reg = <0x0 0x10c3000 0x0 0x1000>;
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.34.1

