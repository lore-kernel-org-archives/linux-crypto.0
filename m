Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E823B895E
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 20:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782937093; cv=none; b=sPwcF1hZERCiRZ8Ka+LACGjp2L73L7Yr0nrJOtHfrlauOseyKzX57hLKlSZJLfYURXUwF+I7Kd1f9n/1em7lmGxZcdR8c7EG6HfyNfiu2gKC6i+EUJ8BEVYK8uOmDhIkLoOXoWdnuUaAg+p4cJTNTOpKtgGWl+4/sBnD615cooY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782937093; c=relaxed/simple;
	bh=e+VbQpfDYnB7JL1Lhq0maA2ZtMLt156FOqYWsbF9Js4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PJtgI6ITOq+G1CEsHzHe9ztmHY6jwv0q+N1HTaeUmYyAs9mHxNufcc93yTwtsFeKAP3LR+z8QZQw9wbjm4Mtcv8Bzqr8gPmnoUdw1eohq0BYsOZK0dNb1dX8zp5eeq8NdEBXSCQqCy4G3tzR8tIVodKRSQfIxOPbEH38m67Aktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LereSESi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RXC0VBbD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LereSESi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RXC0VBbD"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661Gmb3c1589746
	for <linux-crypto@vger.kernel.org>; Wed, 1 Jul 2026 20:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X+Nfpts9UfwfrC/VeFUnTh6LInzlakfP8YWFjpqBzAk=; b=LereSESiC4G0zUwM
	Fkm9wU4JZoCLFKZmYDBzTHC4+Px+zGA/hVWCh6Do4Br3SzrfRYIf3NN5MpmHsX6W
	49l47Cig6Sq7fch9OjQAHLMehBQCveiQ9hqjSkYz/cl6/fypwUOLYkwiGraB2Z0v
	YdkoR2oXrqyGh1zJCOu/86C0Io/KkgFRJtNYlrpah0wu7+9rX23U6x01caaUE/mt
	yOXjSpifjglbc+IQIn46jioejS6xeg5Uca4baU1kYchE6NNMMIrR6rvO8PRYtP3V
	A5URS2+FFLgzWl5oyjqIfZ9xfpVxvb78lQTk3vZBGknxSz9eiGrQUXwa6kFr4vNY
	D1DU+g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f53q09p6u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 20:18:11 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-37fa907f98eso945468a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 13:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782937091; x=1783541891; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X+Nfpts9UfwfrC/VeFUnTh6LInzlakfP8YWFjpqBzAk=;
        b=RXC0VBbDoD5LXVi4hD9mvsRQuoRl9ZOsnV8JCYco74DIzM62pCtdumx/BAyxWuiTnR
         Dc/cCbn9qKNHdgIeR3G0eLarUt65DEOfQGLaZkMXC5Dzix2GBUrjLFuCerwUzdwRbGYs
         LJC63ZkAHvhn7H4Ud5FWol+y4sr/i68t3fr4fEB/eIx2JOZ7VMazdIZWpyx+rHcEWOvU
         dwIiQvC6+sRsmTAsXOBpk/tOYhFoo+68GKMXg0QeofC6NMmdsXVPqhopHSHzCuZCg3Vi
         VL/ZR1Upx2afpTZVgPHs3vDBzTcbRPG61udM6u+OZw5hbe2zK8LjB4wOSI899WYfFoce
         XDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782937091; x=1783541891;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X+Nfpts9UfwfrC/VeFUnTh6LInzlakfP8YWFjpqBzAk=;
        b=tMKbRQxpKmQMezlbk3TIxOi+GoU4y4OXlB4aHpjzO63wKB+a7UcSqI7OzBPB7ymJvF
         jfk5f8gMfiB54SiJiCcgijyg/O3kU58ka0LX7RsPIugfpnAKrpMv5TjKaY2kyLcKT8Iy
         w/1+yokElH/3XaZGifVanwrR9tDYl/GxtvvideOqEbbvR1Lk9B0/HAyDZfcksq+ok1Y8
         Dk1tdpzjfwymrrgW7keHxwpFgo7rSD2An4GyMNTy1tW4bbqxmjcHVk+QnaUT101bNjA+
         fRCjYp5xbFNjW4L4/viOtYww8WkiQ8LZ3DrmGBg4HzXXtV1Y5u5J3mnCwXkghOErlrzR
         gOSQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp3Sg8Gu7jZsYBMBxQPT3T1vK6TH1riyzjHi0UvGHhbqlxIEq2Xd0yzPvkIdgfQRoKcilh3RKjsxUFvlp8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTtwEW30PK2cAz3Do/NOmWpHCNrj/3FxpOgb+uEWY1E/z5xr8m
	sgfpmVchsra6fx+VmcRXEkrcKQXCyI/BI/0iStsymZIKiYyzN7/c7OSDCGQn9C4EoExOS0Yt0wo
	3yCT+jiZvdni2Wm6kM0sCvngXqeTMO9UnlWFwOzs498OQWFKKa9aKaRnN0fj1JH6xMEA=
