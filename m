Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EE63EDAA6
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130086; cv=none; b=KUvR0VP4cDwnjE2Y7qq7u9/N99+I/STe1ec4zXyaroZonScjTE1virajJzQedPrQY1IXVQh+FTpdHy1EImOTpgpmjQikH++166dpGNW0eGgs3ARYl64Il0TQBhFUoQFR+KJ0J8ri3bh/fKerKG0Z39aqSCsGNQpP5ybvUX8OIHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130086; c=relaxed/simple;
	bh=uwfjpukTBy7HMP4EN6kRPVs9fRDUcOji4LjyoNR6I00=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OmYV+3hLSM+Am4eiaNxDxzutSrrh/6RP3i0sF5jh5dGo9+L8o+ZeekjTp9+D27dZwX+9m/2eQwP+OEx+4WrBAyJnLO9b3epetteWDfHUxgKEJyztLjQhycGBE1sdBhEB0P+2K39A5q4ciFAEProsIXN5IFVCqpg9Tn/QxyQx6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WAqdac8H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CzINLmRa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WAqdac8H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CzINLmRa"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EOLt3754828
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	e25Tf1W193iJMpMiA9dqaSQlYyUKRAfK4mqQFSGiy3U=; b=WAqdac8HkD17Iuu9
	2E3Guz6+w/QDJTxEOilusgwARaEN2qxcwADmIT4nmlxtGkV6EUmxnG8X/D+6GKtG
	qcHkpNoyGYl2GBGlIihkL5vZJSCRo5U0yTHgFMREwIAeLsdwlpa4jem4ZmX++AOL
	QPqlMkfWONTdPPMbrS2u5wyxu81doKRS0FRSi72DVqZF4nTRM23xPSZ2++Y9JKuw
	VVWRnHFdAuZNgJ2Z8nnWg8hPqzTf7JjceoIsGlTPNX7rvnKHYHZPPJVqali86srr
	xNEUUcRAB9Humt4nsgbhtlxqHQzhtBY7pfWfx/ql6UhO5dCPVPkUnCGUlKvCZgMm
	hjfQhA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477j55n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:08:02 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-bce224720d8so7259104a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130081; x=1773734881; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e25Tf1W193iJMpMiA9dqaSQlYyUKRAfK4mqQFSGiy3U=;
        b=CzINLmRajUvvsyZYx2l5XOGKyMuXeDpjInde+StxmlkKHZZrRZrJZfeZRn5GKWp6/B
         TZYmWUre69gkMBCjwJqCvnBp3Y2/ED6lLVoCbOK8CoM4ZHH7JGp7D3ileU6DKTwYPm+s
         dNvY7JNt+r1HWkHWwGyGZiNTzhP5q76zs3KlH/8f0ONGzMGakB5JVzyz5EZeVRVQgStl
         vjYRoGDx9yBVDxCjEZAhWgcv1tg+VKsrTAXMhrZcIU8lOGr+pivmLp22s1b65cPedOY7
         baExmQxZYxlFwUCzuEtTygdmcDT8d4akyqMH0vs3F9l5v8Pvu8VwQFkcERWdCGDcKfRT
         o6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130081; x=1773734881;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e25Tf1W193iJMpMiA9dqaSQlYyUKRAfK4mqQFSGiy3U=;
        b=NMnOwEgpLgJK9brkDRtaeaH4HzsB2XVRcrM7NlD2dAw1f3Tg44nMWx7ggI1v8Ab3D2
         jNP2CFcI+wswU7cUw+zgWB8K6Yeh9LYIoTZJMOhkNFReEAMQa90EB30bMBoRVlzZgmOn
         dZkHYaQ7z0+uO6ILauxFXqu5hpy58ENC7/YANDsWJOMy8/TXD3eXm8A2IcH1Vmnh5q55
         saNL8FU4KuUiukZS3zDI24CJX7S1yTTu9C11QOmqAKA2z6dbNY+6y1xRekQIBA9fiZJD
         9Pmd7iR50125ISVEF5TdJmkRwteAo32rqdDdf5akmDnyHPbSsb72zPeBJcrdQL9fRQfR
         NSsg==
