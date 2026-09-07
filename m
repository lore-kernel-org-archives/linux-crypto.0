Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C8B493644
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782652; cv=none; b=hdsCOdRJ1gv43O10qjZOhdRwXKc4RQLXATTZrdUHQeWoLH3LKln3tlxZ0jVJxoQB+D+jzCk1vNGF3Wnqn34IvEmO6o5aEVR5v7uI2aTnUxgVaMauiDtifXSIr3HzLYVgHVZxVec+FRR7iMsgT4h6nKLtYKcTMsrxUpGqPE+JtQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782652; c=relaxed/simple;
	bh=LryhUbfCI6kkeuVSJtTA8hln198JB6Pb8SSyu1QSOWQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M0xyGW+lEPz0Sz2WYuG8eupxWYp9L40CFjMJXFKc5YIfdJ3RZBmYbaTgH/g/vJv7JbivPv3b7loDfTePXHD3Bm2Y9306T4PzIxwN58sqb3QPUps892WJs18BjUO0AJ4IMVfb2pbfPkOLM/ZQaqaiCba1cBiG6LMcl0goT03zqmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=beKKEdg6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KDr7qVap; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="beKKEdg6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KDr7qVap"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687AnRxE217687
	for <linux-crypto@vger.kernel.org>; Mon, 7 Sep 2026 12:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	82ofEcO83bQPd7jzXkJADlMmqIZYW+XTMWLKfngPHuU=; b=beKKEdg6vwhQqE3T
	7+WIzyyD4sT1MZMEitYBIcphABb0e5kf0yMdCxKwwXkyZUuQ3UAc9hXL03B59XgP
	rirRAMSIjdR4w/SOcYqYgP77tMkQBJQ0G7SkX/8aVSJ9mHk8p91xd4uyVYu+gLyS
	5wZv8SHqm2EsjZvH/iMVZGl/lPeWRSjDGQ6owi4TdVXg0l4ov/3CtMAGpYle6vdx
	EN3YQpzTkAfX5XJZHs0Y1WYZQzNOVvzQ1d2s4wyifx+qWq1CHEuvVKbjo8szUoT5
	6hMhLM7UibE0w02lP0HPLtAUniqsQIATjiJCHjNikG3PwlyzoPj1WZqilG9xnHY3
	jEzIjg==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghtdqgpp0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 12:04:09 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7eb6a8c61deso2988283a34.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 05:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788782649; x=1789387449; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=82ofEcO83bQPd7jzXkJADlMmqIZYW+XTMWLKfngPHuU=;
        b=KDr7qVapS07j5kzz6lGsexYxf09zbAF2itfYFJVCWMH7gzfJswG4wgOkWJvOigTUjU
         OtAoWUqy/6C/pKFkc2WWvi9BB5xdif8ceVQ9iqRUkxOJ4oKrnryCdImQMPwfzEQE8Zl/
         /zf+y0hDv5Ym81k1FRvbMyWlLl6Py9zlHHBKmLJC/AGPHdpZohF7/NIti7WPTcdnXYev
         osfDOt/5yWoZKGoO7/TJP3kQmHhhHxSRjs2+TvDWpgroMCc0CsdH8KhzggiPebIn6m3Z
         t3E3zvlwy7UF5cOV/Je/0xR1eDxcwaCM8rbKTOlXpocXwV827v4KzzHNO/C9Er+A2K8q
         3RnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788782649; x=1789387449;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=82ofEcO83bQPd7jzXkJADlMmqIZYW+XTMWLKfngPHuU=;
        b=awUqyoxocxn/jnX5o+CHhpjW1luRa97KS9RTda14aPgWkQI0a+87jBPNnmmf1CRP26
         MzVT250MsUx3OEOQwwobU75SeNa9cV6N6IlqRGCtXZtxmpeguodWeUCPd2DLrReADpK/
         bgJPOwqWH8T5sTGjGoI1HXYR0l8E1ZfPcad4FO34M0dqauB4EQLenn8fwBswkxdlQe62
         49M43NPJAps4N3FarAg8q3EQMVnwygrp6qD3Rmnb6scfC+MnGHdKbtDBhfo5TU4iufI9
         GVLlflU5Va0RZerc9mjHZMTQHK2NGZhvpYlxT8yjMKTa9nb7GFy10/1jkZoKyxfhyIFB
         8UJw==
X-Forwarded-Encrypted: i=1; AKwUvBz62ljjRRQiTUfIbAViStmjeZyzb/IREfJK4uW0NQYUH4GEyuSpNRqbS9BHfqys6kjM8ji4Q+AY619FYdg=@vger.kernel.org
X-Gm-Message-State: AFuF++mI+ZC825gNwkp974BzXR665MJpA9QBQZHwDS9EksyhanqnWzpA
	qMoDTxD/4K3sa2lGa/6a7gn8UbSaAkTubQp4TNxyLWChM3A/l8fE5v4V6TQR6WjzQesSMaH0af2
	ifbRhhpgPP2GcKAvSW5NezfxSbVaT9kNBQixiyyzKXcN03W4hJt3+hyHED/B/MUC18hM=
