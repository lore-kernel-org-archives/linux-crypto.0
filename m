Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41113563F6
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152405; cv=none; b=bCOAFGTv7+YaSE3w4b0Lhz/fPBanusQ7D/iZStbxIDKGcF6nMf99/p7mFQj7/qhXMokPWRR//WPyvwz+EgWL/e4egFbStAHpbdq3vRwpvTNhq7OlSUWRdm1RNeIFahkb5VFqQP/xu6fvyMgRZJ4MAjoXiSc5CPN4pFgknnmxv6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152405; c=relaxed/simple;
	bh=f7FNunJy27Bi9U3lAb60MrlxQ4fA3xkjg9u2My+Z1rE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MtNbmLwoibe94uLwWAAXyj5f9bpLWopcL9mT5Pr170VhTHyWvuWuY3nMCfkMU5XGxWl0SKL5kJiCgzK/xXD5lf8eQiFRNZAIXm4EbimityMQTNZyI0jMCGP+/fNd3LqqFGrja8Gaw3TNmxM1uk4Mi+bZIbLr1p3RClOFYWLwzns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VpvohYU6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EBEwpA/i; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VpvohYU6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EBEwpA/i"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N5FLcf3705359
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fUtVi70WtEO24h85MpRTObjc+viksu9O5W7FRXPUnZA=; b=VpvohYU6CO9/2ggH
	uA1XRJMfL9iTm3HsXV3fy31a552i9bJ4j8wa4HPEvkRmN2p4U54myLftPDHfQGgK
	h9jXEEwVzMuCzaKPoBA/RWBZyx5A7zYKjM2Byz98SgDrCgPuGN3wYlLhETfbB0z8
	xHfEidKHA/SAQODUkFexJlVReZtlDYq0wdDH83HRU2zrxEZ15KwHVZMMbAScdOyZ
	oc2l1dIhqgPvFJyRAbKDW+yiQTNOWFoi+beCODTiE/px2GixUgEvoZyv1vYkYUS7
	ZN2sgJGh2jjAOw/Ymcb4KwtrvHBsHAkycdMm60bMPQQW76DnczXMoBSdgaIkwaP4
	ztVUIA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buuaysqp0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:10 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a79164b686so24848345ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152390; x=1769757190; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fUtVi70WtEO24h85MpRTObjc+viksu9O5W7FRXPUnZA=;
        b=EBEwpA/i/oZVgP5lmY6JuJK8Im4BeTFwVjndaknmDr2VX5vIe/HPSS9e6BKUz1aE4a
         msALQJtiPI3k4BUR6AjgUIBkmF9+wX0s4yg+ZbS/QpwXue0y/sUZQZsWkl5lsvom1dDo
         NavScK3pn31YMwAZlnuPkjWY9jDpC5eVP720UItBJoPPIQC980XZdMf61ULZLQ2yesNg
         /5HvGShocWNZFy26QPv/Xw4pUq2/4ZTABsQlrfZ1WMN3+f5//QoeHe0uuIRlTJDWDNcH
         xSPNsDV5wVbpgwqtMzlyEp0o2PzapG6hy5wLW+T1SmNOp3fCHhyLr8bpqU2Bwc/elNGu
         tzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152390; x=1769757190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fUtVi70WtEO24h85MpRTObjc+viksu9O5W7FRXPUnZA=;
        b=bE1aeZ6ypW6kfevQSSFQ0OqkWoTTjShIcHR9AbnGaI3Rs/RDozRtb/yS8hVSzkMPCO
         fap/GP70Jfm23uCkyMPsjZUKjpQTSjZrHCfEWNK5vRJeJZ1lywOUdSPJf/gzYLeTAZdk
         1tpl82xo/PFEYOAXTpp7JrWPb9AfGNdN300pwCjJc+bslW8MYXMAs5jLePUp1dxU4HNz
         dBUZl+gUCcqbUq1YavKIgIRYHleeQmwcqMS4716eZGxVfmLkD0+iueXfS6x7ixr6Q9sI
         kqzrO/9WpoI2EXzTEiRKeUPiqbD+ttsZ+3O3NZPVUX+VkWw7VAWSgbMivQYYrImCNuHE
         a7Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVhhtTlrJClUIdEmlExg72PRV1R7FimABnCghoXbjLGYkN7HzLKM/4zc9v4BRaweDtbhO//uB9keaeWlcc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5VhHqtDvmGWDjEA6OtpUsZ8sq0ewI120uKD0rCK77Q4gVAR5K
	e2PGrPlu2XW6C8QOyYd6FwQb24u7LUms36bM1gEx93srF0xo3zJxY9CoTzBOS7eEEzs8dWyMMMP
	j+pi3QFqjKgV/FQfoZH++8Dt2gml3Jp0/ufu+8H7bDD24s7Z4c4wnWpkPjcBUVcgubZA=
