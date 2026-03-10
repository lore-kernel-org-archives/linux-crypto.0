Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246793CF69A
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130043; cv=none; b=TW9DAB7+mKszKhe4gsRJ31ULgtNVFk3OH7tap4/8NDcp/Pfp34CTkhCy9/GPbyJoxN5OffPW77mcpkB5PIe79o4o05pT7ROmOa+XVfHxnh1LMapCMRsAaut6HemM6AFGCwPksjabvbDXCuapdqwpNb0vLDJLVERQSgnYHYKp+Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130043; c=relaxed/simple;
	bh=X+9qvaez/wKuQJXXpN5o7PpR/bLl9AJdUe0o1Nd3CW4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CWD9XnbT6d/fmeqjq9ZQYvFfj0znVqh+6LOFyz4uQ0qwSdGYEZBReH7mboZTJFUHPkRxzj4MrU0sJsS+J2XDT+VqFx07Q7O8rRhxF+BHm5WfxOUeFfUQUr2ZszlAk6b6oiYEf7YpX9XLJErO3eaBifuQHmGNe1RSsc9NWgk5VYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YIremGOt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IMP70Kbg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YIremGOt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IMP70Kbg"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EQix2460651
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+wy0NK7XwvpVIYG3doeXTDM2mVaJoSz3R0NLL5vkbXo=; b=YIremGOtkeXvixLu
	ObAPl5LCrsExRFkQBMGUF4jT4Ls7m9p7AY5leX67TZT8q2JKLmJav1YFMFeH9oQd
	NjoryobWuihM1IR1bHGH+DoW16OOSSJsq7LTwdw7OqTHiG3kV69iwBGvG9SZMpQD
	OFXn/CrOgjLBU7G6rrcjOwKELumDD6afDJeqnrLlr0tYetwRwKa36k1uLD47X2au
	zrLbaVlvqIs6LL6kqHRGpUnkVmWjhzDqNU/icaoOgtZ/lMkAWiiFGBMT4ta0odYf
	WfJZlHSDwYgD7MtaWI/l0XzZW2+H0qkLkI7G1Bj1NLHK9QA7hi8VZYifHukLjuuM
	b2lA+w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4csyv1b8b1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:20 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c73935acff2so2420145a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130040; x=1773734840; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+wy0NK7XwvpVIYG3doeXTDM2mVaJoSz3R0NLL5vkbXo=;
        b=IMP70KbgOv5VSMF7IjlsNW6I5mmyX6eAeCpHQ4OwdE55Joc5HSbBg1bGr9EPKggr1+
         iwBus8P+vJeGoH37CJnVPw17WFoeWZQwWjQTj98iCqBTVn00Um6reENe4c0Zw/QOoSyU
         DFIRcY4ja70uRxI55Gcjve9KlZGF6QM25ncu1h+sVJpsNiOCTzQAufzPqNLgyaP8BSdG
         mnEKr19/E9a3Or5m+StyhDisszW2jeBdaLsQr7XQtnm1zzhR39ZcWnI0VYUjPSXKTEHV
         yaMNhGF3gXRPSxYFW5VXxhvI85kjjIpYsU0c8eZROVYTKkdWnjvCmXYgFeyZmIPX1Vwt
         NkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130040; x=1773734840;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+wy0NK7XwvpVIYG3doeXTDM2mVaJoSz3R0NLL5vkbXo=;
        b=LKGVrs8Acpd2vxBDVHwKtNUfgC0PrkmmMapYWHUXQmXgZB8ArTc4hMYdtgFr/QT5OY
         +CrCF098/MFUbnXIFdwVNzntsmKvLXu8SeXjZVqrS5qSds7dKJvFC7dCaC9a6v6UMcRE
         XMQq9kPRPDSh7hB5x/BrTfUlZOC1aNZfy4yCGGJX6QgmZNyOiSGUbrtPSmd39pYUEDzU
         LtwaHlr81UDwKyT/b5RqZ6n7lNxjy5pZG875LpNWwSUXyVVEKppZvJmBBX3R2HuCtxlw
         q+IMHz7lR7rKbh3yL67iWAhPLVgLu1AzhAu5F51sPWMgpwQpE6pIGPnTSAYPj6b3Khgi
         E2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUN3LqKwV0XvzKpCSxtU7NIkH4nE94QTLBNNJCLQGk9Yy11yz23WgZWHNeuCpAhrtL3bE42H78OQe998eM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkIxivmDkdH9vs2hCm8DL9Cns0L3Slf75GgjuvsWw6i6mXNpik
	Fhnw3paieN+cvVhY2JxbLUa7BGj/Aqj5aXuh72rE+8wxajWa9lHK9XYsydHBySd6IsEukkRy/+Q
	G4BNaFvAtSzLS1YkEmWK2jl78XbwSMuqn6XNJyg3PTyLNKP91MfLMt29eGZKb8AnWHuQ=
