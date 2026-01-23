Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F32367F57
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152417; cv=none; b=pgwd3PWwWhm2zrpTs8BJr0aiNBMwBLgIGO6bmBK5gpmPUPMhTpwj7gnITl7QmiS5ZliR1/I2CRO0YM+zDOwYD+TXnKFSSTJjje6TTMQVi1IyBlWjpa3SrGJkRH2mSNNiyEh0zoquU6H6v93PUU5XSRlOUm47aAAGGCt2pU7GHpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152417; c=relaxed/simple;
	bh=8WPoiz6WeS7Iq/0SPTznPnFxvdhJ8gZ92GNK+mUE5jA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZZbrGK2yZdYETLtuFN1R72OLBgZTTInqCZpUk3sCkZ7lI/HQ8o9CEG5HA0yi1qyBhGZqXhLY+SxbXQ9wFnmKC0aIA/PHfo0r1duINxUwkggvt+b5V6lgTQGOK/ypvDlRgPOzL5bLcUXeS/fdlZt/XdU815Sb+efvWpl0dgkwiMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gpIvgKb1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CsBRSL1l; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gpIvgKb1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CsBRSL1l"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N4S5Bn3812527
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+xifkoJxQcri5ptYGaeWZE8T0abAKKbAYRbss+Z8+Xw=; b=gpIvgKb1IlpgNzNp
	AAMiELRKBat6Kmm9O4+9zmqjQZMDWwCPIENA2SeRc/x/tmxTDNU1z08qghcZaJu8
	evprRDCS6EeyzcS0MFbXn5gT8vAzpgvrVnqqyjNoOSna7hQlFGtGITHSU9r60yVE
	RuPRKBzM8JrmDYQlAdJX1VSBQw+GQmOiXewzFecG90vEmUmQZWHkGqp+7kgOmhHt
	cgk6q1r2LrJ/YiAv/ZAI/GN5S8dCimYJzp15IU2ijVMFAJ7IA5VqzvgPLge8cOqI
	aqwi38DTHcwfMzLx/NkgOQMmq897GvFy7Z+CBcFvbX/Z5MgN8CkZIx+oOYG6DO8R
	JL3Q2g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bujq1bu26-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:19 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a7a98ba326so19983525ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152399; x=1769757199; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+xifkoJxQcri5ptYGaeWZE8T0abAKKbAYRbss+Z8+Xw=;
        b=CsBRSL1ljdPHo6i2JJZVlWeXeBDB+r5CNiJY7JoV5aWKN+vTaCg+eg5OgJEKG3kXqH
         ++LbLnwbUTRrEYapFWJuCiDJSEPeU3lAy/RsNej4Q/hlaflTEPOMsZCR76JphhXZm/oo
         TITavQXxaIR6Kp5um8nTDDjCJWxJgoshp0m1QGCM5ChSqXf3/ElTdiGfHAHTMRYwl6RT
         nSi+qMh8FJyl2UY3MjsmLHbSUQLoU8YVaH9Ed7gSq5HZ65axkBtDgrfn4cPKWX4xXrQj
         vBpuGS5+jNg2QKmtZAgoGwVQqp4xSW3YRLt2y5RkzVwe34q0Jisl4jR02wauZYhK0a1O
         WTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152399; x=1769757199;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+xifkoJxQcri5ptYGaeWZE8T0abAKKbAYRbss+Z8+Xw=;
        b=DrjeUzer320azjxm4FDsjhBoircwUGDSxFUTKdrGR+if7mtey5HBCn28aIv3CyuAwX
         aQ5WNYYynOk/AA9J8XFuymUuGZRr58ApCmcYn78KFvIOo1PPqBGP1MYUBvoWzLnMwX17
         +CFHtiJgYCfAdO8yhCbPWfLPm0QlX/44JAomHH+5ql1+HULIayX6dDTknGOhIJuNtDqU
         PyThZEKp2kqdBoRJ0z5JcotndCQIpeO4O8W6x4qCowG8tATGiPJDOYepjfAGxlbN/W0R
         mbaRzrIXNb5PTfx/pOhyRDhKS9CZ7QA4vxVwTFxr4ZvsYLuRajanjaABZDzMM/CALk26
         644Q==
