Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D39E387590
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257585; cv=none; b=ZkXKkeFzsVzyj1jX9jmxGmkyrZhCDczWcCIcnzVKl0RIMXXP5SbHhoKZAeYlfwvCNIfgzKqrk4v6XtQcUm1r1AmwO1InnJrsFphK0Bt5ndTBGYp25pMWIil877DUrQlfbZaDWRs4zBSivIpVCBRNVHSD5Nl8ovDdmGD6w4Ds+oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257585; c=relaxed/simple;
	bh=Fih3H3PK3peo75HwJmlC27QMm4Iy3NsQyUEJpIpUgHE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UgBNJly6yQPZ1HA8ewBx4EHBn64GtFFWXEp9oZckTXdiNtVWlV5a18seAvd3rBAlqzk0GZ7YeI/xHOeViUFDWnnhOnDfDpApyKEXkwy2wPd22dd1BcuctKBAeFDmpn2jDMHJZaVInQA0gMka34PEcKp2Xf1bNq7AS6lkgpNd0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dYtVPsuH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XduWYMLG; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dYtVPsuH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XduWYMLG"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tbob1627188
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aalq/tAtENNGL1pl0pufJMN8+g9gmCvXgFs8/ig8bUs=; b=dYtVPsuHfCu7VYOt
	OD37JqTZ20nJnW9bZUtn1iQASHtwouxAQu8wRsfIUvQO7/KiibwymhQFN1cgb/1r
	gZN4r2uxXifWlWZAasf35iMfdaMnXDqOpAs7VP4dn4Z5KlWTO2rVRYKYUnngQ6Ce
	Dt5ZQGdxSt+V9Y+mAMrFScTfb1XsMp9iHILS8W1m7ZE7Wz/Z+JjbFR769/yGbiX1
	/VNVnXhC8W3/HCpar2v+7SeM4NDu09Sn2C6hxb3DBV848LKjOWbL+srw+NatMNtP
	vb43Fv4CRSeyJVw5LVQgnx09C3PrVSx7/HW4CO9B0GTzKkQqEHlWvn1HXIBUQcMu
	D4200A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31jc09fg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 09:19:43 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3594620fe97so29638285a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 02:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774257583; x=1774862383; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aalq/tAtENNGL1pl0pufJMN8+g9gmCvXgFs8/ig8bUs=;
        b=XduWYMLG1jlvmh4s+1CghyU6d/QFXGynB95x/UR4b7oPqDvN17/oFFJtCeZ3BjOvGP
         1YImmbV3IlSL04ZceZNP79JCBAxJR0jZqatLWSayfatr5DWQ+6pK1M+DN95gSI+8W6cz
         vkDMCDCWJH+O+scItguq+G1lL4EgahBhM25AcR9DLGnbL2koaJi4oZhs2Q8wGnvT6o6S
         +/oqsVxZNZXwZSsZ66zhFZ2GhxJDfMYalKi2+UNiOJ9xFlQXjeChJ53UA4nygyMQkDmY
         ZXEH7bo6IEGlE9LJeaVL+fpXLy83eoNhfXoOIuJxJ71sEZyYDXIZPoERUnoYLywVyGmX
         E+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257583; x=1774862383;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aalq/tAtENNGL1pl0pufJMN8+g9gmCvXgFs8/ig8bUs=;
        b=Nf+DCm4tE9r06zA18rHeE2n8X6k8HpHQ5e68nD0fRxrOdLMEBccY2PjFxAKmNkqUTN
         fxXRQWOLkGH2CvmZhC02lS9wSP3l1UCv3PtlqtnrgCzXG/4WC+38G/x15IKhRpo1vPZe
         33YABwnyFeqs1D0Ha7jdrkkjNKEWuPWvlGI1GQRAai9IqADU/S5EGEa12t2pgI2U9xaH
         MFRSaVku8Z824f3Kr7kB4HCOiN4Q8itkiFSFexYTwk9rUNsvTWX1UnrjKzg3hrJxY+lE
         oLcv3HCdxbmeFJqJ54UTRP3dEmEpBgzMzIub+ANrRtQahvvZewJmyMn031qT5nUF8RYh
         /L/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9ggUD+R3xXoQYdhKRXEDnhxW9K6sq+9YG5Fs6neNijIwxXJYeW4F9dimaLyl9PBVFjH+XfyrecaY729c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNttmZHCRqPiE+vXgklgwnw8XmZglC0IMEhNTpsLva3QPr060d
	s5Ao7ozILYxAhbcf1ZRiCVnRTkIKZEgEsxcSPjXps5oS/Xz/BDvULPJ/JwqwQwGUlcwDzi9FDtY
	euf986ceHrd5bgJZN3uQ7BsEihON3Xp3ifH5W6xZQynEUPTPxQrWLhb59g6oOTN3fSh0=
