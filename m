Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174224;
	b=TAsGqGNCnFUfTcrVlrjgefnGBbMDS5r7NIfohs1kPL8jNxCoSF6PgdE/mEL+eOMYxuUF
	 1NmpHPRvquoNS3UV/5PUkSE9UfNKVHHKe3pE4aKQNtBI7HMUMdXIhLlTwztXnYQGH6M3i
	 kn04kxSxt4wH08kHKn5toBxFSbVqx//6aczz6aXupig+zWkYdXqv/gVcRsbAmTmCXK5H2
	 T901QflLZQ5gcSv1OR8Zzmp6lp/vkatGhfayboiH3LLjQNWA4PLhfq4kFZrFbyp3Th9Mq
	 Lt/ls30lVbG0ya9P21+Js5rQXNjv1NtxOeZBBtlXPtaQS9gRO1JAAtxj/DLfXoeJgqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174224;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=;
	b=R4FVTuPSUAZXR4Z324eTvLyCnRashYIlmRXA0uJ8yJN6gdEqcmClAr1CPcjhkxQidu61
	 LnedN4Smn9PIDhfjQjSEp80NBHBtyljm7cG/L0y5ivFAvye6HBj/b5K2WnHymkrjs3ojo
	 5ZlcUsNnTYt94haXlIi3sgtk12pk/mWihVVZktq89DuIHF+2cEFfsaivLzZfGw8+/Am1L
	 gT7VMPWUFUW47knh+c3HL0fJPIF9u7Q7qUXFnJOmu6E2jlkkn1VgGVJDeBHyq94qmylOQ
	 YQDW5DfoxMuN/sijUxIpylEhxYDnrP8Jdqded7XfnkXm9c3Ma83X1HzDIYQmS4c2n9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cPjXIYET;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XRUeItWR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA82E606A33F
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA82E606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cPjXIYET;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XRUeItWR
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKBKeAD1137555
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=; b=cPjXIYETJtsw9lh3
	xJURsJ6/9D35NP1OWydV91E3GCvAVaM+9qJV5QTRNtbpEkHEJDTzoPemzdiNG5BA
	Ok2q0pHPET8wriTGGRqSA3NQeQTCBxSirzEX/VAOUjYHN4Ot4TrXNH7gSZ7CMZvP
	idzUgDOymbest6qWodiD0M3NJOq8AUReFrNpv2gkfn+yXVlHdvupkQb5vxCWayVp
	pPpgfCuUHsX34bWcoe/Z+wle1pm84CaAg7N3qeVNnoqnja6HuPjKUjbKT8+IPvPI
	jFc+9gZhgz03bG1espcz2a95hIzwgW03sY5kZFYoQzRNf4oZlBeH7KSrx9OwFhbb
	6rGeig==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j27fykdss-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:30:22 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2f045e399acso5209105ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 03:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795174222; x=1795779022; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=;
        b=XRUeItWRpfl2+5sDeT5swyjh5+TLiyV9WojOpYLX7Z3I0GJfsUzdcwmcXpTNzkb1R3
         D34f2i0s9YFl4QahjGrkKhXVhZHwa43YdL1+DK9o9xlGM+sqkUdli+7V7zuYw0gEewC8
         vaP49wEWyl+4062DC7NIzXL4Q7tfy5Hqbn/KYszdfM78OR1/LmuWDjP8Ud2GjSZhkcPS
         f9e5J/QQEgwz2QkRvkB7EbbQXZ2872JK02B7MFPrnmkgbFPs/QvFkfSdDm+ELkaQXn/l
         KDcWpqT7evgp+WMRcwMpit5Y/PXzMjT6l4rGFAyM8ufbl+c9NuxhCqS/8b5MoOLc/p6N
         JPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174222; x=1795779022;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=;
        b=S2sKkjP6o7pQ3F6cKLmJ3cHvkRUnJkG3N+RpOyIMaN6hvTJ3grvQmq1oZd36LTM9F8
         GNemgnTr0m3JGN0M6Rj75LDeW4GF31hJFimLAGdMAoPeMNegVDffFDAaLLGDfVAw9Pvq
         P0RSseKVmfwzD+i/8ATWCp9xlsei4hNKZ0gyNlIieCm5cKirLPtuYImOUdfvRWyZJ8v7
         9zUCJ7FmFEnLo0OiaJEWL0jjSByfoSszfmK7/BgJ55JeGz/pM7SV5OGKjHFyhFXU11nW
         H+V9+EvaISkUBZVNBVYLmI7Kg154dp+xjuu6p/VbstpkStXq0yi1x5XQrUpbmVzmoE9w
         729Q==
X-Forwarded-Encrypted: i=1; AL+hErEFX556+iMBu6wmyJrJba1YaAisFNg2/P7v84tFU6PaO5xE2FrnNizPY5VRhygOi3K5YBZvQ7Fs5QSYFHU=@vger.kernel.org
X-Gm-Message-State: APuU4Z81GFe+8QEOSAqNO+xzMhDUe02QJXc+RH2AhxAYKxr0UEf+MrFy
	wqLOS76WqK5/1Iam1XOCYBFKKvrlgpZPpWqqbdolyZghgcmFjw40lwd2MFVmuyfB2DLivTbJNh9
	TDsPiShMvTAPhF7ZtzkQxQ5lxBbEQDiGd6cV4Gt/Es8V9sust2Z+A/L9HGVJheXMJBZ4=
