Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C066361672
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130026; cv=none; b=B1TXjjC/6JGnMtKXvCvuA4oZUrSKud1YEr9uOQNhmvrXYA3GphJukw9L9UAyswKD+um+uN6NTorgid6qIIMp6oQ1DDUAm9kXKYhAa6t2FpawwxnI7/9tpi+kcuYHuh4WRqoErYigvupsCKU15DsHvmu45h5FI41n4YUDO+FyttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130026; c=relaxed/simple;
	bh=XBioX6kliz8hg3/RQUZ1PwtNPhssAHTKLszF8epseYs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cbYCAD0vaAfQuYyb7CzfEK+0Qvq3eX/bm/2X1QJnd+tLlzNMWoH3HD8sMQsxs/zf4ohyHvET6NHvFeSbd4ddM+hGJM7y1WT3x8p/VRKL9x0sIoQYygODokqpS0Gf0KsiwQejSMI0sHLz7JJxjm20AaZGH7i13SeH/5KDncGCYWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fpoPGjMI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EsD6vodH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fpoPGjMI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EsD6vodH"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A5lLlE568798
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wu+HsZDrvVopogRyY+pV7lzjsw3u6yHcs+egaFtXJbs=; b=fpoPGjMIEjtboHRZ
	sLWje+AtqwGu2i0D11Xrg0D+4yzrniHzGxJiStuzjxI8hbHg1YtVF/nktH7xDxOu
	e9Y16nWxScksbBuBgsJiQrlztROdAXI5fICt33V4ePrThldreZKC0z8YYpEPfz5N
	fu6y1pk+FdbUUoOMjhl01VdCnIySaembtWM5YpUxrVLTXRsReCspJ43bvR3bVNmt
	vhJLvy6Ime3uJ26H+ZpX+vcnYry3Blc02hkBTasZlke9qcbtJhbXaSZTDfpFjWKG
	yOoXhIOXJ1y4ACBiceT9HcXKAXUzwf9orYQk4sSdlOpHIx7Hp8vtOSNRG9qvhlS6
	4MrAOw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctdf8gexd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:04 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso59982011a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130023; x=1773734823; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wu+HsZDrvVopogRyY+pV7lzjsw3u6yHcs+egaFtXJbs=;
        b=EsD6vodHDcfzJHTFtgB/RKGEOk8VxoZaj/Ox3EK8bZSbodGCNKCXDoUQgmFOoJNoow
         5ORal7EQ8Rt8+jYY8/RDt8tz3Pbs20RMsvzUGkTyNizWEcA/970EWWXYR2cmevISCYGV
         sVjUUPzMTEGAiAa6kaQ/SOnjcLEehyHdX1I4H2elBLPGILNfcCL8ZSC3DKRpIXgih3l5
         RS2SAcuurpi4H5MjP6T2Eun6Ssw6uYoazEPrPFMiFkukVVOFDtlUa3LfPtYIAyS4JGKo
         pFSgoZzwym9rrT0sez58TJmGfAl+pL+DFuIGRlgb8DlbQjIds864GkEvBxt2ra26+KWW
         H84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130023; x=1773734823;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Wu+HsZDrvVopogRyY+pV7lzjsw3u6yHcs+egaFtXJbs=;
        b=P1JdwBKyI82F533s76azaSRJApgPzD9M9PIqTP6taSu3ihNPwUml7mtNThG+pMCuOi
         Ziymf41P57B6lK9V5KzCQrFMP4alUZt3PBSpchO18bzH0W8D2m0MD829ZuP0jTjP2Aeg
         Q74S5maQEqaPV52ORh+knLC+alxkOw4pMPAKZtK82IEXARNzGg/kwZB6uOoMaD0bcd9R
         3Mrennq2m+nvjfZmJiByo/iG8c9uiRNuR/X6WQxCxwMI+rcT6ty4Hz52WNnawzDyvzP4
         m6J9E8hd0U0d4utL8vAFAE6lHcENP/NB9i7yXDJZJnAujnFQudTanLtVM3hhw43eLsDK
         gX1w==
