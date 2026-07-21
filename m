Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B307243B3D3
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625818; cv=none; b=RCeWP6ksi6zaLhR53wN8O9o0fb1IVWisEs2yZE9PtohyjWXh+9sBFAYTLAeXc7evMfzH0KxN+rj/qn/wMCEIrQiogzXHiGoh5/ck7K96koKo3hWSPhp5ie2S3TKY6GlpMfq4vvJ9HWGq/B3mTR+ao2F7S0w3UCGg7D7i0NbMOJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625818; c=relaxed/simple;
	bh=XuI4reAkuKlnQin1lmUNoLsA/XShnA4japSVyO1mTAA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ERmrlTW0qJQRemKYH1On7RsFcJBVrA/E3Veyg33qq7Rs8O458edAMbQfdunTkX6ldgDDUVBiIry5xjwS8i1ntVNH1eJ+NplcmCppHbEHh+jpvVVE4lkR0qTyznWTzGiURUmEH6YhtVqbhMhnm4sfu7a5dXjr2pY6E9jcBpueDtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FJH9pzlL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W4M3673Z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FJH9pzlL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W4M3673Z"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L8sACe526991
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	g6EKPDdVvughZmrDjXmmjYpCgANEXgKYaCBl8ydF46M=; b=FJH9pzlLs6fx87Vw
	q4HcgLD3pBOieDAX5QKMTU083FvezLdr7BN+QCfugy2kQ96/9PS6rEYjFLmktbgM
	PYGZek0N/wq6rxp6APdU7ZX2h+tYPH9Ap1wCSqU1eXP7aig2jfQ/AeDQ8J19MRDh
	2FmyztfKjidOZbyr2NmaPn6HZ91toJglGNOsUJCELpiZHp2XaxAkdY35SA8YCZRQ
	7LwGaWf/miQ1okJ13Rpt/eAhmVOtWAXSPniHZBSwobXITQCONVzRTd4SjTOhUxf8
	iOFTrcgueGHFquLlY75wDxNPOuLHB8V8DrJGePfgITD3zkxs3NCYWnUDosW6nsTb
	C6sJYw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj1se1bam-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 09:23:35 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbe39ce62so5068147a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 02:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784625814; x=1785230614; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g6EKPDdVvughZmrDjXmmjYpCgANEXgKYaCBl8ydF46M=;
        b=W4M3673ZDGRuGh30uDTU/lfrPUN2OJgCHTyGYulu94s6z5vsYpPwrif4iKMhZ+zF5b
         m+emS/2l/3zs1YG1+6xMSEzMgXyM87naeis+/kZTc/OVtBldW0TzO6MgX8qz72W1lPP8
         CuCmrabmXUDx6FIwdm2FHl78P2yDt2L3NuLYcCuK1ZSinQKJdIGZH5rlZmDzApqOdy3m
         37e7VNrfPl5rBJ3Is80xOcIQqxNkJPyejqx6XBXxPvzrMMz1wG7XVvpqloSfLyHtqY86
         D9x+FCR5AacWuVWvEmOif6v6VEzobJMH/ksTAjjSgWx3YeWVi+FLetGHmbOUIjRzAnQL
         372A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784625814; x=1785230614;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g6EKPDdVvughZmrDjXmmjYpCgANEXgKYaCBl8ydF46M=;
        b=Qk6/r6NFiFsSenzO2sRcBTvFz64PmN9XwocT173IsKv5AGudqaAjZyseURAJJwHct4
         jAgyQmzhRzrN0uq5ZBmew6W2P8rw0Sc/pOJf0L9BSWF9JP4AjYDfmBfnarhH6t7p0SW6
         Eay/sMx0UnyRrJCSuvayoBDNXgtubkN23INkQNMCN9EkmI2aXVnjNzzX9rtIxiXp3BXX
         JpgEZkdRoPgeeTn2OnwEKjH7H08HWKqKfoeIB1oE+2yeFa3lP6poH4AqOzXdydSnqB73
         FZDFGzuJ0AV+KpAlYJRcIDAY0ro5ov6lCFdNQmjhFjn2DkFoi1VSSB/SYGor8alPn7WW
         j+DQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq1b2vHXGVSeRcxHsUMn5Y0gb4JZJE2GJl3jXyA4C9y/AaRjXnCl35kacjJzCMCT6FGhjW7odD+G6lT4/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaZKvbhX57cuwlqoz4iPYYSIy9qC0WJu7mPSQyEgZFpBFNE0vm
	Zviwr2tKbdZ0JVFPzIKZMlPJi4CpAvAe2Gv2MNEH55ccx2j3ZwAo+RfMIZfFfi3UAyLzalqTfPA
	v9+OZL5YOHRLqJpRDT314kJ3ZRaDZ7i73xa8um7AlQ34BaNbOv+Qq8MhwWnkY5E4mr8e/6Gr0fB
	o=
