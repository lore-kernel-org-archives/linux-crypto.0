Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16AF361DC3
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152387; cv=none; b=oqVr2lWX93dyVIaI7MFeq8laLWt28pczpxPrZQFcY0yC5gxItyFLbjMC7I2i4l0mC4/oJ2rRjQGIqcw7ynDBeTCRP+ANZTevGJ617e6eitt+q5xH3GGqJv6Waeq4YG9zk1NPHZDwZuk9Vh6L3G2OfIrFEL8lCQ+LO14EDypKoZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152387; c=relaxed/simple;
	bh=RRvA1pnjTuwdhETh3SLAdIGbTLnDFUpnlpnc0ANqB8k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lWN0/t6PauLdvhnf+GLKF1UAzGtQlAzpVAuCAHmM4broS+G6gbERo9sKloTI7LmYdYrsj8wtbX1gujkAQ5M4jJyULJA5sXZovnHC401/ywqMU3MTMLsMVi84KmkJpO9HClBl8f9TrZ3pwbt1t8Gt8/IfMMHp/R/EaZShv2dqrJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Phi8awCL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dHeRES9K; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Phi8awCL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dHeRES9K"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MMVlfx2910245
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SgkUQZNjmFSOBv605ka7pW+NpXIVIMHPsDQtpEBPrNk=; b=Phi8awCLjIrx8ujs
	+WSVZa1WQo/ZcqHilqV1yJHSr33PFcw0Gj6Mn7JUbHyIl66NncLetcpQ7JDTwZ5m
	GKI+a7EW5Fdct32NaFxibkbMik73G/WcW28fc5g0WC7Tv+aD5kq5x0kweS/9e/p8
	Fi/elLVc+Yap2f3HbOSQJVEsbtjgmtG4I5NxSSoMrcP5AppSA05Hubw+gIDhl2Wv
	+oJUi83fR4XVCBuBQb2iu0IvvZo1LXnTRjC1rRfSWAg6D+PDP4UrTMqvlSE/T9Tf
	YQ5zoRAYxr4sJOimLhxE7ErmC6s6+a6sQR8FiePi0p2axe+bC0vgGMxD9EHAfqOR
	PI8H/w==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buvs1sj4g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:56 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29f1f69eec6so17466355ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152376; x=1769757176; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SgkUQZNjmFSOBv605ka7pW+NpXIVIMHPsDQtpEBPrNk=;
        b=dHeRES9K7HKrEuJCd4lf243CyOv1nYQ3mATQpgmG2KvQ9Bx1YF7lwumu+MCo3DBCDR
         E70z48dDA0JRgoeHoDn+LwC+H76iylTmPuYsp6my9/s3LU2JVidDxuLZ6r3zCvbCu3os
         DSHDtliKyAOECDnCO0u1WJH/on6UyROdZc+dNfvIgOpajyocG90lCPC01npRFzQkCnTc
         Y5tUbu5+CdYmEQirY721H3GVeGHEjReptjyjcD5FUVJDoRQd5ml0YYhg5uYSy4azxyGL
         xo8MaRXQN2PcZMWDmEZnuHz99olD6jLKg5xcF3hC+KfS4BoA3IIUyMi0uYGeRD4Tst9U
         WtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152376; x=1769757176;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SgkUQZNjmFSOBv605ka7pW+NpXIVIMHPsDQtpEBPrNk=;
        b=B9ai0ewIE6nu3j1qgs7SLRVoIwwzd16KdgN+xC/cFnKhPH7p+kNm86F7DrFgEy8MYj
         kj6LL0bfHiwyG6D610HK3e5LW4z9kvP8geN8dloDHHEZjYp269qoZM9wsIpK/MvvmfdL
         IQcSXqeLEJb8gmHwu/RbI44mWLDwBYZy+8B26Ge+8v+YTtX8btxQdlpZZA4CriNxxKrs
         cIXpIB2dvsSs87IGwfhf+Aqxs6dHo2A3C0TIHyZG7F9Pa872evHkdVdUfEaKS6+yWv9N
         6eySsIbUZKcw0h8Lkgbu3xIXoQ4qhv2Pzn3V9f5JCydzE8ve1aJNquwkVqqlBy1M5jsp
         rO2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtnxe5vIFcJHW7o22RqjTGJjmOuMSxNroYITTMrEQ/HVmJWHVRg6e0fDhkmNJfm2h61ly1gCSZTeX5/kI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbUqpOtFVFntKknRxnbQpomCUq+hXVYLyYWzJZFEsibvpJtFx+
	VwNh8dw1GTG0l/8oCAppsXLD2+3uWa0ADQsinmW2ckVcfob2cN4YW1z+0vketVkO7CHQTFoUCwd
	/qRYDkbWduLQwy7bmDVB0UHM+1fbsqkrr5OjP6/S8du5uYCZIbSOKfMjzeWKtGLQu6gE=