X-Forwarded-Encrypted: i=1; AJvYcCVB5NUBPiL+Ii91UlWYHSm/8jdxRXBYOdoYe/47dmMXJeyhMuzjM2fzS1NTet8IP3AfiexaTviEfTDM7Ko=@vger.kernel.org
X-Gm-Message-State: AOJu0YwltEIxUTYvN27J2OQeeQsnLFJ21JPU8jmB/9yzWd6CqHHp71Cz
	+xZiEaPeBpdexPYVUkQJGb0ryMYSgqtm2DxQmwX8tptFIfIX5/BTQX56AK5h3tOqnVNIf9JztLL
	VBcnQavXot8e2WXtCi247/bYxazdloNwxX2ARHF62kSs7Cg6EN9QYGrgM6/CALchJyfQ=
X-Gm-Gg: ATEYQzy9NM7gTbz1kKNbn6eEIieNAU5kJdoazHQcEOtBmx7M9kw3Kurkbe+UVLs/eNW
	bxaDHq7OF+b6WA3bexCsSBEK/X1ncxLIgz453AbJ0XQhF53AP0acimv9jIMyhrL4H76XMjzY9L0
	f3opZ+F1mkMM4Ca1ew4HG12rheZnVJgnLXszjzY4KktErfCqfYDcaEUUPjafdQG0c82uls1x17a
	mp71B7AS2jAjZUWoEDNk/9YIVQwWaSypNLnjlrM4vd+4+OI8zwVThKD0Gl3/moQVdiRTNewO7ND
	hN0+KoDs4V6K1kykyrkOHDE2V+qWfFUPpVe73rgVCX/0Lz19JleomtFHOcyoMbpSDkk2E/OKX7H
	I8cPiY8iV2CHS1JEF9Zu/D06RkfyybdWkRqQBMww15jw1l+4=
X-Received: by 2002:a05:6a20:a104:b0:398:72b7:ec8f with SMTP id adf61e73a8af0-39872b7f22cmr10560164637.18.1773130023108;
        Tue, 10 Mar 2026 01:07:03 -0700 (PDT)
X-Received: by 2002:a05:6a20:a104:b0:398:72b7:ec8f with SMTP id adf61e73a8af0-39872b7f22cmr10560120637.18.1773130022567;
        Tue, 10 Mar 2026 01:07:02 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:02 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:28 +0530
Subject: [PATCH v2 02/11] arm64: dts: qcom: kaanapali: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-2-b9c2a5471d9e@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1418;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=XBioX6kliz8hg3/RQUZ1PwtNPhssAHTKLszF8epseYs=;
 b=z9eA6tU4+OoTJGvUrw/e7wqUQ1WjL06ZBWf7eblkuT6ek651NddIZ/UesOu2TL5lRTs0QC/ay
 3nZwKaCGZEICCSui56M8qzt56oJ7XrfDT/00VRxoncRL4JnV4rGPU+y
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2NyBTYWx0ZWRfXxp6/EeR9mibS
 +d6y7PwkafkPAuduLa8n3xbbWzd2CXorOO3bg21J9nT14c8RCEq09VI+nDBh1O+HNmRqcgFxNOp
 RAsCGpoxwlc5FYGpiCKLENaXOoiJIPDIgU3cfkTkx5vS5immb2pG+37JdIq4wbOAz4NJ7JR7MtF
 6ZeRU7teI9Lr8kfdud1jgxw3a3A8FkGulq/VccXTD0DjQZavX3Nl5vVTKx3/LdJPeQTushhTwyd
 RyetXoIHaEotqw1HbO5/EVPzKgtgjf7jBSibMubi45afLdziKpTnFEa8Wqv9U11DO3yq0M3pIkz
 fk74j/My0czmAB0LRpP4sOUZSi+vPvOCe0K2+ZFWWvwSqc6IdrliENS7leJUP9aDmeOgGuSy/vx
 jKYt0t4qvmA7ianT7J0fP7H1V1UvIvBjrXG4PEoldPla147pnTNzpBjRe/trYUQMmNWnSDfrGse
 5iGDtTfnt5npvhtAFcw==
X-Proofpoint-ORIG-GUID: MTydsB7AjhV3Crv_l-W0BTWnw9SmFLIo
X-Proofpoint-GUID: MTydsB7AjhV3Crv_l-W0BTWnw9SmFLIo
X-Authority-Analysis: v=2.4 cv=b+W/I9Gx c=1 sm=1 tr=0 ts=69afd128 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100067

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kaanapali.

Fixes: 2eeb5767d53f4 ("arm64: dts: qcom: Introduce Kaanapali SoC")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 9ef57ad0ca71..7dea93d80636 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -868,7 +868,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

