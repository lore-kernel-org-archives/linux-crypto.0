Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2805295DB8
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765442719; cv=none; b=fvYdRWyA1cpC9v2azjOlRzfIE4fknBiwwE1UPOD199rRRngINX2LQqjH6A9zXxLkcHF7jEHRk2WpztkLORa1Nr47v3XvVZzrmp+URp2zEsL/za1gPlrvGsPKR+L5yKtrAPnP7nqMs/cJgugr+oMfUrNPFKQ/7sfOjTw/zv9nFis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765442719; c=relaxed/simple;
	bh=tA7rSWjOklQFAL5MqnFh0aLMS/Kqq/abTUJ7uP0yas8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YRmiUA++ra6iN/4nEXRb8OaL282Tb3GX+xlqA48pZHKxeS0Jq84vaDUrhf/sToyHFJOlBoY4CnBiIu4AmsWUOZToMM/JUXq818GSliIavGdlPmUzRx7ZGnyXenmicmTOLqoqWSclYVFzE4OKh4D6m5ESjcRtrA+zdGEuMcqDE6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ixKuLNk+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BoLRz3Wp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ixKuLNk+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BoLRz3Wp"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BB8gi11428987
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NEL68xIdbSe0Bko1W614HTi5iAYgcxCt/fdYmXWqPwI=; b=ixKuLNk+EwpSeOX5
	LyFaZXgjOg/2AUGyHAbhfaTv8886kJXnmZvrnqC03shnFIjob6RmFsL1vbzhfVwk
	QbRha2m20N0nKdWU8vPQEIUUQstmQQ5J7kzRxEjCgDuY3Z9HpguF2xMYUq1aFWfH
	PB6xzqY06BrhU/BWo+Khkl89qoeYCJFkDt7T0zX0T8B5U1T/UgnjDAkt+psv6NzH
	oe2vGPHSltsQMjVeY80Y/d4fqEjxOqo8RCXJVdyW/UQexaPJxR/TKgF2exwpMT5G
	Opt0CIkMZYq4HmtecdDOCFE8pW1O7lvfMLGFT6Wh5N5uRMH+RKSE074e1r4x8S0p
	XzPCww==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aygrx1pra-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:14 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29ea258c1d8so21320715ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 00:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765442714; x=1766047514; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEL68xIdbSe0Bko1W614HTi5iAYgcxCt/fdYmXWqPwI=;
        b=BoLRz3WpnvmTV3dTZj8QHVt6AtWtrGLsjW5Zp3PZ1mnUfLcaI/t+nZNmhsU5iEOzEi
         2YWHrKPbxkaKJxTp9yMAeoDP1HXqOzvWLfAKyLx9Av61A3+mHJMRjkOiRIqmK5ByqRFO
         clkNk/NhlCn//h7AsLq6ui+BcmyPk2/nM2lHnFr4eMhJGi9/gb4sE93AkNg5TVYxoMZZ
         QpZLPYPRPSD7R1IS8rfofJPc7B4fLJZEc+hj0ggoTgRB5D9GZa6IcJmFuOExmu7vs7dI
         ddMLAYO1ZtNKVFHzwO6T0R7BgNbOrMcyr3Qow8qE7KQw3m5I2m4yl+u2YBWX1wv/XyGp
         Hwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765442714; x=1766047514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NEL68xIdbSe0Bko1W614HTi5iAYgcxCt/fdYmXWqPwI=;
        b=OHLMnbQ0U39SAkOsTxGl454kRGFPoJRJz54IEj159esEqiD7780XBw9STVrcikazPy
         b0xY0P3VYWTRprC8Y62du9PpHirr4GeVie04Ja8J8NhIyXUHASkz7ZCs4TqwJJJmWcyW
         tHyHVqH1ygtE5XFPX9Bh/0vbOMOFVXVDa4HG4Hk58YTSWic8Q1d7Ih2rtbPBJTipVgNn
         ZchZTqEqT8x5PSRwav5PQ8rT6Jpkg7Jr3WqIreGqG73QOCEQllwssln3/eKerpHxrYre
         21mc93eOIpcPVzLtDW9pqFsDx8eo6p0E1i7igcwiV4I0cs5Nx4cDrojgM3nvJnk1HdIJ
         1oRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/EillMhACaqf5zeveaLn02ElXao65wolp8cnGSZy/6lsKm+Vzy1iYbOutifkZoAiedkZZkU1H01eIVZk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3zopVSnzkYpxJocGHZPu3r6ejREIshhIbchVQMS5/ojPphqaC
	t4nHSxXVPim4Oz6ouRC1V0oKDT0AjrT8QeGP9YaB6iWbnlBLGSxI9JYguedki3Mc3CSeR78tsx3
	tB5+O+I/OPhqlQfl/qJ3ceUYlTN4VqLj5LFfDJ/bTCN68rqM1v9CxY2+F4btEoMaH4rbwhDotxr
	o=
