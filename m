Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8826F3CF69A
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130034; cv=none; b=c05TUzflQxsdE4tC12CcvQhwTsGkDbXgGi5BAvYpQ+h9dTKHzu/1WBEnAXbQe1FrZMUGlG7gfo8Gc89yGShHkomhhPt9cJh4UTgdOS8eXQUNddt411BtGQviJ64muasgjEfceQNA7UthHAgoXAu7KqbZApdOufgWirDjkv6UrYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130034; c=relaxed/simple;
	bh=eBc/tZwYk+Z7AphVW8f7WhN/S3F9nVUOBnpnGU+WVlc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DO+vq7PyGS8fCzAb7Bk4y1FNoTDpLGnAg88GkYwZMcWi1sUBQcPhrVxB6fNbS75ywDPaNuyc0wbOBl9moTKTmyiZ2+p7zt2oxZ5P2RUXq48kXNkN/gRgV5NSFKdgYknrrHEHbSrmBZN1jpcwr3GZDSQH22EQAhNhXCCpWU6N9SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aFEg2qgt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RpKdAydc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aFEg2qgt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RpKdAydc"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A5lHNH568739
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zo28n/Z/OC59k3+VeK8QF7/lPzfhkKamJ3iorOSmEmg=; b=aFEg2qgtc70VhB31
	wh69BrmZCv3sg5ELq1KRjwuv+gV6R13Yp0m5BfMHN7aSkJdvFGySqRTciHwK1W+X
	S6hvtIinFIZPIQuC8uZV2nZdllu8PfFEupVlcUOdbUkOTWVm12rw09AdE8fP7ii/
	1tdVM9XlOZ+Ou1jvvTzr1U6o1ML2hXqScowyAv9fgJ2lzwpZditN3xYrJveZQG8G
	5ZeObGqEYFvekn9jiZxVhIgAwlRvIZQ35b5KUR17h9euoUYFGmT+IBEtH3RdWWrq
	SdGmT0eZ9ZcHqaDfVlxboTgjmwoElutH2UdpyvOZN3mg1W1g5CyOnZlyp7V1Lucb
	XIaylg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctdf8gexw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:12 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c73939e0314so2614837a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130031; x=1773734831; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zo28n/Z/OC59k3+VeK8QF7/lPzfhkKamJ3iorOSmEmg=;
        b=RpKdAydcd37e1xdGdFrYTwQi2MHYoLvIMc8tTgd+gFrrVedAQYO1qbJ1fGX4YBFGHn
         Og0yyVqBZ0qhigGVArUxiFvt0UrhJSam3P6cF/I16OKUSCEu7FrCTrQb1B6h48+H64zJ
         pbuwWdklPJVXDusYU7NoeJdD9Nq+bCTG0TmlBeLFBZNOvPpDUt79j+9QWh6ITyf2lz7B
         rSaFvBQvLWNO7ocQxrBWRffHCStiNMrfWVfhTJLHhCJR1hmZcMiRzdchj+fqj4ow7i6a
         TW/gvCwsZhjzPaxFgGrE8/w//FOsrzCDbE6zPWpAY/lIWGBXJ2XJu2mNLYG4CNfzjXrY
         BSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130031; x=1773734831;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zo28n/Z/OC59k3+VeK8QF7/lPzfhkKamJ3iorOSmEmg=;
        b=TA+/V5oIhEJU9UG8TISR9HHLP5t5rgJxiuC0oeZ7PtUuB7A8gFrz1lO/bBMx1TyKCw
         eBQm0GTsDumi1APXf+6Hpp2V4shnB5Oxsw+5UOQmskWjuMI31zW0jtuLJrcP/VO8gJFh
         GbqaxB1EFC/25B2pHZ+TkUYjn/5/BBMDA5yx5q6VM+AiJ58G3+3Pocql/5z3X7U71AEk
         rmNu+bBzaEM/MJ0xaW8Elulg1qWAtZdW7qAZPF1fbzQErNKhkncqfAVKAIQMNiVUFCXB
         le+nlnuIv6uNdDwUrZgG+8nJnNyOjUrK9KW2+07xbLaTPuP++vyltYKWpaeK5xogi9+T
         OQ/A==
