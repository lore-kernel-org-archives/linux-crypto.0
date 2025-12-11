Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C2E2E7F3F
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765442713; cv=none; b=Cbt8VFIOqvW4Rtxkgrq6KqjZ+datDjGOFP2veC18e0/hYIIc7435grKFaBTv6GTxlG/jV/QEqfES7EMcdxJ+Y8gCyq4aCV1DfU8J9yjbr4bt0kNbmwdo/VOYD6kEc2ZXNjuF+vv5+BJA5r3fO9e8jdCphvKd3voreCfeUnp9NAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765442713; c=relaxed/simple;
	bh=ncT4TM0BBAdDbGM9rh5XCCjb/AfVMYnF1YPbwGMv/zY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XuatGshgkqHt80tW7cAySYvXaewgZixNdyiv2d/46iTUKIXTbIUFyHUOGusqsM5A6/Tudo4j7Xai58va83X5oBOdHDUDQdkQYv5bPWhdxjD9ZmwE6BS7iQpMzGgwDjUwmQU4IiZZCdmD64rYh8aL4j3pa45mbemY7nSzBytn5+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e9j1wCv2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=joovWI5i; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e9j1wCv2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="joovWI5i"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BB8gW3F428759
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yAeP7YPvuxCEZemk/uSlfzJ3SDOLL6hhg2f/SgVkZ64=; b=e9j1wCv27dgiGXg1
	BC168U5Knp+FRubbNVlhhFFENCedCb/4xs0ng8KZgrmVlw1ksCtYW9D0Z3OS/OcI
	bfYnwr5E4dN19Su1rRd1ueN1BT0ore3Lf//OJTreAEh+vGxzcd7LegtbuNIqrebu
	s5791M7GuXe+b8RD/ypKVG6lHSWX5u8Y6drLOAIdJEIcHRl57BiVeimlAEeYivVN
	+S3N18SG4XpAeP+EXfVATUw2iEGICNWIrsSmOzY9S72BiwEFuIz0r37Sb37T0her
	WY7VwCjnWdF1seG+lyRdxfQ4oKQo/IATsnWJE4gNb4WWgJRzMQ88sUDppaheB9N3
	WvQ/nQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aygrx1pqr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:10 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29be4d2ef78so16044925ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 00:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765442710; x=1766047510; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yAeP7YPvuxCEZemk/uSlfzJ3SDOLL6hhg2f/SgVkZ64=;
        b=joovWI5if8J+YbT5NmYYeqQbbpGgaSYfCKbjzG51YGheAlBZx9qcU/n/Dq/jLrdP5l
         qsH1cdN7Okxb/5NJZmrmdpq5hfTqMsTro7LfajoNSIu0/HSGNF0YkTpVW9+pXqg2CMIm
         aZToKNVJRToyUWDCGGbIlvSfzdMdVk94f8qhOnF4EoZ+R42Z0SefH5gmMpH/ApJhWyz7
         4ZnXFUmG8fwlrRf6nSWXi99volvsblaFWiPO4XnMbpRidS4TuCNQp1Ge8njpBgQ1ZLRV
         XZzmLWY249zItD2AKzmo4OkAPa5PyQbWUCRh77eee4CzbjBRmL74GjLWg7pOw9lNyt82
         OiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765442710; x=1766047510;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yAeP7YPvuxCEZemk/uSlfzJ3SDOLL6hhg2f/SgVkZ64=;
        b=CLWVe+7bN/Dc8BMXHv0GiFV+FUbe1HUt28eEXabVTns/yiI+9m3y2kPynS6jRWsso5
         YiDfEBbO5ieLJ5GTMabua4FZqApJbs3YiYmJtROn3svOLMmGjOlnba9pr87yaUj7C4gg
         J0T7JSFAZfa+KXvzvksGeff4gMA1eVfwTc+0PihVJzOU25IDS/5i6gLmb3d01jfwsOhw
         Ln0ZBcAodWfROX3/CkCTva+Ry7OKxAKZkNWXVtCsTy7s8ay0WwyFgEQfquNtm9RVPPzt
         ZjIIfXP3XMyjudqp5gN748yURRsgySXcPF2fLG14rkbcmUZu9xAQczGanFVRE8zRf0Pp
         3YBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJfpL1dygLk1NmEB9Xft+72vf69uXIO2yhxuh3B/Z/NwLZHlZgEFomA+MkbaJruJ0aPt+UyP3cMfBvpxE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeyrvhxYcuZCZPHNpwCidlDZ2eax3AT86QLvk+U18v+uz/O7Pf
	uGPTe7zgNGA1nMcLk/Ug4u9B0EOEb34gd8558ZUegR01a/xZDsXLLFLaBPsltzpWtlilzCbbmwr
	/Gim9I0MZCxkP74hvcgCtUS2fnv918ThXxpe3nH7kBwYsIotJgp9zC6b1k9EZ8uWGmQ8=
