Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0854541DEEA
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337566; cv=none; b=m0acsnD4iloLviuquJKwuzUR22xieA1GqdZBht4E6IAh7BBVU2iG4q6f7EuaWnVAx6EHf5mZ+C3V/Eh4IrBaYe9mg+rfY8YQibHvcOdECw1/sYrbm0NOEP5g2zxbbg1BhWXlopCorQ3fC+aTzRb3PR8jBxayzRkhiJrt9v82Qkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337566; c=relaxed/simple;
	bh=GYBtHdAfmrTdiirah8LRW7CT3SS4Dm/ZvWHw8lcOR9c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uojPGRjcLm1rS9PhbWv/jzVJi+bFtneS1IupWvb+DlpNz/Ys6eMUyPE+TypLIORNxgMYeGf+gTCe1QxVr7Rvv+m4BjhhGY1m9WYoz2N01vvxCAP1AFah6E+SABJTCQSA3pgiqTWt8IlqijVLGQNtPU6EY0rWgRJ/Yk9YHnCgnGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NZmmDXSm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KpxD1iTK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NZmmDXSm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KpxD1iTK"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxJjm316458
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0+52xMxNLQjypHGjCHfpQGl3UABCxpAIWFYZGy+rwJc=; b=NZmmDXSmzrivJIPd
	ZyZ0MVwKD/gP6BFrJxyqG5n4FwkftO9QAGxtEdYaNcL6y+aAcDvwRaHBnM+zOpfD
	Xg2A/tN512eMRk27ltjDJ51g5/7gVrlKUZXaAW43w8fG+TPa4zi4wSCr49zj30BM
	SePssU1S9FOZ/L45S7Bx2PSDEBF9Q6tINSmNy/Z/lp4ZhR50WnIgoxmZBOTho+3B
	C/6dQeIrIwUvPcz+Bw/rnni24NlhXzjbghVpiYsUoguG7FT8zj9ZgvC9bbnAyUsb
	/nCYYL1XDEk0vZC8+1gKcr+s1qPUfOsMDO0v+MZ41fRReIvmaVg1VURJUqUGtH9C
	vIKGZQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f87q7h0rg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:43 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84622d6102dso4015529b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337563; x=1783942363; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+52xMxNLQjypHGjCHfpQGl3UABCxpAIWFYZGy+rwJc=;
        b=KpxD1iTKtDkA3avPgQnpDNkhZKnDCb6Rl4TPkuIlSF5MVi528Sr8i6Z3+/iJD2HWIg
         QGMu7M7Uf0zM3ZayBpVmhVwzootIz8GZjabaEPpWWkGTLbl+S60/rCEht6/RglPNahBt
         lzRifZxVce5zfLPMeBaVosxRSktgtgcep3rfZri25sh/zmgHSjTJNTyIgKOatkEzVz0H
         r4o00BiUvn/ALScLIPU9mAB0IbnAv4yho+mVy//OR0pMdWqvs8LW6pQjixLBefSBsY8o
         SSz+n8Bs6758XohO3ICFGTS6cGo6QBhGYzICziDkee0TiLg5cXC/9fGAXKqYEs7o9jiT
         L2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337563; x=1783942363;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0+52xMxNLQjypHGjCHfpQGl3UABCxpAIWFYZGy+rwJc=;
        b=P4N0RxH204bexfHFhamO4BEGeRrEyfv7nUEcXrt10VdKc2A7SbA29okYz2i9Kk8tu6
         /jDDwsw534D/uTSFpdLJzbLS09sV9X8Nh4H7agPMAi9JC/iGOEAfwvKkLn3H+Qz568EB
         jzddDFxJrynr7XmuBw3nVgvpwovVhrI5DoGKNc/OUxnjv38Pw4aGvHwjzh2WuQd8Z8Mw
         9A6JO6sAVGpJDMGDaR6pdPr6YsckMgsjni4SQ9CobsA/Jv2o6WLg3gIb51J0kDoQfQdF
         goTmKAmY5yDkWh43w07n+03F/t1rci4l/jOjwOD3+jXVyeebKB0RefGxrB/1RbA8uMnA
         /Mwg==
