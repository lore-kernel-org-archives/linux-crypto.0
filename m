Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334DA29C338
	for <linux-crypto@vger.kernel.org>; Thu,  9 Oct 2025 06:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759990769; cv=none; b=LMGhS4BydWeGvhzusLIMND4/lTvEkTzC2BNbNrd0mnsoKZPXckTFgEQn7deHoZkd0zenOojokvm84jYB7TioKoZNBuOfez+5vmp32AEhzliPEGzf4i4TLQZZZgt3Qa8fqk9Rm2osJfQqA3dsg5jFcDiam/2SQwe6lL4S3eiglN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759990769; c=relaxed/simple;
	bh=77PWjnqFF2rxLV6vy3wMYiqtmpcFtBrBVy4hemvoz/s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eaAjTF1147vr0v1vESTt0fkeD8jl12PHnA28R/S9NAW+5G8bJGa4KIAMDX13HisJc4y5tp8JwGvklMAucBjY1W30nkGBSFI/qrm4f8CwPF4VxlG7M1z/izWv1FC2Iw9iJTXT8J5twxiCHwfsbHibXgAT1JOu3SakjxmNQZFzU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bWeOu28u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bWeOu28u"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5996EQ5p029793
	for <linux-crypto@vger.kernel.org>; Thu, 9 Oct 2025 06:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5mHh+0IDbJt3IBXVxkofwT+y+G3d2HQhb/K1OzNac/o=; b=bWeOu28unbFVp67T
	48fWFmki3S0SMJwNhZsLhPD1T0egOTL4deGeqdgBCLrLKgD6RVt1r8a6op3Igo8X
	hOnZrVn/JNr5jJug1Qzq1UKUHSfP3OcaHEUniSYQyni/p3nTG7LuTkZyRh9MCjiP
	vLX7YMWbyFpH9IdQV1eKFx0LsMZ/N/FQsEVmcH8yxsWq71Y9fBuiUhC8abR2pPmJ
	lS4UpG4JyOySLrr2KQLuhfxoA2zpEcolqxeT+iEopateXLX0zbR+TNR9ILS1raTw
	mnlWd8yDZdP/Qz2DEbn69ZlEataOsA0rRCfhpNMVFnz3DAj0ZlF2xufNZGFVqHFm
	AxmikA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4n9pc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Oct 2025 06:19:27 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-33428befc3aso1653180a91.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 23:19:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990766; x=1760595566;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5mHh+0IDbJt3IBXVxkofwT+y+G3d2HQhb/K1OzNac/o=;
        b=ec9AMxmMt04YISwS0o3hecaRUiOEtkDQux75OdBlLZMpXSJ2YBZXpTEviCb20YbiMw
         ThzQwLFtSpaq+keamZ+WVB2Z3+9QupAkClCYtt2vBzzRnShDS1cnLYpVsyiFp+zWgdmx
         nQFtR1ZGiYQ630rMI4nvZV5MIZrxbAoN5Vadn4nCu3moqClmPlUuRzqphiShXWRnHnfv
         hj1Vxyx6MGoEQ4BagAiKiG5CNwUVZRV5ACAcLMA2dqeUrbY5O9nt2mhF+54z4FeVfG4x
         6VXLD5A6Qrg6GLvTBEQcq5tzlZd2/zTeFb2qrnE4SXTzg9pEAHNpOnBqMlAsi4WyIhnf
         J+9A==
X-Forwarded-Encrypted: i=1; AJvYcCVoEocPNyRO+NeHjsNfyzTIThPMhIWiorP+hXGxIcdQvIDOgbpMP1IEDEpz8UzTeyr/tKCz2BENtWGvfE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfFaxdBKQJ1R/125/8fwYsZ5u7tAsDRATtUvYxn5YUjP0kzc/5
	sHDmCUoWJOeA0yr+h+LMQlGYuryNb52c++xkm9+z0uLcCFyJtbWR37ebO9S4W7guavVXm7Wj3uu
	jlxG3HWDnjO1S/AsvgjCbBIt80gEEBrTMTNGkXXLazBzyO6s2RljRLrL5RDCadb7+J6o=
X-Gm-Gg: ASbGncuQ8e3DJGb7r3Rmls1d0mj+8RfKsxiu2rk04S2hCY8jrUinh/7RluAd3lIn3t6
	KDQNB+fB+5tKGhCUgY68ELJmVuvxOIT6yePXh4rHkmN6zwo+7p2iaAFWrSeC1egmM/I8yndfRTw
	sY3Tfd1SFwOpGJ+Wm7JGEqNApMy59OI5s7pJ336o3W6PHkTDM9WrDMQt7erMWqNP78GBWPxISso
	+DlB3qgeu5wNJ4pbW+LFCRn+taKV/WOCLcwq35e/KEEvDbEO5phxCyQyxcqpe8aNI86qierPDJf
	P6iqdfonZEM8USzKkjxCwBhnqILxrx64EyYwWeH4nb/0V/J+SXrFJwsFpXoN1doAIYm9dJSWUw6
	J3pCTtgw=
X-Received: by 2002:a17:90b:17c3:b0:335:2b86:f319 with SMTP id 98e67ed59e1d1-33b513eb68fmr8887009a91.35.1759990766335;
        Wed, 08 Oct 2025 23:19:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGxM+/0itJtut7tU+h/gHpRdUBjLHespHKzHtM0eqWK/DO9Sdpm+LCvvpON3YUB9AzUXE2zQ==
X-Received: by 2002:a17:90b:17c3:b0:335:2b86:f319 with SMTP id 98e67ed59e1d1-33b513eb68fmr8886972a91.35.1759990765735;
        Wed, 08 Oct 2025 23:19:25 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099adbcbesm19239671a12.4.2025.10.08.23.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:19:25 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Oct 2025 11:48:53 +0530
Subject: [PATCH 3/5] dt-bindings: crypto: ice: document the qcs615 inline
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-3-2a34d8d03c72@oss.qualcomm.com>
References: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
In-Reply-To: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
To: Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=ZJzaWH7b c=1 sm=1 tr=0 ts=68e753ef cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=0DGZwrxXYRw7ACnPEe0A:9
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: wFdL8VGhBtoRB0YcUx_7WBLuQaVToqPF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX6ACjR+iVqPuL
 SX484pbn8li4ysVGAKnHvjcatlc33G6MAFD9o+BFLfvHnobwfQUlF9Ojtv9g4zMn9a44qXS2Nn6
 W9DbbJvD5oyi669eyWRyDFDBIVHTUwik2eThP+t/x9Qtsm90zjhqy7iufaub/GE9SdsZC9yeLTO
 fZpk983Zmt8ljb8/6NaRss6r72XtdrQ11ysdcHBbycWa5ZJiycPPmPxdolBFSXGagavTFVXTKfN
 qXyCGJgefiqCbTKTutRijg1u/0a6c6SAl7rUiyp43tJiGxJgstet3swZThjcxTdVc9A5Kw5DUjC
 FTpQGIWxHnxFOYzctSaqcUqEDMUWh04tU43OCO7BXtt8kzw8NQXfJlw2aIbkMKAYXcajaDbAEZE
 GYEtA8SZGbkpqZYYcNicMKa68p+UMw==
X-Proofpoint-GUID: wFdL8VGhBtoRB0YcUx_7WBLuQaVToqPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

Add the compatible string for QCom ICE on qcs615 SoCs.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 88bef1d38013fc7d0e6842e370b2adb3bf3e8735..ea335d55070f0931ecf39427c59e2dfb7728cbbf 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,qcs615-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine

-- 
2.34.1

