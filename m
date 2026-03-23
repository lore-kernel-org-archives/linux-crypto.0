Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44923876B8
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257559; cv=none; b=T6bDPmnsvD8qCiS7elcVXj+pRxklXuDOO/+j0Ez5r6fYkcUICHcn03AYS9C99yp/l43dnCh+Ph5ooKwU1VDO6gKh+SOIEi1t8qKeA7eLIb3Kg7/vf391lrRjY0jVlHG7Zd3qXPhVEQlR1mjydfdzPeL3tkzANXICpRIG94TEy0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257559; c=relaxed/simple;
	bh=LS4FXm8KnlrTRJlZxpGWlu2f+zGJuXdncoQPyY79QG0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qbd+R/TKBTgEXMEr2SgbpYnv+U+65Q/fDezKu3mnwcbPHm94OURH+09sO++9b4ci/l+HR/vYne87VUndBizjXpNcnIfX2aupiG0o6L+ySs5RCUK+xOJd7CrFPRuHm9ZalRm09au15XTE6drgDDHOnPrnpjhKsSjkrL0qWuGxqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CfIH5dAX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AkunuRhL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CfIH5dAX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AkunuRhL"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N756ra199272
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0kPiIhTgCf9OoUIvaI3Ju9pKAKStgsxqhL0qjTgECzE=; b=CfIH5dAXHmJjhTex
	A2CjDdvi7Cqhz26WgkPJR9mELbgvlucLaeFaF4vlWSbXA4KtzF24Ti3/e7iEgZab
	f0EWn+7xsRDITPZ9W64SnnVg2LtowA8pLmZafC6CDgpLpHwO1m7IzA2IOiL1mgDr
	JhlAUhWFNE65Az2jXX8ySzPHzcF88bq3e50qWf6pHdokI975EObzp2Jro0QMTKGO
	jrz+yYCZOu+ACOOzQlB9wGpmfkiSMOHswWVlnw5VpeSuhjIbvdHivyX5EAyOk2jc
	g4AGQyseUEoUpEriRsoiDMXG8uhyiQdCSflYR+ORjaUHjwYKo1zs5wVef/I3fUVM
	FY3mFA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1h1e4t9t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:16 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35a1e725a8fso19676026a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257555; x=1774862355; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kPiIhTgCf9OoUIvaI3Ju9pKAKStgsxqhL0qjTgECzE=;
        b=AkunuRhLk8zN9R2Oc4hrDEOzuzBnRpjogSqgyf+wPDSuyIgGQsd+S6u++H+bu7erXa
         8JxNZayJFOt8EjIuVYCKQkHsWGG9LX7b45xChrq60umJMOHha7eYZhS3nZpQH8tIhF87
         i4GUKvZqEHdDlVbChstF/3bAxtk5ROI4Ivrq2yvClaR7EVK0Jb2fxosw0sGey86sZhLl
         QpkUHMKHOEgZyuSlPCZHX4tQY36C2F5ruxMclSofgUYtTLvdsZbC+NIwPpbvvNHoxig2
         uSRYTEb62qEnMgPSUSKyPq2+aWU4Y6fnUZIiuRoMdg9bvauNJqG84+uM5YVOCP+K8kjW
         RHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257555; x=1774862355;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0kPiIhTgCf9OoUIvaI3Ju9pKAKStgsxqhL0qjTgECzE=;
        b=YMB0T637bNAUORZxaHNqjB9Tzz5cgO9WXXa5lrM1t9BhDcbbD+M/HjdepiS9p4prbi
         rqc0RJpCRRe/beoI8BUZD6iqGWTKV9j/KqFa5vxvVYGmFy2UeafEYfJVr/tKBngI21Ap
         pbVSt9QMIZ09qcHi6YSDTR1mSF0gi0VHfyNx2QpA695kp16KbdwovaK9ITM9c0bGOnpB
         CIYfHTLBzA+cVZMzHnKEFBbT85cfQwNl86c41Tx5Frxrtx8ANE4ZV0fBcS4M9sF7FVi8
         d+p0zns4/Hw69IZf5TpSQpwy7CNTEIpc/L5hzCV3OjHUEoNaOp0SgqqVFKFy6Ji4Te7p
         YDUg==