X-Forwarded-Encrypted: i=1; AJvYcCXAvxpIEwPFrVvbhif8bXH+0XlQq6F9rzz4AFlBL8eq8PRmi4uarhUWv4QF0U/mnURMC0BHsc8ngFrW2G8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm6GjbLm5AdxbmkARQVBGEeTR+H1iQV9NZFufAil0il7My/JZ7
	FBGIum0DvbglnbdH2OGXxrokv7AK+XBwP6dKLPOMWDm/RErCvASKosPnM+9VoDuF1Ne2gtNSOKm
	53PLRt8o5M1Du7zoHOxfCKzOicxXH/TbAJ4WN9TYuwEt6Kb0MEctDzPlu0rESiXsnPgU=
X-Gm-Gg: ATEYQzyCHUJK8ZqBersqxOvPzUx+9T8pOr/PQ1/MYbBReU9fkO+kumA8mViCVaDgZlG
	2A3QrJz16iL6P6jQIr7Bs+4Akhr7MSWze3SaX5i2ksQebxM+VV6sjKCjDzpWHonYpfEkgASTetH
	Uh0QfO0GM4iKYTXspDQIVI6PLyqVx0cRb9o7l+fDrdlW5x+iwS5DyimS1AxQAdXrmUabYAEcu+T
	H1mCi8Ru9M94cTAgvxz1CCTp67kcy8Ccb0GKAdWFwEzJefhwymGt0eTkgCoev0H91svfzkDTrTG
	R9aFjHC/milBkSYFOm9Y+NlonqUO57vS4gYlMXIo5piczrl8MnoGqii/feBlKy5NccCkvkL/E52
	3K5r+TL012zf4TVzb06BHvtZ/DFC2Cgu2YFYKPOIjlyfPwnk=
X-Received: by 2002:a05:6a21:104:b0:398:b499:44e9 with SMTP id adf61e73a8af0-398b49945demr699704637.64.1773130081534;
        Tue, 10 Mar 2026 01:08:01 -0700 (PDT)
X-Received: by 2002:a05:6a21:104:b0:398:b499:44e9 with SMTP id adf61e73a8af0-398b49945demr699674637.64.1773130080935;
        Tue, 10 Mar 2026 01:08:00 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:08:00 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:35 +0530
Subject: [PATCH v2 09/11] arm64: dts: qcom: sm8650: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-9-b9c2a5471d9e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1416;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=uwfjpukTBy7HMP4EN6kRPVs9fRDUcOji4LjyoNR6I00=;
 b=SurLQKqOB74oMdxxqSFGMXA+XYrESMpfC2Br3d6hfne2/1y6Tikz/aBPsXj+A6o9V5Ws+c+R2
 +XyiZiI8xjcBrueZEku0JfeJuhzjWMrzUJ0wnqx61o4u3AVzmjkEey1
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfXwdbcMVPZ/cVc
 Cb89zlFQs4xiRIEXy9AmLZ0stV9OzRiXTIk3OZd39LM+Au9LJXW5h+Iyw2bH1u8+lDlDrHGbCx5
 X/3XsMYBgrOmBOwIZhjrfF3qwUEvSEXKlmGl9lplYikfoT/6XSIOEHNXisgiVO1+ZnOfryNjZFH
 LIGzS7hkIS9F8rSDxUQdT9btv8hI2VvWldpGovfiacozjv/pc2ia3aq7TgvhTk1mK/+DSxiiCGM
 B+GyJs4poxNydmKXRFUXIPtbg1Aqsi/IFBBQ9+JJJAIrY96MsjEw3lZu5Ed1fckGqFXA8+9h5cM
 /vgK4+T1cB5vhykeQ4Ao1xt3aaXWd1WndJxKUcKRD3wYLNdlKq7tnUj/BGqJdedoAIGR4XvOPea
 bN2Vep55GnDAURp2aoWu6nVIpRsEEK9NM6Hj0S+JFgoJvQkRq3DJ0gRlAZhpCXGRxV+2I1dbppt
 p6eJaaNFnBU2lyoEI5A==
X-Proofpoint-GUID: _mFivLWNTkrYL5cb7G4X3DgRxSIZKGFT
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69afd162 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: _mFivLWNTkrYL5cb7G4X3DgRxSIZKGFT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.

Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 357e43b90740..c32a817efdb4 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4081,7 +4081,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

