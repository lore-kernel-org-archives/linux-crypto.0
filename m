Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA8F3B4EBB
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340852; cv=none; b=A6cBW0hl9Y2896v0n/D3mGDEBREF/0QYff3MPG0J8k3Wz8JexyvkSrxw+d9KiF+jIysVPLLjsM9c8eJlDaYHIPcyXYm8mMbDdW+IiGjToD4MDbiyzyEjV4qTbfXM0J4mj30d7mC4iyM+XDqZm9p99E9HCKf1kTg24XnhUeYd978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340852; c=relaxed/simple;
	bh=9W3DEzLqDL23ck7MFEmKisVL2SWOD/GMIjoH+WN7/4s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dPUYyc+MiIxDSBZYL0HOGXi3BS4VoOh6E9q8YL2+s0vmOL/9X+w/V1/WW+Eni5H0WfO/NnyGUNMNCf2S9FtszO+3dcsu6yaRUDc2RpWVDrOnhVjcA6dkx+79zK/wvxttPpZV8ccq562aETNdyJMu05n06W2LH63S7KeFqgZBCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ApFwi31T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DotVKl5C; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ApFwi31T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DotVKl5C"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G6Ossx2652064
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LOconiE3DhsyHprWuZ6bExEpIKAinAlDtyF6NGNx6bk=; b=ApFwi31TWRrWByPP
	MMD9HEIEoh1TpD7HYjihzNPxM1bzClMmfG7WNSzdNxroMRMuY6OFbNMpn2Y4GIUJ
	QXiRDZTB6FINlGh1Tu61YltMtzECcf7KivAQMS+phMb0c/Xsnrw7ZaZ0xWDQmEho
	taPTfhWqvEn5X5ozwr0YhXc6hZtB0vzC9uSJ+PvuzGdHRNOwZYgsTSxb9pUBnrZG
	XdL9Fx99CF4yrz5anImYRtPPI4akUZRXtx3yNsl6mJkpRmi4AqCGvUenbPFA7/lB
	zglkgLohmDpxfMwvyaSsBBh6ivb6S3ohHr178Ri1wO158OZpqu9mEE8eDwtfH8QR
	MYWgWQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djtfuh5rm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:50 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f37353f52so5412855b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340850; x=1776945650; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOconiE3DhsyHprWuZ6bExEpIKAinAlDtyF6NGNx6bk=;
        b=DotVKl5COFm8UgXDkGdysjzZ6hp0DFiUnKj2egzqQhvH3fopTLn4WPKTx96CuJQyCJ
         i8UbWJC92G5hD8LBpGvaI6rlPt71ZAbRL5Coy56ZK8BPkNNFTZFuQKUKvCDv3t//Mg3s
         jLjzhv356N8jdLsssRkUkqUt4m9zLT/8Hczs9CvPplJLXzkbpacJyB7BJGxmBPYR1Oz1
         p+OG8H9Zs3K0i6Um03zLh79YPQ3Iase4s2uVwUVivLtNyR8veS0KGgBSI5Cl24LNoLbT
         Mf8CvqzBl+ADPfMkoP6cpERoc0eXGk9sXBXYn+jCunvBXnw1DDhbt/0+6RytztPOqd7V
         cYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340850; x=1776945650;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LOconiE3DhsyHprWuZ6bExEpIKAinAlDtyF6NGNx6bk=;
        b=QnDx6xR/5pshvHvrowNH43JeE5HhUCpcmse81Tg2VGIIwTl68XHLsiqVWAEzjpnSEW
         OiptYrCoYX35nT5SL8moZMo6+qtpXpv1tBfqdgcYK150ECi0IjsH2dF9SFnGEOsRDboP
         KrFWsyPIfRRCGhnBMitkjWMbZfJkfKUxMKr9k/aw7mZh1NSx3NA2JYO5W9J+F+e+00L7
         UqlKQt6i6YHHWVYQmseURhgHMfh6Y/Pdl5tF5RpTeVSlsd44xQPfW3GK1DvR/GdUNo5m
         QG9eqp5mHflwvSJBNRqbG9qBQ+51rrd8HqpdIyL0RZ1g4lheNe2ZvxE5gKONQxzTpVHf
         VL4w==
