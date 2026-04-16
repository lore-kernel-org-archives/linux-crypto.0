Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381582571C7
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340873; cv=none; b=aDQljs+0uOwI722BMCWlZ6vDu9V3Bgp4ME2iKfxl5QzjkLilAazCqoM9ZV8e5cmOQOHZlO8jMSkHgvga7hAd9wTIIvOfM+/qBjZ/pqsD9nQ03CrqUpuxWw+BXintMFf4fsAL4o+uWrIhXR3+fWiQ2zUa84R09c6rJyS4QpVBiw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340873; c=relaxed/simple;
	bh=z99JMkf1pnX2Nke7sOx3xwAS/Jwb310G7tQUUNdVAiU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AWJ8tVNsBzRe8YJWI3kIuDUcjaxTJsG9esFol/r2GNZFINt9geoMUjW95dwf0v/gR9cNRCRhC6v/sLGnEoJeoG5uchrHZ+6jriEpn3Xb0/1XSN05LdJRsBi1zMVedH9dkdULo1HkGBaLdFn7jcp/RGKaczDbeTg80evJ24Qyi1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WiREz2qc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NxnTvvX8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WiREz2qc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NxnTvvX8"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8YYqG1702831
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	J0vIm3ILY0qd7lApxZdqueJQwm3beMzxpl/RYFhS7+w=; b=WiREz2qcJmzdyVRR
	UfcgZ6fCamnFQYCPPCIBCq4rMTpT0Hg49vwj36xRJS4evRaXZwPeoinApoBkS0ab
	mimn5aqa4Z6UgIAer8i0aC6m+3cJEN96Y5O12U/Qi5CRy46WwobJQaDUo8OFQQyV
	LM90/qqv74yBaqwC6/PbWuulKEIvtq4SCXVG58f4f1cKQ3qwa3erLYCtFcg9jwBw
	FVBYdC0U/xIgqi0FwH0onf6du9Fc0tQawsjR09st9sSz22ukYr7ZeIUd9FWyTN+3
	vxGXvA3yHw0iWQiguGsnMA7rzNkQ4aMUXTRV+ZJmbNhzeuydPTarzwISF2yCYM2t
	cjLbyw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djdamkpdy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:10 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82c89d4ce16so5488390b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340869; x=1776945669; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0vIm3ILY0qd7lApxZdqueJQwm3beMzxpl/RYFhS7+w=;
        b=NxnTvvX8D64Hcx6Y+We3BW33HV3rVJPU/XVH/wOvXNUm7s/guB7HtHW4dBG6xsXE/a
         Nd7sfLLh3CIT0ScjmRp4S4OQJwkybck5HEnH/8LZCd4Bs+Nz7l9nAQG4CRuWQWzCGOIY
         q+is43UCxAxAnITCvGJ8gBE8lNm6h31Y3TWQpE0GAe5tmvn8H93ckhqKZoFnbOmn0Ucn
         vzG10dlWkTHvyg2K86ZGb9QM002RZ4Eumr6nhbaz6F3xP4GpFF+KRPnE/bq2A5tu9gX5
         J2FsS+YC6tLRagHMTrO9lJUB/sL9/RaLmG1yp/EfA7QKylIqrjkQByILf5Xwab9sse+B
         GV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340869; x=1776945669;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=J0vIm3ILY0qd7lApxZdqueJQwm3beMzxpl/RYFhS7+w=;
        b=gPHC9wOPS3Ww2EYrGiEcOwteL6exmwdYHKJiNM1qtvgbgwhLFz5HXrf48xUBiAEZvY
         db4OPfRKumiBhV1aU5sBu/Wsyr/3U4wMDOk/EB47BkhpK/REP0/YUBdhLBOxZEcgsGPu
         3N4fLixKNfqB0l5SlZSTzpC77wd5ik/jLJvMdVVSba9RU+crJuBzVjgfqMmO1IRJxasn
         3q4fq0cBYUvZi825xyx4z1lhu0jAB+Wz/vFLIJwsHeQI0/KMILvngy6MvpsUFgPEoFgE
         sDM4bG/v2P2Od/vyftFK+1PX+EZTzVsbce+aQpDtoAYH64zonqEzfJ5V8oS0Urcr9YQV
         3ipw==
