Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1B6375F62
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739319; cv=none; b=TpsQuew4qwg8HQT4UdX6dPLNAr4UD4mkN6BUEWwV33B4wg2/8WdDejVWHC6LaWN29I6yABvkWPVdfIlmbNJgspqVYWLEunZKcCYcMXZVnfV3ceojtJ+vv+HpjcNbw9UBFcBeeO+eCF0HQ+y43YaY5jRIatr62uldEvyGQZxmgwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739319; c=relaxed/simple;
	bh=8uK0totW+fO1QJ0dJXJXu3+dAqyfgP6uqq9AtSWKjgs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p3sZze35Ey3I0HpOGaSNncoSbBiU/Img1wGhhML0GptzRrDrsTppDYfqzj+Aljg6aLaFHhURb6k3fB0URxm6g6iNcuBS/9c68RakoU8peXUMvRblkPuZZlDX4ELwelmdxrEF38lYUAKolM63Fr0hKdS6+Vo8LvSbq8xf9FwJDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TwuGoUqG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lc1tyqWt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TwuGoUqG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lc1tyqWt"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H7LF2U2375064
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HKkeB02/3Y+p8cra5GYHxicECKL4T4itHN6GbMdtRQ4=; b=TwuGoUqGQjR0qjhw
	FJ1CcFKaLKP2rAoe5JYhwdvs6xFT5LYKcBzx+fslhxkTn0Il4cOF6z4ToBiQiC6U
	2MeScNE+t7Z+7K2MTmwQdZhkKlhUCgwd8qGjHvWLy9+ss5Pe2IeCdIjwvp749h88
	xIdY4eg7MXNaaT7TGVFvFQt9p0FVeBv9n56sa95Qvr7RmLhUXFnUKKQifFBpkq4q
	YeKcTHN12d56l/zbZR+6UBV8X4c26H5xHV+YJoBj3WlQRAmGFou0MlCouIfs8DkI
	fAlkQ+cxUZvlFR3WSbE7aF/eRUrMuGofEoE+2tM235oTS9lSPb/12qZzpH9wi2Qu
	Wx6ZaA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxkby3jh0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 09:21:57 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-358f058973fso7171451a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 02:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773739317; x=1774344117; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HKkeB02/3Y+p8cra5GYHxicECKL4T4itHN6GbMdtRQ4=;
        b=Lc1tyqWt91QIbAOlS79TtXEHtsgHMhlT/Af1SOROIV9r1ehn1Pom+Rzi+4ls9okBk6
         e34+TNZpB2bWVAXKsml2w5U3ptZs3i7y2EJgJjiBKQxlA5PvLdNZeDMQR5ZeX9uT6InK
         h0WpMYgrI1ClNVPfd+sOEgEdQfozRBYfIPFMWZGVlKeq0YAWneocIPXbnz+pJYWQSUhK
         ovXV5X0IgpihAVIxsVubJptJ17PNTHTNzCkKTXKWdQEyr250ZwVOp7+t8rPEOpOV2Ekf
         dmXdFms0YDjDmLQb4XKwjHMYI27jczH6VsJ16n5CORDHHxqZLZdZDEL1ekFUO0ifJ1P3
         KoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773739317; x=1774344117;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HKkeB02/3Y+p8cra5GYHxicECKL4T4itHN6GbMdtRQ4=;
        b=ZIouEoTCv+SlIkbUlmWKTI+0dB4EAzCKUuQELSClP/JmmMU3eeqhFFUVN75hW27l4z
         kEnb8wdC0UiwHqF21QPKlwabPczeC0uJ1xdOHaxXAiqj75PPgHDtW9rH/f0+2/Mi4JZr
         Y44NPZw4Yk6iRfAyQ72jrlIrOuoSRkjRVTd0dWFv2SMzZAvP6SFbk7nrunTJ/L2LI6bz
         cNBlvBjc8CMitKfTX+Q26Dh8sxbTsy2xo65X6Vl99LZZE2eKaXt5cdAGsqitgwi+Fx91
         pLgTjFE9ZxRjeGl7R+ywpcOU65TbrLdMP+uQRqidMsVdLHO4/ZeTsazq3TmnNNOGnXck
         N0Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUahs82E9HX57hBMOd8pup9/KObKFg4yC2hJc8ZZG/zrYwALpOHkEyQQh4yMsiFbh8kb4bwjorpb6aBA8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdbrex9QVX9lYAB/tjKplDuWdRFdgCbExtE2hqdC+gjjAnh/Ga
	BvoIqdDF8j6426MzqECPYv6ljW2Zc34uTgjYurzK9Wc90UTZti+UgrKyvkrungzIIZH9Zpel7fs
	2LbDuTTpyU2uBqwJ1Ri2i7/n0ri75+kt9yRJlhRb6RuJqm+f0trVhcDcKblI7nUqjwf0=
