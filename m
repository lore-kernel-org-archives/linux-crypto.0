Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6CE31AAAF
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777019737; cv=none; b=ImvNK6cTYN+E9x/fWz3bqskorpUe8dkR87FkFCijAkiqEIXrC04gkWNEHmS2VITxMKOmAu3JmBPddzMg00pxxlcpGd7QedbUqXRDb5ty44Hr6GDUpb9TOjYw6qc+5bOmF1dYltdXcltV4TFLkNhIuISJwu0l9db38kcbuyJKkIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777019737; c=relaxed/simple;
	bh=dtdz/yukTGy3rf+mwTbyo7Nqf64WPlvGCi80RhNRT1c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nT5U/D5nRocKINYw4GikOEG1o7RDR8hGtxgXV+PcAUsyKkrADIbceqFgqBCg4RXLPMWi5S6GzlCuYgSiBB9m28/XAmFwhV1lAhDtxD6zvPzHu2PaR0md3rlhJPbuHcriobM1K452977DS/w8/7uN+xlgYBUIoHkud6L6r4OukxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WYsxF/M2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ni2XP+U5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WYsxF/M2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ni2XP+U5"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63O86SHI4012120
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	11xqZkhDlvKiZpuCn2yF3jv/fK0mKPjC429JFqQj6RA=; b=WYsxF/M2c6N8Y9pB
	VNWsgujJt0lda4ZJlNLhxqAdM8r4f3uNegF9LsisficnkDhp+1SusKyo37A7TQoj
	4sJ8Po9EerVHPlYm0ulnIItVNvfid8EwzJ7qCJ9lPJtwDF2l4nCfnYgeqF7/+Dgk
	d2Zfu2x83KrxaJZic2C3072no9LIRHrkdBiks5DV3OC+Fcur2pvL2hvcjFL4J84D
	UfiOHa/q3XGnZwdhDsSKyNk9cD19sDax/cUttYfl3hKtrvJM3HqjzTvAJYWKfUix
	ny9DsP/Kg+EAyo7hbJ/yD1CvhNmc+cwT3IEP/UqEPHSeHk2g2pwQOEVwJlQwI4Nf
	Q1oG0A==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dqpq9udhg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:33 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b4678c6171so77405955ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 01:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777019732; x=1777624532; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11xqZkhDlvKiZpuCn2yF3jv/fK0mKPjC429JFqQj6RA=;
        b=Ni2XP+U53HM2lpO1HC7LaEprqJGmoZkBJdLYmqBeKFSv5DGuZiaYQ4LNZ9yJE9ADXv
         8E+6b4c9dmYGpLztvKTXzWpOMd6cmOhMgGoPen1fqvYGALzXz8oF5PguQMvEMGtLbq6T
         AIxfYWm3AZU0QMqt4+HGY+aYSUd0UczPtJ704P8Me42F7kZEudnKRk466ppBwb9d+pGJ
         KtkfMG/5OsN+bF5UzXbM4GQdqmcOuScljhvzAr4Nm2QTmf3BZFzAClGAm4/0k5ME1GBj
         2ILxZKLN3bTSAQk3LA5LKdhlIFhwJGcIF00JfHmrz7aIESEuM0WbCAu1Myxr8L8eUrbm
         tKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777019732; x=1777624532;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=11xqZkhDlvKiZpuCn2yF3jv/fK0mKPjC429JFqQj6RA=;
        b=MRJaQaUxxUozzOwdZybUIdOI8v431+Cw97Pcehre7jonAmXKoIp1KCOgkNLCMuCxas
         68HhOBbkf9jgOM3oNmandiBnVg094YkiKoHFLMs/eHj0k9cH6zwzRe1g+fRGRQSmRMpj
         t7CfSGoOp3AyhEJml2301ltwbniuz25Ao6Kyn14MGtDnU1cdIqsEemW7FJRnCQoZz80c
         HJ1X/xI2mxA21OdJK3cg6PJNQzjmqmZDUB1W6g8N9YNp9Kbf9QgqZz5GIGOP3Lb3CfuM
         UrObk04L0Gi9AGZmzIub71F4N+NDY+Ddbvp23p/AtaNn2mXk8BDg1UmuBEu7ATyjOxrK
         IQjg==
X-Forwarded-Encrypted: i=1; AFNElJ8xNkGa452P1ie7wuNe9wxIOT9VMrSJVtB02qfrhMuEr6gzkTfeRwfJkwO/ZsUuln64U3lqxdNkPyzumEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL9kEgu40Hn37jFnOQm/lzd3xpJX39zAu+LXV/O8U4ymvJ1l+B
	a9TQkLPwDmP7yK6RjJFHmiJ9wtl2if9UwTSjTGZa6+PIvE5hLgGCnGP0IkNv8Sd773wnZfNJWGA
	WVczl+WayNtnzkdlmPW0L1cZTf+jClM2JTYiCXHuffsoE+K5k/epkhXwYEKYO0VOuRw8=