X-Gm-Gg: ATEYQzyX/bGUqVQ+WxSd8aXFbTitGaKfHWYZ39ZA6Zle2bZdHL9jK5YrWzGlKw3/mIc
	dK99iaiDsUetAP+1Xah4S2RfYijxKaaDPW9oKoc+WccT/1OPFZJC4ybi+7tPGRAtuxNxUzsIyZa
	aNFvdwtJUFI0GApkV7XQNlVydDSXr6/Shc8PxAYmeiJYwHhnL4o5IGXMwfw8K2cQ+zskjAqtiaz
	MkrhmT4mo3VH4CCC3JkEoPvuQapMFdurnOaeZxDnX+6FPfyj6Q8Lbo7xF3t5YK6yU8ZA2RmfWqB
	qgsT09qB1CnnzCfCRxJwAwMPFiRLsAxY+2JBq1IG7xgFtlLg+AvPCIrkZKk4IyhpCPqukt5B86E
	ACtyZlxp92dEDVXbRQP3i6NoTSca6hyMAAnr2qgh9vzcP/z0=
X-Received: by 2002:a05:6a21:35c9:b0:398:6461:6872 with SMTP id adf61e73a8af0-3986461cbbdmr10167489637.61.1773130039744;
        Tue, 10 Mar 2026 01:07:19 -0700 (PDT)
X-Received: by 2002:a05:6a21:35c9:b0:398:6461:6872 with SMTP id adf61e73a8af0-3986461cbbdmr10167425637.61.1773130039270;
        Tue, 10 Mar 2026 01:07:19 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:18 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:30 +0530
Subject: [PATCH v2 04/11] arm64: dts: qcom: monaco: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-4-b9c2a5471d9e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1467;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=X+9qvaez/wKuQJXXpN5o7PpR/bLl9AJdUe0o1Nd3CW4=;
 b=3RZvw+FuTUzKWHTutZFpoLgdeE4niluTBpLlRRbKcE+KRA/LMtUu7QuT5YidI5nNS2nVfsl9p
 ZeQjwoTuBs7AwfO2R4RFaY8HaiBp7XwHQokDP/c3LeFH/rbjGv6L0Xk
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: kkjXBQK-oBybqKN8oRXBNGOzQ3lrYnn-
X-Proofpoint-ORIG-GUID: kkjXBQK-oBybqKN8oRXBNGOzQ3lrYnn-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2NyBTYWx0ZWRfX/2vrYwfeNZjU
 Ef1d6a9jR3MaKbTDfpBSSBEK5o/wqAyZvHWtbEqR7DeRHVF5jA4q3pZlhkL/heOeTZOpCmJmF/J
 I8/mSk+bRdU8wU5rVKSmO12Ut3ekccPDSYOKdhHMa3otkFf4aKYywGOYS/8RSnI2PevmPq3MQdn
 ogPWJKtPP+dPvoAWQWS9M4FcykmpXj16Lvnpta/hE8wLqXg3tKs/Vs+4AhHTUisno2Nr3M22mF5
 zeON6pYWdXRxHSWBI7jpxqbZsFTGAHGM1/UeE0faMQCHT8+W4oJ0F9A6PXQIjGo7eZq8wo/pNTN
 W+zsjzkg9EfN5FCdcMAPnpS3MdQzD7qx7dOzoJsW90FvtBEKGtXUQ6ORmSlU0LBN6MASfegn4PA
 dZLahCmqxVYdfSrm5a/B+ZeDDRjPSA2nc/tBJHVq6fSDu/LSoJjWRFFcLAAXA8bh78APHiA8dTV
 ecLpwjbdf64l2PdRveA==
X-Authority-Analysis: v=2.4 cv=Cuays34D c=1 sm=1 tr=0 ts=69afd138 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100067

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
monaco.

Fixes: cc9d29aad876d ("arm64: dts: qcom: qcs8300: enable the inline crypto engine")
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

