Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB736CDFE
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739353; cv=none; b=q1/Nf3fDlt8UDyqtV1AOQp2gi75XQ8wU97tnChCamBKs8KYPGo/9YPe9VNaWO8dgyGRx21YVGVThxU6eT6oSnFPbEtkIlnvAdEV0tRz0OZA/QLBLmuiWkr3Rm5ZBTPN3pcTvSzPogGi+ioT4CTJxH/gJEtHdrK6YE/n3G9n6T10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739353; c=relaxed/simple;
	bh=jNnS6vGH+4xi0XIVQONh6OWH1bIBeXmAWadZ36T98CA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q0hO72ZcB4dSkfQClK22SBeGHlOWQrSTg9B9kvzwM6eYWmHFITmFmACySkQNnjR0ePIG5HWxJS0VnuIpSnso59UPzGifSIP0VhHNTMffJpaKd7ziDDG/6J+TNrZJJeVqxDMg/0YzqurFpiixRibH2dRWZ19FN5EUhxJx/gTeHO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fwJ1WhY2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bMgAF7aT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fwJ1WhY2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bMgAF7aT"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H751NJ2375054
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UQ+QjOHQmyJW0MDla5KzS+DLHnL+9knlYFjtShy+6P4=; b=fwJ1WhY2wbwJ1LzF
	gZ6k//13FDlX2U8X7N2L8n2YpGdyLybKfXvZTD7GXvFHCZXwrZuNR8R8yn2v3P6J
	u3eOYEwn5dLzMjGbgWt3VlFR2Nkopdo0V/9DqC2KESNEMgk1RxMLmmJ7cSKvClWp
	ijb6YYMVuTJ0iGaK8SHxlsUz/aWDD/0biAga9iykW9cAh1DG8Kf7R/nRHrQADrqi
	FfxYsTeG13u8lBXLyz4jCufA+8LGGUM0PCrYUu2IapuGmTietOyCrlCdmK/Ga5uY
	B8xSxu5Sy+I3OP9bJyVf+6voPn6vkHMP8iveJ7bn9TOkFsQq+jCri7uCOrWbdciJ
	SpQAuQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxkby3jka-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:22:31 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35b9333cbfbso12274343a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739350; x=1774344150; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQ+QjOHQmyJW0MDla5KzS+DLHnL+9knlYFjtShy+6P4=;
        b=bMgAF7aTj84tPbsnucbrFzimt0MGJru7+hcqhw5UztP2XGLcI2IQkNAzjxRQP/uZlm
         NvTBroXG3MIi8KYUAOelUPPWNl3wsVUZyaEN1qh0qoNBkd/FFbtxouBgmAUbipjWhbiN
         Y5ZU0vL8oj3c5a1lCfwcGf3H9F95yNWhTRKJ7Sra6YELUB+m7JV+t6qcTlJvKK5RSv3S
         nNjQal9WEvTl4r5x7Kx1uNK5ZfwE/eP/b5KOqnIwxADG5lhG+FmReNxku2oE0IYQ6Sps
         Pxqr8Nt+aeTBfN3fQiBpwM/Jp+5d51UDw/8RGqnu/ilFTMdltG5QFY/trGoBlwoeOpe+
         v0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739350; x=1774344150;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQ+QjOHQmyJW0MDla5KzS+DLHnL+9knlYFjtShy+6P4=;
        b=ZRjjH32dqw3gX+UbnFf1Uwk8hOc5xh0hphaR4mYro07mefb1izi7BymsUjF8F79icF
         MceEC2g5SYzqv3GegHQiATb450u1gw9MGDKgQBO85G8CcSM9KYP9ClGfHu/ZhKqTflH+
         EBKbGl4DY4lHQ/Kh0mGCu8nb5FciNpkd0bb5kyAnTJ6zwplqO/TVv6PWEP0cHin+boru
         iR9QzHeVWW9wOnPxKGoumuSvrqKu5O7pzfXtDJ6mVGTIcNPJx7MKnXG4iOVt6tP7MBVf
         iUtPEO+Ux7Glkjd0W55ADaU6W//jYHJBZ/ICaTOS9FKrIBTcrMxnfscdujgxHm8GMLYK
         C2gA==