X-Gm-Gg: AY/fxX7C9MsODfdP9rDJT66+hpIhLWlXWN385csv2G34gx88UgF5cdJqHgAIunKkEjf
	yl96shFN+19E/d0VJ6WTdXtjIXIT+9JwAhykEWsIi8kV8ioOpmvm2XfJYVE+44L4tmWKQqKJR6Y
	Tp7KcmGXSjrSBguSu5EosFiWbOAa1LULbCNpaNpizUqrZhGajFfJsAa7oLdUybkA5nlGeJxrrP9
	t4XWjg5VTD7atGbO808QMDAYoSFccHkUZMFrddaFR2EQWCdO8wJWOH1immZorc5BaWxSD43zrYe
	Ao3tF1ljS+mkZAEOE+fmpkEr5drNRHyfaltIhGNanhvJoUYJPsqWc+jDbB0/TznRfjcAT6/rtNX
	xoUW2NRdLsDPY/qSAeGXY0XTJK5AISFbk1T0=
X-Received: by 2002:a17:902:da8a:b0:298:3892:3279 with SMTP id d9443c01a7336-29ec22dba39mr63865595ad.17.1765442709794;
        Thu, 11 Dec 2025 00:45:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECW+SZtciVJJlEW1vxKBUE3GmjNq67nRoMlXxJgDyCGyr4xAKUvTbfQNGpwWnMp4xeNjMdbg==
X-Received: by 2002:a17:902:da8a:b0:298:3892:3279 with SMTP id d9443c01a7336-29ec22dba39mr63865255ad.17.1765442709341;
        Thu, 11 Dec 2025 00:45:09 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea03fcd8sm17322105ad.74.2025.12.11.00.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:45:09 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 11 Dec 2025 14:14:59 +0530
Subject: [PATCH v3 1/2] dt-bindings: crypto: qcom,prng: document x1e80100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-trng_dt_binding_x1e80100-v3-1-397fb3872ff1@oss.qualcomm.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765442701; l=832;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=ncT4TM0BBAdDbGM9rh5XCCjb/AfVMYnF1YPbwGMv/zY=;
 b=2xAoFbKOyo1bwOs+4X2yyjMcnP6nKFnvmRLAoKWNWHCf77xz5DEcHlonm/42r1+5t3WVEnfKm
 UwkZwE5zv3VBJAxah361OzxtBwD66GQyttOmM90TpprCsUwuRTZ8CNf
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=Hc0ZjyE8 c=1 sm=1 tr=0 ts=693a8496 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=-yDIlTExAMyGpBI_tPkA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: Bj2r7EnQcdLtSCV-txaPet4ljSx1p1AR
X-Proofpoint-ORIG-GUID: Bj2r7EnQcdLtSCV-txaPet4ljSx1p1AR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjExMDA2NCBTYWx0ZWRfX6j6AYQRzeYF0
 fNu0pJrC7vaYAn+XUOT0bJCt23n9roYoF5//FMQq3Li+98AgPY9bua01Rhk/C0DFH4LNzIeUgFC
 qCCoPasUoXQzMT9PNouCD0Ax2HAusZ45UjcVKTGJNb6uEc/8GYCd2DbDHxff0tQt/5WH4NSAApU
 Fk/VAZCqAVWRZCh93c+qYfGYQVRamQZJER3OaIcvZYOBcX1Mnm5dfTNbhUVEdhHOUNADlwgZWI2
 GNKP0EWs0XNLrcIwWMBLa5ZTI3/J+LVwuMIi+Z1CWphg05zS66/9fgMV9wVWk0iXkJ9GkPFkx7d
 D7zL8Ojx6i9ZTVc5GN/gvfMj0Oafu3IyPgw/dbtVldHmyOhLAbcQl/DssKuS29QS3q7kA2QzLav
 GZksEtb/fs/6fEjKu0TK+UaPZv+O8g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_03,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512110064

Document x1e80100 compatible for the True Random Number Generator.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index ed7e16bd11d3..aa3c097a6acd 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -29,6 +29,7 @@ properties:
               - qcom,sm8550-trng
               - qcom,sm8650-trng
               - qcom,sm8750-trng
+              - qcom,x1e80100-trng
           - const: qcom,trng
 
   reg:

-- 
2.25.1