X-Forwarded-Encrypted: i=1; AJvYcCXTQlYmXYD1FztmjCfu7O5j2654+fonEFvXKSDgvFPEXAClvxD8fwobEQ2Uepq8ei1z0Gxfmpxc95XX7lo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAJ7caT0xn/af8kRiCdDpy0k2qcuQWWvEtjFG3qhqYiX4Yp7Q/
	pvm15QEt0px+gr1GG8jrQsqzTiselt/SIQ101+54Znb88Tqt2dtX4Xw9ifxqtCp8OEdqOhYjff5
	6lI6cNNV7GSWUmPn9bn7dwPPjXGts9hvkaM1wKV1nkDaYYxdBbhYkhBuzsvFGglx0z7uxSOV7w/
	c=
X-Gm-Gg: AZuq6aKlOqjYjrEyokf7xfwwo6oPPHvUqsXA1eQKk2p3zFmVZ+QCzXD+UYhRj+REZwg
	k7Mo/g+pZUQL4qVLwETzzGDwUrphelCkxoRCpkX0ywoOAYHR96nBY9OjauggZoMPGJ2YpfJclPe
	u22V8qzse69M7gfa6HRkA+ZHxd015hX860BHF20LeWpNeuZgQpRrN13v7AUa2u0K9YaoOe2zWtW
	EoU0T+biDVwI/X8SdMPz5HSaXAJzFrevn952Ig+Lxe7io/Y6plbuP9SwBIceFLaaW+gQpN1W9QY
	D58gI7ni4R1svToaz6ZWncjBLNHijLiiom7hmMunpKHA7E4LARgnoYu/tD394DxQTbUIGzLc6sZ
	YKBzcjDFqddCU8enpFQiPcP2LrSfCj2PSqt8=
X-Received: by 2002:a17:902:d585:b0:2a7:9e34:f463 with SMTP id d9443c01a7336-2a7d2f180d9mr57846925ad.11.1769152398715;
        Thu, 22 Jan 2026 23:13:18 -0800 (PST)
X-Received: by 2002:a17:902:d585:b0:2a7:9e34:f463 with SMTP id d9443c01a7336-2a7d2f180d9mr57846745ad.11.1769152398234;
        Thu, 22 Jan 2026 23:13:18 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:17 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:32 +0530
Subject: [PATCH 08/11] arm64: dts: qcom: sm8550: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-8-e9059776f85c@qti.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1165;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=8WPoiz6WeS7Iq/0SPTznPnFxvdhJ8gZ92GNK+mUE5jA=;
 b=kCxf9LcPx1MyPM979mLfZ/jYDtGX/zqFe46nnMLwEXEsqsKVMzY/owKrkPnsn/Igy4ya/UG1e
 qdimX/quk8qDQu0432Rt6Ew37f6EyJTpous3eggYWaz/cjuh9Yav6YI
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: 3BJxlTJ9gXv9QfqJvSM5Y1N_cHtMe5qq
X-Authority-Analysis: v=2.4 cv=O480fR9W c=1 sm=1 tr=0 ts=69731f8f cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 3BJxlTJ9gXv9QfqJvSM5Y1N_cHtMe5qq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXzgCz54WDSoMG
 UPizDI8nCga7HuaIMYT48O9oTOZRWr9pkl5GYLqqBMpHjB0KO1qUHPCQNFKCD/vDObDoqstQMeX
 amT+aR2fY049nyA8Y1YfWCosZqUtiq+OOKfKi9BOe63oSBaDEMv531A4IbRD8l/63gQO/aXVexf
 voDEy/7hHxP/laldtXjW/DkDiLjiBUb1+FP5Rrln92XHb7V6J7Z3Ks7RlDaHTSRg7/bbe6pSy/J
 GQ7kXvvXgWb4G+TDfi0Bak6MlgDPTI8QGvGTNmnRTvZdmejW1INKF56nScw+7z1/H/2iIKIwMMo
 w08KU6u4hID8CDTiuyHC3u5rke4o/BTw7esx0NjHqrqK182Q4V/zBi6o89Jc9mL1BOVLWIMccai
 3uQda3hJMeoUU3LEZX+BqzZRmlnBYaWcG61nbV9icwzYChOmuW2QP6SoQnJi1DQ/xr6U7BGe1PV
 q4+2KtN+i31ot79q9qQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the UFS_PHY_GDSC power domain is enabled. Specify both the UFS_PHY_GDSC
power domain and 'core' and 'iface' clocks in the ICE node for sm8550.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index e3f93f4f412d..b6c8c76429ba 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2449,7 +2449,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