X-Gm-Gg: AeBDiesGZlY9vchPtI3owFTLvc1KlzKZpHGCB1+Z+AHUr0EfSOpvdHvfIjwmPmOK+bz
	O36E0urxwEqTAoir7Y0S4xwMsYe1TIIZRY5SFuaQ5L9jJhH4ftDI2B0ZNBgEHqnnD/nN4DKgdv5
	fHItAmOp4I3D10vy47KXbD8uU8ub4cqBC7GqgEMugPJDB4tY+FiySY/YcHy9gHNG5Ue56Pn+OjF
	+Ln4xtkejXpI7Ug/TV6xnz3mouuEISC99e3PZdfZ+7AKwIRhKKHd9tzS3VJnHD8YEDqBLBO1Nur
	OSLePrXxNQymD8AqbJOwK8irlM4m7I3Yjk1uamlgnvAqBeujSHl7atgm2Pcyk0aXjth2uhuZUw+
	i/5lT2ye9GJ23fwpXGwGqYUTyKsIqp7Fy6ML5Cu3YUCZ5OseuG4FwKOPoOg==
X-Received: by 2002:a17:903:3905:b0:2b0:7e4d:f43f with SMTP id d9443c01a7336-2b5f9ffe73amr295732835ad.41.1777019732372;
        Fri, 24 Apr 2026 01:35:32 -0700 (PDT)
X-Received: by 2002:a17:903:3905:b0:2b0:7e4d:f43f with SMTP id d9443c01a7336-2b5f9ffe73amr295732405ad.41.1777019731856;
        Fri, 24 Apr 2026 01:35:31 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm211389495ad.72.2026.04.24.01.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 01:35:31 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 24 Apr 2026 14:05:07 +0530
Subject: [PATCH v2 1/2] dt-bindings: crypto: qcom,prng: Document Glymur
 TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-glymur_trng_enablement-v2-1-0603cbe68440@oss.qualcomm.com>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
In-Reply-To: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777019721; l=879;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=dtdz/yukTGy3rf+mwTbyo7Nqf64WPlvGCi80RhNRT1c=;
 b=o3+GM87zYpuFf61xL2hYMWP1IKf/7pTwrji9hnNyymjO+JR2f+AkbEVLwXKnn8XobOSqGTrQ6
 YWe/xKzaH1dB8dX+xAEPGJrl/4vfUapk1BWIFKyM31dWhLWcJlf6PpE
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDA3OSBTYWx0ZWRfX/1+JFEuVkmGd
 TKgEogFPWz44iHwaLwnmsv4Z22wuGGOq4xuRIuU72J6ke6kPqZXLpUh4O0yyuAn9yZqTLb+8buW
 Jfv6bNw5c3CLxL1fLVpUJIsLTLo6ycl5B89MDrcShkfaijx+3TPB/OXGm9pu2c6X5BKYProl5WE
 LIwie4ij6hB0ATMB+Nfamb0RBZIuNNGuog1IwYceoQ0ybHggtzYAyCYMa2wY41ApRz2MIYekcnz
 f7Ws7UJAQx1XitAWAzsyQF6eRvTi+Atcr8BF/YHs4aTQzLq44mdRBtlFrfzmMfQ7peM6Vzy8xtE
 I1ZdpM4n3tfsgibnZAwYexCO19s8qbXkcKpuXLFdnDqJfMAuK/+4gBh5PZbl8zuIr9hXTjEKVeL
 iYFY5pGoYuKAkimnz2V5cPcPM18VHgPigkrOolu6QL2frCEbAIhCxudjiL4+zcN9Hwy6cw5JgLX
 lMcQ9eTM/yTswQ1WYtA==
X-Authority-Analysis: v=2.4 cv=FPMrAeos c=1 sm=1 tr=0 ts=69eb2b55 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=2IqcgDMfN6YEDlzvvDkA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: HjnCvjKhq35uiExADulQ7IjdsC3F86Kj
X-Proofpoint-ORIG-GUID: HjnCvjKhq35uiExADulQ7IjdsC3F86Kj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604240079

Document glymur compatible for the True Random Number Generator.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 41402599e9ab..498d6914135e 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -17,6 +17,7 @@ properties:
           - qcom,prng-ee  # 8996 and later using EE
       - items:
           - enum:
+              - qcom,glymur-trng
               - qcom,ipq5332-trng
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng

-- 
2.34.1

