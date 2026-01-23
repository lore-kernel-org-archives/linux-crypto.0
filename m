Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EE73612FE
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152409; cv=none; b=FxucFNkoAixskE/0RrJwqOuxxOoDRTY+woj+4KiZgIQmTom4lO3r+wrwe/gOLXrz0XDQA6NqfvjRqN2OaOpriqNe6K8GmRJfOo4/nsmRt64rh1UzwFYS/vLYt5fTb7QC1boSQR3/u6rZMGd+9JIGv3NeM6cHCu72WNZ7I000Gbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152409; c=relaxed/simple;
	bh=TUr60SZJ6b47XuuYpU9lYYOfs+QK64RRaQaYUhIjboI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NY0ApyEfds4yr12Z8ocfAWRumB6EG2Q3CwALBY0XF7cqytkHIf6wEgoSr8mYnPbXhJez9H28wB6YBFhMEBexhz1/mXHYYZa6SIeEI+GEFf/9TGXxVw4xRZamJZPhqmufPBofTersDrcRAYM2wwkados/5eICQ9mb0nTpYGmZTtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Eahb1bWN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iBjJ9M+9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Eahb1bWN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iBjJ9M+9"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N2OqxG722440
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4AByPOkn9+iNeGfpQDKHJKuLAUfJ6PJXVbDMOUaR06I=; b=Eahb1bWN9ygWJpYN
	+rP7cwbi66wHWps0wFUYQAvLWCDQ0r/WYYYIuEP79wEWDjybrUUxy7mIbXJqNXbF
	G23vg8qHmjd6HuoTTlhxmGE1SXiM9BXxb51OGC3BZ36Ma5c1aaTJ4CfX6VA2ODJF
	R5oapn4SfyRf/o6PLNh82c44llHmQ269/HhwTQeRYR6kagw1qYZY5WCOlmEa5qXh
	e8AsQf4POv3aMBgOqU0KcTosA3OiAQZyX7ICS8QjD3GL3Ks5iW/tRxRnYqcD+SJZ
	m9ELhdK8wvEDzVr19Ihib4Ov9WLnwAHlxQ6/eLBqsTqwHaYrnzTKGI7wRdd79SuP
	SY39PA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bv069gxtk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:01 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c5454bf50e0so3177143a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152380; x=1769757180; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4AByPOkn9+iNeGfpQDKHJKuLAUfJ6PJXVbDMOUaR06I=;
        b=iBjJ9M+9FZziHVPfhoFnt8jgWATUJsnxL2O38biaPagP9ZAlu95+IAylADpBXy3Ui9
         dsTFpSqaR/aTUFQKvR/O27rNKJqqB9ixBZbWzn/RIz6sz+NKC4H6MhfDfSgibg9XMdMi
         fFfKja8YTtgwoJi4uwODsyqtU6RGxZSGk7YOIR6/+llrQfPosdGEKNFCFnr1WaLsa8fU
         vza49EHPHMTMPl8/p/t3+BwLp3Pl4wltGVCPWamxiDc9mIzFLZvhPy7aemisCNdvXgmA
         pNUCTo8s85K2jhyjsWyWzHPLMS8hcNuU66m/V+pnyjT/rQGSZ7diwF/WuyO8kNyTEphh
         /MZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152380; x=1769757180;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4AByPOkn9+iNeGfpQDKHJKuLAUfJ6PJXVbDMOUaR06I=;
        b=Y7APqU6AJBVl+y6JP/5oKQrEDM+AIyf4nuaz5T9drXvKisBU1bcaSy59T1XQyNbW36
         oLQNlzRCRUAakdY14p70te1x00BxAWfpano89GJ1jP43FbFFL6uBKhCrXRMmvXH4m8wN
         2NmiSSK2ddeQjkLrb4vDT5O0E4S9J/Ud3M/ZU/sV25k0uCEW2e8f3l3axWDhYOnjJp3s
         e/eCkjiE0SX95wVU806/cUh5TJEys1rDHxLuHbZVzAROxLK9mdnSZ5YrtdXmIrdmn6kW
         cW/fcWQLA8e9m2uAwaUnedvt8e+TGQvbJdmnKHMertgMRtYaxF0T0GqM/xq8FPYI/gGV
         ZjUw==
