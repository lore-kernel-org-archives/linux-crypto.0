Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523186;
	b=Z9ygQc3hYdJ8G45ViId6FsVmVrdeoWRFL7FUW7SedC7qLWRgHF1LDoMJeWzd4sPymVoy
	 Hjuq4otimSS4iodPqZ2TWIAuY2fB0ROAfZrs6qgGo3YJK6DxWdq4xom6D9piTgJsbgwDT
	 h+w3CU24H5Zexn26GIoOjSiT09QmB5A+A1zDRcupDVCkWyuIFk4ZAol27+1voknEeHWzR
	 zdlg9KG39uqXBYckEVqLH43bkU3+0r3/9o3r1LHZ4LYih7jcTSVkHFEwyqQPDBXhvzNHz
	 SthsSw7BgAziNmWNFd6x42UQhg5mx25iKObLu+4LafEQRZv9Q+Z1tLeyJm8NuvawTAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523186;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=;
	b=vSSItWvHrFzUfQP+33qyl5YP1gD2A4bjtA3iDtqV8RiX26AjCAfujyJg+Ecbky7V/2c0
	 QwbpaR7ACWlkomrrrNnSjWC2/QBQZ0MEIJybZ7hEq9EotmE7fiJAlqR+nSfcsHLCbZ8vY
	 bt00aBeRqZgxuUZvmlPw/S94bNs7VuZN9r25mAW2npzZbE6Sc0qYNtw6mAlNrkzjWfaU0
	 q1tJAYdeKejwj7uqF5zMjPQ5LZHwIygyu+ccqNj1yWjCoZiRsW9LfjPscGfCeljHO/AzJ
	 U5WXxgcv8HF2bl92ko2S3zBwlH/blZd+7gp23KstDcLSYU2nBwiiReGKVnTIJgZKgbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q3xZNhkB;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dwzFUtuJ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EB1606A89F
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1EB1606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q3xZNhkB;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dwzFUtuJ
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZktA3120880
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=; b=Q3xZNhkBWFe1lWE4
	AeuH8BITv502qgQA/TRAo211X9vwsHk+KQQlAR14tBWzdyvAQPKufqKCH90hoe/S
	b/wTZ01ZFma0DSVxlG7EFUhW2NCf6x2I+IL8c1N4leJhK9YWc6opA2O53L/+nDtD
	zX5XHeB1lhiF7COt3FtfX4JJZO1EudxCiIQDj0aBz/TcJUxmqXkPS/G3Aavvy5vO
	/u552aoPrquOBEAIYJ6a4rKMDpvq67mYgVxTPuJOOkj5mn5+VK23ULSU6njl/ZZH
	0GSuQj6pjXgjDBjMWdXnHo2rrkA56S2hkvCjhCANCACcX4l3Gl7mIpCLT2PofdFu
	C0m9tQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwbx32gyc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:45 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b3b45597c7so533304c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523185; x=1795127985; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=;
        b=dwzFUtuJ7ekdHlCB0W6m4FY+Tv/N3J/oXG1qgwuVTWz72d7htWNEnPF/UU0HqI/KNt
         enO0kjufy1EFhnVarx1pOl46rHvcJJkiMlLyAWF33O2oEWoHZddiXIcfIO0fizVBzPkZ
         HOAHB076y8it1Td+OsGscVrarLk4l8yyMMDPuLgR3SE3u+ov0qmvLElgrixDBjQMZjiU
         EE05vYEVeFFB89vEuRxcZo3Yh9Xo9QgC8eeLEb8NS+UPOW5fmosNOsWhEsNmuE/+/rJE
         G+jVJ2lvqkTq70CkpdJazFS6X7PpmViHMDj0wkSKV/kBr/tQNPDeS2C6SdlN8sW/Df+n
         uydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523185; x=1795127985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2FQwINb04s7mJ3OBtOg2oqHSpYWCSQGkL/MPOtCiMo=;
        b=Edp+MVy1oJQQF4+QDM3rZJ4TmV8KGnNMWiHaPFBqd/bx7GLMBCj7uKHAzOjB/YLW4x
         /McosiGrOpYc7BAxpcHnnjbE4d9vJZbPxdjKyzug2OBXraZmHWpdt7dOyx2Aofk196rR
         oLMEitbX//z6iA83Zqv8pZQVERL2V2SZNHr8RprbCuaUgx+uhcdviM7HfvXSH/616tNK
         PPdtdPRq7AWgUPEqX6CFrfwIW/49/oWBN/wVvlGQLtCN5ia6In+In440kDS5EQAr7KX1
         BenaOaW5kUKrsg4c/Zt4zrXnYKTIyAqymFYsVLMXVIPsISZwO6OuYhCpwYUFCwSA0XN3
         c4TQ==
