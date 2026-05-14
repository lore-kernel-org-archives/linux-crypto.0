Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516B3939B5
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778786653; cv=none; b=jkzGp1WjUJvQbnwFUJtcYgc2xepQO95EpLaWDBSIAzksFqcXQhX/uqGCyIf97iIC6dZBvlQ+huSTQgoeHyKh9IDJKIDzrCoUsugO1fymbw61Ax/BoHFkMA/ZeRImD16/6RgPb93q4Q4Dl8r1KhRt0p+txPTMouATUu5oKpSLZC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778786653; c=relaxed/simple;
	bh=070Xbb2yH7rviMxEVsDp0aqueE1Kr933aUlYRRWqT0s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BAzNiwuEi+VURl1QgmAT2WJ+eMbJmRhMo/ScV6oTXVIRnU2cOeY4G0dZvgjQtd8h56ueRKu++YurzQD4e81B7cLWF6FDGuy8hF4K4Pngw00icxvoyO+dEhgQmJFDMm/0j85J5+bN9B/MG9XLHcDSMniDDrbe2gIa2Hfakr/c4K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=C8O3Zt+u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hqD8A2pS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="C8O3Zt+u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hqD8A2pS"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIpT203200311
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XBdCprBquhJT6uJVe5HV6Os2DLU+NPDukg1/CpLMV1I=; b=C8O3Zt+uhCIKom6L
	Dnlt6RMMVI6HUw4Q9tvyfpxUDrQxsH7C3rgbM+HyZ5Bq/0odZlUIQVrYpJQDe25k
	QCP4Fj+VLw5P6lZ4sLMolh570FU+WWcmL2ty0BNu4kNAf9+o4oedEY0vEnzdMyj+
	mVmeJDKkZ5TI91bJ6cFdsUtSIjIPwY+/4Amt/Tx22kShnMh18+9UgfsRCJhuKoZQ
	9kHUoZTQrzUqQ05ol+cvQ3sY3jwzqAlCp3oahPgR9llDLCWtA0dHU0dfz0b7zMNf
	JtvYnnSnUUcloLWvgswnhMKysVj95Yv0flxBcDv+OFj3fRDSrhP8AG5dzxYAxPvF
	rsS47Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1qr3be-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:10 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ba86e35aa1so129666655ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 12:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778786650; x=1779391450; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XBdCprBquhJT6uJVe5HV6Os2DLU+NPDukg1/CpLMV1I=;
        b=hqD8A2pSvLstggTsiQtNdx4UtL9QHxsh32vqtrEkAHDFLZHCmojOSSptsjZ1KX/Vtj
         l9713+xeq5YFyVgxEIpOfRldfHwebBXzsD8PheBUrLDbrGCRb0LV68ywb60LM2x+Wv93
         SOq2KP7NeXerqfxoZTa2RepqgNBZTd6e4ZB2TK+cguhkPnq8Ojd6m5BoTr3oKOhC+XmW
         7+gbULq36ymSdWRouWZPkjBvaalMQGqH05l+qYggrXwfIfZz99CDckNJf6q/gREV9Nuo
         RW/udUWzL52wpgjWKvnKq4yCm27U0wWC4LR2D1WkOMOzsJJ7xW35UeJxyDjAF16PJCDi
         1U+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778786650; x=1779391450;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XBdCprBquhJT6uJVe5HV6Os2DLU+NPDukg1/CpLMV1I=;
        b=LF5vowFR2wzo6mTF2lRk1OEbzTgAPHSzV1nw/ZCp+gj1flTKXQFUORqZ8gJZvZO84C
         5ADnYcjSYQiQfzxUGGOdAG8MPDxtRqV4R7A+k/laJqQxqHAa8NaAW79f83f20r7gfetF
         Rxuj7pM7j/DuvIYcMwIcFDo7wEBW5WectjpNnO/8P8xh1lX2sC8jBpEfGUTrHvvqzRMo
         XC0WgKKpdhwEdgsONYCTIRz8ZLejVChYyIJ88E6dYd38KExmZJFwogDzCBg0IlBPKdr6
         q6DibIOLglc+FlviiTE9DWD3PtrMb3nmyrfauqLVY/QwQW9eHdGkrYuVEKreNyA6UtDm
         McFA==
X-Forwarded-Encrypted: i=1; AFNElJ/aVcJe5AaWz/wF+417rvAPiROXmJ6VespX5OB5xTBKNR+ocmreGgHaZ4i1IvBF8gne6jUPAYAkSwCrAkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvxKaPvHY/CfJFSjjH0+YySJQLa2KW4WR7/RscQpPgLC2QOuv1
	ouDUd9r/ESjnm0o84mJumXIQWSMmEWqIRHzFco6PIA1RzF+1qPYKlsC4R7GszmQ+OaoXcn4Wxpz
	132DfYaqLhDu37yhi010bSz87xbkMEzYwV7M+JKFXyG331sus7hOJqsn0a5uWUKWKynQ=
