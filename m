Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6919C26A1CF
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778790648; cv=none; b=ckwmFRE2UaK7oEdj6Zr4j6kxsYvt3NwEbqaYNoHLQlU8sQuUV0fpqnrWSOg3g8BdoYZVOOWMpPu9txEb3T/B0Ez+RgEPcsxXLeQoaFXhBjw5C9S6eNTOvyfLEi1HJA6LZJjFBxftE2M/3G0NnmCgAxWlJ0Tg7XjfkhXqNtK2GYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778790648; c=relaxed/simple;
	bh=ENRAB6NaAfz+N/esGn59rAS1dbyvJcqApk/1sxjO5Ho=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CNjvoRQXPn74wPiWb/bhzN/T3DO9Neg1gJ8dUUs9LXmRcoFR+vzJ9ZUAosOsq3cgw9Q6mL/KgUzViWznzkGlVMEs1mTZUKSMTob/dudmRgVJaKDq+M4IgPEsciAasEPCalMyrH+qhsOJlPDWarqMGScKk4842eICP/eifGf3998=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GBHCraI5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NxzF+asI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GBHCraI5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NxzF+asI"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIpd8i718363
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	29moSWZqjKQBR+rms1scwxyd2aS4I64T0JEH8KBPdfE=; b=GBHCraI5y1rPwzFw
	WFcvkHTQqGILl0MlKJF7AUlBkgEwf+WnbNW6zKBYbBt+y5KPlWMFPSaGHoHb5cuj
	oFNRtKz4Vp1Rmu6e9xE/0kXFS7qLqRsccs4uqzJARwm+zPXa1KbmcM0e+E2Y+eYh
	2adZz/5WPI3bIRbzykZfMN6g4pSz6pWoqvSAJBD2IUsL7C+wf8RVsvTk29AHRaTZ
	wqZRY1I6VsYRInyl7CmSYlbl/haAaand6yTKcGFJL8PRv572OVN56TzptpnGV+Kc
	UrtLj0VcePBu3a8ugDs47+fySkhevvAx0ThONDwddR02F4aWVeG1pKLKpLtFOOrw
	Q4JcyA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1x0a4j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:46 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-83cecc22d5fso4403395b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778790646; x=1779395446; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=29moSWZqjKQBR+rms1scwxyd2aS4I64T0JEH8KBPdfE=;
        b=NxzF+asIHWQHaRDw05hiBMWU/9WCYlmlHgddp0XsKBAhl374FtrrK9vgRw6tLyHGBg
         MA+7RTxpTaEw2JViqtcLeh+rPK0zQ3Y6ZWlYbEUulQtZJWF2ZyawcErwTTZIHZKwvvt5
         +s/RkXqmoZ4jbTYw86JSlMvzeWbGotyZ96/Ju2QCcHxJrI3mcERM9sfYCIZ/qktS6lXc
         EGubG50PbCft20KXDUueRsoi4fo1C95PRTipE1KvcEgncaGLGujnfYqORK0NXoANS9QP
         sv2wunTsCj/d1L6wWP8VylVBZB7SGdRRa7h8HMlf7vS3anQzlnhTAfCRTzNxmi0ZpKc0
         I4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778790646; x=1779395446;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=29moSWZqjKQBR+rms1scwxyd2aS4I64T0JEH8KBPdfE=;
        b=i2eE0RFzMiWXiu024FVrzwifHjo1EVu14dZdRCFDAEV87Zg9BrRcD0bhEGWSriLMFH
         o1abaLAzYWFc9hyjNDWsSbS/bGk4Biod8d8QQLwGtnr2rosdBQ6KooJhmcDuZUwg5h8r
         jkMOCqizETPN+FEzfKs9JEgHYDWPjLjWV5rj4aR7KVqZwhEar5j4+CmpThmwOEXyX7Wc
         4XwkSWpIk28ig8sEdY0yy25STt9tTRCrt5Yu+ATsvONWJLr2QaZHvrPuSd3vvYjfTnoF
         bbtwz6LBxNgB++H6Ce1gBxdj5aO2ybSvE5cBytqbyRDAnqDWi0a9tBVzXf2IADliDYMb
         lsGw==