X-Forwarded-Encrypted: i=1; AJvYcCUWGuRrrx18Mc2wgi13OhHPc+g9nUjgo7krbsZT66lMTIbo4WD1JTVdq868THXvAeDqYrkwIPspdmJADLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAYL1SPWslBTy/61CBs51561692bcXcxGRTZNBkOgnlx5sI2Kd
	SF+uEFBUA4bEnP+nc9aCFS2tOVSls136OW2WiWsM/ybs7TqSh9V62obUa16UQaYL06nrgIRWtlc
	1fOpKVrRjfQhfjjIjByPueF6h0fY7YXe8GSxE6oXFpKxHS+qT+V9Q07RSFGT+XdFPPWQ=
X-Gm-Gg: ATEYQzzpf+OWk9bVkx2XOZ3pDFP77h7AJBBAYsES8eq+mtuhdwdxrye8/MhePmpdWOk
	XCQlk7Fv6SgsDq5GLmyEDYZyt5uP2r/C5KrJ993/r4dp+49UsZPtoxKzUUlt9EdS9SrERMZqNkz
	68j4WeGXOOQydQqvMczUUZXQmXeV+6/b0Zg8YOdC66Hi/ubFy6+ij0PX2qted1LTeKa3W+H8Ht8
	/ty121k2B0tSgZ08ZQ8THb19o+ANjoD6ESjbQMMfzxMmaupKOVBsjGX+Tk5bxUqPqpebAHHQ3Op
	dvGUiv4SfOFC6IyUhE0iyYIS8UdHOTYwPzbsgJcqPs5I6doUMez7byJe7pBgGwso/CIkbLalO3b
	55FFAyZL9uMJKdquReNDnlYTJx/YL8TPCnWzcbe5ePAUFjCo=
X-Received: by 2002:a17:90b:5292:b0:34c:fe57:2793 with SMTP id 98e67ed59e1d1-35a21fdd40cmr13749994a91.20.1773739350509;
        Tue, 17 Mar 2026 02:22:30 -0700 (PDT)
X-Received: by 2002:a17:90b:5292:b0:34c:fe57:2793 with SMTP id 98e67ed59e1d1-35a21fdd40cmr13749969a91.20.1773739350086;
        Tue, 17 Mar 2026 02:22:30 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:22:29 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:48 +0530
Subject: [PATCH v3 09/12] arm64: dts: qcom: sm8550: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-9-53371dbabd6a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=1391;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=jNnS6vGH+4xi0XIVQONh6OWH1bIBeXmAWadZ36T98CA=;
 b=vbNo5npV05uEkkrqWTggqoxF8bz7B5m5CsrowYg9qOdDLAE560Z/12CZZAz8+WrSotUThYCbR
 9yQrRYwteMuB+oVbxVzk0Z9CRwWO3hSPjP/Ux83tT3zpUYU3A77bDyE
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: UHhJafmANqNqaMumJ0VHSgZSX-sYh_MA
X-Proofpoint-ORIG-GUID: UHhJafmANqNqaMumJ0VHSgZSX-sYh_MA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfX6hzR1esGCa2w
 UnsQ57Ug5gPV730tTxIaU3qybmeZE1XijKF91ot3ZnWfvnTGoNyBDpOx1fA4K3I4iE5bT/+Cd4H
 km2aLs77d5p+cJGWY52dPy3wjBvmBrnPeQyhcNSOUurgQG3fKtGn697pD+Nl1zlc4rqknpgtRO3
 HFgTQ0H6AUOOh4XYzXd6691Jp/X/iLS5VZ3Uane/lydPUSnIjbOLf9NxyoaX1GW2l/IOztSLp5m
 F2QQxx/SegJ6atmCWPXs1JdtWa8v28id9XHuGqutTciYf2sTf/1s+y2tjTVa4iXejo2RiNe3Htj
 2LPdLSNyN/DZJsZ+/qETFF70yPheJjeHrcFJN23mpXdMNXarBviDfL24AT9JSHaYSyAuT6clyxi
 0/8U1lLLAK+cR468nbqnbHEihFQufLOrFG1y/mSvgzL6Ch/surjtXiONQgsyBXpUYLY9bPhYchI
 Ll0SH2Pxt6Dc1lClVfA==
X-Authority-Analysis: v=2.4 cv=ZpLg6t7G c=1 sm=1 tr=0 ts=69b91d57 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170082

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8550.

Fixes: b8630c48b43fc ("arm64: dts: qcom: sm8550: Add the Inline Crypto Engine node")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index e3f93f4f412d..473fb4748036 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2449,7 +2449,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