X-Forwarded-Encrypted: i=1; AL+hErHrzfxr7v2pRhAZbWeOwCUMlzj2Hz4JJeqvZoZiBj63+rULqfdV4RTKa3Vdkdt8Y4BFT8fCfNzhYkd1L6g=@vger.kernel.org
X-Gm-Message-State: APuU4Z9qPL9Tdsh5df2v+yq3P10GOATbLgM8JdFkGF9Eo8resPEKuOj7
	LLq06Tk38I2du4aSADrZ5eVJfpcgaj34ZCU2knrRz8y4Zd7KPWQvT0gDUNlGNVUD060DXbDrYYO
	vgrlMgtjZjZv14sXUe0KFDCmSUS4U/zkJmMfdVg2U5Wr8bEgQw+38w2dMkSSgeuKs7EU=
X-Gm-Gg: AYBFou2+bm1P4R/AVOhb0ROgE4SloOigN0807lY52QuW3R7Wnqnr12EaruSZfxQ8LUf
	FSNQHAI6/J2QVp2Ii5wf1hneqXxWz/DKKE1wpFqOdpYkc/boidt2MUWeD4ZeHkJ9kHkMidzDoMz
	LCyCvTD+3Rj/1wfdsOj1+zPyR0k6Oonh7h3Bs+FvYgkbVkEm3K4yQ2Vi6vDBF4MEEhdQjEMCix2
	vA2dzYe+Z08MOy6UJUGyoUjG+JmSE5pgAwq58l1sDNqVZo9w8oqLWSrjyqm0Kf9zSgVy6/hgrLK
	4OaYH8GF/QYcF+O4b0qsoNyUfWI+CvMcK4ja7MwzUnsmabkJItDqVdCiVljcR2ZN7tfW1/cLOUQ
	PqqvIj4yWiJhsX1XxjKW5fjaq5mnvHiLAeGLJ+Lp8ClQ3x6k5pCTO6rwzYgjAdV5IJSo+9SP3Rk
	tTlVvd5vmbUQ==
X-Received: by 2002:a05:7022:f503:b0:166:b307:5855 with SMTP id a92af1059eb24-1b502fe3953mr895753c88.0.1794523184475;
        Thu, 12 Nov 2026 14:39:44 -0800 (PST)
X-Received: by 2002:a05:7022:f503:b0:166:b307:5855 with SMTP id a92af1059eb24-1b502fe3953mr895736c88.0.1794523183996;
        Thu, 12 Nov 2026 14:39:43 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:43 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:31 +0530
Subject: [PATCH v13 5/6] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE SDHC nodes
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-enable-ice-clock-scaling-v13-5-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=S+5MU4sP c=1 sm=1 tr=0 ts=6af64031 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IFdraIdqUsMg42QbtkkA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX4Z5xCex3krJ2
 CBzQaE2nG8EF00IH0UpKxDtpNoS4rDbd++2E629DB/xnrKLQnubHrsV0CnbG6FIpLC3wxDgp38o
 EiFfCwQKKZsUSOsTA8tgTDnbhWH/9UsJ1+1VFG+V36V6c3KGiOJVuJ4X9moATF7anSsv+ZIVDQZ
 naJLbEXbdne4+dYEhUbc43+j1hOREbKjs1CJgR9FcSHzscmzQXiaNAPTeXPDuRC9ucNtnyZflGP
 +4TpWC5J6I2KrvsglKagQLvPU7c/fAPX6urpQkPfwfIYfUQsrLeo3LtL2wnrqFJ30shxGqrytps
 TBW50rLwANQDOJdF3Tg8j6ZJHhHIjli9p/ReGcHyp2CYKSXgtDE4m6k17m/HEt95jyk2aYxoEzb
 qX402ufQOKbQYqsEC7RmCCsP6pR6JFQ4UwNZKUrMKAJ1Y2MBEY2Z5/RCH83xP/SG6J1n2c7vd94
 w8+hVhnL8+8+ymTVyQA==
X-Proofpoint-ORIG-GUID: Qu-jYH4BsyRLWdw9IwJoJPqOOwOaXsYP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX1I5N4YLQSgcv
 Kpi7+y19Vs8WkB+29UO49hTJkI18g1HgaFPyc6PEWxrV6Pu6KbgiEPXolcwZb1F/v6YjfR6ARIz
 nnFq+9NuZtVb8FE8jlr1+s8rMn94fjo=
X-Proofpoint-GUID: Qu-jYH4BsyRLWdw9IwJoJPqOOwOaXsYP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE SDHC device nodes for Monaco
platform.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 3541313a79bf47fe27499f6dc370cb778d780a08..d7e2038854b0bdcc91d65d5712290c690e772258 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2725,6 +2725,27 @@ ice: crypto@1d88000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
+			operating-points-v2 = <&ice_opp_table>;
+
+			ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-201600000 {
+					opp-hz = /bits/ 64 <201600000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-403200000 {
+					opp-hz = /bits/ 64 <403200000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		crypto: crypto@1dfa000 {
@@ -4890,6 +4911,22 @@ sdhc_ice: crypto@87c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd RPMHPD_CX>;
+
+			operating-points-v2 = <&sdhc_ice_opp_table>;
+
+			sdhc_ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		usb_1_hsphy: phy@8904000 {

-- 
2.34.1

