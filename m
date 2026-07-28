Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1041F342
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232494; cv=none; b=BJdrkJCTy5hkpBgN90KLkpLsqOELxAWN4kq4YWZxqYZIXa5leRKVDf7sUa0O/5D2ZpAsf5VDSFoP9yDyVDSkRbqCY5FzVBxyRM7NFiDLG4pUtgr38EkiEqjAG0d3YQq/ew/0A5WA8P73RnC/s8skaE/Ialn615t7u7R4V+3Xtnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232494; c=relaxed/simple;
	bh=oi6FyzyVJnz9Mk995hby2l9AHSSEOthgArlwn+kBN9w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XzpQ+W3sUwhVCUx9iDWsZyy6yfubfhBtXyi6FPyCTqWDRBLM38H9QAUFHEqx1+0uSHRQGXNblguufYrmpTi6zikN4b4V+EMNaoA6K96qNW8wM90rCUOkBsU5+kT4BFYD3CknXgdaJjpvtvoZLGmSNMwxM4KRKLEwGO4rYLb6CH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hTtDCymF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PykBAl1f; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hTtDCymF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PykBAl1f"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S82GaK1908866
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zAMrgILvwzWqIrQMJOhqF/nOJIjycXqb0wNzcVzY6u8=; b=hTtDCymFr282rfw+
	f5sC3/U1oOQJPjqIiFWcog49YvtxKJtDG11p+G/vDA9mbAMiRYM2YLjRBNHyB0Kf
	96yX9ncvPJabnb8LKKjV+8uC4B8l0tA7kjy47zxA2PMrnT2mK+XdQHzzgscK2/Zl
	Gv4menMVhf9xiBelKhDvK43PEeQzE/BEkXCoCy/j+P85wf0YWxl7Iy1KSmviYwT0
	xQ40o6UZC6RbArCu2wKvwkTkfticciOoxbykBzP0oD+jnqAhqlZmTgQ/242z5w39
	4bwkl+ftoSBgzBtj3yoJJmyblqNG8kpi2aR4hUekD9uBcH5px/W3+qW9145Z8DRC
	9obflQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpbp8bppd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:54:52 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so69716025ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 02:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785232492; x=1785837292; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zAMrgILvwzWqIrQMJOhqF/nOJIjycXqb0wNzcVzY6u8=;
        b=PykBAl1fI71YE99TLE3nHNoSjpHWfan7L9EBGOxdYa2/G+wDypvjm1d5pQbPIqJCZA
         5ZgyRtcrsBtBcmFrtUHGZNAd6AMT8SeWvgCS07vUhJtjV74gT6kh0x05gtdjW9R35hFR
         rhhhItD0rsHKzdvYi3CjTg2uDpOHWSVopX260zVTHPYYrhT+5cqoNWTLKJdaKd9JNj7L
         nrujfoWoJJFeRSdafv9Yl8fz5V8FfNsuXbJRrIXiFbhPPirdt0s0CMz5FVrCeh2G08Xs
         PAcuRFapeJ/gcci7Q9OwffACd0P6Smrt5OJyR8P0sArsH7lRvyzfn5rYASVGbccZFdKP
         RQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785232492; x=1785837292;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zAMrgILvwzWqIrQMJOhqF/nOJIjycXqb0wNzcVzY6u8=;
        b=qPtnnx9s2ruHy9zTv0595EIHlVW8dtC0A/rUsPVFIfrSgb8E71voTZLXvQgx39lT7b
         zWXb/lTwTYxftYMZj+cgbAMl5ODZn5fbuZSgmmiWz0ipz1apv0B+PG2LoCqAIVaL3j9W
         42BsxLxAdnjdWybjNfkSVcFivlqYpV/C7vgo0ASHn8wZT7ylNojy1kN2fgR9ZWO7JwZi
         KPLkSkthjGAD9vmn3lfZC9ojJHvDako6gkz5Fc9/5jAqHxnJQAbPvN4WfwcA69w9uGlk
         I2O8sdOZMvxAUTPwLLur9Qn2Pfrqw1MbjVQINGGN1zkpb3zxw7ejUtBSXTo2a5EQzusd
         Pz7A==
X-Forwarded-Encrypted: i=1; AHgh+RpfTCizfJXDJFRKYGKCC1fC48pV+8/m3vV6lf6N/JiYcJrDbNQHnWFh+CytfSQjbbcXVwcL6n//H7wLwq0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy60iG7U1oorUw/WB3eAG4OFjcR8zZqi3PNMmwIA1H4hbCNJruu
	Eej1LXORDhAf3D3nYflVnn89N7o/O0NhntdK/kp3oL5CC2a1KVizoj7j/CpRCgLEa6vvFwGf7aF
	CLMb/nM2sZy7uw0od30M5kCOVx8+yUcI6vrpYBvRFZjcY7Y6gP4O09hDfVyL8oXg5r/Q=
