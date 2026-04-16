Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BAD3B38A1
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340817; cv=none; b=kf6TEvvukjL0nzPxFcI1oqg3s5/iNP5uHu71JaUvXqz1vvqiy7FeG/DM0cI8Oft1ulBxWekZZufH+ZV++0JD/4p2KiYHNUiqJ0R95djIWblFXWYKjk4/wtj7e4iZHdcKiuVJxmwRCckI7MjN+Uj7yvWaTCy2fnDPP+1aSvUHep8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340817; c=relaxed/simple;
	bh=QE8CNKbUxHV06s503gk28Y3re8Qm1iszOwW9njMEFI4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VBvHMEeEFSbiE19+HUKWJDj8mDd9ltc0rJfivFUww9lFw92LMDEENkwkreJrMfjkHrT6zxY3WX92+YI3lG1GcCHZFUaUgVhfDMQS1i7K9avJ4X6AdzrxODHO1/meBhgIoywutYgd18GReuk+5Qugq8TfY1a8vbZprNohV0cfF6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MZfn+elt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SM4ALTuM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MZfn+elt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SM4ALTuM"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G7og5x3734198
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yc98Heos262Glwo4M0c+bKKH3aIaHhX/ZC3SOXWuFWQ=; b=MZfn+eltiMvFlBuq
	uUtyZjGsVMXw46hZKEbgobU3pTBhj/OjtKW3i1GCROscmP2R8LAFGVNIUobvH3UP
	B9miZ1Qt1StMQFqkn8qZstLUdbZTsV4Q5vAtbekk2UxJmgTCMExkDJFzNnv5npW0
	haO1QxdKgh4o9xWDRvT5DWdgUaZGFiEWmSKGowhVcK8Rv5PSxbyVBJT+HK6Uj1iU
	Rh8yJe1gtQrtwI6sig8nSWT157BmZ0lOSdKcto1HsMVWhdGbwuNSGByMS4ivv5KQ
	rol5kY2u3kFgjWunRhM1S1OPQzSRanrf4MkmKa6l4uWGIcZ3Xhh8TpvJvBfApC/9
	IvY4og==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djcqwkvp5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:13 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c792e2169adso2600270a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340813; x=1776945613; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yc98Heos262Glwo4M0c+bKKH3aIaHhX/ZC3SOXWuFWQ=;
        b=SM4ALTuMcAF85FZcuDH/ID+yG7lwhIdCqMWR6tv546wfrPLwC0PsiZsmgkzxeRY6gk
         c1axYYpP5qxS5uA/AFpWxbTglGDHX/YhThzYEXMzggqHI9o/ag3QPtn5Jpd/jslgCpAs
         yka6h+t2uiTnxkQYianYlip8sfeRIl7Izay4tEYUSASPAoAIVTH1iqbF7YJqqqGzBW4M
         Ov/55E5pdevZF8zrDlfBsxBHw5/GTtH+w42N6NJGWVmQEj9ALFjQS3Zk5qT7P2Z21k+T
         XAGJHtwKZyGXzCVtvwDtQmbu2EgETrqK4IFvLEBdVCiVrML7DTgbOUDKGsgtInE7jJbQ
         nTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340813; x=1776945613;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yc98Heos262Glwo4M0c+bKKH3aIaHhX/ZC3SOXWuFWQ=;
        b=LWjjiFrw2slo9XsNB0UalVGSDlqIJyzUnknCjYX2Z8fcisap8egYCFKiaz9y6Eacup
         ANsdQD1Z5opZimtc/5uJdNlSU6XyXpZQm8ARsajGgfG2p7KObzjZaDI8HSTYFM0us4zx
         t3DHq18ArgG+KzsT1Mx5DA2pw+kGGowzQpSD8oJH5neQVnpT42aHo6cSUsNNxsdS8+hS
         sWWOQY8XvofNcRgAb0Gq26u6VXPyJpMyEHsThx/k076u6GCDGGeoqr/wAuybxKUoOqoT
         Q4H2bIrGjqEBut0ME+BlXLzMGaXazKXGqJW+8uTd/0wNlpZXLv1osilRtGqsrIjnDU+U
         uD4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/zX6/LZ4yaLOE7UxC1Qg8dsY/j5qgY7hy+zfxGCoJh6hCq6mSQqQJJ89zzSzPRjCC8nNoOmlR7L3r/o2w=@vger.kernel.org
