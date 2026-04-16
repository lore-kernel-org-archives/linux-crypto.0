Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9143B583D
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340890; cv=none; b=cs99BTRDDcSgciYHlvmlC2qCRkv1pkeA4Wm/HptWkpZ/OxHG4cXx2cGIY/VbF19CJVEDSqhYFUdHmmpn3zCyv04/fh/1wO0U0v2gbG7cGJ1jffY7nohBaghEW+89MEQhPJev8ctsCO/sasK5QmH4qjO0YWtR/Eu/r3I9BMSy2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340890; c=relaxed/simple;
	bh=vzBr5e4UGGfmcb+i1bWUkJnCUj4+LyIrDlmIKIXz/Gw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tIQhzgT9xphp8OU628iyLc5IYDdR07J2sm6J5eujVaNhA5Q2EzLTtrzOlN82fMhAzhXie1HRDzXWQD622vZcXMTcDgCFy5lJJyDTKpxk7iftKi1TMDsPscNH5zW6xy+WZbEHxxcYDkT3OxHq1dwLVvc25BXj9s8XKutioATsU8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DoFrV2rX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aEZMrYlS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DoFrV2rX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aEZMrYlS"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G90bvM2979274
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bYKgeLzF+EIJvPu5vjBT9RCwcEcSg4BxDSJhcfSI+V8=; b=DoFrV2rX+Nw4sqI0
	ovBTJIEzyPGnlwljWSfSFgRWECqMJh8RdplLNQs/CtaHeiX7c46253Btojft8uiK
	ipi40wI0GmtK0fiDyD1gdOQU2Udz6L9MNeMcBT6WvAVBSAasKMhO51uwGgySJ8en
	tKuvc0ncenzwHQDsOoWbljnqeoap31BDwhvOxInh6ECcXGgAUb3KPM8QZaS/B5Rd
	0yn8MCbXqemMFwUDK8SEqppQVZvKxmzfHQ3FAytepSe87uUHx2S6eMZ98mwU67RA
	sjhCbouzfmm4UTtkkXzvwpmBuvLmIwNlnpBd082BCKuklmFVNb3MErX4bApULy88
	puatbg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djvru8kpc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:28 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c7965975ed0so438948a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340888; x=1776945688; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bYKgeLzF+EIJvPu5vjBT9RCwcEcSg4BxDSJhcfSI+V8=;
        b=aEZMrYlSdV55o6Z8sUtjsVHtDyvCVmLDA5ni9NmP8xCsFxJUGDOqR2ACkW5SoPqFrw
         0NNwUYQH63vj+2hAj4qey0wXTPVBIWV9ZqfGbapAXS6iITpxT3LLG6Ly0HMkeGO5YDWN
         78OOyb1pmZxYhjbQ/X971pKntU34Qzk26ro6V5jS36kDJpWnb6+Cr/EN5dAEW1rwmYV+
         AM54y3xByodTviX+nvM10SdI6oKXm0x1cU1j0RJRKRyxycf3sdnBEZ0PXmjC2CUCXAAq
         ATxGTaC1XSVo2wqKP8JiM2JV1h2U2LZ7jKDAzaW+/IGepUVigCCr81wGWsk24Q/dMFo3
         sukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340888; x=1776945688;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bYKgeLzF+EIJvPu5vjBT9RCwcEcSg4BxDSJhcfSI+V8=;
        b=bhuFm8SveFoXFXvnZsnx3xM/WYZuUC4JV5TBFldMT0jw2zfUfbeN6QRKcak4Os4GHG
         2Z08uvPQYUgJKzPieW6zyMVYYp8mWly+fyjxv2PekTHMVWUhSSDCU+IXHTCnjeaamv7M
         DlHU5uZm/nJZXsQlkY1xghHKaZe1sLcwpKh075dT0l17AKePB689G1TRj6xoO/Tbos4C
         70qfIevY2Z9BhKonRP5Du7C2snIpucBcw2mO2hl24KSdYY7XR6/R29H3oxmhx5+/Uuwj
         XvbFsCpv0TH6B6pVCEZkuxwIvmtYUdGrHBkb/bh/sQcV8c7hd9zDlYrKJYoBpArQFBVI
         7E7A==