X-Gm-Gg: ATEYQzzePWd4EFQPhNyOYQDIaDr0/L135WLFIM/d/TaO6WaTjSNld+KNM7Kb/aHni/5
	3q2LYIBAU6Cz/VnDJWE/fc1Ajqje9jVT1oVBhLCsSwSX9LqBTKkkD531CYKHTvP7vFiCVJ7lsr1
	XNdyqpe9oR5VYSXqmOtU5Z/PTN6fpbB40aZYUsI3c04OvRSUj2jsxsM9YOQeY7UIjN2x8jd4fOJ
	FAzrK3AbNHgJk2Ah11V0GtR0x4NxydRsvVGHWhm1xsjQk8/FFOLbHYcRWUdURadh5znGuVPloAB
	7WH38o7JW81t0UglWn2aJmJTIoejLyz7loE7Ja3bftOBCZmIo8TiurKM3NJoTxvnu2p0F4wkQmh
	HeqV3iNQQ/KBVZC98/8R4SrIgE0ZsxBcsbuUrWRPzqwowztg=
X-Received: by 2002:a17:90b:3fcb:b0:35b:982a:28d9 with SMTP id 98e67ed59e1d1-35b982a2addmr7808757a91.4.1773739316899;
        Tue, 17 Mar 2026 02:21:56 -0700 (PDT)
X-Received: by 2002:a17:90b:3fcb:b0:35b:982a:28d9 with SMTP id 98e67ed59e1d1-35b982a2addmr7808720a91.4.1773739316397;
        Tue, 17 Mar 2026 02:21:56 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35badbcdaa6sm2331968a91.15.2026.03.17.02.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 02:21:55 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 14:50:44 +0530
Subject: [PATCH v3 05/12] arm64: dts: qcom: monaco: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom_ice_power_and_clk_vote-v3-5-53371dbabd6a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773739265; l=1455;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=8uK0totW+fO1QJ0dJXJXu3+dAqyfgP6uqq9AtSWKjgs=;
 b=ZaRitGJW72HEgnAkut96vqOlwGqBggoYgPpFP6b9sVn60d+sYtiUj5qMS6kNCdSVyFO4WNn5A
 dFs5Fk4bpbSAE0+mM46TLdTK0YP+QwAbz2oIhXPLgJnnpnxXZbKS7H2
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: h20Hutgp8O49usR4RHF1pHaPHfHRbgrv
X-Proofpoint-ORIG-GUID: h20Hutgp8O49usR4RHF1pHaPHfHRbgrv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MiBTYWx0ZWRfXwolsmsvSy2FZ
 7z65OffOIV5YPJNeA1bSv8AA/qola4FFA0cEktqugVMQLnqQEu0nQHHFeBg5tn0f1ol7X8f+6z9
 xugqYxNa9wubFp+UZwqvfVVGQPC3nv8hxbgPXwONc89KMKp5sRZaybSCdAOREm3xeOnBo7yOdyz
 gF2FINwcEup9NbbVz3Ku1kKMZ1TV8wYyyVyULZWmD14Zo16R3++0kOUIMUGLAZ4gCcSu6ruCwLf
 TdjDKBbGv2Febes9f83RszDkxZGP2yyRqNGsa4vJSrEO8THU3nCYm5XBEnvA7OaqjXnuGjRjoME
 g+lTDH3dws3K7QxA08Z1+TmFM7jvnaPoadhMqWHHq7uZpOTzlV4GEm3P9K0BZanXdPy876aXWyX
 /EkXhDnZFGCNVon6JufhhPxdpJ1YkO2XxinGzQiswypSivdeomQww2pksk4ocWAjSE6eEoBXzoq
 BCgkwrejw2rgah1WxUQ==
X-Authority-Analysis: v=2.4 cv=ZpLg6t7G c=1 sm=1 tr=0 ts=69b91d35 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
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
done if the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for
monaco.

Fixes: cc9d29aad876d ("arm64: dts: qcom: qcs8300: enable the inline crypto engine")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index f92fdb1cefa0..e408f102a8b3 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2725,7 +2725,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,qcs8300-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		crypto: crypto@1dfa000 {

-- 
2.34.1

