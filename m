Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857353630B0
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023567; cv=none; b=P1yHYIBh/GgrCKdAJML4NNkalBDOoMeuamaR/RULLy4p7b28BLwKG/WEHOB6ZENExkRCRkDOM6wjtscMLa72WUEs/0aKLN8sB02VpLS6Bf7JWEJZfxE4kgEjTyvlCWPhcsfqvWY3ksarFObU1jSNk90itUgVRmIG5Ls4ixefJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023567; c=relaxed/simple;
	bh=zjzyQGqtQEvToFUvVoo7pZ24KQzxayJOTmTLKhS4AOU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FdpMMLaXtXlOnR5Ai1gDksgm3UV6rpXf48WDMxrI+2HMMW1bui4fGrPkDVQL7EA+nugwOR24ZAxoGuI6cDStoTBrr6QCreGabgdi11SjIBonAdzgCAwfYgExvkrDZUFCz7erytl2DAWGdfZ4Y9jAARH9DJMl0vOwpL0FeUNnDNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O8Nlq3G7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LGhbXap1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O8Nlq3G7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LGhbXap1"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SLjX3912628
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7SkMYn1pW8LZr6abBIJ2z33PKYxNNOhX0ZIHoUiS7dk=; b=O8Nlq3G7P7bg6KCW
	3181XiVgN7wWxHVczLpCGpmC8BSECUY6uhB2Mg4zIa2jSJPQnJh0VWL6aYVFBP/c
	aTT4tScsp+ipRcaeFp9EUCwm0/En9xPYRCKONMLh0nxkeMP5HXfqOp+rFJzmr2M8
	/Tt/3FF0F2IGCUaUOAdjyxEVhllIsg3iWTQTTg3jNmGUiFFy+hvmNTb6I8OGCxAr
	B/AHXMolzI2CrnEiCj17KsAHOrMHavwCtKlxJGLGBMMvFRN3fTEzKXg5ER5BqVcs
	VW/DY8/2ak8JdZITaEl6IRgXhceK0KApPfuLTkkSgpAYkJRN9f0joO77oDOUPsom
	RCn6zw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fdeu4h4ky-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:06:04 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccb6823efcso39337025ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 03:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784023564; x=1784628364; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7SkMYn1pW8LZr6abBIJ2z33PKYxNNOhX0ZIHoUiS7dk=;
        b=LGhbXap1j7MlzOM/bJ/BksaQHVJZsXLNrtNDg9DGnWbhlJ6PeA5r7qfSSCUlw8bxxr
         vsjT34em38Sq094irDtBTmAHY6oO+IvLKE1p58myzvvdZDhF5cvo5iKYpMAE5VuzsOVd
         Qop4PAhmDzMevgt1EbsgImUQpogHy0QbKkLXnWqEdD37H1f24GiLePuqseKf9zIuELS9
         aKjFJHyZ2aNSpdJqMyg75o0s7UMkU47CsKAwaIc5r8O5FxOcGLd2ABcfdM5yWPVa1yLK
         MrP5aLqI3KbGaO8O2UWWOBm0EacU9TNfc0CDQWcYyPWzT8JRmKEPnLlJlv2yUfR8JTYA
         2cug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784023564; x=1784628364;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7SkMYn1pW8LZr6abBIJ2z33PKYxNNOhX0ZIHoUiS7dk=;
        b=ktjSK+Bk1s49H73RkyDPb0XTw1Yrp3QVTngc7yVn+7dABz6t3MjdJ/BhNzZjXl6uYe
         fwtGNpwzNZ1h6cvmuiXCKWcEcbu0Q7LO+M3xLXEr+PWmOLfs9KYm3yypIhbmnRMmLPtH
         bS12/0meFa/y9NJPN9DpCUTzRXT0IwK+HoImXS/dzlDj8RgW/xvrXiGrhwaoFOl5Z1vV
         YMNZnCJYtFWmhfp8N++wOgAHH3lUzHh3+ISlnU8WWGxVLk2OjTpKvFljrGuK/LZ+HST6
         vfE2CSYStlfXu42S6B3JvEBrtqhYYJNIbICF6dbzQOGD2zI0Zc+IvWGznfBWz/dBRgVk
         tTsA==
