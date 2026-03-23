Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0926389102
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257596; cv=none; b=QtUBI86FYiGFEXboRvW1HDUC78/GGMlu1MMxNlPRY8J+yCEuY6qWiknpW+HOdoFr9T938jIbXfJZmJpOypeYdwQtintxrujB9xOpWSCeGjYes8zNkGGA69tMpWrtQ0Hv7Y3fefnJoNCAWhtU9C27Et2EjOF8fk/r494gITJeBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257596; c=relaxed/simple;
	bh=4gCokkHZ2GjRf5B+A9Zqx/4PsUp2LAmyJ4JNgVsWI14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EB/sG39zSJsvrFJPP7tL433b4w+uJqMrSDOtvVw+gZG7bnrTW6EPtvs//v8Yn5TrX1HvvJVQNwduWCEOp5K0j+GebevZ+p1YsDPNYyh8TnNppatAaNRScxc8Fn64V3AKW0wjJhzTGU5Qc6eZ/ERdCeg2OaZkjPkvKH+zZKrf/hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Kddp+ydx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CKXNudTU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Kddp+ydx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CKXNudTU"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7G42N1220191
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zpbpg0hPnfQaJ1hYQGaQ316b4Tnqdwkw1WSwGLLXo6Y=; b=Kddp+ydx6NynhTSU
	Fnn8ufuOmm5/WZKJ69ZFHmVLX7OLuY7EZ79mFTuDVt2zs3XjC5Vm7BIDUI8hXbRC
	FUAjBi+BaFQhG5uX+rRdqWVZcG6b3GRkp9Zlge/TpszsfmMEqiW6oQpms3IyFgKh
	6fdwj04WeicsYbcskgGAaAR10m9fzW/NCiZqU/x5K8L3q8iMa6QgNQOkyV43m22F
	YEq20AKdqOpGyoosNBt/G9U8ZStB2DVMPUDcLNieIKw+iYuW2ukmhCOfE+uPGRKa
	0A23Tm5UQN2IPav7V1sUSh8h/gyyuCi5IwO5Z/junGeLez7CoK86mskz6OG/1LJQ
	m6zQVA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1mghcj8y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:52 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35b8f351debso4880827a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257592; x=1774862392; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zpbpg0hPnfQaJ1hYQGaQ316b4Tnqdwkw1WSwGLLXo6Y=;
        b=CKXNudTUTvvT2FPnw11mj9AQaAqnNnFkTQiAn715iVftZ/3HiXklxmZaeRJwQqm57K
         Ezhu6kgPRlX5af54eo3qlrsXnqH/taM5In3c8k7Y5RQJblbp4TBsXxkZUONwkxphsR0p
         QUHcLMOCDoKVi1XvBIALYc7+casD9WIyIENFLWxUQdBbBMGOaMR+xJEmjL5twaxlbVza
         FR1BifX8qqFd9vZ1TAxikLiRXMBjGcA4UlOKElobIWvwjrBorqmSf1Z+WT9yGP46Bo69
         gG/Th3zevvNpkVOVIIIWvIP5/YfSch2dhwCvJ6wCexj9PV7f41209HDuycx9nneu1UKE
         IUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257592; x=1774862392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zpbpg0hPnfQaJ1hYQGaQ316b4Tnqdwkw1WSwGLLXo6Y=;
        b=l9jI+pJVjbaSudXHA+b1lGu1fHKoRdw9j8UZbmDyg4LqwH+SkiATWPbgX3XTKY5BNo
         70dg92LCereH7OldjubTpTtexUmCDMBgYVpgti36DxKeKzT0uUEVWBTdpTxBj0zhq3PL
         JMNtUBI+z2rY4i26VXMC22PCmufJx76RzlmydapTrzGCr5wZCsE60CRu8iv8XMg1hvVS
         9Wvha9T1vqSqdVFnF9nhKBA1al98jpHKjNT3lQHQ6oUmG0K6+tx5F4WNKPQDlm8VZZSW
         Pg0rxvirEe387G/RD5bxuwwbo97F3IM7uKBNmVOjQYVW0lUuT9fddbPRMgHLHxVy6mwU
         STtA==