X-Forwarded-Encrypted: i=1; AFNElJ/v6mjYnWwyjDv8BnQgsXMB1CmNrWXi1hJEHerHTUTZDvFHlghxzreL4vYVu4yANQ76k+XFJz7WGsFd9P4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+6/GRzIThs+KWtXiRwlXpWGxof81LKFQFBnxhdVC1LZ+xCabm
	ala09KdmgGufz4dHIgKlp+sYuH2UnRVljD+zf447NH5vEmJbOy0MnUeAmnsWanHll2k25gE1Oev
	kf7/MeUoul6h5OlEdRw76msYlxQ4eAvBXitagXbP0pDv2sVj02mjsjYdczweLVs9NJrc=
X-Gm-Gg: AeBDietVNiNjD2c0dXfvYOW/6hnLVfepgg6c+MHxzDMikuj/1XPG74tnwHjTqT0Bi+V
	vnylBXewl/RU7gvddBpc+4dQPfuZZfVaSEWASYi87+wcCR8vw5RlFSO3EEkOi6GMnUL+p3EXj/j
	+gJkdgEvuyXt+mEJPzbSby2rX6Rk7tf/usaAjdcKloL6AbBWhZx8bTqNaE3FUzuFd8Zi5Oj3eyY
	rzrWNLWudPxbLeS414nFIvyUgT3bptQr/Odumj/UFlmM+X4EYaR1kIRfNQ0S/QfdSFpjQkrc8EC
	aI44YayhOvEnmrZsfARSSzuFbYnTGONZnbNENQKE2TksRt+71xhCCQkHugxFY662x3MHld6jCf/
	weg6xrTJo2iw21rG2cDWMWs+P0JViUydyS+pRMsnSUpF8XjDdCUaOf8ophg==
X-Received: by 2002:a05:6a00:e13:b0:823:3079:7c7 with SMTP id d2e1a72fcca58-82f0c2f7a36mr27612304b3a.29.1776340868710;
        Thu, 16 Apr 2026 05:01:08 -0700 (PDT)
X-Received: by 2002:a05:6a00:e13:b0:823:3079:7c7 with SMTP id d2e1a72fcca58-82f0c2f7a36mr27612162b3a.29.1776340867803;
        Thu, 16 Apr 2026 05:01:07 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:01:07 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:26 +0530
Subject: [PATCH v5 09/13] arm64: dts: qcom: sm8550: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-9-5ccf5d7e2846@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1513;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=z99JMkf1pnX2Nke7sOx3xwAS/Jwb310G7tQUUNdVAiU=;
 b=XnVWyzluOpdMBMeal8wz/S0LJ0FymNUpqE3V14EQVZk4ct28WkuNED24E+P+K1rdKIdlIIVhp
 zQcyr7IZU75A1E1MCF8BA1pYW0jhLqfuHpHAC4Gr0sUk1UijDXThHog
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: v9CuhjFz5ZIGtNXvT-FiFmnPYhea4TDG
X-Authority-Analysis: v=2.4 cv=HMjz0Itv c=1 sm=1 tr=0 ts=69e0cf86 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: v9CuhjFz5ZIGtNXvT-FiFmnPYhea4TDG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX/8nXAgpXnsOw
 sIVSO1ZqjgLkJHYqHXYNnJQHfHALqCxaNYj3y7NG5dNhwbzTGBmEXB+MmYFlmBJ1RDb8Cu2Jyl+
 ouf9X3fnq19WseLdlwVtztwithJ7psbrbGXuy4V/aDlNWUnN2/KIf02S3W4aBYcIfh8sLLPtY9S
 7EuXrqrsospUb5rnLQVmWXoScrxJ8zeCOOWphB/eBHcvrJiug5u45GNFr1BKWm0iY9510xDudJy
 rF/eKPlSzatDeyfZttYNxeqDON/SkpXfNSVqKMyNP1G/ouXK7+ghek0neK3yOp2l6KOwXvf7c9W
 AI6do5rKIbYhVrh12Zfd3s30F0y/p4mWM7UyotznPPYDFfGzWan+eYPwaTCm/zb4c1VFlmwSduD
 0L2BL22jqZ7EatVD65nbYKVfgzquR8MqTMaHIcX/YJkkXIDyeoT9xjx3OiA0CnUh8oXxeN9rmlv
 hP1fvehab1tGjcODefg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8550.

Fixes: b8630c48b43fc ("arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 912525e9bca6..fe46a5d41fe0 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2465,7 +2465,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