X-Gm-Gg: AZuq6aKfdTW3NX9iF4v3dto7Yq3Cuw0rZVAGgFnjUz5c2e8cX+wBHu8PbwlKP51xg02
	/W5ghi+QWZblnsQT2RdeRqAb2XKXim/IuKWMq0wW3Gmh3HYTSrnV5wDd9+cq0/Di+fSwLkVhF71
	QZB6RVc7Rg1oEkmJMWqMGWRWx8aLwwYXCxdngfwGgaTurFtIwUUhdrIHJaIObwDcqS4yPHQlOS/
	bxbFPevx6VjN/HspWchKSGrgJ4mbFc8UR48ABTVXjA6jrapgqgwCb5UaNWKMdB5/RLXyO+a+2h9
	eNLEfDNc1bVar1KPjJjHoOzKEjhzMAAeGOTVhGL/bLvR4AhmQu/jvrHyDEKjhAnwhyKJ6Hlpgvw
	Y2ymOiJ8h8G1vD8NILTQICVONIhz2HJsymO4=
X-Received: by 2002:a17:902:f641:b0:296:2aed:4fab with SMTP id d9443c01a7336-2a7fe5967dbmr22143575ad.23.1769152375666;
        Thu, 22 Jan 2026 23:12:55 -0800 (PST)
X-Received: by 2002:a17:902:f641:b0:296:2aed:4fab with SMTP id d9443c01a7336-2a7fe5967dbmr22143355ad.23.1769152375117;
        Thu, 22 Jan 2026 23:12:55 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:54 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:27 +0530
Subject: [PATCH 03/11] arm64: dts: qcom: lemans: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-3-e9059776f85c@qti.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1228;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=RRvA1pnjTuwdhETh3SLAdIGbTLnDFUpnlpnc0ANqB8k=;
 b=FYuSrOGwJHDCWziRaOqDDJUypvCx4W/2H492KRTyiwM/JD7jULVQYj8m4o1U/nUJwgeRD98w+
 VR64fSCq+4hAaFd73BRDMbq2QdZQNm6nZnjCOvbyQGOH05nTurCWzCH
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: mbt8ZmDSLFCGg4U6-hY3K0Eax6lPN2uu
X-Proofpoint-ORIG-GUID: mbt8ZmDSLFCGg4U6-hY3K0Eax6lPN2uu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX36o+SETZF3G9
 LwyrT5+oyTtJ8UidJiNRb12rMXAhjJ/wlQ3U+9AvLz7uBEielWLR5PDoPxTLa4+T15B5rBx/VFg
 oyOG7F2g8sIPLZhGgNtEKQg8OMxz5YjO3dmkurPSgYkNsRTJWHXtpkgU2s9+YSD3QOvJ/SHJDjD
 SMoNISG8x09QYkgn3Zzy+/px4wOeKA+MD9FDPme9oKX5KzV4eVNXEmjd9Uvg38T4uyRe/yFIn1a
 I9FkGe0aHiCranQSAt3ICCshwr/YsP0MHKu0ysj/HJOtyUA+r6kdR2Ey3ivMcPM4w+YnomhGu0l
 Koe/hiPVPS6bAmDP+4/J8CddVCjQDZ7sKM6l87rLyQDTymg3hs6gDyOHrnN/5bhcKEdAXXcbDTf
 7h5RzM/qu+bUBLByDrWokft/jc02m4kLO9NX49n+EvEbOJDAhvwImCUpfkTtrUY8/0KYmV6b+d1
 0fe4WmClVBEJVZK6TQg==
X-Authority-Analysis: v=2.4 cv=faSgCkQF c=1 sm=1 tr=0 ts=69731f78 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the UFS_PHY_GDSC power domain is enabled. Specify both the UFS_PHY_GDSC
power domain and 'core' and 'iface' clocks in the ICE node for lemans.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 7c46f493300c..0312702020d5 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -2774,7 +2774,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sa8775p-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
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