X-Forwarded-Encrypted: i=1; AJvYcCXOi0b3n8IU7Ix8Eieriu2486+d6QFzypxkcsmQpDiHsofg0re9U8Sz8I3bXNNL5bIBlpbr1T4jN6bBamU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXtL1oZeYeDVIYuGpY6A/k583xYDUzEt0O6NTNJKj+LrB9YO2d
	kgq8P239kO7H9G/9Wzw6jT5hobrImPwmqZ+qqpv/3KYM17g2dPHJcWooVeQfcu8Nwd6gscZVq8Q
	dcLVZyVwDmeFYBSHA0oej79hlQ+ViHdaOsNuWIqkhFfsTbQnP2fX7s9fw4whRL0r1WZ4=
X-Gm-Gg: AZuq6aLX33FJBl7hrpaO2QVnKM0pr/eE39vUXT8WcQ4kt7T1U+oa/f0WlpKKROfRxY1
	zNaBmZW2SlaUpklPrMtAWWA3/PqoIOWv+/o6S2Iq1D9iKhTykS59mWWaWW9YcxTIUpKXyyFqdBc
	Uc3kM4Q2+kZ8wE3zDXMGhbyQ6rJJn7fyVTc593hq9FeVvffHsosTTnEBOr5kRxa4eNTmkQvVgoB
	TnvFQ6uMmUjDojeVjkX9fgZivmsbTmkeufL1U/y/rbyqIgl4hsUnMFFORW9waxCjzlnLr5kUiE5
	bhFUphbGtKtRH0vb32WwSoQKv6rclzEg30ZGhZQQ9yn5rMnc9G8QGzFFEqAanf1fZ0ahpXgp8cP
	P6EYgs38B6SEg5XrkVoOhITToEGFcj0CIhBk=
X-Received: by 2002:a05:6a20:160f:b0:38d:f8e6:fc87 with SMTP id adf61e73a8af0-38e6f85b9demr2215084637.76.1769152380184;
        Thu, 22 Jan 2026 23:13:00 -0800 (PST)
X-Received: by 2002:a05:6a20:160f:b0:38d:f8e6:fc87 with SMTP id adf61e73a8af0-38e6f85b9demr2215052637.76.1769152379696;
        Thu, 22 Jan 2026 23:12:59 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:59 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:28 +0530
Subject: [PATCH 04/11] arm64: dts: qcom: monaco: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-4-e9059776f85c@qti.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1230;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=TUr60SZJ6b47XuuYpU9lYYOfs+QK64RRaQaYUhIjboI=;
 b=hbPnWxlLxktyHBA0akluW5P9sZORyKr5dqVxLAMH71rqvSwnAiulYTZDZor+k3WsCcvmCxIyz
 FbKJ630qKdSAAaHa4CYmPSNB8j820Mn7dJs7vJMtQBBGBxrUVMBVvP2
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=eLUeTXp1 c=1 sm=1 tr=0 ts=69731f7d cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: _ZYQ0FVHDVbHQaNua9Na57v3SebyOZjR
X-Proofpoint-ORIG-GUID: _ZYQ0FVHDVbHQaNua9Na57v3SebyOZjR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXzvxDn/79PHfq
 z2/W5FBaa12xB0/u8CC2aa60hjkloeJHtp0vXe31FtHaK7ehVKTuynsuu+7fWTjNCNVxKqq6cUc
 tgnQj/GIG1R1xjdJYVyN++Lu85dgCCqvVPWmZ4Dlu3j7vroyAEqVf8qfkBeShLaD9G2n3c9O7bN
 ahh1HMzDWtcu/ieT2JTOAD81UC7jZsKLaGm3AK10MqKoC9uvZed/o4b/Fp7Zh0G3yvtYS4Rdkg3
 WiCh5lT39b6t8asgSE7+J+N2PTVqkx3xP6C1kFG2HlaomxPe0atJRrhpiQGogMd4ewxlZDwVlnD
 4MIevY6k+EJ98D+QdsIOFPB0mUblxxa4tOx3CG79xdxjNqSXucYA64pELcn7TG0By9MTvkw7tKx
 pBmR1g98wW/xBrxflyw2KBjH3qqOyvBV0qhyF5sL5CmlhUuEosUf3lre4EIYfy2phjIB9ttf4kc
 rzcr+1wdSMCq3TCgbPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and 'core' and 'iface' clocks in the ICE node
for monaco.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 83780cd3dc8a..b97a35ef7d6d 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2725,7 +2725,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,qcs8300-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		crypto: crypto@1dfa000 {

-- 
2.34.1

