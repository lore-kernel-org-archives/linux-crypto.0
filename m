Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EE936EAB3
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152423; cv=none; b=iGcUvoYTWXxacAcO1GyE2bjIGiRxeXio//0rHilijqONL6+4OE1FMaTDYobSfAjIDqZnfD4x+OKHFqr5V86EgEb5ZHa+i7slXcIQ2wE0IozRmjdmHu0pXIijQNywxrPMHreXiavHYIuJ3/G8WPvbUpmBPFg7a08dbjR0SEp2ri0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152423; c=relaxed/simple;
	bh=7y6blKebgKzt9BRVqRBcQ5R8+G4jp/Ep6s3mVoRZmtA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VEYfVL83jwcikOlfHhNmRKpB1u2ObYZ4z9QCLnSzILWh+/HaJQ1r3/ToGN9eQhbKMigo4w3no2Jc0COKOT7zgfePCuTKqbh5/5C75Re3FvmhPAwoVsKhg2RwZrV1VxKkWVhFhUkwM6vHL8BYLFRRFmch6/iLigkXkfTuyDGz+5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fKN1JpuV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SuN1ZUNj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fKN1JpuV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SuN1ZUNj"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N5PYct3811192
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iPV2eXLOd5gbQl9Ewk51iLk1KlwSkFWdUok4y/9LcH4=; b=fKN1JpuV4zIMTy+z
	D4JcSM9LZoTj9w+QulnDBGrENM/TArbNP8WO3B9qoMNcGL8t/o0g/tDxEC4LfctR
	hixz9CQgKJoFnIRAUhN+TpD/Sfd6SKeDgHDZeUw2sM2MDo6LMwhrxdrVsTNFahI9
	S6ci5i5nDN0yIqn0WGuAftewQ1n4NwyhYEFOsI0QEuVWPzPErAGDwW8gV0b0uWX3
	cRuGbHzE5AUxSywOczsJUFRo87+u32KvCYUFj0fQXJmrZpzKMnoBZxrPIGiqOdhO
	Mi8OSEMG6S9hUtOVCnq99F97nTGp9An8P5skvCuG21KuxCmReacHJJhxb3ulH0IV
	ve5x1g==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bujq1bu2s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a07fa318fdso16205905ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152408; x=1769757208; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPV2eXLOd5gbQl9Ewk51iLk1KlwSkFWdUok4y/9LcH4=;
        b=SuN1ZUNjzypToBilb0u9E9I4m4g3QLuc5vgRuluo7I7STDc9FBNbxi6hZ0BwU/GQNX
         /RNbyCYWovrtWXgowjtYU/ZQ2u8jMElLdqnk8z3jSUIQVWeWSMs79Q6sl1o6wEiVOy3U
         L3m+QMOOJ1o859TwSq55pGB0EGDthGvv/UWnOoEwyA5ZYQVL1PQcUpGSd3oooezcQfQ1
         Xqp4KU5WWhFZOl9YgBChAGT7ltvdVaFY2fvOnqgN0nQu6TlE8rYccO9Xf4prJvqvHktG
         sGp+4r8rwGy4RJCoRvaQji9+rQV5kIoRAydHO1hgd42YOVvUG2QicDyWGyvM63dRS16Z
         L2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152408; x=1769757208;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iPV2eXLOd5gbQl9Ewk51iLk1KlwSkFWdUok4y/9LcH4=;
        b=GXt6j6slYgmW+XulUfG1h9/CvfVTKolV9b53e5rqN3CuE7YJ2bAeL3PPqRbqSvXsju
         1Fpq4wM/84OaYqLogH1B06qmcKHKbfpKJDR8UuURLEEnXG9CN/674V6d2hVxdfTX37KX
         PSug/rOdaqPu7MOQVHOyfsBQEQQfYPNj5hQCnGZgtYr1TFeSU9/FQeBKZdAf1ow7H+O/
         RblwPp9oC7h/raG1IVUpkw7PIUvrxqjK+m6bNRRwyUDifVeuCs0L++XsdDQqbk62EUDp
         wyoKA2RSqSHSzMCgy/IZOQoWkoRADJ8OUljvdnt6axd06Kj75scAwsE8pJdiwUSsl6jj
         js0A==