X-Gm-Gg: AZFdTZekh61BJ3aOcRuENH2+2A9mDvNSa7ok1zLfI8C6KQ2J2v/VEwRFf+fV0e/PGXD
	lLm69AVygpEk4yiOR+aDuv/M1rPFHxEACQE5OdWcPWO8mjL96zY6jlU4y7rt7NLnsz9DcKBI/eg
	fOweoVT9t5ZlcFj7k0CRu2EEW/HoBgT+3qi6Evbx4jrvl+f90kCrY7PkWpXmejDomJ04Suawk6B
	rXQ2lhH5dP1zsaIHAVmgz614P/6/3WQDtPpGacdfCvAbTlJsYbWVOyyXiyhCOeNFuwW+G2HRGt6
	jYnPwG5Zkb9goQCOpIWm2+1J/Qnt+uxalW05QWTOrAOWc+fk/Yctj8QhUJLfyjKKTzH97BJTxw4
	sbEtYUq3R1e5L5PIqaMcy3FaEUztWyNgJKtHz8VlW9dozWPxlwyAJ7p2jO3knz9vPRrpsz4VldN
	fw0ONrvZY=
X-Received: by 2002:a17:903:3bcb:b0:2f0:44b2:648a with SMTP id d9443c01a7336-2f044b2674fmr21097275ad.42.1795174221659;
        Fri, 20 Nov 2026 03:30:21 -0800 (PST)
X-Received: by 2002:a17:903:3bcb:b0:2f0:44b2:648a with SMTP id d9443c01a7336-2f044b2674fmr21096925ad.42.1795174221174;
        Fri, 20 Nov 2026 03:30:21 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f04f6049dfsm2751245ad.19.2026.11.20.03.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:30:20 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 20 Nov 2026 16:59:52 +0530
Subject: [PATCH v4 1/2] dt-bindings: crypto: Correct Shikra QCE compatible
 hierarchy
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
Message-Id: <20261120-shikra_qce_fix-v4-1-5249e31394ce@oss.qualcomm.com>
References: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
In-Reply-To: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0NSBTYWx0ZWRfXyXQr9Dbkp1UZ
 Z6nt5Xhp/Uar030a6suIA1e5E4FU55pnO7qaiBxT5M1uOtbRerwB5Ky5VMwwA++6ifvgw3IeXBW
 a9wqC1x9wd6a5aawQauSBlCH03seVQU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0NSBTYWx0ZWRfX77k+7sVPanPz
 1t/b2g8dZbNr4Wjy/7BAr9p/Gq3cBitSW8yVRtfgBXdLOzdt4i++QuUw8FQWzWk7doJNFEn/xdA
 Fnu0nw0hPp+0w9u3P5z4OpfHsx7WYZjVobZDZ843hL8mssP3Vk7Kp+s9WgDQSo1UQJbSMKbVnSf
 vDncRRqUciYEKHjw3n2xXTN404gpO321hpHIyAMWMPkAUR0Ub04caUDcGh3T6PaS2w8ncnjHki2
 bdMTOYiZGFWCxF3R5WSF1IdZ0d327df6IPQAgqM3UtsWamieysBSydQVcsRmBngkBTcWsutEpVV
 NzRxe23KVD2tl2SdtLcvZ6vsyGIDaQ5ih8lCgRukW1aRxg+7bpMdQyPyTgffjnwSDKoxehGmzIA
 ScF03Z4u715XuV7GX3w5XJEpt5pK5rbfV79+diJHPnkQj9Mn+0OBZZYGfY13Vh+6wuvdiQh5tXb
 5d9/wQEeG+fvFHV5j6w==
X-Authority-Analysis: v=2.4 cv=GZKCDgXL c=1 sm=1 tr=0 ts=6b002f4e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=BEl7XTdPtaVR2fHMDO0A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: YLff0vir5pdKNoo0bpEOic6dtjLYqGhX
X-Proofpoint-GUID: YLff0vir5pdKNoo0bpEOic6dtjLYqGhX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200045

Shikra QCE requires an explicit core clock, while the existing
"qcom,sm8150-qce" fallback allows the clock property to be omitted.

Shikra follows the same QCE clock requirements as QRB2210(agatti).
Update the Shikra fallback to "qcom,ipq4019-qce", which requires the
core clock to be specified.

Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 5a653757ee75..fcf725bfa36b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -39,6 +39,7 @@ properties:
               - qcom,msm8996-qce
               - qcom,qcm2290-qce
               - qcom,sdm845-qce
+              - qcom,shikra-qce
               - qcom,sm6115-qce
           - const: qcom,ipq4019-qce
           - const: qcom,qce
@@ -54,7 +55,6 @@ properties:
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
               - qcom,sc7280-qce
-              - qcom,shikra-qce
               - qcom,sm6350-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce
@@ -133,6 +133,7 @@ allOf:
           contains:
             enum:
               - qcom,qcm2290-qce
+              - qcom,shikra-qce
               - qcom,sm6115-qce
     then:
       properties:

-- 
2.34.1

