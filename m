Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F929D289
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758757118; cv=none; b=Q2wCWqif8tAaL8ro9cyuHhLUHQFxpMchuBkhaoAob3OPnPrnTX2f1CvCVcDsWfFm7+dKId70opepfrAH16g90dm2SRLOkF54FRjdDDuCqrS/jjA+hhNiqYiu6wVMacc7A6J8BOJQ6Bp4yeOV1u4lUHcBRsAsdpesUMp3vJQfs/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758757118; c=relaxed/simple;
	bh=R4a+xO6YzjGKd8+xDBkkEFUU0Buw6iW5iNLWRTb2GL4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VAKtTDfN4qelpnrsw1anrJpNyg/SichYHiwXxHVO7AEOGT05P3RNZPGIyjDYBjrCIThJyUJYdMo6npMeiZsESuyvRYL4d1YAWo9GCz4Iw935Q3vT7FHh0EEUGfqmvRXYfpNlBXsBoY8W11+3voz2uASvXeHBodFJsdybjfX24ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=io47iIWU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="io47iIWU"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OD4AHw002118
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m6EJyLoah95Eov6Jjxf32aSHBqBRimx6jvDy8Jf6Bk8=; b=io47iIWUbookm9jA
	D6JU4qBtEOB2Ko6ua09b2HQNoldSEuHnB6b/PXf7Bs+P5BVKuvpkV6+bSW8Ryz8h
	hqBdm7BU88WdJ5/vJteG+XywxkXym0A8xlvXy+PVrJoOTmePSD6AutIIPiaJr4Re
	qyGfol2pPQ6o9bcEoNS0NBepLdPgfGO3Fdus0vNSGgDFrpoZHO2DRN9sUNaBhLMT
	2atpI6wGF5KvUOWNsxMZS2FUNWJkapIzJQC3Zn1QY3fKlahux2vUZ6pUpuE/fhI4
	5hhF36NYdKdx6qQsvIRcL/bynZjC+cczSuS/gq5K4oN5t2D98s082MXQ6V5oHt7b
	8VzMkw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 499k98p2ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:34 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-780fb254938so332774b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 16:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758757114; x=1759361914;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6EJyLoah95Eov6Jjxf32aSHBqBRimx6jvDy8Jf6Bk8=;
        b=gb1urgQJxOjRJYG3x47M0EX7S40mRiSNU3vK0NY/+zroPbGgn3sanTrU5yWEkK4Yjl
         Oft9PcWiUCdiynHUvd0B+W1Y+TcmyhdfriihMiduQz5VOQm97EOEDZ52aQOyjlrYDREe
         QxHweO09EKtqcWfvNgoAXdz5rcb6Ch4/IZp+lKWGRORZt/2zumI1uVuADQER9sZjeifa
         9IAhF7GCWo1jFnuu9KGbIpnmUBOSFrflx28hdahh7Jh3g9sNad5MBfChSXbTQp/E5VQQ
         ycFX9mYtdUJm37IkluCyIOexET0LEdGx338sXEqJQS3AKtQQGr1qRTijOVI0LpA9717B
         sgKg==
X-Forwarded-Encrypted: i=1; AJvYcCVQgxyMj5YaXeNq5EUwrusaJXJSTWG8zg5z0vLh+UcH08TIDDIMfps8rPV/y5AodrvAR1XNKszSOq/xQys=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdXqqfYJWzib8dJVwhOrQ5rMasD1RbpfOctPCZzOG2JxsEOj/y
	MP6L3odtFoRlOVSScKF9mq9Ps5WAq9WPpCmoruRzdwUz4JEEUMudBnHNhrudeVtMCv5+2qdVhtS
	abu7UjU6clfF830pO1i4Vhf6DmACV9OX88dkGJueWS5fyxbVUzcppBJDuhgrg9dmtV6c=