X-Gm-Gg: AR+sD13eMS9NnHnbgH8Oqr3ZG7ux8EAxVt3mCkV5HJ63oFJRfnhFqiKK3OrXvVQx2L4
	mKadN/Dp314+4B6q70y87If85AuQPd1gsKRHdlpw521VQC6OpuhJOPawiSmHwepocDFqZsDPAop
	lAmx3tp6WPf9O91YS6nPjRHI/PGt45ssXkSUUD8HloGTgTwZB/2b1r4je3N97wi2KqYAZlBGzzw
	dlY+GBi/8OLvv16zEkEd+i/YmCZK6dhsv1SiIBGZoNE7RHZlc0yDVE8Qp2tlFIxeB2IR1ubUaBX
	40uFbmU0GFKAQJzlRpt4IWsDxJ2qQBZbs6s8RsS6iD1jx0kWEKSrSi/9XvXnhVXD0zLKl+uSjs2
	p2vExD52iDAV9P9A+KyKWXmHMrJTuKu/c8gH0LpKnx5o67+YsRi3JkFjASn4P39CuMHbVQAMnvw
	==
X-Received: by 2002:a17:90b:2891:b0:37f:9e21:91d8 with SMTP id 98e67ed59e1d1-38e4b68268bmr16354668a91.15.1784625814406;
        Tue, 21 Jul 2026 02:23:34 -0700 (PDT)
X-Received: by 2002:a17:90b:2891:b0:37f:9e21:91d8 with SMTP id 98e67ed59e1d1-38e4b68268bmr16354659a91.15.1784625813990;
        Tue, 21 Jul 2026 02:23:33 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e4801e0f3sm2308661a91.2.2026.07.21.02.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 02:23:33 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 17:22:34 +0800
Subject: [PATCH 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS inline
 encryption
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-devtool-v1-2-ade633accb41@oss.qualcomm.com>
References: <20260721-devtool-v1-0-ade633accb41@oss.qualcomm.com>
In-Reply-To: <20260721-devtool-v1-0-ade633accb41@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: kernel@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: r-WGvujNR_SR6A044ASXj8TxMgXbM9Tc
X-Authority-Analysis: v=2.4 cv=TIZ1jVla c=1 sm=1 tr=0 ts=6a5f3a97 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=eAbYZzanmNLtdhUhtOEA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA5NyBTYWx0ZWRfXwbWVgNTie91z
 7pa/KafWSOfbiDb9SQLxTrdTqiugTrP+mVm1oy4H4qyJjw7+l9Rc/7H6mJ3CGTYOerZd4RazzXn
 +/G6/jAiFAV5V0AByFWo3TrRL+93/+Y=
X-Proofpoint-GUID: r-WGvujNR_SR6A044ASXj8TxMgXbM9Tc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA5NyBTYWx0ZWRfX0uBPRX7/WbV/
 pQ7RfDcS4QoKZKzMec+PQfqPYgDgu8OpnHN4R3eJLD10KzwI5lKLrWKvYF/GyjajLNVKc0eq/IS
 z3KP2kih/Ah4yOmlUJ0shodajIhAbKyvzAoV8bwFCHbSz2moPU+wvMCFo5C0tAG8wUTlQ3bAfy1
 be2zBR2uHSxpNBClUFXSpdVobrf11DEVZ/oZxs5Vd5/gTjMYCKh0gHjAptRBS6BcsA4hTYecr7v
 eQHkXggwJ48XyOee+R5OSBXiJdz6GuLVZ/tKBsYgcz+LFP377VOYpgeuLN/EnUVzKAzPi5B3meT
 3k53/cnIFjTQlNMb3XbuqR4qr5EEztOvuf9OfM09PNqiUO4sgxvbp9HYhKaGFnP1CW+kL94pol7
 FRsYk+YeAvt9oFj+uQLdrddQhXXaJCTxPePtFya6EVTyJthi/K4nEVdliY5Ol2AbhLMCbdYW4ca
 axzjuorywZ0vvz4daHA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210097

Add the Inline Crypto Engine (ICE) device node to enable hardware-
accelerated inline encryption for UFS storage on the Hamoa IoT EVK
board (Qualcomm X1E80100 SoC).

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 0840eb2f884f98d76442fac7888ed49a07780898..0c9b459055d720a528a319272161d1d7446daefd 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -4176,6 +4176,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
 
+			qcom,ice = <&ice>;
+
 			#reset-cells = <1>;
 
 			status = "disabled";
@@ -4221,6 +4223,17 @@ opp-300000000 {
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