X-Forwarded-Encrypted: i=1; AFNElJ8L8Me0TiCW6FGBYDz5hGWIazYclrsd5RTVep6R5Fa4SAeh8c70tNgKLcmX3AlXtTrXR1gMU3oN8FIHgPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDWEGTF1cXyAePTp7EE/q9c9nHhJDpPjamsozAkHlyhC+WcFKr
	qUcEL6ZUWoKyWhhSk8FizQsPRnRe31tBcqMVe0fo2V1dua+zq1J3eXGSMlZlRsiK99RXsQ1FDCh
	HSBoC47aq0UpBgQZQ7EBGoAJtTWOzABic6dCD4vwR5KzC4k07lv6EtzoOPJBTVPWPseo=
X-Gm-Gg: AeBDievNYasbM++yKmdXqn9qjFPSCKbhYQOda3iR4EgUqC+zaNm9dZYVr+21e5bo5tD
	RFoJZMER59USyM3mmX1B2sib4lYLdlgHvGqbWemwtbSshGDoEPrmK8mQUAAiemhY3H5ENsFxK0s
	VR7AxF9vCZKbi9k1S8VVAQg80keBKbu1iSobicmLfGwV3Vi71yi/fxTnlndhaAMzEOjCkIYb1U5
	XTOWf61EhamnBeUZpcYKnsuuMgoy8smYNW+VUylaekXPO6aoKhJVJEfv2YnOKr+tEfWya5hHyS6
	qQi6WAHohz7bjHkZ8pJX5VAERnG94et5YUHAfaGQL/ikrEV8oZtZTfzWKOEAMJMhlTHClp9JoLE
	8z5hQ2MXAYZvF0fVAaeh3EqBYVNPHmbzBUVf8gzcLg2yx9fawenvj0aomVA==
X-Received: by 2002:a05:6a00:ccd:b0:82f:623f:e5b3 with SMTP id d2e1a72fcca58-82f623ff57amr8689240b3a.34.1776340850246;
        Thu, 16 Apr 2026 05:00:50 -0700 (PDT)
X-Received: by 2002:a05:6a00:ccd:b0:82f:623f:e5b3 with SMTP id d2e1a72fcca58-82f623ff57amr8689136b3a.34.1776340849405;
        Thu, 16 Apr 2026 05:00:49 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:00:48 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:24 +0530
Subject: [PATCH v5 07/13] arm64: dts: qcom: kodiak: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-7-5ccf5d7e2846@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1633;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=9W3DEzLqDL23ck7MFEmKisVL2SWOD/GMIjoH+WN7/4s=;
 b=5OBI0q8kmiY819jpq+CIVl0FcflmkpbwmJfrEdZ3TG//uuc4B0feoLKbtHRgt8qw+/n1/LI1J
 Bj4KXuJKFYABZNFesQ8H5b1E1uNaUBL+09gs3edwY2mlHwbwFHBiKcP
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: TNZqp1l0bp-tUJBhpa3wC0D4kDLmWqbc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX6eFIyK+fnOxi
 DyHYLqfaR/P5z99Jy2N/y0r3QSfhr3S6iK2RKgj6CM8Onebh2q/tkul9U7++a6HrGv7pzMd7JiZ
 WZv11wdU1YBCNZcL4wKb47UsnNpzLkDKqaheLGulLKqubg9z6tOJ8PM42jAQ8k0U1Wpd2R4tqjM
 ZHnUMei5h5j7rK9ZEFN4V29ySl4ZWhS/cmWkRHKUsMTzq0vDYO0m3mWgWd8SojGx6nEiZgL9zNm
 Jil/OrSUaSJl5pMeKBipmzGx6FPqMb344oojJVRQYXKvQwZDWMBimzRdTkoW6ET9PKzSlKjhjNG
 7qK9KbFP+dgYNOJKhPPDtpspomgeQxajmQjYJ0W8Zujs+qwtAZk647iHtIQL9xQ60FIdt2BsIoT
 8ffM9GYh6xDG4zKXOPI+6BsCuq8L1mNn/wqnGJpznWpBz1/mY24avpIggBn2uiFZCjgtkiDDygB
 fQAzZa9W19lTUrzBXLw==
X-Proofpoint-GUID: TNZqp1l0bp-tUJBhpa3wC0D4kDLmWqbc
X-Authority-Analysis: v=2.4 cv=KrF9H2WN c=1 sm=1 tr=0 ts=69e0cf72 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kodiak.

Fixes: dfd5ee7b34bb7 ("arm64: dts: qcom: sc7280: Add inline crypto engine")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index 988ca5f7c8a0..55fc256501c5 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -2579,7 +2579,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
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