X-Forwarded-Encrypted: i=1; AJvYcCUFHEEyUa7fJuli0zk/rggWiVdEjrJkbFqKMZZL4sYaLUJtPdTodgplJAMn0ceKQEKqYtsiaqSVXgYJMl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfJUwDkF1lrCaYaz3dagEDWH1dSe09waZAYFb/QJvVe/8LhlBW
	hW3XMF9UOMYRFLg7TY1rf56gYbuESeSv6hryxJdUgyzPCD0640xS+xn7tb0s1fqAZ8JEgk+Q+wV
	jv3nbhAoSSxqDHS9l6X0yu1HmPz8YCN3d6/zABAKeIDLGPJPaZq8n3wIWeHyou+94COY=
X-Gm-Gg: ATEYQzzzrh6U9sTn1gQm36o2lZ1EmyDRyyA1SbSEjP1IL8qsedHsOJn6XqswPIm2CUf
	y7f2TROVveM4kPJoRjBl1UdBNqfThyyCSsX5xoVkFQ9I2bPcMwQu/sMN/6IgTDK62jWqyBFyc4K
	FXNb1WhCAmtTPTY1mV/odxS0J1UB1AThAkmFJ6/Z2kvvxRq5z9P/2dwwLkYQX7SydJPKJVzfLr7
	uQLPzhaQ3SoyhsRuceyC7TtgjyClVGfdRl8ErdOiNFvYypS8t/ddO8SWzkPvwq23+fTBlXlBMDW
	Lcmzq993tehg5jbpTHc14oyrqFdNFg8rq+qdD/JTSeZk59J3Z5JMXO0WpN3mvNrLiw0F5Hipg8A
	Ohwl2HFe3VjQH7Wf0wQJd9OKQv4Jv6zA75RdAW7jIhAofXno=
X-Received: by 2002:a17:90b:3d85:b0:359:1063:6aed with SMTP id 98e67ed59e1d1-35bd2cb3e52mr9251824a91.22.1774257591866;
        Mon, 23 Mar 2026 02:19:51 -0700 (PDT)
X-Received: by 2002:a17:90b:3d85:b0:359:1063:6aed with SMTP id 98e67ed59e1d1-35bd2cb3e52mr9251785a91.22.1774257591273;
        Mon, 23 Mar 2026 02:19:51 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:19:50 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:48:04 +0530
Subject: [PATCH v4 11/11] arm64: dts: qcom: sm8750: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-11-e36044bbdfe9@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1456;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=4gCokkHZ2GjRf5B+A9Zqx/4PsUp2LAmyJ4JNgVsWI14=;
 b=RswpYVENgXtuJbX4xVStbksk7BFMx7jSFT0f1TB6KQum/olhlBcJk/LgtEnVSjBqp2WNzexDI
 j24z+9Fl6TJC6vKXj+9p1xre4eFuyfcqRcwxcl1ntu5GX3AGZpbp+7L
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=HI7O14tv c=1 sm=1 tr=0 ts=69c105b8 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: p6zWaS4XM9gwZaLf3yuiOX38q6pUvuBe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfXzAJXuRVKnksk
 2ZbJFGT9G95gF+riOcWePanNhcZVjtg/eUcniVcCUuK6B2EWcHbLVbELgdjug6MntFbInsK7NGI
 5Y8zb34dSedT8WhuKG9uTFz2FZ2FRj/XObKKX0mmZ4pyon3K9jhJIvUAnSWArhMTdoQuhfTBohh
 bhlMxo/WU9GpEZRITR2Iapn5A1PmjupaA8lVnF8+8J/jP9jtwo21POqb7hX46Rm8ScX7aE8mmlz
 xQPdJjfcZNjRBFMRc8RejZjR8htX9xUFyybj4VXyS6PuGFeZmNcFlUOg8+ZRs1jpLzAgGvVach2
 dhHG24HLRVO7fINK27r5IXod3puWWZP6c7A0fEeUY3uOw2IjQC+vCk4tGEUv9HSKv+mw5dsoFnK
 bDgHkW7mod9nd/WyCi3i3k63u6ERd8ohT1WgufpWcR6/13sSmxeFVzHszHBFCWH43de1gXGL3xv
 q+3IHNybosIbhYU0tpg==
X-Proofpoint-GUID: p6zWaS4XM9gwZaLf3yuiOX38q6pUvuBe
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
sm8750.

Fixes: b1dac789c650a ("arm64: dts: qcom: sm8750: Add ICE nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index f56b1f889b85..8c33bc3620ef 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -2083,7 +2083,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
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