X-Forwarded-Encrypted: i=1; AJvYcCWlSd3G7cg8wmdn0v5B0N+v2BUKDTGQbVpLhipAUCCZiDCLUmWF6oqh2591+7+eHV5wkKKgKghTODi6V5c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5AfDBz3B6coYRuodo1aD6pPc8OCQZqWksvgttQj2VX2zSQjRZ
	UE0jUNW6yVUa+PVoZTkpDc/Zqewef8r4J0OkW/y+Op6TVHTGPRIvoCsl80WosyAfX0g12iHaL8G
	1j3ExT4V5Rth4ruSYb4DNxnTyIGz06Ttl+rob+A0jwyrqwU0PDc5/1peT/FtmbfnzJ8c=
X-Gm-Gg: ATEYQzwyMzHgtHODfMb14GoULXzneX6Fxn03USZT0CMDDQ7fxVFP950EoyoWPP1/33B
	twfrVRpmoDabD5plxr9ExEwnEYFxiU7YY4bXaII7nTZKTQcYVQnolEKvSaxH5GbVl6ii9LPXWyy
	Q2pMgYjYriCC1I8VMa4+P6C/0hwOq7j+i6s8OtNO8vy+dTp/KCAimOEra43oLT+xmsKbKnjKx21
	w/5A1MLuMccj9wb1saDoL4Vrl5fPTTXcctWUOdV1vh8qszkxTUdWd/XcoPulDHysCUoIJxTsmuM
	ULwzdMsg9l/JNEMOKTbEOfHRTl5z75DLuaJqgrJuoxfyty+eBCi3U3vbMAydvfm6Tm/4GRmstf9
	R0i/GlJim1pzUJSkqIxt7okyoSSeFURUwh8Z0T/uI+zwo7e4=
X-Received: by 2002:a17:90b:35d0:b0:343:7714:4ca8 with SMTP id 98e67ed59e1d1-35bd2c69ef3mr11216549a91.15.1774257555429;
        Mon, 23 Mar 2026 02:19:15 -0700 (PDT)
X-Received: by 2002:a17:90b:35d0:b0:343:7714:4ca8 with SMTP id 98e67ed59e1d1-35bd2c69ef3mr11216507a91.15.1774257554914;
        Mon, 23 Mar 2026 02:19:14 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:19:14 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:48:00 +0530
Subject: [PATCH v4 07/11] arm64: dts: qcom: kodiak: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-7-e36044bbdfe9@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
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
        Alexander Koskovich <akoskovich@pm.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1513;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=LS4FXm8KnlrTRJlZxpGWlu2f+zGJuXdncoQPyY79QG0=;
 b=biRYorjV9jV7YU0YAsnA5858q5QwIrCqCidA4lchyItfLEu9ysEGLe/XL8uHLOG3QJl06gLZ8
 YklGA+Hy0nqBxf57auSkbNCDdiMjzxsQMdMCc+jIs/2ibF5OBOPFf/o
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: m6scwWlcSkC2G0rsnDdsAi-lAy7LRPpE
X-Authority-Analysis: v=2.4 cv=epXSD4pX c=1 sm=1 tr=0 ts=69c10594 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX7UNU9BQthBsX
 tFC72Y5I/vPkkhQGKK58cFhkojSyUH1tH1KF39ycMTdgIL+YZ3C2zAh0BzAsl3d0gWy+WP49Du4
 4Hq0/SGGgiP9qhDf+o7eExzKSD3h4RtJPMVwjVIbAz3ip7peC0XU5xedUa2kkwKhaAbGP81oMZi
 uY8v26RY03VXvyPJZIXDECLXeijNqbeuzILr0BXwpFVkYf+5cdG8/Tqjucp8iMUcILb/hIWr0VT
 E6mdH4T0lvC1V0tW3jD5rErvq37peY36FhSqyFY2xTa5rsRb7jiug3P8Nj+2pPQqU23dDXmbEWZ
 BSWT0II8UWtMGFg7SatYUFgwgr2UtZlVjDHSpKI8zvBkVX65y9KvcvWotG26zqOLni2SXgmTZ5f
 MNnStC+maJ3YU6A9aV3VMjoE2rde/SUVt+s+kYLmUfghDlaxsdF7NIQkGV8e6zS2IP2ZhrE86Fk
 pET0CdX81woP00FfK6A==
X-Proofpoint-GUID: m6scwWlcSkC2G0rsnDdsAi-lAy7LRPpE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

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
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index 149954a3eb7c..9765bf361db4 100644
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