X-Forwarded-Encrypted: i=1; AHgh+RoTg0ptMvn4VL3RsdWh+KJIWtCPbOp6BkM8SaYtwZPWjN9NxzUaHWQ2dchucsccz1ESJ8icxKYIa1K5kJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOMBChN6HhpiGIIONJ0cNCnQYl/GFOwmgvfz5rfzm2cWCPoJ7v
	pijK18viP9gjQ3Mqm1faVvapHFzX+6QIUpWBWVYF1WPpxPW+A8I3kqyH2eD1vcP+KaPKXeergBM
	yVTtJ0V07w3b2qiTzBnP/33K4NgSCmddwdICT1cEw5f+PZKofSIqUq/1YMrZcwfbIAwyYII0rn9
	g=
X-Gm-Gg: AfdE7cmK4LzMkyqB6sBrl7xfadoNq5tf2HBmDK32zjGF/bxP+Vph5H/gxh9pu5vpB3x
	XlLkQOLnIAJ/Sv1wntM+PPOzEJ4x+ARraiseXZJkF+3mkQKIQeRo32QzdIHbIrQiA14/QDF1PHl
	0zklRIC9VY1ekGzwrPz/n7T8p0jrEISy2fKfdlcMDdf6PKtV2yq97pyLKv9Vub+NOEOvvGAaCdr
	csoLU5jJibZoWzjhaMCO0wzF2VjUgEMe4gXOMP7tBzuNC20VwH3uuYKX9GP+6blRXxzd4TwDJnG
	ovjWGnfXlUw3MLMG4giV/S/SsbO9DZZ1cAY9M+4poVkzU9jB3j5+DA7W2LsVd2PwV7ZPvK9w2fj
	tlOwSKs+vKVScY4HQvPs0UF9UzE7ZT4+ITZkvXDBXCYW5
X-Received: by 2002:a17:90b:3d8b:b0:387:e0bb:5803 with SMTP id 98e67ed59e1d1-38dc7bc3194mr11380406a91.42.1784023564173;
        Tue, 14 Jul 2026 03:06:04 -0700 (PDT)
X-Received: by 2002:a17:90b:3d8b:b0:387:e0bb:5803 with SMTP id 98e67ed59e1d1-38dc7bc3194mr11380375a91.42.1784023563734;
        Tue, 14 Jul 2026 03:06:03 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf737bsm112653485ad.19.2026.07.14.03.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:06:03 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 15:35:15 +0530
Subject: [PATCH v4 4/6] dt-bindings: crypto: qcom-qce: Document the Shikra
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-b4-shikra_crypto_changse-v4-4-06a4ea97c209@oss.qualcomm.com>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: fsWPLIltanR2RUUnnDvcmUq5WbvkNOvU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX78iF8kIaiLG/
 Dbv26bHe1UKaU6ilypo9xzusf8kYiPwOciSDj6X4Sdd1eqWIWMrpGUbq0LlIA1uyoKsK3chetwC
 eoGVps0X/7m3ravRenY4q6JZgcOSPTY2zk/cs7g78ckFOSbhBOn50Wz7T8nuG3Jk7ZBGznUE47I
 Xu+ZzperNXZuXNUnNjkxTe8sOFz6AQFwPsqgDn4Zl49rax/ZaC/uSjEI0CkPhuvdNjnQv6iCByN
 mMeWH2u2w92h2Ly6cnvPUvhZUHW/i4HGClyMRouAtMJP5+Wdea/PLIJP+k17eym0hVb5+ntWw/t
 eAzwLf2gqB3JFJo2HMDVZ79S9v7tRMX7ZJn6SnqJMGmQd2MBXVf9LJJxGcNiRKh7R26eSAMYu84
 IJt6lVNtSL0BL4sOjwAZdMZGQ13+scmUtsPHqqHSdt/v0oCMkJDvDnIxxhUo1EyYd0t+gqYOq3d
 lkFgEHTlK6Ip7lUrRzw==
X-Proofpoint-GUID: fsWPLIltanR2RUUnnDvcmUq5WbvkNOvU
X-Authority-Analysis: v=2.4 cv=cN3QdFeN c=1 sm=1 tr=0 ts=6a560a0c cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=mnL63iHeaYg7R5sIRJMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfXyADJLh/4RI4m
 5YOxN9CB637KxATEP6+0Wr6M1DP4nOneyLDxxBxDwKI3S6Bh6ReSTbquOY/nsCAzvzoeX2tOmOL
 hXC0XX2YavBPmA0E88kLZGfKKYAkRXw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140105

Document the crypto engine on the Qualcomm Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 08febd66c22b..5a653757ee75 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -54,6 +54,7 @@ properties:
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
               - qcom,sc7280-qce
+              - qcom,shikra-qce
               - qcom,sm6350-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce

-- 
2.34.1

