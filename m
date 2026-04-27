Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E89B1A683F
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777251941; cv=none; b=REspQMWWeeu95EjTZrrat5+kI/iOYeCuiLEfn6FDfGpp+L2uGC9twHurgWTOHd9fyIj7GtrqcknLNgKh7GuiDpdtZkjFpU9jKUSfWag5lZJSsOhV64tloPJtpbDMD9WzFNDHci8X3HByGtrDEGZa66q7XusH8bhgKyz6HfGF/aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777251941; c=relaxed/simple;
	bh=271J0lZFHsgoJcX3dFlGjV17Kt4aHWOaGN8cZCfR5Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VQCNl5eHm0PAdWVuZqx4yP6/MVvqN0kx/2uWiwErViDDla21u3X4ypZeUOQO/av6W+qcQeWSbo7LzG9Da4CZGjQ791/jcB95uS6yauczaOCCxFdsr3CeFD1kk7yCoL1yVdHmrhUshvBMaARfA8t+3CLB9rPx9J+slnSYermGOOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Qu3Rqlcy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DIuvU41r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Qu3Rqlcy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DIuvU41r"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QKPJU71353525
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 01:05:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=s7PxwMFZQggX2AK6HZIzTeEsYKNAeZcrWBZ
	TCXXOmCQ=; b=Qu3RqlcyHPELxHIxXjKFuxWyAr2utRwjrUyWbuZCgVWwBarCv1R
	S0C4YZKgr8kbG9hv/4fEZalBjdr5jT6PQqjzkaUl0f4loZJgi5w6BgApTnmp8O16
	Sbqi3MLOzDvBCuSsl9c4XTpGlZsYsBzlNlTGx3zVPVrcEj/HCWzowXg0+DWzkJaZ
	4KWR4jaPhjzpcnY9C2Y0cAUPSLVzd0gC7djzqhwbyW6adINFiD0mHxcP7ZSFdrMK
	Lp4bSDvc6QYPOPhMKc3chhCQJM67K867rkPoRUQ/Hna0/7LvYiIJa2EK7hwWPdVG
	AyB4xxNE+QggmTnxUlFvsybkoVTB650kvWg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drnu2uutw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 01:05:39 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-126e8ee6227so10170252c88.0
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 18:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777251939; x=1777856739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s7PxwMFZQggX2AK6HZIzTeEsYKNAeZcrWBZTCXXOmCQ=;
        b=DIuvU41rKdMlv4f0pen7j3esfmHNpKK3gbs0Pn8I/KqrAij3E9xdq1gvzlX01yfI5z
         kKrCUdbk1TFX4zAONOObsBewk8cuasb/EKbFgxOswygDUvLleBSpMWejJujwg57qKejL
         +wt8XcIo6O0CsfyBrquBt2C7DCyoDilpTL2BcPNqpe+TBETK53j0bn9foLseWQgEGbQy
         xoTpSbxvgIFWp1uQsqkzZJBloSMZS4YOukL0EQ3Us+mETTMpPZhq0BXXTKGR6XIJ24XQ
         dWnlzV+xGy39KvugLuCI+fbYdfEFj2PSlfj52IqS41ONDs42SulxDuQsjIe0idEtrdLD
         Tyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777251939; x=1777856739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7PxwMFZQggX2AK6HZIzTeEsYKNAeZcrWBZTCXXOmCQ=;
        b=V2PdQImg1InNO/dwD4ALGCMQVsBbzVd57No44gR9zwfiSyUBg1oSGH+GC4BAr6yuWn
         w3A03bcdykC2nb4nfsdHGTFSD5Y+hexVso2RxRYzs1wNq1ovf1CTPWsETz+sXdKEW2Ni
         TZuORExKq9gQAqYsaSuXLxq8esRtr3ZXoCWuXgXqVlckqyGSuFxvi7V58AydSTV85I2x
         +tsDKwXtIIlvz+WnC2X7NFSsqFNEHcAwBYe6TV9wwjH+cLCFIsRoIhzEPnjsj2AgqhKt
         rp66+FH6n5/Sz9fJt7YJUtOK1goATPZ736OGQuq9HaMFpcnBta2VTv+DCWD95ILTLIf2
         1Z3g==
