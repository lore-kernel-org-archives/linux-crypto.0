Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706A63D16E9
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777966831; cv=none; b=qwFBzrbKKPHwBvFP1gtNPRQXkFiC5hzSWOO7/xPDiYB6TEm47N5IBI4RocGwbnoLEpCugf9Al3+Xs3Tp95gvpuWXeXRysN0Lqto6WwyL4VjH2XgcSurnIScVRi4peeLejw77r5yxUwru/7ol85OYorPlWuM8s/HqvdS23PrwAc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777966831; c=relaxed/simple;
	bh=VhTqfkkMQhd8FYkjcpswypDwlwspPTNc9xO7Y0w70kg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VQstJDb51JJrTyxzjiC4XP1Tw/X787x1gZGBTRd4Hvm1u2vwV4ZgO0zT3mT7NbcNpZGHF7LLD/HaWDvqcsj35hHO8H8F25LaM8op/eldCGFzp5M7pwhR5TRJ6lWpS5YH/I2mJ1WJsr+2kpPrlfP05QAAnt08B+NS5xpcAV4ytAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T/nHU187; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RC0XtA8h; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T/nHU187";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RC0XtA8h"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6455e5HF4128856
	for <linux-crypto@vger.kernel.org>; Tue, 5 May 2026 07:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	udL9WX9i+qRibq7xQkeNL5ESzGcURWui+twSW5eyu3M=; b=T/nHU187QdnSSA4c
	X+R+qpj1xS0acD+WG5Wf2QusnXD2WZg6Yb1kqvmrjKb+z7w/dNdkr39KJ5Hn+1V8
	qSCsqav79SzA8V6vVSRJqQAq/egoNayWOcxF6GlTiqZnAfMf+VbHGqGeDdsC7c86
	q6r7iiD7g4jZBGYD4ULrKwL7CwF+gxwN2nsOY5cTYOC4or4FS1VYRCwfZwpBQFAD
	HX0gjL6rDCNnI31SDhf1pwwFVuIBkEkKHJB39lrVCR3k8ff3kmMEdkM5MtBV29lA
	ejkWh9s7/9KjLaiFGtEnrSL3BSmbf1xfQ54DOVybZt0Lzum62wbHFSePaDbXZd1f
	uWgexA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dxsdw3ynu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 07:40:29 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b9a6b13826so97613775ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 00:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777966828; x=1778571628; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udL9WX9i+qRibq7xQkeNL5ESzGcURWui+twSW5eyu3M=;
        b=RC0XtA8hbwGKphqxavtIg9sQ1FUZG7QUrXt3WgpAP421kzTaxI1cBq2CNxculPHh66
         SBXQGQfbUQqhPwqBtMQT8r2JD9ZlpGMBYw/pZJ7T+vIufl3gXuG9DG/faWNCRMEgjbJ6
         nZYUTZQ7yY4Wyk0KTtHhsx/kkwmSyUsJ5fOMS/uy93rJA+hQ380XZU/SQn5JCZ9N3dR4
         KL7w548jksLqUpd329K/UOXUwm65JnXZVkiJfL13XmpfdpXWjQ2u0H9FNBRM6BTwtZPH
         oyRbc5Zm0ufshY0cK934/VhTfIXclS/dtQeWzdddav91TfL4fe3jPboczesFPD/v1Rsn
         JPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777966828; x=1778571628;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=udL9WX9i+qRibq7xQkeNL5ESzGcURWui+twSW5eyu3M=;
        b=bXhoCKE2cUx8kItoQyaLEddhPALErWdodlUMaKcK4K2yJNP1t/VXjkm7lv5JlZVkA9
         pyfXYh3cL0jk+f90aESGwtb1bCUdpBQNhiAWtinfSpCm6QUsiGLdjX+qClFtlV1gKecp
         lI9nZfm+/+/f1MrYsBTNLEMSrERCnpc0ePiFcc085awcmyGNcrX7kopLV9wOHJCjBvWa
         TZd5uoHAMXwABA+ZWX3elVBWyXmRNIWTs7WlzFz2mId2ETO3VyMLU3EjDL/WZJfTyFiD
         GpWaHmuJcoAE7BRSR20tw9C6hzHVwODkHJSw1hbba5NahMUi1JoEDnRlvWYuW97+ionr
         zUvw==
X-Forwarded-Encrypted: i=1; AFNElJ8DEwNL3WdAtWZ4qSldtTVvP7yd/B4m3g31Jic7nD8L+zuazy75lQUKOxg8Eqsw7Jgo7g0oZYkBIbK2n90=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPK5IliTaR3SjC7ukAgIv/Rgnjrjo7msPa0HnH2TOBDVolYRbi
	Y9ERo1u7FccBwvS21nTcRHljznIyE13rspSOg5SKOtuIcu+ZdiR82Z1Zb0RaORBCzbQyjiuAsAe
	Y+XC4FOFEFXwM5Owk73VD/ibfhdn+eis+fhnxG61Y6R9W9lLZuyHAUNvmPsv+9iXIRAs=
