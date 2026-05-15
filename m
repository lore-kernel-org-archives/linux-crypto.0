Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54644D018
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778842001; cv=none; b=l6goE9YpIFASXi8fy/cin3Jq1j85yWto4hdUHy/g0D82Mijd8dWKIjmw+0Z97E6wTQGstZyFxIf9eonVFVkQvgmXlKt0dQHWJxDJ3dCxGJJ/54+fMeKAQQRBe0xTz6NkBIF8hxLItOPhkONJjBH0oQp/Z5corLkJxmUVql4vsNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778842001; c=relaxed/simple;
	bh=yUPwZ7nx3sItMNqsXllva4yHZXEPbYL/YigcpkHAKIE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E/Lo7gejSn9tJw1fM8Sg6WO9O4J6iVTbNStfDjtkDdKs6q7xbsc7t2tiitl67d3XrIJoKrYXJBcAM/brTsrmigOUDTHSofIADIkegV25DZNTp2dIsZnd0aUx1bNI+46GvdKSbCTwLaoe3BZbPEzbzlP91NwrnhiL68APos95Nhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K715b/JH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QyMalq1A; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K715b/JH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QyMalq1A"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F58mwT3795744
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uyod1xcUrYgx9CzChaNG2Brzec+ACoqmFiT1FPPZGdI=; b=K715b/JHzQf8iLxU
	/FVLy+ixGyjQ/202GPMRJE+FOp1u3dd8z1FodM/gNDLTFXH3GfB3tyjomiMHLmMz
	je8Wrjtt24ZnTMoYxZZe7mzL5KFS0zr4eEStLLBU624XPZcrEB4f0USI7686PRWs
	q8Q2yGKoH/bYlRtIhPhKt68lDFG6x+MpBSUIoXEfbZ4xmzysjSr5wmRMsFxnAr/V
	e2dZVz+n2MnZb6/pFxoQ46uEjGDMjtyy7mySo6xdwoBCIAvASlAPAyiVDJ4Me+cZ
	eg6XhBuuoIY9mpjZpkYJEqy7RenXqWFRijJUJUwcHL3S8AvFWXQMhEEIMxSFfLvu
	1tgo3Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1sturu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:39 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ba718173d1so157279855ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 03:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778841998; x=1779446798; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uyod1xcUrYgx9CzChaNG2Brzec+ACoqmFiT1FPPZGdI=;
        b=QyMalq1AhRaPFVnRWBd81HkLyeN0sEjarb1PbLwqgyGX2bG8AEebfp7FuXl+BBjFqz
         2LyerQnzlobHEzBQVTZM/ED5JaV1OZBOpEDza3ixhFM9qr8yUnEI0sjQM2sK+8ikBHEN
         90S9I7QFZMqqZspX4p14U27DTpbqD6I/y6xZ5j6frg8PEziqA+P2+V5LItQ5YooHyfSE
         EsIWQle04g0o8SeRyrKPcBvtJKC6CtYPKpfhs9uV/Ctpu0MBxq5F+SYHNsUqwtBvPntr
         CoKv0YR24QfdCLgLuFBLbRpdMCo5bw02GMmXED9IU+jGHpF86jJIogACxjSrL0d8Z687
         g1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778841998; x=1779446798;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uyod1xcUrYgx9CzChaNG2Brzec+ACoqmFiT1FPPZGdI=;
        b=c/n9s5MlifdlccQAjxFj+aUgMwqjzQsHqF9RqhYinX4t80BEaqT9zJa3ET5K71zrke
         lL8ngTkhJv3XejJVoW9yBjgW6wywhAjpbfN50hwt4+438RHDgWyeD/hfKdIK9sDNMMpX
         FnuIdOD1N2roNBCGff52jVjYWsv7dvXus9tUHjkX03W2HZXi9wDqypw1JV822k6Yw2sp
         hQzgBy3S/me9buvB++sULr8e7qA7YAxZjaMfAm5crXz6fbljFx3PcXmdW10Z4uxplOq9
         lZL3y/rNZEXXY+Bg04QHR0i+y35legb6bQT3s8LaMVlk+/xhZrkR/PYJJMjG++xRrInb
         Xg4g==
X-Forwarded-Encrypted: i=1; AFNElJ8uMonvQ4g6+t8A6hzvWwxIVJ7/W6eUClRx+IsCmXtQ9dewA11/dxD7maZCCIwCUd5ZEDkOHM+hdOK5j/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpdcpOiOKZ0TTbpHR/3rCdFSgggP/O54U1cz3ihZ8T7qAw146T
	VDDKUSm2XjWjMa52bOGhZJjUb+HQGlk7RXOIE2udXKF3jauYTcoW+XeFfaBhc+nIfvYo8/aTxtn
	/OBuc5TvX9mQ2QbDcEvRfXJ5vACnCUbJLJc7iR4VjtyPTAKPWVVUrISulE6v/T+f6PxM=
