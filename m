Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113FA3B8958
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569926; cv=none; b=DsZhpPikQU5P2Cx88hXAyn8en+rVMkYUn03jnL6HiaA62o3Kqv5by1kulFGknQOgUeMWhOL5foZYU8tdL8vPMJ9mKqb9sOv64ZyStU26SJum+mE60akjNHY/cPWTbfb0TmRkU+IyI9Y4rQLNSbOdYXMVcctAzXMYfJ+UzlgMqdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569926; c=relaxed/simple;
	bh=9aNnMIHy93ye8Yvzp5QMUCPpY5lXKw/pYtBvbad6HNc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZAKd49orh80Oo43MTbqLp6JdnFgcCYjtpiLXpCo9v0oCSm30oZfIQAQvdmnzQ/JxFCTtpYNwVGnDM00+FUhklD0lyP218sMfwjbaQT1fhvKZ/OBAkSRF7pnY5af0UnKOgOWzHFrErCvlkZcOBFaln6Vsp+ktz3T5x1pui5EvpXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=m+g/vIwJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i4QlUEBD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="m+g/vIwJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i4QlUEBD"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637DJ3F83536859
	for <linux-crypto@vger.kernel.org>; Tue, 7 Apr 2026 13:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tZVHrEZHHniosNApu3I74U4uISmrILmeMewkp/0RFlY=; b=m+g/vIwJKA1MHCCV
	GXRi1RXLFUh3OxODQ5P1VPZhZG85g3NS++aodRY5cP2LfhBY9pouvA2rF8MGEt1g
	A7CS+RIkdUabvgBKY6peMUP32NgiO7gWsXX9e6BtaUQDGcgZAWBC+98JU4PycymM
	TS9tMO3Ny9t/yXC75EGA9CoJ0Ay5UbMWG1zriIOxSMkaoXHXbQpC6HijmLc5V/0+
	RjUc1OjUUKKJ07oXxbk8rbuN0jt9T7ArpHNizHqo9mxOH4+1qoAFmjQnPnrOsFso
	evvMO6Zn4zeq5A9wRKGvnITlcSzReZsty7eyqX2HxWNbDlvD9aoZpNpaXbXYsyNO
	kQvDDw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcmra2yrw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 13:52:01 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50da31af14cso20787141cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775569920; x=1776174720; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tZVHrEZHHniosNApu3I74U4uISmrILmeMewkp/0RFlY=;
        b=i4QlUEBDMKEJP3/F1sMJgaFLZ6ZX+TT62KGPXXB+og757Rex9MsENXeKoWPxL0A6R4
         1kFUP+/nN0LYxjLRUQtdvYzGK4DfMtMr23ZVjr6MaGg2VnYCjm78zXXEaYqH9VfkSA6h
         Lr310VnMmO//r7IZuhEdq2IT4+FLa213MLEOcsB7Mv5v65P8NIyKbhyPuth9gndPrkIS
         CSGn9YYhmXHUfkuUN8ovaRRDE99ZVe3+pNVYRia+3viYeMM5ClCgt9EvciUP+qyjytfG
         rmXj6P8J1P0pSJ3kc8vVeT4/oNmO3nlq10ywt/ifeBcqgDvGMGLSnymmCH7ZdX42qbCM
         gQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775569920; x=1776174720;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tZVHrEZHHniosNApu3I74U4uISmrILmeMewkp/0RFlY=;
        b=GejmKNL9vHlkIdWXRrBhL8dHtZysXoOiYPbU785e9FtL6Zt5a8W2DATYnshnxL5dBA
         XVhlTVYSEp+J0Kc6zTcdlVsDw1mzvslYwLeDTLUOQi8nNLXotGKowdYYE8mFrfcaEmx2
         H54iFxgaJPK9trn2sptWDXgJU1AjVtuYq4bJFWPXked5p2fijQFpbngf09AVfwtKfkd4
         aDSlfAyZEjbb2NUv1wDEfntUqQ7KXinhhi0kiT6m9Ck22yj4zDgEIcfcb1k+NtWORm1c
         YaY5xlfa4t/8YqhKPpc1TPiLM81syWHJryn+IowVevbxkE5sbxXUzU+4rzESKv32ljK4
         Vb6w==