X-Forwarded-Encrypted: i=1; AJvYcCXzrv/Ma8oQhpueiDrIGP69SRvkogS+sNrTD8qHTHDeB1cCjSk+0pCoKSsUNT9TCJvcfnnt38YY3yIGTkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1qK6vCrV/GMz9i/5swJpnzKP/YiaWZ6S6e/CA+iSuEDeHboXn
	h4dvzzW43O87Pnj2T1dRTfJASH9YamxYe+dSXLmG2dOGL1pvgTnoQ3Z3SqLu3QOABq/m7xqBrsq
	kY3yZyh3zE1PGJCQyus9bZ/WUKD1jjAzXCl6t1ZEPi9JJI/wNTUHdbF0QNAwq1Mz49QY=
X-Gm-Gg: ATEYQzydQsOrF9OB4/viJskkCJdU7cWrH3ojVSqmSGT26YLB3DSPfx4AqTs7s51gD8w
	KySYNBbSPwCOiv/y2DgrcjA9kd9JNwJPR8BNLJbIrJr/7ORNJtyrfasDp4NbUeUubh3U6wQ21Iv
	j54CWpc7G6xQUlxeWxaQ7hD/tZrsZ83IeTFSo25XNPF4PcJn9hSUDFSs9uyEuKi1dBd0NpJVyru
	GhucklCR/gUbRilsSH2luQVU0Q2WXJ1cSnv9TpHWJpmqPChtRUMJzVqmr4kf+lkQutwBg4DKG6V
	EB3ZHZSDw1JBoanWHn7OzzU7uaD1hD0REJ8nf70Bj5aV+GxcrfCtpMGqaq+2fWsDA4ZEzoseSw3
	HxwkXploYprXWEOhuLoz7sBTdG+vcpOvXhWnUy7WXPMGlVMQ=
X-Received: by 2002:a05:6a21:1f89:b0:398:b748:b571 with SMTP id adf61e73a8af0-398b748c49amr179914637.45.1773130031460;
        Tue, 10 Mar 2026 01:07:11 -0700 (PDT)
X-Received: by 2002:a05:6a21:1f89:b0:398:b748:b571 with SMTP id adf61e73a8af0-398b748c49amr179871637.45.1773130030944;
        Tue, 10 Mar 2026 01:07:10 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:10 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:29 +0530
Subject: [PATCH v2 03/11] arm64: dts: qcom: lemans: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-3-b9c2a5471d9e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1465;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=eBc/tZwYk+Z7AphVW8f7WhN/S3F9nVUOBnpnGU+WVlc=;
 b=BABY7pgd16anVLRoM+eELOrI2+1ajg/UoVcu7W4wDva+HetlpdONBveDoz+5MiAsOGfop3x8i
 vu/Uo8AoJ3pA81LXCzO9DZxsJ8Pm5DVXlmFmXYtHY62rGQaaEsrvRSh
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2NyBTYWx0ZWRfX3wwtOlXr+Po1
 sGQzYnANwtBzpIUHgxQPpV6GxNqf3+g3hJ9VR8uxPStf+/IiC6vQPFzvJiFBl2cJUPAcz+WP9B7
 Igx7wkZW0Xvoys43OLvuqO0Fbw84NJUz/krgb1A4ij/zC6Nfc2kUMi6icDmWLcciqfPgBhenKt4
 VUyR4X6nVTJbj/l4uRqlz+Mwn12zQnJIKykegNViAXm1jS4xXUgbufi8EdG6lshUlxr9/TIOznH
 SWOyyS3jV7FMfn6IY6SX9sNqRH7DeKacneAlo2agL7ofbzQ6J+wC8Zl8v9dJqlS706lVewBEpun
 kjsuvS5uK6uK/rSOTRLDrS6o5rThHwF1lpDqZ7M98+LxpPec6xRlbMb2PKialNObTNteh4Pi052
 yRk4L7bayMELs3CovZIt0qC1cFtuNHo6gVpVVyBKFmjSswXHLcdhT7+oSlweWYY6tKcst2y7hgn
 QNV/DAN3srtJ9dmou4g==
X-Proofpoint-ORIG-GUID: OGIiL2Lynie6ou0SDLLjUBAXXXvkpxDd
X-Proofpoint-GUID: OGIiL2Lynie6ou0SDLLjUBAXXXvkpxDd
X-Authority-Analysis: v=2.4 cv=b+W/I9Gx c=1 sm=1 tr=0 ts=69afd130 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100067

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for lemans.

Fixes: 96272ba7103d4 ("arm64: dts: qcom: sa8775p: enable the inline crypto engine")
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

