Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03623348469
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340881; cv=none; b=Rj/Bjbzdp4+S3/l8ZHOpK7amXQu8L3gxRk5rkeQS3Jrb3VUqD0v8xWTZfYF8xqWBf1JAb7/mOHeFiZxhvxLz+TNmr/n6zyKngk56NqtVlMZ+Jdp14R0CbLa4HyLCxmKiQZpaiYk6dDBIiyWzoIQ8ObK3jhyqAR3bbEfCXAY4qFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340881; c=relaxed/simple;
	bh=3P0k4RjA6CyjjnHR/MCVhLicQAWATF/QQmixOrepKjU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NQBY+otjc22NuobAx9NOC9/44FpC+cmCi+hpfWf2QT/OojH37+OQEmfR7Y7KUUxMBOGRqB3V6bXxAo8KLE8HB6pOjsL6By0QjfcvRjJoLA+MrPt/w9Be4ywazuOCh6S6iEK+30b4ryiosjpHT8Ae6XpZZVYuru+DoPmy5SzQNnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JlDcGTf2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fr5fYrVz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JlDcGTf2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fr5fYrVz"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G8Z9Cb1702363
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EybqkRSmlEJflSP37PUiHtMv/rrppQ6/7WrpcwwSTDw=; b=JlDcGTf2fE5O51JD
	qxBtg8HVrvyozYJJg665xKyxft5ZEeSw6mqnagqObWp207f6VXn+cRPCtAJUYWwP
	uCkk79qKe79qo+PWFUg6C6tId2Ujr7fJ4hnlf8dgLL6/uyncpxcX7VzYnRm5Hj+f
	6F4xF2mw01tFeQK0PatOW1x0X9dXWa7AEtrKj2Q4x/LpjS5le4cN71o4FEANl81Z
	Pm3lyWU1EGOn8p8TgJlpaToX5hOlrkc+M4dtbtDyVRnzQdxGI2tvj5RtoJfq0Eo0
	vWEoYFwT4DvV55pbZpfs3bcdAoqqC54BK4XRNuG/3dtMYmeCg1fy7N4bIs08M6m5
	lv24pA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djdamkpet-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:01:18 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82f6e6a3a76so1822087b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340878; x=1776945678; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EybqkRSmlEJflSP37PUiHtMv/rrppQ6/7WrpcwwSTDw=;
        b=fr5fYrVz3/QQRfoyeJ/5VVhqxgR7gPlnITGfqRbuH9g3C43UlFxyY9PnZiE7lfQqTT
         xp1fZJksbmlduXEnLCa6I7Upun/YOoD0Dq8QRxFct42rDhiYDt7W+wnvwFF+qfsP+zQP
         M09UncUpCPVs6mTZYQ5qBvinQ/fpAu8RzhbP2gd8lW+M9/eZrXNmpOO6Ss/thrQEDN7c
         Hsr2fT7RVzyNIhpSTbXZj8ZEexo+ijdMi7Jvl4l8ca0gquMfSgHkYsqxK2xB6Awx5+wM
         Y++fIly5uA25Yah1Qbt3vLR+sEdTulVtwkO+T3yEu98Hk6fKQc6oI3eAhYqbzmOg+8/8
         WVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340878; x=1776945678;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EybqkRSmlEJflSP37PUiHtMv/rrppQ6/7WrpcwwSTDw=;
        b=ceCx8mh9Zj9MsJSHB89z0QTPUG/dv9LA8XcT075WcVvRPXk7XLVyzHBA5ZAnAUqU5c
         /gAPWwm0OGtJom5P1411cBXUYznJZ5+g9wjUGO1sJBC09KNXosFh2YUEaEhZsRw52JCi
         9zQh/WvP5FqWRP8oyQGFvFgl3Uhdqs0RUvyuOpMk+/R4TxwMXeo1QzLyi4bmTB8xwqsW
         RBjGZZK8sNnqZwIQtEuxPTY/r1h+g1ug5z2xGk6B1we6fuqWrA/0gtrW6LtrLvO0OuNn
         HPQlLdmzfvTb8O0khAch1pUtYKb0VCLylawUEd+6n5c4M7lIq2O9kuu4DdCfa+Xo4Gz0
         BdgA==