X-Forwarded-Encrypted: i=1; AFNElJ9GSC0y3CadERimf90CfpNjfviTAmqSxqC1aDNHGB9iYer/+3JkE7kziv3IHYvUApSbxZ4qSfEk6UJxxKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAji0blBtQHtgxsPnsp8V+3qZgPHCafCJtkMgX4zjBTz8xsr1P
	3kps3AKUeT7686Agt2RnGke8hXERswiRCJ6dzrDq8HDP2kVEMMifvbBbM818iXO3uuUbZTIHpNr
	Q+AHLj1t7dPKxGESHUFs/cg9E0dyAUTqBOZCR9yQL5sHUvDoyB/pkHUHaxAoM0q4pBEE=
X-Gm-Gg: AeBDievY0Ha/2yhabY8L1otv3ghhWfjI6+61r8WeCEpeSdJa68W3U2t9ungudRdTl+O
	OtIRNOTTOasnWkO3G3mR9bDDh+xMbyFCttTQ7cfdu1sI3VQOAYJDHSeTJUmgomCDIWEgvmqrG3D
	IeSb67aHFjfBr8JmQqTgw+szL0vg7PhNsl7k8+HqPteSjaxzyaLRZGCIBARZNAav9Drl9o39KQ8
	iWedHvh3d3ibBKARC03w7IjSlrxyT5Q+GI9sKPtiqrsepn4vAd3yGkqIScvBGRkn2PPJiwoL0br
	uAU/4NHt24QVshAkMHKEyr1n3T+DTpSmlJpcC43ElRU0iYbA/nbrmBWR8K7KNAAhS3zhyWu53cN
	nAy0uFzW8GolJzUbcngSb4CWzoWqtMbLNysWiIlUWG94pOAu1KtLmZQNjeg==
X-Received: by 2002:a05:6a00:3397:b0:82f:4cc9:1854 with SMTP id d2e1a72fcca58-82f4cc93627mr12796299b3a.49.1776340887524;
        Thu, 16 Apr 2026 05:01:27 -0700 (PDT)
X-Received: by 2002:a05:6a00:3397:b0:82f:4cc9:1854 with SMTP id d2e1a72fcca58-82f4cc93627mr12796207b3a.49.1776340886803;
        Thu, 16 Apr 2026 05:01:26 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:01:25 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:28 +0530
Subject: [PATCH v5 11/13] arm64: dts: qcom: sm8750: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-11-5ccf5d7e2846@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1517;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=vzBr5e4UGGfmcb+i1bWUkJnCUj4+LyIrDlmIKIXz/Gw=;
 b=x2zFbTpFFbANsslFGvo667vqOM05Wn0sS8CY97j06xPIrAhgsEr39phqEmwXqQ+zOvfQl+YqK
 0Lq6nKu/BjiAKj3pRJ3SATMtC+HJJPOOJXZE5im/ykLa+PDowCcXX6/
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX+e4w/7Pxv+QE
 yKUTtWZfDmdN0AqhTfp+FAySU3Q/2F9lQnGIERMDmpJWldeuE/accSWy8EzsNbH7G/KyJdf93wW
 Zp6dV97/030uttq7tGrctchU1z445cLKAZukLr/w13o54eXwXAXnrpPmt/adUhFk/NwXobXCyvz
 DqGd/6sXP2xej63dUE0BlRem7QhIYNRZfi2yYxev+ByCz7Mf332sc4mRasPxP+qUz5T8zSpKLN+
 vpBJgoIIErTe3KdRvsEkaatn9QY3Zz34o5DjCqC41kt9UyuXn+bOUbnmiIyvRIChoc+aXGwZtHw
 X4R5VB57uly6NIyEkc18fxKZT4e+TBeyvIsa1QVYnRUVay3x3YEIk4eYL3j2UgMr+j3So+N3IYi
 BEUTQa2oyUpx5yBkO0en6r5EUV/N9e2Qp2r0+ZPs53TDPE/WzfIjo9lu53zztWyOXY7VzRr8vXr
 uHYYRMMImNM0vjCWamA==
X-Proofpoint-GUID: dYXQ7Xen682lkOQR7pidhg8hRQHBD-S-
X-Proofpoint-ORIG-GUID: dYXQ7Xen682lkOQR7pidhg8hRQHBD-S-
X-Authority-Analysis: v=2.4 cv=GcInWwXL c=1 sm=1 tr=0 ts=69e0cf98 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
sm8750.

Fixes: b1dac789c650a ("arm64: dts: qcom: sm8750: Add ICE nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index 18fb52c14acd..099d7fb82ae6 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -2086,7 +2086,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