X-Gm-Gg: Acq92OHS2n+ikJ/PomgtSmqz7VLg20nWL4o+zNuwgNe5GanpJzim0zLz1/DA92z5pCH
	3IdcBGu6EBadJoJUby8ZiXcVaUcTH6cRkGRB7Q780+Ga3KoKQjyAs6FN2JgS/nf5sdir86cj7zf
	mkY2F6JcwoL2D/RvyeFFy/+hYte9nv6v3UmDV1vUTs++wqIzk/Y+AjCdYsfiT/aZVMP7PA5XexG
	jjVKbKKoRvAwLkOiDWyFl5JnadQAl/nPS3kPwAe+0DOsmkov9vhxJQoI6iutVDMR4R8gz0b4R3N
	6skYyC64JnP9RHB/W9/i/ByGnr8WbNvbpLoAltm/ezE84S5CZCjSmJRAUgGbirjzp1kM+yu/Xa2
	Op9GcDwYh0qVrv2aBV7A9TVzM41zPxuhh+0ScIM3RYdA1Mqs8uLcUrRE=
X-Received: by 2002:a17:902:e352:b0:2b0:bebb:1081 with SMTP id d9443c01a7336-2bd7e8fdd29mr24875795ad.28.1778841998458;
        Fri, 15 May 2026 03:46:38 -0700 (PDT)
X-Received: by 2002:a17:902:e352:b0:2b0:bebb:1081 with SMTP id d9443c01a7336-2bd7e8fdd29mr24875505ad.28.1778841998028;
        Fri, 15 May 2026 03:46:38 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f2dcsm55839755ad.13.2026.05.15.03.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 03:46:37 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 16:16:04 +0530
Subject: [PATCH v2 2/2] arm64: dts: qcom: shikra: Enable ice support for
 SDHC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_ice_ufs-v2-2-2724a54339db@oss.qualcomm.com>
References: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEwOSBTYWx0ZWRfX02Jk5WX5CKeP
 V3JBR0Ej8ZzWbyVqRuXmCFNa2CKbb9memFVIBNX3wVja34DNsaENlPGsoNUmagY/rw2UlXv8hAj
 d+1H2NkNhsU/qoMPX6q+5jRjCC5458nMi7CpT7iHIGPzBvLefq2JaLo1+9XvzW7NfM4lQftmwVj
 QXRqwRdRFMiTk+SobtrrxPKEhqWx0NGGxvQBvDfZuqgffpvyRIgn8ofYucYgxuOX/aEbo7QTIlq
 9peoCZlRO+hA/yOCOSdz75rDqnOMd9oeOYmzkAk/ZjvzBNIzSHz6ZbaHHJee6vGuE3Ookq2IZE5
 oM2vYL2VIGlfk14WhPcWCOuCAT0bQXfRUF8bPibftcWwpAG8CqjpmTJkWz/iYmpTSGDnZxMtYDi
 G9EUb4kJDGJatpBBzxNgQ0FoY5qnJJrpnfNpIXXPMkr29FAvsrS00zzRefTwB4A9KUb+uYbpHfQ
 O7qX2lfeptJrZu2rTFg==
X-Authority-Analysis: v=2.4 cv=cZXiaHDM c=1 sm=1 tr=0 ts=6a06f98f cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=Fg_DINg97nz2W6SJEv8A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: hfjcVbQwAMElEPWbe2_EriyzSiZ8zUBB
X-Proofpoint-ORIG-GUID: hfjcVbQwAMElEPWbe2_EriyzSiZ8zUBB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150109

Add Inline Crypto Engine (ICE) node for Shikra and connect it to the
SDHC controller via qcom,ice phandle. This allows the SDHC controller to
use hardware inline encryption.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 262c488add1e..0b988dd607df 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -641,6 +641,7 @@ &mc_virt SLAVE_EBI_CH0 QCOM_ICC_TAG_ALWAYS>,
 			mmc-hs400-enhanced-strobe;
 
 			resets = <&gcc GCC_SDCC1_BCR>;
+			qcom,ice = <&sdhc_ice>;
 
 			status = "disabled";
 
@@ -663,6 +664,17 @@ opp-384000000 {
 			};
 		};
 
+		sdhc_ice: crypto@4748000 {
+			compatible = "qcom,shikra-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x04748000 0x0 0x18000>;
+			clocks = <&gcc GCC_SDCC1_ICE_CORE_CLK>,
+				 <&gcc GCC_SDCC1_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&rpmpd RPMHPD_CX>;
+		};
+
 		qupv3_0: geniqup@4ac0000 {
 			compatible = "qcom,geni-se-qup";
 			reg = <0x0 0x04ac0000 0x0 0x2000>;

-- 
2.34.1

