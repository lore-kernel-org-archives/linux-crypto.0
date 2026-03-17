Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE9435F176
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739327; cv=none; b=lzgv7N7LZyWrpNSVDsJ9TKv6Mt26LmnQBaKDhc/FuqcSuUqsg4EfqmYsaDNh620L6VhqgHSV1GbKjFYAnq1+1n7x4jId9+fRAttCJUBPpkZ+o//S8d/ouaJUITQcaRLp2wr9K9rCAdbid8Xa+w+eHThDlrVtwXKTT0O1jQvo0FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739327; c=relaxed/simple;
	bh=gNKhNyU8Oyr/Xdzey4+OBtMdjcQJNeOG7d2xyewrd14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=thPRVbCEjZfBqlH8C9xybZTuoNEVF2zqyIiFClXTVin2U3Aly3A+BEHyMC408YnIJUxufTzJIqE5iK1XcZ66WBAl7woDztPm/HH4niOXmdJsEfqbe27rSOooZiHvO7WjIa6vBzrjyMiqRriyVcYE7V/klRncn1vEqAbyeAzlPNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fgXSH+vy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K5dw+4uL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fgXSH+vy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K5dw+4uL"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H95dkL3102446
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	arFztdI06DpQzbYjhOlyWZCRNNwQAGFQwZvfaHEejqM=; b=fgXSH+vyiLZ7lxbr
	avUOoTh4zVC+6whj3zVISxIIQ61H8ZxrP/0CU6pmelZwgIycMNwhhneqNbulVPCY
	3I6uZ9VtDP4Lxja7Zd73gzLZl+KYhWJk4R8qxdd9HgNtHWGRXP6GgpqzE3RFNYFJ
	Z5Dmm1NmvdR/KQE0j/JddrN+dFy1xJwMWfC10DiHe8mIku4VohikFUCCraEhiUwg
	sh5vmbmkI+T6Bv6ct179N19gOLdRZoTCQwjemUNWY3O07ayJw3wGNKEwwiL3TzbJ
	fXNbhoJ28Wjn9oeZkTCpXupCZ8+tYxDKJBhNclTy4YtWJs7YnBm6JLW1zN9DAPKG
	3TS3Vw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxnb7b4h9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:05 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35678f99c6eso4342227a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739325; x=1774344125; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arFztdI06DpQzbYjhOlyWZCRNNwQAGFQwZvfaHEejqM=;
        b=K5dw+4uL9n+36xZJeR0FIbi28ERBJVcic/0ddCTJ1mptfbNFV0FmDwdl/MIx3I+afI
         y/P+471bME9CN0KkDj2gdRuGNzKMC8wmYHLj/kx57QOqn+4YdrtgBXn85p2hmivjerT/
         GCQFVDwMsWlSR4u1rQfSAeGGabStYyt56kMfYWdvGcJ1T5qrKLTVA7O1ynpHtcXLlc47
         ZUmvT6T7WMIJ1R6B55kHQqSN8v3rRgmGolcUx8CTm8/nc4QVZ1GykC8VQdF3mH4Nv/i+
         1/ZGvt2dTKmu1ORGyFys1VDGKoD9jN8wAXvZgN6tMTsowNzVVTPYnrBCieyh6dizHTwu
         JRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739325; x=1774344125;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=arFztdI06DpQzbYjhOlyWZCRNNwQAGFQwZvfaHEejqM=;
        b=peG1lO9qbBsfsRQPWBOyO8u3kOuMasGVSMxx8HtVvCQ1Lf77mBk4ywy5DTUyEQJdFh
         pkUSumfl0GVkKRSVxp+1Z1G/hBIiCukocseSuXv5CS1/EpiHnW74z3AmoeB7Ne3KpwYy
         YxNK5GSVI9d6woiWTPudQ8RdOh2lYaSZ/ZdpKoMq+Aa48etuvYdxoXhFim3UqWywyC2w
         T6LGri29Sq2/jf4FOcBLkQTmyNUmCh/9lstmnvl+dLX4kEaEXsfEDdOgzfYk8VwtYhUD
         nxIjNl/5B3dRC1ob1BxWZiv/q4h8h2JbhTDod9erDWtfHZ+B9PAZ54wuHDtfTFAEsqgL
         J6Gg==