X-Gm-Gg: Acq92OGO5yjNtnWxMWRR/G/dYwzb8OTIeNt7LLKthgs48hbh+WTXDadEi5Q3D2QT9LK
	dJ0xM+zG6Vz686Iz55m4nfLgHVAzgt6rWB4/xSZCc7bJxj/UlAYkMda2FxqeEtecWOYRBZrHcyr
	bz11zcYJTHrKPgu0PUHV7fk9tPDu7kNMVECuu+wiwxUTYb+e49jYAv8hSc8P9qyXsHSEmSx7vIF
	YiJpYSn5ktLBJjqOY3Y6+iWilAc7RrTJmBFWf1+psbRyhqNSBZte64TMA2g+LYvfLNIFqym0141
	y70hDBANoOpqqfq8yryrIjArAzBw9yj2WCGo9P3PvluMjz+lWn/4lTaoFZKrKaj0zuYeLtPY0jQ
	gNqpFGA+xZsGjUH/sVitORLCqiW2XdJ7xNKFdch/crF5yiiZVkUj4plCKynsZa11qGg==
X-Received: by 2002:a17:902:a618:b0:2b4:656b:aeb0 with SMTP id d9443c01a7336-2bd7e9399f5mr6818475ad.35.1778786650130;
        Thu, 14 May 2026 12:24:10 -0700 (PDT)
X-Received: by 2002:a17:902:a618:b0:2b4:656b:aeb0 with SMTP id d9443c01a7336-2bd7e9399f5mr6818225ad.35.1778786649681;
        Thu, 14 May 2026 12:24:09 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f291sm35506535ad.15.2026.05.14.12.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 12:24:09 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 00:53:38 +0530
Subject: [PATCH 3/3] arm64: dts: qcom: shikra: Add qcrypto node support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_qcrypto-v1-3-80f07b345c29@oss.qualcomm.com>
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Authority-Analysis: v=2.4 cv=HbkkiCE8 c=1 sm=1 tr=0 ts=6a06215a cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=fM5HeO57NUmuB1IZ8XwA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: 3cBH1_8DFV5L2WGR25bWPrtTMid3g2y7
X-Proofpoint-ORIG-GUID: 3cBH1_8DFV5L2WGR25bWPrtTMid3g2y7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE5MyBTYWx0ZWRfXy05PeeK2Td9v
 wTaWNGlDo2dSN79VkyQ66ASrm+n44CHb/bTmLxqlxmiZzTfTNKbD2bhrEC9hEHMigOP9mBNv3LO
 VdBoXRtU9AjzD2/J6YCO9eX3R3hd9Q5ogBMI4nvrlLk0vl+f2KJ0RmEsTw3FRYVpfPChqr8Vdm7
 CecVwUij8gVfD9tZmKnGxAwlW2Q7V2Hyr8TGsF1e6oUiodWspNnhyKLYv+wom+7H26fgt5joEL5
 7YCn+SldLLNH0rmKA1ziQWNuuxLj9vTXfk0JL64y1Tkr4Cruka1dx+3bsFjnSqHaL+dTlyU53Hq
 OtD4qbHJZV/0WroW9iQfYaE8hC8z/LkYHJ0PADUN9YOvlmva2ipxhWsWfXj0/fJQt8Iuv3yPUkC
 ouGTUEVXxXmBVxsZ8pzoc4knHmsdUupe6ShmzKcf8/7dwlmerl90hIGDbHE+RPadChQUKwAmDO7
 VbmeZX6DUXZoj0Nxgpw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605140193

Add qcrypto and cryptobam support for shikra target.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 262c488add1e..dbac0e901d6e 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -541,6 +541,41 @@ config_noc: interconnect@1900000 {
 			#interconnect-cells = <2>;
 		};
 
+		cryptobam: dma-controller@1b04000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0x0 0x01b04000 0x0 0x24000>;
+			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			iommus = <&apps_smmu 0x84 0x0011>,
+				 <&apps_smmu 0x86 0x0011>,
+				 <&apps_smmu 0x92 0x0>,
+				 <&apps_smmu 0x94 0x0011>,
+				 <&apps_smmu 0x96 0x0011>,
+				 <&apps_smmu 0x98 0x0001>,
+				 <&apps_smmu 0x9F 0x0>;
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
+				 <&apps_smmu 0x9F 0x0>;
+			interconnects = <&system_noc MASTER_CRYPTO_CORE0 0
+					 &mc_virt SLAVE_EBI_CH0 0>;
+			interconnect-names = "memory";
+		};
+
 		qfprom: efuse@1b44000 {
 			compatible = "qcom,shikra-qfprom", "qcom,qfprom";
 			reg = <0x0 0x01b44000 0x0 0x3000>;

-- 
2.34.1