X-Forwarded-Encrypted: i=1; AJvYcCVYabZgDmPR+dvdQcqX7ObqKbb0DMzc8/zhxW/5f0DqdSIpACSNSFG7UFOPRuTgg30nvYuzLl4OlJSk2Z0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjGYtBHT2diS1LvwRWnU0MISfPTl9VhSD079y5/zHzq8VIh/bQ
	C8USeYQYXLraJ1bxA/eTne1mv5r/zFVNbPbJXVY7nOA5RCZx2CSYnQNj5DtQo71PvYmyMRWLWl+
	ce+uV4IW0KcPtN4ADD9GxB9A8jke2IYGMNNSx3VGF5WrF2Gz21wQ858wkuMC2yOqsou4=
X-Gm-Gg: AeBDiet9Q5AD7/VNGwcSEKPGo6PVi1EMe4yN/Ad6G9BNloFf6daEaj8SJvLswhAZznA
	x/XdGWzbCEXk8Tcdx7S/jCMzPdxol/ggx+57Q7pfgPFi2rPkIZajytomGGutoPh0fNAn4WWPCl4
	dQr6wnLsPL8HJkws0EKGgOsMknKHv6aovexHJc95LaNZPS8xfl1lpyq869bDpFgIuZ009Y7QMOs
	D7uYUsxh77g1Eofck7wibJPV4gjYWobOa1d7PgKzDaiME0Li6TqcFjv+J8N/7Zek8h2e28OmxRF
	1i1eiX5tIOwQXh2+UkGQ2ara25h8HqOsMpio+196fgVSs6G8QdISE2O1cR/czEuGBl1oXJrSFOj
	ETN6vvL6MXRzRR+T7JoIa/8YOApc7dOK5VnOQjC3Nq2Ae
X-Received: by 2002:a05:622a:4aca:b0:50b:3f6a:1d88 with SMTP id d75a77b69052e-50d62b9d11amr261913771cf.19.1775569920346;
        Tue, 07 Apr 2026 06:52:00 -0700 (PDT)
X-Received: by 2002:a05:622a:4aca:b0:50b:3f6a:1d88 with SMTP id d75a77b69052e-50d62b9d11amr261913281cf.19.1775569919870;
        Tue, 07 Apr 2026 06:51:59 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.219.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d2971sm49788420f8f.22.2026.04.07.06.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 06:51:58 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Date: Tue, 07 Apr 2026 15:51:43 +0200
Subject: [PATCH 2/2] arm64: dts: qcom: eliza: Add QCE crypto
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-crypto-qcom-eliza-v1-2-40f61a1454a2@oss.qualcomm.com>
References: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
In-Reply-To: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536;
 i=krzysztof.kozlowski@oss.qualcomm.com; h=from:subject:message-id;
 bh=9aNnMIHy93ye8Yvzp5QMUCPpY5lXKw/pYtBvbad6HNc=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBp1Qv5KBNk+KfRBTNbkJp/jy3fPwrto+Iz5tAJN
 aZWA/KYwSmJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCadUL+QAKCRDBN2bmhouD
 1wH1D/4mYw1oOjqGb396+7veR/0k/6iogd5gD8XKPNpHrBAUlny10iXXEePJIdUqeGq/Lg2pWBx
 mDrOGBvGF99+jzF3JuhiP/n83zZLVeZXmlkZFzRBYxer3rYZCQyCMFZotD8QatQ26i6HouUugrP
 muEOgqbQkgyA4Qi+wCqXTIGWHSp4YtCc8VzGaA7nTE5OMNuB4RBdVVNi9nvvfr1QcUfvSsfn0Mc
 mtTszmaDMLFogZIpTikpVbBL+CFEhqnQiNlrqdxbNnn+RWQOH0pfvuoMGK/pDFcIUPYchgC5l6Y
 pUch/XPRfpxKsIbSF/NN6USMo9yjxJQhBW5Wl6wL3OGNzLyv5klCgRDoIFxV2RaiNWv1xpPfn4W
 loRw43NoX1YMpfK5ZrD8mL7o86qoxSbswH0vb3Zgwj1IplvTWsbtDrkj7vl1unA8Jk+HAazeSAr
 BP2D9LbrsnkxKALN7niBWCssRclbfnCVbpSuCOmyU2i9JJHqyQ1b65UoErQS7iFnEtpOZJJ2u24
 wv/y8CpuXcg57Yv986AWUhKkRlinWb2lNPAqBju3OKeJZRpxikvGheT9dATLrP5M5mGR0cQvXuW
 IemQxbiIpbwOUfQokP4QFmdAGM/MJ1ymb3iMLGAvkqUQJ8dE7D218ChA4MJRHT75kP0En7uuLF2
 QAi7ylPgReXEABg==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