X-Forwarded-Encrypted: i=1; AHgh+Rqvwxzabr2nmVQoFwU2u7NIto1KyYSfYfmXPP5dw4/xodPwnp2pjgxN+vrC33fmQTGhnX9enkG7EOd6ZRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywks3fYgGO8bfWdL7y+87Raxq6mw+Fm4Mi4HkvZfVFoi0zgpONO
	IB9/A5sK6kw86g8ZOOxMMniMyF5TbEIKBaY7uOytSqqM1zDzowvnPuIHM1XRKmU/Km3/xOQwTas
	eNtzGCVS5GxmJp/5jn0eo7drNvALPdmUczbnH45nf24FvjPzCNRqDvrG2pL+Sx7RCPno=
X-Gm-Gg: AfdE7claFOdI7wnjkiiF2VmXNhtMvRszaVPupgvwvnb3rdw8lxO6tmEaYmkaO2LO0Dx
	z/LCnD2AAnBZz1tAJLRsHqTEhpr1g5rdrjS+BDQhZXm7ylzo/6bKD001l4VpbaH7WRbDz1Qm/iX
	hl2ha12eg36lkXmwpguczeuambGpbW7b1e6/OpFw+qN6RdWuBhGFlKbAR4wllsVcLMf/5neM1Cc
	S6OScNK8HDdsyu9RHDpe6FhYw7w0v9fkQw1HLnYuodwz+SScY/ahVtvAC84Nt1PaXA7rXWfEHsj
	9GZAr0E8w8DUfZvbPU2z3IMqDjD+j8t910pvszr5LY4BE0evw9TSPcD5/q4XQL7bR1iVotK7KYA
	4p67YdlVU/Jf9G8Hf4i7AnKDSxmIP0gWsAnZLhx0sI2d2
X-Received: by 2002:a05:6a00:f8d:b0:845:44ec:a648 with SMTP id d2e1a72fcca58-84826c0e777mr151316b3a.21.1783337562887;
        Mon, 06 Jul 2026 04:32:42 -0700 (PDT)
X-Received: by 2002:a05:6a00:f8d:b0:845:44ec:a648 with SMTP id d2e1a72fcca58-84826c0e777mr151295b3a.21.1783337562368;
        Mon, 06 Jul 2026 04:32:42 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:42 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 17:01:34 +0530
Subject: [PATCH v3 6/6] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE
 nodes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-b4-shikra_crypto_changse-v3-6-23b4c2054227@oss.qualcomm.com>
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
In-Reply-To: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX1tpSpxYzoL8E
 CAh9MSmtCuMoRupLnrLSh7NZhJJa69Y9u3nz2poVxmMMyQ4GQk4mVxapYCXtvbvhbrrWArlpnJj
 QrzSXprjDmFW2OfRmjLdfCQoXCarQDDddCMlFGvALusRj2nCfXBRvSs/PRXteyrGAQW5sn5b0pu
 hpe7JZzBlRsYuEEu6TsdEZ9sDSevbb5ut2YSKCnS1V8Jf6IdMCyGLRyFrcruX0IBowwy6Cox2+y
 y/1bHGBGWSJYn5lAjM/9RtDyFvny6KFhYPyWvaPyyWdfb6guPxsuC6cR4Ud7fHjGrCHzwsVmzrC
 U8WdfLzjYfY3b2sGVhgDCOHcBxYovZK7PxvHabbAVFeOR5PqrjbINSYtwlVfhvJb+dZbXD+OGBh
 TGcney5i1niBrzlsyJ7IX2FBM/UbdBG0T8SxnEsjL0MqqEIEhJ2OTkB2ZSpzGFXZKFcmAqwcozw
 bHPI9RbuvOexThLOiAw==
X-Proofpoint-ORIG-GUID: 5vKwiHD2zqGlqIy9AI_NQRZp90awrmCO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX12n+b9XPf4eZ
 q6Tt9LTD3yO7cFZwvwhJX+8Jvqdu+H5e7u1ObOXjg8/cKghpjcvNn1QzAEqbQ5MYLHpvg6muZuw
 3a0zeK8koJjmkcE2hjkbC1RPYnYJjg8=