X-Forwarded-Encrypted: i=1; AFNElJ+XLH7cG8bvqYURgkfVX8wgMYzU97pE4S59U+e4Q46BG2tVVCwIKWrq/WYirtnvvvoWbbYcsdt0ZAhC80k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFaqlg6u2iTtDhy2OGz5y0+VeKS3PfZ4ruY6bxgHpAsVbfcAcO
	cyWvZKtbMFPrvrhkbkoOwkeI+jUM0V+DocXwaEJwGce7xrO01K2LTR0cGGDIwv9owpQixN4Ysw4
	+ZfbmtyHO6KkF88TBVBEQn98UZ3x8TYNfqePMY9CTFtV9q9+mdHUhh7BIubZPRDi/Oow=
X-Gm-Gg: AeBDiesZquH74ZByHQAcegU4xfQgl7MNmCS6+XIqcuAKki9uDpOpogkXwTeJSXAEuTD
	9lpKHkPX5gYyT2Oz0sS4cVVW2MShzkig3D+99jOiB+JU2i5LpmwvDrTHUqG/i4xRNrjUrSMqSEE
	c+GYnqmflP5F4K7o0RhxRBim3K/Wsln41dC1Eb9J+btdydeqpSH6sd8FN4hqPwcO04Zn4N3v2RN
	A1TA44itukanb7tlEgRBKlF43nWhIuB9KlQYh7fLjXn9a9bQprCnuj1NanBC6qoOK9YcgnazItt
	Sb3+l3XkCvC5TGUFSpip61ac7+oHNfl2+ALuD9+KW4TeA3vMWdqmrPzRb29vFy86bnPVOBAXeVH
	ex+glo4/17dTNjZCcHBKXjFqUNd+Nms2fyC3IcsRqOKPMKaql/uL+lCtUAd3qGr5X0i9kzVaWZP
	Uj0+KLVkJGK/enL1YU
X-Received: by 2002:a05:7022:4596:b0:128:d450:bc76 with SMTP id a92af1059eb24-12c73f978fcmr20066386c88.26.1777251938709;
        Sun, 26 Apr 2026 18:05:38 -0700 (PDT)
X-Received: by 2002:a05:7022:4596:b0:128:d450:bc76 with SMTP id a92af1059eb24-12c73f978fcmr20066363c88.26.1777251938194;
        Sun, 26 Apr 2026 18:05:38 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c837f7feasm49985745c88.0.2026.04.26.18.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 18:05:37 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine: Document Nord ICE
Date: Mon, 27 Apr 2026 09:05:27 +0800
Message-ID: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Z4Fg_GLilwtOOQcSbseSeL5fpGYLGhcJ
X-Authority-Analysis: v=2.4 cv=cbriaHDM c=1 sm=1 tr=0 ts=69eeb663 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=_7_cwL0RbDhQ0r_n38wA:9 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-ORIG-GUID: Z4Fg_GLilwtOOQcSbseSeL5fpGYLGhcJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAwOSBTYWx0ZWRfXwjjoMw05TFOe
 t1EytLrMJuOFc47Apv8zW3vzodRrpiyFkqVsedhKSC1AQiZ9ZcW5hMHcFT1kasaLzhED7L0cGu9
 hrQcq9Imv7+Y4Vao6aKTGRx/MUzliUVyTFxUo2ezTmTHJHVqaGVLhQ2wgO2NefBgn4wJLAe7L1A
 HejNoH/GW6ABp57spkkK5/kKyNzw2wNnaGNCh+wes3a51x0WbTA6yJoE/7iyMH1+F3o7l5CheJj
 cU9r75rVesIY40p26Z1QfPihAtyVW8uvXVHhbFXbreLN5MBcOrKoF308VKnHZ5CaZ3xfbtVEzP6
 dmm3uqDnn5CNLCccg7XnKat7rldHmgb4MtjU1XvlXlIBhHCgBbPZtcF0g1aAzbCZd4U+QNfgO3i
 HyBVxhCJd0O/7h0+b+OtZSWS2hXVqgyh2FWferd9wSdRfr6SA9XkOafh1n9oqGf/RQOd15edt41
 x/JztVw9ecI1a2qu8zg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270009

Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC which is
compatible with 'qcom,inline-crypto-engine'.

Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
Changes in v2:
 - Improve commit log to make the compatibility explicit
 - Link to v1: https://lore.kernel.org/all/20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com/

 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..9251db2b8fcd 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -16,6 +16,7 @@ properties:
           - qcom,eliza-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
+          - qcom,nord-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
-- 
2.43.0