X-Proofpoint-ORIG-GUID: SQ3r7_zE1Pznoc1LD6x6LrGrWJZfiPTI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDEyOCBTYWx0ZWRfX4ajQT+2vsaPv
 AerZLrcyRZEGGCaheGqnpKI5tYucl2SiSuoJzB5nC4sFXiPR/mcYWAnv4INjUly0MU2fpFBW1lo
 IrOjsuelUlhDEs1Vdis89dU3wYTQ8+ygbrasFdb9BobF2JAwrv3uJ2kUTiYsNUSi4zlbFJMwOlK
 iSOhjThGcCel48CuG689n/mB/EvL7eFtqEcbj0aHjpqexQxLxEREdIA/Sy6rVF+3ZH+Ce3hH+6f
 eHz3YYpmdPQpis6ApkAx3h8O+4k776ecfXOlTSTwDD0bna8NqhRiPxcfj1gGuAhV7LdM0dTWL+N
 WJ30QpaWG1LT+N/dAYZ41j2+QJhnvbMxiF7wXAHJDl+w6Upmb+5N/pvbv6L/rpomgDm5V4JjArn
 ODlmYdsyG8AhhUAM27Nj8WlUk/6J7KB4gb8mIRy3auCI8GZA2CZUzChZCoZcmunRk4bd0EPIsa9
 mjfDZsFaOGQ9K0nvn7w==
X-Authority-Analysis: v=2.4 cv=BKGDalQG c=1 sm=1 tr=0 ts=69d50c01 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=gOEeR9iKwsj33Yj5oN/cWg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=RBDiCIgPaVw5J07OToMA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: SQ3r7_zE1Pznoc1LD6x6LrGrWJZfiPTI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_03,2026-04-07_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 spamscore=0 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604070128

Add nodes for the BAM DAM and QCE crypto engine.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/eliza.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/eliza.dtsi b/arch/arm64/boot/dts/qcom/eliza.dtsi
index 4a7a0ac40ce6..24c680795481 100644
--- a/arch/arm64/boot/dts/qcom/eliza.dtsi
+++ b/arch/arm64/boot/dts/qcom/eliza.dtsi
@@ -846,6 +846,38 @@ ice: crypto@1d88000 {
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0x0 0x01dc4000 0x0 0x28000>;
+
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+
+			#dma-cells = <1>;
+
+			iommus = <&apps_smmu 0x480 0>,
+				 <&apps_smmu 0x481 0>;
+
+			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
+			qcom,controlled-remotely;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,eliza-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0x0 0x01dfa000 0x0 0x6000>;
+
+			interconnects = <&aggre2_noc MASTER_CRYPTO QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
+			interconnect-names = "memory";
+
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+
+			iommus = <&apps_smmu 0x480 0>,
+				 <&apps_smmu 0x481 0>;
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.51.0