X-Gm-Gg: ASbGncuTVkLxe4V1C3OzvSYSE5RxAt+QXgp0pPQX6SJCjuEW24br35Duucmr6udi3Sy
	2aAYGA4pqsqyN3N4F0zoR0UBj0OIbGlEp6bJOshclgNuYh66di5M0pB70On8scfaSYm7eico/Fk
	S7xUsq6fKgYQ0ghuRCJjJYeOSl+BQNrfDK+Ww5M2ofCDuSx9rDbidQoligCauiES+IOtZjmcvU6
	RcwgCLxZtjHN8f4AY2byfQ05ooKHwnkHSfkDOJNcvepcKH/GaHnsXK5dRMIkXt/KkLY2PGleWwz
	sbuTOD8foSIK6srYxVe8dzhKMNh6DyqRGhMEFroFqJgi7eF4Xymms1d7tkI6pDQt8fdUJwvBeFY
	1zQ7lQhiVSCO/tHg=
X-Received: by 2002:a05:6a00:2d90:b0:77e:87ea:ecac with SMTP id d2e1a72fcca58-780fceb708bmr1759002b3a.24.1758757113674;
        Wed, 24 Sep 2025 16:38:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlduWD5j5O1dhgkaATz2ppoqEJZiU0V8pGBVFWj+WZPierk/jNzCpKicZ9eurz32EFTkgekw==
X-Received: by 2002:a05:6a00:2d90:b0:77e:87ea:ecac with SMTP id d2e1a72fcca58-780fceb708bmr1758971b3a.24.1758757113226;
        Wed, 24 Sep 2025 16:38:33 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102c0709csm177056b3a.81.2025.09.24.16.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:38:32 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Wed, 24 Sep 2025 16:38:27 -0700
Subject: [PATCH 1/3] dt-bindings: crypto: qcom,prng: Document kaanapali RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250924-knp-crypto-v1-1-49af17a231b7@oss.qualcomm.com>
References: <20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com>
In-Reply-To: <20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>, aiqun.yu@oss.qualcomm.com,
        tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com,
        yijie.yang@oss.qualcomm.com,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758757110; l=893;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=8JJMRPXwStM8oNf/K3bPstEsS8Hn9PWNKSZdyFsUQrY=;
 b=7ZtmwklUf3aLvtvgw3SS4Tvxs6sh6uvHucPTsyLs+6ggmonxS6D6kEI7Nn3EH/f5SXIdBiKVN
 mZelxeIg8oUD5vp1p6POExUGZyk+a+OI8fDDkp1D9powFEpnM02RF+i
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-GUID: EjQlaaXCxnMt-DnUNBbc_fNZ5lX7lCsN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxOCBTYWx0ZWRfX/8JNQ+ddxgq2
 wg1B6l6QzysD+pL181iSyteNjcMaEizrIPuXOainbtN5qqH9zBqpP5DzIGbFsLKosjo4rgYj1Xf
 eZnEygGF6E/WHdhHDaB4vb0vRLFnSTy4nafi+ycpLZNaMb9EoCphyX6FnxEjBzi6nfAuz2dGQ4n
 0KC8zcCpEGcri7Ft+ZjbgTYb8JEDzi7q97DVb0XRa+xMEzVqenUqd04UTbxI4rBHN+L6cNtrJKt
 s7wh5IGNHhl8fLuqCaqZ+d/2d6uXUZtiD/YmOLOsNLUfA0sfPpmjFa09Jz/qkqwS6ZpDsNX8D1K
 NSzFIH2uOCkucmHGqnWKqCnFKVKH2wv7EDwSyALxVVY8KG5CR8YT20wDf4tS399dkzQQH1XApBg
 uVpegXqU
X-Proofpoint-ORIG-GUID: EjQlaaXCxnMt-DnUNBbc_fNZ5lX7lCsN
X-Authority-Analysis: v=2.4 cv=Dp1W+H/+ c=1 sm=1 tr=0 ts=68d480fa cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=ou92kEv10uOBaGRFQZkA:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1011 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200018

From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>

Document kaanapali compatible for the True Random Number Generator.

Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index ed7e16bd11d3..597441d94cf1 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -20,6 +20,7 @@ properties:
               - qcom,ipq5332-trng
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng
+              - qcom,kaanapali-trng
               - qcom,qcs615-trng
               - qcom,qcs8300-trng
               - qcom,sa8255p-trng

-- 
2.25.1