X-Gm-Gg: ATEYQzxGe/VceVv7GAtVZXByEcqmQ1ckv9NgpjVNYYwaN583NpsNMuj1QP9kyuBHrzG
	5mZbHTKqPAW1mp1Qcl/9b5YCMEjnqE1yri4sgIpSyUzLuk2vCn4Y+7S90CQABrnTk/1zFUvHQ61
	3OV/CzBSErvaez0vBQCUdWu+hreHDgMRGB90wzyZeyvl+CjLdIGLal2ayQwJbZiFY4KFL/5EcOn
	2sIJZ1q0RVt8sVyR3p5lkc6iDIJPVWVv4LlFsF52TlipIX8EHyoDQQddXcuX1GiuCKNKC4dl/mJ
	8bW5F7eYNuH9INKrKhKDccYKF/hsuzomVL6c9EKTQiKjzZUbluDFy3HvFh6yyLqZGHrsjUxcbpb
	4Tg2MQ+mOAx0lNLQvre2bbyeSD1bcORYTDfXchlx7xkHwrMM=
X-Received: by 2002:a17:90b:1dc1:b0:35b:e671:a527 with SMTP id 98e67ed59e1d1-35be671a6c5mr4626572a91.3.1774257582757;
        Mon, 23 Mar 2026 02:19:42 -0700 (PDT)
X-Received: by 2002:a17:90b:1dc1:b0:35b:e671:a527 with SMTP id 98e67ed59e1d1-35be671a6c5mr4626529a91.3.1774257582223;
        Mon, 23 Mar 2026 02:19:42 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b5ecsm3923448a91.5.2026.03.23.02.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:19:41 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 14:48:03 +0530
Subject: [PATCH v4 10/11] arm64: dts: qcom: sm8650: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-qcom_ice_power_and_clk_vote-v4-10-e36044bbdfe9@oss.qualcomm.com>
References: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
In-Reply-To: <20260323-qcom_ice_power_and_clk_vote-v4-0-e36044bbdfe9@oss.qualcomm.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774257482; l=1465;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=Fih3H3PK3peo75HwJmlC27QMm4Iy3NsQyUEJpIpUgHE=;
 b=p3n776ssmKlC9hQM3oCpnh6ItzEMnUlx7FtzWZVKAA5x3Rrj4zsHHqFZpu5sRP/TN5y+FNP2K
 jCw8dzrfM2QAs9JrQtClgAVCafZwDj//YP8MfBe/I4GmXSp6SxLo4OB
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=fKc0HJae c=1 sm=1 tr=0 ts=69c105af cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: CNQO5cMdIw5W8WvijVDzWZLM7CB9PRb8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX0ljplsHXwJfV
 T3TtGCJJnFj9ZgeLD6MXprXsRhnwx79IeEXi6DsbiBkfT0Lb8mn+AsDsqWsf+h+q0CpqyBaIy8R
 zpGhKltzF3kMsRRVuhYu+Q65eaThbO2yUXF8AW4kF9MEhDl9BWTkUQTMINP4q9jq+C/E75tRz61
 CCEUpd2rGo5YBvKe+FlO4uNB/jm5q7ohmSf3lPa2VCotN8+aKqPUvqDWR5grhC6ycbDWSA694Cc
 8YFTR06aY6HldtsTbmA2YsXxmE6wbsIqL8P2wX8yG8KpHE11IR0cpv7h+Tmj7csMmXjhXDq4tiE
 zGvWCS6Raly9ATTvA/Xeih1AyNgOJopVctNmH1T4rL1jVReSlewc8oN1gRduvKttuJA6ha9tRj0
 Q7ioe6lAm11mtvIjKNFPT5lGMNmwr1F9QwXV+lpc8oBOukfmngDFZ16+biz9TTaccw+0EIGG6dl
 kIBgszQpaIpdLkJrWEg==
X-Proofpoint-ORIG-GUID: CNQO5cMdIw5W8WvijVDzWZLM7CB9PRb8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603230071

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8650.

Fixes: 10e0246712951 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 357e43b90740..d211bd94fb41 100644
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