X-Gm-Gg: AR+sD11mErRClBqGZYUgE4/6ZUBrVCZQ3WCpQ04LKTx6Uucd7V0zGGpoRZmQ+8RiDA1
	dakgYwmVVHYBgcq9HVZtYAtetW832yQyRz3Sjzq8w6UKNa4W+ATMBUJ4LgykWTfk6Dp6KuWcpq7
	n+ilkIX0cZCw9m/w7DAJTXw5tnCzFxol8C8mgzWj/YiR5e8L4BuOMdddLLaO8PuBBPmmCrbGYWg
	iUc9d+96Oho4WO11oBhVwFM8rubuL0TTasxTII9jahwLbzWlrEDGHnos+4oMgKCfYMEybMMz9O6
	RCVaW5/Miq8LF+R9edDQiFbF46fkXzEYA95hurl/g2iIwranGscsA+smV9vnlYON9a5W7XRTowj
	N6nwXdl6eO2I8ZsPgNiYNDWuIUH/2lQ5UcV7E37GmCdJPgRl1Tje8XbHOGOcuA8FGNR3zgoRdXw
	==
X-Received: by 2002:a17:903:fb0:b0:2ca:e565:7b15 with SMTP id d9443c01a7336-2d015c91d62mr19418315ad.10.1785232492008;
        Tue, 28 Jul 2026 02:54:52 -0700 (PDT)
X-Received: by 2002:a17:903:fb0:b0:2ca:e565:7b15 with SMTP id d9443c01a7336-2d015c91d62mr19418045ad.10.1785232491556;
        Tue, 28 Jul 2026 02:54:51 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d00599b631sm20264945ad.42.2026.07.28.02.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:54:51 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 17:53:56 +0800
Subject: [PATCH v3 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS
 inline encryption
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-hamoa_ufs_ice_change-v3-2-293c7c6c2ae5@oss.qualcomm.com>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785232480; l=1369;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=oi6FyzyVJnz9Mk995hby2l9AHSSEOthgArlwn+kBN9w=;
 b=w9D7yyJ8jEVo8k9K/5FD4LYY2Byw2/aJyjWn/OM35jT+anI0oltHvluKE36ySddqWhqUo+VKE
 u6hhvKqRYMeCmKtsIhKHHrPiMU+Tv9ABQ1cf4aumrYSqD6DKFI0oPnw
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA4NiBTYWx0ZWRfX9tHlrIjDMCJf
 65DyKQYUEYYqWDNYZhTSoinNcjmCng64Zi9s4z/7KciAvXeS3R05l86I7c3xi/lf5N6EiBOP1ID
 YDMaGELg8pW4mmBflrigXdFPpzH1MQY=
X-Proofpoint-GUID: zKI-UZqn2wYG4n0xX1e1VuHYB-9dKK5z
X-Proofpoint-ORIG-GUID: zKI-UZqn2wYG4n0xX1e1VuHYB-9dKK5z
X-Authority-Analysis: v=2.4 cv=KLJqylFo c=1 sm=1 tr=0 ts=6a687c6c cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=7g7wA4PAc6ioHu1SxIwA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA4NiBTYWx0ZWRfX3CaC+68JXblG
 tjYqnb/HxOv5Hfu/8sHD3ncS6iEVUwQ7/JS5sItTLnaHCORxNNbVnmJqP8/I1tnlldPZlNGPU42
 2RvOSWEiiHkOAmxjqfWMYPb7euN5S+9L1ELFqV1D5IloUdu2Ocb2dodgUAnr/XZT6uzDUfqsknC
 6v4srQoxIP0yzgwOYYPDPdfffxnVcsJlK6xWSHVhZq5lqk668PfTA9EDwqAiz46xTsqLG0B6vyX
 oQYJRZoJsy63E2vTwiGHWgUopQepuiLzehmB5ocIQqAK4iNtpMOgvwOyGD9bbUCIC/xh2nSiF5H
 MvQo0kRNlpXjklGgKDPU3PCv7wUC/ARnYAgrZC69LjXgYmSxvkWDotzqV43C83laIWkK55DTZBR
 VbjbDP9YQqd/bpl2uOmZOm1F4Fc4jPm1egbPuGnrrWe8fbEqyI4Tz0CJwq9yFikZLGCpaF+/ZbZ
 cRAsAWZbWu0ODcWsb2Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_02,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280086

Add the Inline Crypto Engine (ICE) device node to describe the
hardware-accelerated inline encryption for UFS storage on the
Hamoa IoT EVK board (Qualcomm X1E80100 SoC).

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 09527dcf957672b4b9658988359e79d8a432fd93..abec577c062d53952528f3bd0330638ea53b83b3 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -3894,6 +3894,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
 
+			qcom,ice = <&ice>;
+
 			#reset-cells = <1>;
 
 			status = "disabled";
@@ -3939,6 +3941,17 @@ opp-300000000 {
 			};
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,x1e80100-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x01d88000 0x0 0x18000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;

-- 
2.43.0