X-Forwarded-Encrypted: i=1; AJvYcCU/fcOVub4rnzy9hOqOZj9UIKGxR3ssHiLC1xHn8zpIljTfzOjubpOF8+Ka6Q4NA5rcGl8hHGHfJ4lu4qg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy767Hws8UDsGBIzd7bPE5vbyJaZYFN3/tU8xaiXQQdclIZ4TDy
	Kn0O0niPgH0W92kMzrQ4pvN6gLDv8s324wdEvPCapyaIlDYK708tFh8LCsdmvYj9pQpVm4UcQtO
	ssNRnut7IPWxlU4PCVw3q4Xj+oeXXyL5rMKPv5gqgnJeIHVLIle08LwOJKoofyjYuBo0=
X-Gm-Gg: AZuq6aLLfINdtwPXzACgEK+OuF6WPBojRXl4ub9bhOzO3ul6DqzJESsTxTe0JJXw9xM
	mZaXPs2VZw5CLNvMPPlN1soSWGCePcMKBbkYexy03Y/1lS+yaYXHgBxysERykZB9kvqsy8rxYOe
	Qqqc2t3jtbp52g5MnI86ZbEEpniNrBjPjh5JaZxSrsgpAiPP7HG9SpM5yBaDkfCHkt07b0w/zpY
	mIAPVvLltTgisuodRWOCcbbEHgeSnOkclwPJlQZ0cp75vFlv9CKBX4VgyovEhpjwEOJSIR0Md0q
	anGbO+G6tF+ZX7eqAuwZjP7P4bTFaHZsgMXItJuNV/Yo+MlevuZAXn2Zcyw9ddm/uyzxavte1gr
	+M8MzQoObMSOSJVGJwOtj7z9u5xKp7Ovxi0Y=
X-Received: by 2002:a17:903:2f84:b0:29e:c2de:4ad with SMTP id d9443c01a7336-2a80ebec84bmr3446515ad.24.1769152407838;
        Thu, 22 Jan 2026 23:13:27 -0800 (PST)
X-Received: by 2002:a17:903:2f84:b0:29e:c2de:4ad with SMTP id d9443c01a7336-2a80ebec84bmr3446305ad.24.1769152407337;
        Thu, 22 Jan 2026 23:13:27 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:26 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:34 +0530
Subject: [PATCH 10/11] arm64: dts: qcom: sm8750: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-10-e9059776f85c@qti.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1189;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=7y6blKebgKzt9BRVqRBcQ5R8+G4jp/Ep6s3mVoRZmtA=;
 b=NPittR0Vi/r+lMXTgDwI9lNwgDucxRJan/NqRGPRF1akhKwbbzdGmVLoSaNzVIkhWz66EuVkY
 5uSPHLwLi97C2Nbvx2my/JSNRn+Tb+iDox2sZnbY8mnRs/MKqxESAYG
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: Rw2BI988897eoXw8AxrMS6nazaJs3jMp
X-Authority-Analysis: v=2.4 cv=O480fR9W c=1 sm=1 tr=0 ts=69731f98 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: Rw2BI988897eoXw8AxrMS6nazaJs3jMp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX/5H1ec85t/r5
 mpUptN3q4xmYkUfXefz/r2uOQ8oiEF8mhuYAq7AMcLDuNHPIFMVDBMBVl5miBSb10fRrP4/Tbpt
 s6zSIZ8NxT98gs2fjZv6NmB007Tykt0ce8EpJITLvX1csBVaN0Y43eOiXjGpANzyu/apkHW9acn
 4feOdTQ2y+iK7rSUNGwG3SU/PVJ+YFmmEMWuYkWa54OJKizYvAj4idqqjffF5OKCskoOs//ns5Z
 eGVEip0wLjOIR2LAPmiTEl0Dly0UXF/Dx7MomCJAIv2l7bu1pHAkqiRq33xXzHwTCCpcCWA63I+
 n1cxeSx4QD6RTdlxbqc4uqv5cH9HiddlSWgAJTAgSxv4V7zn+n7wVAHE4DRB38+/CPgfbGUynTc
 LkuOlSA1nkamr+uaELyM9Q9eAdYTLNCo99K6XWKrIqSvR89mbz38pTd0XSNDi5WdYcR17YQWy2z
 bK4wp0UbkxL18VPjrvA==
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
the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and 'core' and 'iface' clocks in the ICE node
for sm8750.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index a76bf5193a70..11352cb16baa 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -2074,7 +2074,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