X-Forwarded-Encrypted: i=1; AFNElJ//X1Z4DMBcoaChcwWyDmKBxZwstwvpq5IW2sOOcNrU3W4olTHjF4cpfID/W5KmTtzVPwRUuooALCEfeDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdoUNjEvgaE12xkx6NxHUxDr0QG2r//lrhmAegkZBkbl+ez1XU
	P4NjbzjRmNEbM+cnQ7R/6LslW4SZHWnZNE5n+6daYmXF5beh3iiYiUQrJ0MgnMGjjhIwyGXoJSo
	e2E2hzZJf7uf2jTAqM21AAFNrfUbVvgzwfoUQD+zFWD8WCnaBIfE4VdBaISzqkDcqUFk=
X-Gm-Gg: AeBDieuwDGjRuowjE/o6egKHvEwb5WNvMuDELE1vhJ7YPtb3OOiedUO2mf7+epJzCXz
	pEIi73JmDHkLbTQn4bXnTPo+WxXtDeO/CtokcqaI8U42hpnHXEigvOCyNoMPIcOYc19+CvQdM/e
	f6DZUET2uu0uSgcrH534WeyofAdTapU5pQLPSkWAk0wjcpXcug/zyWanLsYDrd7AiLpO9F/K0WV
	anc6I9LBbyhCNa7feVmIAeAYQEfkOl0ygTCDPPGHgzdU3wshNtvgaanPdKuQ2erkjTTBOjWZyEN
	zK9ldRlh+eZBqnxcxrNB1z16w7nxcJDah3CPbGjbqWkB49zfOWu2mSzEySsU+7g2xFEVbJTGbAc
	FAW0pP8ubxgunbrj6HbQUStz5BcNe68vhUL78yz4F83s/2Fo9LXys2DlRGw==
X-Received: by 2002:a05:6a00:400b:b0:82c:6b46:271d with SMTP id d2e1a72fcca58-82f0c2efb17mr27205213b3a.48.1776340877904;
        Thu, 16 Apr 2026 05:01:17 -0700 (PDT)
X-Received: by 2002:a05:6a00:400b:b0:82c:6b46:271d with SMTP id d2e1a72fcca58-82f0c2efb17mr27205097b3a.48.1776340877213;
        Thu, 16 Apr 2026 05:01:17 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:01:16 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:27 +0530
Subject: [PATCH v5 10/13] arm64: dts: qcom: sm8650: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-10-5ccf5d7e2846@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
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
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1526;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=3P0k4RjA6CyjjnHR/MCVhLicQAWATF/QQmixOrepKjU=;
 b=uP7x1mpLofRuFo+hN3TkTZ1T46+1bNT1dk/vSUMEfHo2B/SC0FBABO6HW3F3yKHV2Rw20ekUZ
 /xJeY2mOFpeBCQfyD4JQKJcYQxwAAiRJnRRuN41pzfgqKfHBY36d+F8
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: VKhuPtQO5cj4LLee7ZqKGSP4xw7SpXLM
X-Authority-Analysis: v=2.4 cv=HMjz0Itv c=1 sm=1 tr=0 ts=69e0cf8f cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: VKhuPtQO5cj4LLee7ZqKGSP4xw7SpXLM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX5xLu13USnQD7
 kMGetFfepfmGzxxKwUX2UmUy3H/YamXbkuouBIRHFg1q4sKO5C2xTi3C29rumJ7CYKHccuk5xAu
 CyT+0+EmEn1EuUILq/zvWb/o0XpJNqkiwt1uF9odTAmIleNWUwrY0gUn23dsl0g2pwUCixjifEZ
 O3wVrymZe0IJAWlvEeFijBFj0LsygqPVJRjNZJDm475xEDfqTo4gIaLMSULCdhKn/1qwA8GWH1Z
 rSJcuow72r2X8woJ9JVL5EXYKgAF9ePRCoNJIzvCmEhxbMNo5CeMix6MvrWaewsUmnzAjdETtb1
 BxKdsKO42PgYqYXj4xLE5smGMIyEtdRH9tyinSzpxa3LXQrZRMiFw7wdPlcZeLm7zw5Z1KTjJk2
 XdNTNq1Az5bnXioy4+twpT3Pg4xoV81xjz+eQFo2iJDgFbrt6J+fUEa7Zb0gGy/ZVw6m5n7UFvV
 P3AqL3YjQToD+1TrVgA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.

Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 1604bc8cff37..e2d98cf6adca 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4081,7 +4081,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

