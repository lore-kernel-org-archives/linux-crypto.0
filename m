Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504FB38657F
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257539; cv=none; b=TEaQlnHyKlxzt7CDBmbDRfFqtQrKv4nnB0JQyJpknTJSXl5T+hb1w6Dl5tBjUe2cPx7yjMzbfqf8YXCTstdoQgHBbWTp/lPrBIWnQkFFt7stLLpHM0ay2y85vEtAZn83jVporJkhpzc4dIQr9ijlwKSZ+0gSzThm9vIUXSetFLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257539; c=relaxed/simple;
	bh=zSf5B+scx1LHzF3C7LbBC/eyKMhHBwfouTQryzgofZ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tftFw/0gCUZYX0VzRa2HosmvqfjBAC28kQclOd2HcsB9FSPk3WwTaX/WDuWfVLfMAhP2qhHMOk3akyRaTd6JK/V4id1p1jL+dAFv0n+oYWYMac41SzgDct0eDIt922kpnG6K2Qhm9KasmyuPX876SIjs48S4gTQjA4k4tGVNodA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c08vod+7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B+ZyICMU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c08vod+7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B+ZyICMU"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N71SmB949420
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pxOtgD2NGLF42PFt4g53gf0KWjA7/Alkky956K2USm0=; b=c08vod+7aXUZjxq5
	mP5rGz0KG2Iv3ICJ4p2/BY9yUkyPnYLys4qen1FcUiCmTPYuO3jdOGwMUeGkdk2m
	uOWBU69cpHyCmcPY1Cj+8/oq9Ny8BuwlMNQnGwmQDRH+IZajm0x28Qq2pDdQaNn2
	9tdw+7BbduaNchvYl9ZWzR03PV4YKlw3F6VC0R6pdmhAuPXCFqrlb1HehH5f3z8c
	tZ3My8H6XWeMzLubIBxZh9y16jGp8I8gAXYy6j4sroSvDj2QR9Ds2DbtWIsbnjCJ
	B733J4ZzSZ7XPQrpWQTdkgaNbaFBnTmcp2WCyr9otFJxkc5GCJRDKRkxdpLnWyr4
	m7+naw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1mghcj4j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:18:57 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35a0337930eso3906892a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257537; x=1774862337; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxOtgD2NGLF42PFt4g53gf0KWjA7/Alkky956K2USm0=;
        b=B+ZyICMUAaEybtWLLx76IPt4heJ1KsZzU3iA3wP8mF15EdUKb/W649bOiqi7ciqkEY
         ISBpjjQRxPPnBe+luX809lUC+V/5LSK1FrlawidqUQgiu3K5zriktM8AsY3XtdHLctS7
         z0tTkC351tNZb6a44N7Ml4bkBqnHvsJipLpIsnVcQJhqILJFzS7his0FaIQx/Yu3L560
         nlhIgG2tdFj8DZj6+poblvVyUXmXXU1OZg8syuagpkYxez1Ed3r9WhEU9CK/73jW/GlQ
         xfCUw1d9li3qd3elw076vepogCsqPicS8LLAMyU1Rb9YyojwzVkVWCs+EOHEIHk1/hlL
         7Onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257537; x=1774862337;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pxOtgD2NGLF42PFt4g53gf0KWjA7/Alkky956K2USm0=;
        b=ou029dsG65WVIGPp9qoKUBJW3uZ2eghQgJhFKvVjc76aPSKVNi5tSl0WzEop9UBs/f
         LHNPikHYneskP0UgiFsWJ5TTXNjZvLMKYOThdD7Vr41UYbEgZQnqctRkfKoWvGhkM7y4
         smSJZeGC/szUATmY0LLw3XczrAAtOyQC12XqBhKruf+QKFRcMFpNyayiKH84OyBezQmd
         Pa4AAD8IxZeEPb12dmWkxg8X7nTVEvp79OhDSUzq8Oz0o7wuKCmhfEThV2fknCwXb75f
         VdipQ5r5pRq/d4Xf93b2JGKlTQ6P3mu+IuDFkqfVgk0FvrkJUCkvOkaDQiTBvB9mgvRS
         B4SQ==