X-Forwarded-Encrypted: i=1; AJvYcCX3vjvaHb/pt9DcoGdQ2XXKSuWDeG0eA0N1hlrYPmEWQSi9jLypSWbXZXxKWq0ysMc60+HyhtN6JmW4MyY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5G8o9GEY+56G646PXKEVuDunDe2CYy2k5cFfB6KyPCTUWbtWM
	F8o6ZZFVCPDVpuc42EydkgHXniU6j3x7qvLPZePlVnp1/dS5hD14AmxkvKVQANGcAt/slcIBwX7
	dtof8rA+YyqhYdFobVmcuNMFTOPZhE/Xd/2uM6lb//18yIEd3IuZjyJaJxW1JxJdEirw=
X-Gm-Gg: ATEYQzxEEFHsalSmbxrPcmwm7cik9lF3HFQaEfJ2YUguktzIGCZtu4u4doEjT3/0Tsx
	FCGFxjTR1oSp1jA/mjJ8HeeptQt6K5sSM5n0CmsyXKzRnxf5JL0k8Al+uCN4qORfwrSunF6ER0O
	QejouKyYIo0krrfAPgi7iAbszwoLsh3zLkx6lfCHQDOQT6bm0SIosb8VOX9YJ67b3etplZFk6kY
	ChrYmf2ELCRBeMkP5zq/AenkBEt0SbKjI3OQEJ2+eajPc1sG9r28IwWAKPvXyOniG1S6hYWDzuY
	W2eiMa8SJCLO4kKDG2A6i5Ii/0Q1P1w5C8OJNKrT3ZUpLd7bLFzcJ9nieAxgE84zEjlZYdMHdYm
	Z2KnyyEBtv7juQ9MueLE7pWHwyLdjULrMZGqHrf2MVg8Tl74=
X-Received: by 2002:a17:90b:388c:b0:35b:96bb:47b9 with SMTP id 98e67ed59e1d1-35b96bb49c1mr6229841a91.19.1773739325302;
        Tue, 17 Mar 2026 02:22:05 -0700 (PDT)
X-Received: by 2002:a17:90b:388c:b0:35b:96bb:47b9 with SMTP id 98e67ed59e1d1-35b96bb49c1mr6229815a91.19.1773739324787;
        Tue, 17 Mar 2026 02:22:04 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:22:04 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:45 +0530
Subject: [PATCH v3 06/12] arm64: dts: qcom: sc7180: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-6-53371dbabd6a@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
In-Reply-To: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
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
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=1411;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=gNKhNyU8Oyr/Xdzey4+OBtMdjcQJNeOG7d2xyewrd14=;
 b=9pKIgvcm//lW2L9A12Tw6qrcqejMTVkaU8/oO5Vfj+itPFa/MdFnXkxkFwzMU1HNV6GK2hYRw
 O29OtC/iUwPBCBQV44esx8o60bTwk9BGdGNxCPN2gIakMx4AboMBR4d
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfX4ub/EM0txHiJ
 6aMNSxG1atMEBSyXDG9NuAJlNGld90Magb2OoopOKuJNn5qWa3B+tgUkL8QDnULnrnVzbov+rFq
 2nTpdpu0R85l36gsWhj92dg3jm3YklhamJGVSJXbCD0xua6JivyvIWsiSmaE/CtnkuVN32z+VFQ
 re8C1aZxOLLqNbdYSQxO1RwWGJE2CV6ZN5vWcexl9CZJaXcRXezVJtqSmC03aRf8NPSisPxR0GV
 n+WFXF0rBlxeV3AdQcY+Lim8HIcGg/xBR5442Kkf+UwH340V84n+AhRCVtpWzpYlhLGBBevp9+E
 I8lmoU5Ff3YMzY083ZCAJevwVl8JPGfN1x0HM7x5e/LLT/JG1pHdl4u5cAFP5NDRmLTGxw0WYGS
 HdD1j7qgaJVd39zjcd4Ud08cQSsEHbtmKLt5hahwS9aNRTy+1TrqFIBwd1r/hQkYpFteFdsbzVu
 BNRRwU5Upw8YaKS5whQ==
X-Authority-Analysis: v=2.4 cv=D7pK6/Rj c=1 sm=1 tr=0 ts=69b91d3d cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: f0k0oCl6CZRYyPTVPT5yGVJTjzyDKEGC
X-Proofpoint-GUID: f0k0oCl6CZRYyPTVPT5yGVJTjzyDKEGC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170082

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.

Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 8d69225a4271..9eaee5dc824c 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1605,7 +1605,11 @@ ice: crypto@1d90000 {
 			compatible = "qcom,sc7180-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d90000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		ipa: ipa@1e40000 {

-- 
2.34.1