X-Forwarded-Encrypted: i=1; AFNElJ/wwlsgqOyakyN3STD9YuZK/Lzi08JXGLRlNvq56/ANJYA9CKVdty8L4+2MaCLi4GXqoXZ8s+3n3Ajt/1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtceXIT11G73+VdJWlEGKBIbzeuTC4XRh5xUuW8xbH06fVtnzH
	GSdQvttcbqQa8eCNBERbjKaqXHzht95bf597ILhM8U0oJV6QjM2QP5ceo4++RAYkbsHzxmU8odQ
	a80FcMQ9+0fnjEv0vdn+XZ7AcIILxiE0KY7LSoXUSu1F2N4yfj0qfMLCVQBJafa6yKso=
X-Gm-Gg: Acq92OFJwcHINUYH1QjW/1MHWecclVFz3xHV/BDuqgtgNE9uyUP13Kq96Vv1wnBxvwS
	u5ELCG0upYObwEfgZeOSgOkQ1S6WivvNwUvT2bt7eu/22unEDCtkeIe5rCS375U4rT/sUZZYwUu
	45ZtvldFMxd1bFd27o/vynC2DxKCzQjjwGDW1yLVz4nqHtPT7haolYMxHkFCH5zI9Nc5aC0+trf
	hSv/kv94Y4hUUB4eupPNivzdWr2SQSGSGrZ1Gnph1W3OwKG+6iFOnbFhSpikjEkOsU0zbbCBODT
	a0I/bzKt/lP0hTFoMArhOQsc7FljBO9veK2YxAS9qlv4ZcrnBkQxTrpIlNtgFZchRUMy9hMzUPD
	vaWlw3II0r5sydtNLgixl5xW21nZWB+MNCTyx6p42213MVREazZmTyhg=
X-Received: by 2002:a05:6a00:1d85:b0:83a:a55f:c3f9 with SMTP id d2e1a72fcca58-83f33b4e019mr1029707b3a.20.1778790645758;
        Thu, 14 May 2026 13:30:45 -0700 (PDT)
X-Received: by 2002:a05:6a00:1d85:b0:83a:a55f:c3f9 with SMTP id d2e1a72fcca58-83f33b4e019mr1029675b3a.20.1778790645262;
        Thu, 14 May 2026 13:30:45 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19664a59sm3666952b3a.1.2026.05.14.13.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 13:30:44 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 02:00:09 +0530
Subject: [PATCH 2/2] arm64: dts: qcom: shikra: Enable ice support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_ice_ufs-v1-2-b1b6ced70559@oss.qualcomm.com>
References: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIwMiBTYWx0ZWRfX1YkT/C/EPr7a
 tFdjc+Did4MGzugq4uwfmNLvhqAUO3VCF5f6tI3BDVOJFb45AQpS2w/PMiMi0ncEqIsn6IrKOe+
 t23aK692j7bo1z7gFn7VSeRJC9h26SXjv1wh6xCeovAFmp7QpvDy7YRHdrzzu/tajIUz61u2pwH
 yzA0CA0XrpcnUrgj3gbTcMKI/NE7lyKg7r8zyfSwVDt3pBkPrTz2mXSi7FxvGQe+At3WNN3ya7x
 77Lo0QKBmScdSJINqHNefLB3BqlSPpRQgDMQHjLe7L9NMLV6NLxqIPPlhN7WlzNXzdUG5QMULXx
 Vpq3TczwXeLk1SKughDNHX1L6xDeyXipH+0zc0GEAAm8B0rkzbOKfC5bJD/IDkCkJSBSTYC7G9D
 IWTeRFWmM2RTDW3mObakiMwgPBdQkIH9i5NtZ8wdrRR77j19uQhifC9DLY+UPBIVcLRoBb4GXWz
 btP6H3rlYJBMpgrTxhA==
X-Proofpoint-GUID: Khw0L08sRYuVA5CSbRLc-AkGlBMlHW4R
X-Authority-Analysis: v=2.4 cv=GL441ONK c=1 sm=1 tr=0 ts=6a0630f6 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=Fg_DINg97nz2W6SJEv8A:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: Khw0L08sRYuVA5CSbRLc-AkGlBMlHW4R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140202

Add UFS inline crypto engine(ICE) support for shikra.

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