X-Forwarded-Encrypted: i=1; AJvYcCWg92dxQibJN6v+DvAEPk6+0rE+ExulR6hgRvj1ztz2oyJ1EOQ+e7+hkb0AOgrDcs5CIJA0gvhryH/GGLM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2PCJH5LIZ49ym4ERi35e86HjfdCp6Ua4zNdXnaTjMcns9W1vu
	iIe2/n/q0NhK/fboG1xTGbP0qOqicXmp4SvatAM+Wg4WU9Yy5I9LJag/vT4jl0TgMtGzHgYvJ4r
	CHRlVHkkIzj5LIuskUOI+WlaftD3Vob2qaytJh+2eYcLM3iUz3jBz6m1LSHGRZcPmOVk=
X-Gm-Gg: ATEYQzx70+yK1GFc/8TpStsPB5MA4etqIa1qQDk7XL6ROkG1RFukEWwXwUXPVNAeDUW
	Pu4Hp+rNAuYWQVyalDL8u9t4bB6X5QdwH2GhakuPLE8wApdoVJhoXdhwLu7IhyrvwjmQMXqB3cH
	RzliLACt6goS87uO9a2AxflgkhfSm3H6WFUZl3EYUXGAPeGw5yaJxoV5ZQXmTVkdCftNc4A8GFR
	YolHXMkIZWHTQ835gpiZPNMvlaEPdBJ7Yf9Gg7udjXnE6zEBA9zf81CHgEyO4dgjiVe+pVnnnP8
	I+wdRSQwBwP0R7WBvDA1ik9Dn0hoC9n77TrycIik1w2TCI5IVjFFiXGoM8T6A/87DvKINUBiGoV
	JQqaWJzHlb47NSL5AXRovErmGdYs3Wn7jUfMAzV/N4aVeUGk=
X-Received: by 2002:a17:90a:6c82:b0:35b:e4f8:7cc7 with SMTP id 98e67ed59e1d1-35be4f8d75dmr3257281a91.17.1774257537114;
        Mon, 23 Mar 2026 02:18:57 -0700 (PDT)
X-Received: by 2002:a17:90a:6c82:b0:35b:e4f8:7cc7 with SMTP id 98e67ed59e1d1-35be4f8d75dmr3257259a91.17.1774257536589;
        Mon, 23 Mar 2026 02:18:56 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:18:56 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:47:58 +0530
Subject: [PATCH v4 05/11] arm64: dts: qcom: monaco: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-5-e36044bbdfe9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1516;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=zSf5B+scx1LHzF3C7LbBC/eyKMhHBwfouTQryzgofZ0=;
 b=KE2Bpeyxt+9POWeOYoFJl1S7PQnufeCWHtYVTgveOr+XvgBnLh9rgpPsTldA2Gh6Vp0GXWmNS
 Xe8uo99AM0wDLgJw8n9TK2D0vSedbmuBcBoLlrc+fMymHylZB4Bo2fU
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=HI7O14tv c=1 sm=1 tr=0 ts=69c10581 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 9fZEjjwDXmZbn83YPpoiAHPwFvNsiz_f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfXxx6awZzZ0iV0
 C58uWe4MbODmjniFxvJkXm1sHsfCqrnWm1+B+PeC5xN+D887o69DfbDmiNOy9XV6Dbm2KpayC8x
 Mu+Lw5QDKgF4cAojww5sx60rVMov6O1ddt6HZHet1tV8GmcPBDZWHkpzgsYJ2Vu7Exgx49ZqyxC
 zaCA88daUBzzT8d6QXMQR+34/75aMDUi2Rgc04OsBmA2yXZj6HQ0V1WBeSP12qDEL9Yy5oVL3Bt
 OX3LodGvslLfywYUNhWlU0KgAY7TnyzkPDIf/WW5hJ+aDxZbd6YcMbKqwj4G7zxKK/amS5u2HrE
 mWPuJJ5d3s6aLfHT8mq/9RONMHmD4UVUU+55OAr9W7Rb7J0oamuYr8uT4YjtD/T3YFwFax9qK+G
 gDQVc1Ug/USs+aqgr6CHjNFbhOAe+fIIHJrtXj9YqDxkmsvgWhRWjuUBAvFMAeSnZGA1NOewMun
 rhIeEMevuuSCceyQovA==
X-Proofpoint-GUID: 9fZEjjwDXmZbn83YPpoiAHPwFvNsiz_f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
monaco.

Fixes: cc9d29aad876d ("arm64: dts: qcom: qcs8300: enable the inline crypto engine")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index f92fdb1cefa0..e408f102a8b3 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2725,7 +2725,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,qcs8300-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		crypto: crypto@1dfa000 {

-- 
2.34.1