X-Gm-Gg: AfdE7ck3EjYxe5dkT84x1wUioNGHAl6ghKU2lOT5lM7tHx+dpWRreT5ptNKc/o6jLs/
	4RyUYcH62jJhRLSPM7gIhWnxOc7YLC//8eLdFDD3D/4jOUOl6cMUG5Ge6QGED1Q3V2LeePzatI3
	FiZpghelgWDDTLekJdGyrhZLTHJvCH223TjLt1C//wSnMLokVqS1ReF+WUSAxTD3sUkDdhOocKo
	g52uY7oDeNBbCKD5FLUeY7iiYguvPW1y7/jVOl2AmKtP7CbBOIEONEcOxy/v8R/dQdlVyWVfl2l
	Zb3Ffhs73i8EK+Aayx+Di634FzQwrnRS8rdYAKghUE0LbYYLzrQ3+RPKMQYA7c+TKmQ6Sq3Kupg
	gDUgX0u8OWVNJQsU/eCp5u8sF+ciDTau8VGvXR6Y+pdiH
X-Received: by 2002:a17:90b:3f8f:b0:37f:db06:2299 with SMTP id 98e67ed59e1d1-380aa1cb0f6mr2989504a91.21.1782937090768;
        Wed, 01 Jul 2026 13:18:10 -0700 (PDT)
X-Received: by 2002:a17:90b:3f8f:b0:37f:db06:2299 with SMTP id 98e67ed59e1d1-380aa1cb0f6mr2989460a91.21.1782937090306;
        Wed, 01 Jul 2026 13:18:10 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bc79231sm948685eec.31.2026.07.01.13.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 13:18:09 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 02 Jul 2026 01:47:16 +0530
Subject: [PATCH v2 6/6] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE
 nodes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-b4-shikra_crypto_changse-v2-6-66173f2f28b3@qti.qualcomm.com>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
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
        dmaengine@vger.kernel.org
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=dtnrzVg4 c=1 sm=1 tr=0 ts=6a457603 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=UqF9ul3sJ95V4vUiljcA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: pv1u1qK0hCWyoiTTFKgNR9Ldx_tS9iYo
X-Proofpoint-GUID: pv1u1qK0hCWyoiTTFKgNR9Ldx_tS9iYo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDIxNyBTYWx0ZWRfX2FzxEuRwyoG7
 xdGHUZBjNK+BBI3qo22bqE+aOmug5oj+6AZp1My6H9BaOMbGz0DQJPmp8XbTx8AKK7FLc4+BitB
 7ogfNmlO9LkBeYqiI2PICPLmNqGnyR1u0aRwV1FH0M8d3INLS/KtnSQ+cF1qPk/UavYvAZsYtOX
 QNaLg79nkgKunfJ24lSeJ+SK1Uqe8lF9gfMshqYZ6XlJbl9UM6ID0mdmZjH8CwQ5Cj/kqmvVadd
 lBp0p+M3/BqyHNZubrGqe/cAjlZ7LPvezxUsgwf7odYVIOK5+ZKJ8xwzT2FjsF4XbqZNyTnNDnj
 cY8Xe6lsaQKhI9HwOiOe7FfXFTaoEuJr+Z3QIQmOWk8nImLJMIsSgyoG8wio+CXDoYTNkP8Z82s
 J6YfLAdhDI5RijfMXEjk7GaoA7Xu5WfKicmYpXsnGzhqvf2NFAEYIVkkCglzInO7nZEHFa6i5bz
 mBb/+6pv9pxsD4J1uNw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDIxNyBTYWx0ZWRfX5evbxoh2++Hc
 nUWuraotl7xewrW6heZmulS/eUm8scCl2rVMl/4gnEyeYbHxAXnkm4vO9ftY2LvX1CQY2LlBTJ0
 zfNuujQ+4IuRFvsJp9OAikfAFWqJq5E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010217

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