X-Gm-Gg: AYBFou31lfI9DfT4bYUl9IWstQC4jW0s43c7CRCUjAHfXTRBC3bNiNl6EHX/boOiTqd
	6O5jMHAB4jtyKsngCZkkT9kcYstaqDglqGCyi9LVAhOlUYzl41rQxnrl+OZl++3mAesFiM0ElZ9
	UZ7MXNYuOh7n6Ssym932OXEOCjKZEU39PBATEz2eycyMVn5xnDzruP46rhLDen/a1cxBdvwfxfZ
	c6TV4BRRS0HEt4v0m3sH7Q+J/2j8uvxMK92py4YTPe0s+x0s6hqyu6MEKxVdGd07INgreCSw22D
	idbjPkNyKjf85MRlK2sXajGoCwWmtJ+877zUnGmWfqEjALsgUPu33AvVhVJmIeqUXj6MBvcdU0r
	i9PAFmPtzXOHeOaVFr8kXGKnW8jZlBHVoxA==
X-Received: by 2002:a05:6820:217:b0:6b7:8396:f3d2 with SMTP id 006d021491bc7-6b78396f8a2mr10733572eaf.52.1788782648577;
        Mon, 07 Sep 2026 05:04:08 -0700 (PDT)
X-Received: by 2002:a05:6820:217:b0:6b7:8396:f3d2 with SMTP id 006d021491bc7-6b78396f8a2mr10733525eaf.52.1788782648095;
        Mon, 07 Sep 2026 05:04:08 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-333959d5f69sm26345960eec.0.2026.09.07.05.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:04:07 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 17:33:37 +0530
Subject: [PATCH v6 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-b4-shikra_crypto_changse-v6-2-0676f61894b3@oss.qualcomm.com>
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
In-Reply-To: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDEzMyBTYWx0ZWRfX/QaiQKF5xCt/
 D5Z4DXfDreFUvNE3tpaRq1xZ94hK+4msmWoakZ4COkTbyBcGkoiwX6VkzLvAydZxyapL+CEQl8q
 evd0zY1TA0Zd0nnh+3Q9XPy5KqtzlDy92zbm0XG4fI7YONho9qjBoYpp4qNrfGkUiDFdu2rVRhl
 T85yvFbkNJ49D/QwkMZZopPK0CGH0tPg01UsXSSPRu9c2du919T5O9PwsyhPVNnfGxY7pYZBnoe
 de+PWRE06NIsJ5YV4tZ91xWkiWyoUZCGtf24xhlVxtYcKSU9FUtxJZ6pntokkKrpMGiCUSP4r0W
 OkOzgjXmGAR9SWzxtpXUJprRRuQRDhfF0N9qG+Vm5rbAIQbEsFZ9SeUBczxF6cGOVpCpKlM2u5S
 bkZ3bnhmw7qBIY9AalCqcy12EJ3Tgk+bnnG/uWdR1sYSRIGFX+bl7TPhjo/TasbQtL5Z8hwg1I7
 RH6ZzO8nl8la4bhLB7A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDEzMyBTYWx0ZWRfX0EHgewdOrKYx
 iwxJ43ra3NNqm2S2IhCmU3PtZmtto79/tvwrIzFR9ff6ZXmcU+oCHSyV9za5OwIU9a5Q4uWsPq8
 anfALmb7yacjgVH6mkzgkJhn3mRInRI=
X-Proofpoint-ORIG-GUID: wDxFJle8uEppSHV6ItTvUMkhGPBnVTJX
X-Authority-Analysis: v=2.4 cv=U6aiy+ru c=1 sm=1 tr=0 ts=6a9ea839 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=Oj_9Y9B9b6gWBUhzqToA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-GUID: wDxFJle8uEppSHV6ItTvUMkhGPBnVTJX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070133

Shikra is derived from Agatti and uses the same QCE integration.
Update the QCE node to match the underlying hardware implementation by
adjusting the fallback compatible and related properties, including
clocks and clock-names.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index c1f06f692f66..30c7cabc058a 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -1075,10 +1075,12 @@ cryptobam: dma-controller@1b04000 {
 			qcom,controlled-remotely;
 			num-channels = <16>;
 			qcom,num-ees = <4>;
+			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
+			clock-names = "bam_clk";
 		};
 
 		crypto: crypto@1b3a000 {
-			compatible = "qcom,shikra-qce", "qcom,sm8150-qce", "qcom,qce";
+			compatible = "qcom,shikra-qce", "qcom,ipq4019-qce", "qcom,qce";
 			reg = <0x0 0x01b3a000 0x0 0x6000>;
 			dmas = <&cryptobam 4>, <&cryptobam 5>;
 			dma-names = "rx", "tx";
@@ -1089,9 +1091,8 @@ crypto: crypto@1b3a000 {
 				 <&apps_smmu 0x96 0x0011>,
 				 <&apps_smmu 0x98 0x0001>,
 				 <&apps_smmu 0x9f 0x0>;
-			interconnects = <&system_noc MASTER_CRYPTO_CORE0 0
-					 &mc_virt SLAVE_EBI_CH0 0>;
-			interconnect-names = "memory";
+			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
+			clock-names = "core";
 		};
 
 		qfprom: efuse@1b44000 {

-- 
2.34.1