X-Proofpoint-GUID: 5vKwiHD2zqGlqIy9AI_NQRZp90awrmCO
X-Authority-Analysis: v=2.4 cv=f9N4wuyM c=1 sm=1 tr=0 ts=6a4b925b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=UqF9ul3sJ95V4vUiljcA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060116

Add device tree nodes describing the crypto hardware blocks present
on the Qualcomm Shikra platform:

- BAM DMA controller used by the Qualcomm crypto engine
- QCE (crypto) engine with DMA support
- TRNG hardware random number generator
- Inline crypto engine (ICE)

Also connect the SDHC controller to ICE via "qcom,ice" property to
support inline encryption.

On Shikra, different BAM pipe pairs (for example 0x84/0x94 and
0x86/0x96) may still resolve to the same resulting SID due SMMU-side
optimization. They are still distinct pipe pairs and therefore require
separate DT IOMMU entries.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 52 ++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 4e5bc9e17c8e..a95e2140416c 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -482,6 +482,41 @@ config_noc: interconnect@1900000 {
 			#interconnect-cells = <2>;
 		};
 
+		cryptobam: dma-controller@1b04000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0x0 0x01b04000 0x0 0x24000>;
+			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH 0>;
+			#dma-cells = <1>;
+			iommus = <&apps_smmu 0x84 0x0011>,
+				 <&apps_smmu 0x86 0x0011>,
+				 <&apps_smmu 0x92 0x0>,
+				 <&apps_smmu 0x94 0x0011>,
+				 <&apps_smmu 0x96 0x0011>,
+				 <&apps_smmu 0x98 0x0001>,
+				 <&apps_smmu 0x9f 0x0>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			num-channels = <16>;
+			qcom,num-ees = <4>;
+		};
+
+		crypto: crypto@1b3a000 {
+			compatible = "qcom,shikra-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0x0 0x01b3a000 0x0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x84 0x0011>,
+				 <&apps_smmu 0x86 0x0011>,
+				 <&apps_smmu 0x92 0x0>,
+				 <&apps_smmu 0x94 0x0011>,
+				 <&apps_smmu 0x96 0x0011>,
+				 <&apps_smmu 0x98 0x0001>,
+				 <&apps_smmu 0x9f 0x0>;
+			interconnects = <&system_noc MASTER_CRYPTO_CORE0 0
+					 &mc_virt SLAVE_EBI_CH0 0>;
+			interconnect-names = "memory";
+		};
+
 		qfprom: efuse@1b44000 {
 			compatible = "qcom,shikra-qfprom", "qcom,qfprom";
 			reg = <0x0 0x01b44000 0x0 0x3000>;
@@ -521,6 +556,11 @@ spmi_bus: spmi@1c40000 {
 			qcom,ee = <0>;
 		};
 
+		rng: rng@4454000 {
+			compatible = "qcom,shikra-trng", "qcom,trng";
+			reg = <0x0 0x04454000 0x0 0x1000>;
+		};
+
 		rpm_msg_ram: sram@45f0000 {
 			compatible = "qcom,rpm-msg-ram", "mmio-sram";
 			reg = <0x0 0x045f0000 0x0 0x7000>;
@@ -582,6 +622,7 @@ &mc_virt SLAVE_EBI_CH0 RPM_ALWAYS_TAG>,
 			mmc-hs400-enhanced-strobe;
 
 			resets = <&gcc GCC_SDCC1_BCR>;
+			qcom,ice = <&sdhc_ice>;
 
 			status = "disabled";
 
@@ -604,6 +645,17 @@ opp-384000000 {
 			};
 		};
 
+		sdhc_ice: crypto@4748000 {
+			compatible = "qcom,shikra-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x04748000 0x0 0x18000>;
+			clocks = <&gcc GCC_SDCC1_ICE_CORE_CLK>,
+				 <&gcc GCC_SDCC1_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&rpmpd RPMHPD_CX>;
+		};
+
 		qupv3_0: geniqup@4ac0000 {
 			compatible = "qcom,geni-se-qup";
 			reg = <0x0 0x04ac0000 0x0 0x2000>;

-- 
2.34.1