X-Gm-Gg: AY/fxX6LrLoa97LaFL+Mx5UFPL29psJZHVzuKgj2jP/D7PxrYvej4P7y2x9Ydi7TtLw
	XgT+CXcYnSGTqCXspILh/1SvraXOPXAa1gsrvLWqeYyACdRxC+X0YOIfPeEvvUy3PeVRG3uNujJ
	cXaVUIkUwNL1SkI6cO/2JQfZprfVcP02D/ATSh2JC6P3W/ks5INnV0GOpMWUSTRelf01UgkZmA1
	bsGnIYmrElHnsgrarGrkteueWIykxTdnkUS9LPqYmrhY0eFh26KqmYbByE7P5PHrLSVbiAlH0WO
	Ebff9uqjL0luLA0PTdlzB+E/lyWX9fbhdfRh+sRITIHgiKDfYV2GWsiiLP/7XLtzQ0C6ybgK3K7
	l3tngKlt+KKBFvBHHiOaIZdt1TiRxgZLhdaM=
X-Received: by 2002:a17:902:ea0e:b0:269:b6c8:4a4b with SMTP id d9443c01a7336-29ec22e3ec5mr63410895ad.6.1765442713819;
        Thu, 11 Dec 2025 00:45:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGp4kxixkf3dMTYp+q5hmdYDoQGEfWePNeN9JyQ/GmyGZIOuW/9F2dIiOEh5raInjYU6VmalQ==
X-Received: by 2002:a17:902:ea0e:b0:269:b6c8:4a4b with SMTP id d9443c01a7336-29ec22e3ec5mr63410615ad.6.1765442713405;
        Thu, 11 Dec 2025 00:45:13 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea03fcd8sm17322105ad.74.2025.12.11.00.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:45:13 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 11 Dec 2025 14:15:00 +0530
Subject: [PATCH v3 2/2] arm64: dts: qcom: x1e80100: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-trng_dt_binding_x1e80100-v3-2-397fb3872ff1@oss.qualcomm.com>
References: <20251211-trng_dt_binding_x1e80100-v3-0-397fb3872ff1@oss.qualcomm.com>
In-Reply-To: <20251211-trng_dt_binding_x1e80100-v3-0-397fb3872ff1@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765442701; l=942;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=tA7rSWjOklQFAL5MqnFh0aLMS/Kqq/abTUJ7uP0yas8=;
 b=ctLXjztotMUXXNG4rKaeGt61oZhP2AMvLVdoQ8yYEDocdcmc3KxHujVGQWUi9/+XO/3nEh3Ae
 9r9h7fnLk4CDQWpiZTBG6LWlKYzQl4bCrn+g3vfUd4zJ/CG9HCv34f0
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=Hc0ZjyE8 c=1 sm=1 tr=0 ts=693a849a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=75mWG-WH9mJFzEGoRSkA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: m3P2S3PUktXvTN3nDWJa1oHWlZPLJmoj
X-Proofpoint-ORIG-GUID: m3P2S3PUktXvTN3nDWJa1oHWlZPLJmoj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjExMDA2NCBTYWx0ZWRfX2weaDLgS2mTB
 eIdniScTvRqc+fPG+2nGxBlQMGgiiyOeBfSamd/DLAbR3mEOgP8yVVKvvX5Hc/JKnpymBYzWSJz
 UwksI7ox4K4PrYJc3x57JXCMzKiPlnUvuZ3L1DTf+OilYdhMIGlm/JMMfjjKdTfRft20oleGkVu
 +CNYqomFJBbCigK4lEgtFKWZ5ljrJVEeCv+mUGLrk9RgJ688bccukMF/ZoTAfJ9GndjQldFRfkW
 Jxe5KU/TZ8tM2B+8etU+3ATGBObI4A6GWtT3D06DiVGMViE8Mzk3OK8xwxs9yxru/Fp1lKFMZeR
 xhDi2wEaEc2l5CBugCTHhv7mgEtKxU0SzyeELYCdE4eGb/T+iqBUYRH0FMlSYuJGlR8ZrgvoDq8
 r2MZ9mNPl1V2aecziB6FZMqvmIAOTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_03,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512110064

The x1e80100 SoC has a True Random Number Generator, add the node with
the correct compatible set.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 51576d9c935d..c17c02c347be 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -3033,6 +3033,11 @@ usb_1_ss2_qmpphy_dp_in: endpoint {
 			};
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,x1e80100-trng", "qcom,trng";
+			reg = <0x0 0x10c3000 0x0 0x1000>;
+		};
+
 		cnoc_main: interconnect@1500000 {
 			compatible = "qcom,x1e80100-cnoc-main";
 			reg = <0 0x01500000 0 0x14400>;

-- 
2.25.1