X-Gm-Message-State: AOJu0YygebCzeXXdmf+5ZqUZo1WyC49EWh8+//gfsK93y/uGFOoanImK
	+gevWAHmPfsdqd6ghT7dWh33Rj1YtEVDfLdX0CWNiwdp6xelYjGjm6q6FSDiJOtQYNxvbCNa8zF
	EL0FXfpm/kazbs8eyW7F7ECwfZqwyaLisl6GiQkeoEUmeZY3kzIyqODYMZ4fY0+K1K14=
X-Gm-Gg: AeBDieux2N67E4mZN5q7QWGV0A20AfNp37+yGwAwShDZcZrBadzSmP/gIoTZk2v5PP9
	LU/+z/ln5KnXg0rr0Bqh8KEZUr5UE6M79q2XVwRoA0TSlD1radkEZsWpWwDvRCPIsK21J83tLev
	cuD/dQWe5Xj1sH4mZ2e+fOn0aOoxX+eOvDk9yF6TLt2cxpSIfWaRYhN+cYvaweS09c4w2xtYHAi
	8B2r/RFzgjrPabPxfaZvPo/iT0iWS09YlBgZx4ViK+chRSG2ZOHjPwkBNp1n6NIDEKhv9Y+ZxAu
	kFVzjOqc5Zmz3OAiqKwi3qfWV6yD65JZHVupwzt7U7RJxNyu2+iC8WrSkhjXv8t3QwbQ0HMGILG
	BD8J4bo+nGUd/9IN9TgoihhAKb3FIqWi9ljOGwWKWvlB8z+4mnEqqybpbVA==
X-Received: by 2002:a05:6a20:7294:b0:39b:d9f1:6d05 with SMTP id adf61e73a8af0-39fe40e0678mr28808085637.53.1776340812765;
        Thu, 16 Apr 2026 05:00:12 -0700 (PDT)
X-Received: by 2002:a05:6a20:7294:b0:39b:d9f1:6d05 with SMTP id adf61e73a8af0-39fe40e0678mr28808003637.53.1776340812212;
        Thu, 16 Apr 2026 05:00:12 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:00:11 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:20 +0530
Subject: [PATCH v5 03/13] arm64: dts: qcom: kaanapali: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-3-5ccf5d7e2846@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1530;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=QE8CNKbUxHV06s503gk28Y3re8Qm1iszOwW9njMEFI4=;
 b=hlZbO11yX1CFG/dQ6xbqMmRTnRitXdbCOfRoswT0t1xEnqyCIZLpK8N2n0TW2y+WtS56ObNhK
 eGSNi1JM7w7DoSyjo9zJ9BFbbavE8M093eC954b+M58KXu1UhHJ2bJh
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: 4XojSzOEgia5CKt9hd1jA2mnou1wxzj1
X-Proofpoint-GUID: 4XojSzOEgia5CKt9hd1jA2mnou1wxzj1
X-Authority-Analysis: v=2.4 cv=XOIAjwhE c=1 sm=1 tr=0 ts=69e0cf4d cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExMyBTYWx0ZWRfXxQNclOfNvn59
 WikUNNgB/r4T+FHDNMMrhxwqn76pJL7bO29qV9Mm+NB7hqGRySwAILk/X8xkUk0erQ0BGKcpYG1
 K3IJDuehIXbonOgooZLhUKyvRXC1p6yExmac3QTJi7xaz6ax0QyKFoDWyZ2cj6Za4V+oHzRKHs0
 uXVER4R2qbtInQtuuaVgntTNqH5+s2BeoZO0xaaa7hjmfoqfIXcI9cbdQfN3zZM3GNqTnQawgyR
 i7HouX9n74HgGnN3bqfSNVJiDqZ7pOca9fuBt/hF9Qr3qDsOMH2mvRYtZP4VRE05etrQKwAZBQS
 KlVVrIztcWXMarenvO3EGq8199QxGVnGLx6Gl4nrZ0PAcS+LVDjVdmL6che9/VLUTaWvbGoHKZS
 Eu10pa5RrpqauFQS9U/au5OIigsjIvPcuAuovtdl9VKT88tRBhI0MsoigRKLO2D7tLLsvo9mUhA
 Du7pg0gSuWY8iM3rU4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160113

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
kaanapali.

Fixes: 2eeb5767d53f4 ("arm64: dts: qcom: Introduce Kaanapali SoC")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 7cc326aa1a1a..14e362a4899b 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -2538,7 +2538,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