X-Gm-Gg: AeBDiesbEDvS1v8I+jC/7s3Pgi1VslVUvweXSB3LrMDTh+qRfyl0W5mohNVl4xsSTLt
	NDGYVEt5NjmkMEcu9l30vlmH02KbO+r0aM9OJBd0aODZMuVv548VRjC5Ht3pTJEDiigYfe2XHBW
	G4Wh1MRRd1WZubx0pZoTHaEkXvgVH2ohKnySDS9YOAUUIbDs+zLQPvYxQH6mmhl2La812lZQvjZ
	4qlLU7MCJDWrCKZRUQUhm/G1ORIYdCK/v/Jfs/FUbLo0PqhEIiTHYnqZceCCX+OGvfM50GQpqeY
	XJqQoicNbByLsrWps+oxvw1hP+a6v1dUwrgIWkYJqHRPmD4p4VLRLbsaZuVYhCMvVxmY6U19fmV
	7JV+WxUkT33+jN3dJHliyUffUaACwuu8qBScJYzdLDdguPNk43sIatsoeHA==
X-Received: by 2002:a17:902:da4b:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2ba5388a2d9mr17357645ad.34.1777966828240;
        Tue, 05 May 2026 00:40:28 -0700 (PDT)
X-Received: by 2002:a17:902:da4b:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2ba5388a2d9mr17357185ad.34.1777966827742;
        Tue, 05 May 2026 00:40:27 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaadb1esm132663405ad.20.2026.05.05.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 00:40:27 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 05 May 2026 13:10:04 +0530
Subject: [PATCH v2 2/2] arm64: dts: qcom: glymur: Add crypto engine and BAM
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-glymur_crypto_enablement-v2-2-bf115aeb1459@oss.qualcomm.com>
References: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
In-Reply-To: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777966811; l=1767;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=VhTqfkkMQhd8FYkjcpswypDwlwspPTNc9xO7Y0w70kg=;
 b=jnk18UAmmalZ9GblsatNuBsexUjsLEXa1XZaF/a96LR2qQg7mXsno6jRcWH9d2vYEq6RdxLnS
 o68I6l4QrOrBvNQ8cAaZM7l8mYVKsaGF6ZBqOh8foSQCsqZiy43SnCU
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=a7AAM0SF c=1 sm=1 tr=0 ts=69f99eed cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=FLCKqCdKcypBhwN286YA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: ExDlyqHjnTzauUOSAc1uvYR9JgLuj1Rg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDA3MCBTYWx0ZWRfX2oeYMa+cP32g
 SsR+Q1YLFtKi9kduqJQAZ5n7gc9YSM0Lopc+kkbLUjLG6jDTwgxqmSzGceMhAfOneVIGaVMO6Uf
 //OJ4jEh4vFNWs2sceBr7ySlUsqgO7knfkAJ/S3uvPfccX6u/Z3TCjvKUZ3LOXpINUL0RSgzEV2
 1Wlr+RAr+xo2wPq8vMg40nWSqyBLFW6Oog2s6jocQZnJPr6pYCJnBM+nFXjXG35g9EQFM5zoWlU
 FMr0vsdYj9zinC4HcEVLhzjaTLlyU24Jr9tSwL0EHedD4oV/B2RQI5M9o3zT2wlJDKl/uY6mRLq
 LvUSJnMlXiBnEWgcWFDP8Op7tbFBgBefi7U56+I1KFpxk54SwM+wVsZChHumlOgZ3lPrYB3GvN9
 9iNMZFpfuhGr1kgMdWLS6zmTFCJVo3NcQf0sC+yVSyufC2Ms9UYwNJDpDERQfQoZdKU1iCRThi0
 dLEfK+1KDWeBGe34NQg==
X-Proofpoint-ORIG-GUID: ExDlyqHjnTzauUOSAc1uvYR9JgLuj1Rg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050070

On almost all Qualcomm platforms, including Glymur, there is a Crypto
engine IP block to which the CPU can off-load cryptographic computations
for achieving acceleration.
The engine is also DMA capable due to the presence of an associated Bus
Access Manager (BAM) module.

Describe the Crypto engine and its BAM.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index f23cf81ddb77..349da9966d52 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -3675,6 +3675,32 @@ pcie3b_phy: phy@f10000 {
 			status = "disabled";
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0x0 0x01dc4000 0x0 0x28000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			iommus = <&apps_smmu 0x80 0x0>,
+				 <&apps_smmu 0x81 0x0>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			num-channels = <20>;
+			qcom,num-ees = <4>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,glymur-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0x0 0x01dfa000 0x0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx",
+				    "tx";
+			iommus = <&apps_smmu 0x80 0x0>,
+				 <&apps_smmu 0x81 0x0>;
+			interconnects = <&aggre1_noc MASTER_CRYPTO QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
+			interconnect-names = "memory";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.34.1