X-Gm-Gg: AZuq6aIoAe2udlpMuZs169zPFsDskg6IhNBuYX2d7yTmUFGl2OJk9UYw06P1Y1/rNf2
	UVsvrUAHWPxG8Qa24UIVDm23YqC8Ugy+q161g70FU866v1g1fAgwwG/X43x5LL0oofS11cwT2k2
	ipVJXO0lu1qOroU5fNiFuohVVajqWDpeqnXEO8ArM0AJq4MwImRSRXQE9c6O2gYi/vK1GO93ofd
	LpGY1ON7OM9YX4HtbcUudxmV+HMibIVojhXEl3vttHy4V/F2AbI5LXvuHs7QLBI6KwgzwdKGA/Y
	aGybhSVlKf1uYieCqLXdNfeFUoXoMwkzCndkb+7rQj4rwLYJWXm6esbpX/L/wJsFt9CMk35Y/2D
	qIyL28xtADZaQ4tCpPfTBxUJ3k28u2qnZwWc=
X-Received: by 2002:a17:902:e842:b0:2a0:9402:2175 with SMTP id d9443c01a7336-2a7fe598dd9mr19755995ad.27.1769152389577;
        Thu, 22 Jan 2026 23:13:09 -0800 (PST)
X-Received: by 2002:a17:902:e842:b0:2a0:9402:2175 with SMTP id d9443c01a7336-2a7fe598dd9mr19755695ad.27.1769152389040;
        Thu, 22 Jan 2026 23:13:09 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:08 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:30 +0530
Subject: [PATCH 06/11] arm64: dts: qcom: kodiak: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-6-e9059776f85c@qti.qualcomm.com>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
In-Reply-To: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1235;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=f7FNunJy27Bi9U3lAb60MrlxQ4fA3xkjg9u2My+Z1rE=;
 b=pV7X6A3t7dEsEi54Ci06JmVtvliafYQjZY9hYjrHA2Rzssx/7ruPaAKaCvaeLT2sA/Xbme23V
 bzbeHRmv00ICJIJoppHTDgbIbgInKm7VEeEA5JCyVFaBlqbA7zc+SX4
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=GP4F0+NK c=1 sm=1 tr=0 ts=69731f86 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: vhCiDJJkQGmVtf0erdyffNxwZr1JKTzw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXyZWs11xr8DAn
 RH/+vXcQv+RfvciWmPsSSd2S9sifkzOVb7ySRNXHt0ybhjmOa3mgPR2R6c9/1wHFTGm4vzWOHzJ
 mJjQFcz5vKpE3+KgkvBYT1D3UzpqQMWQGW+Ovu2pYIOl6BBe1AAc8D7ftLEkzhobHdcakvYQBMc
 D/hmVvphDLv+8wv8JpDO5sFMrI4tj4CCpxsNn9kFyYQSyd6MM51XSPen8otACEcyUGbeQ1OAjEr
 uaaOO0lsDXa3zZaMY7sPP6xq++yeF0DTq1IQNTn8Ha8FquQaYLbr3xTr011UqIekQ9FEu+RsX86
 iRi1LdYe3p7xiStdGTwUBTlETkAC/gT1KBipww40gXsKAH+QuMKKFsWOnyEioPquLFOqhiyvf1I
 ix7++7+lKj3Fzpc1/qIpc6n/4LU8lak4FtHQSt1v4FzwXQHAd2hDSY9ZLyiGsND/oEcZ+8IDWEW
 i2VW4wHOk9UAsLwVTyA==
X-Proofpoint-GUID: vhCiDJJkQGmVtf0erdyffNxwZr1JKTzw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and 'core' and 'iface' clocks in the ICE node
for kodiak.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index f478c5e1d2d5..8f2bda7af74c 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -2574,7 +2574,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

