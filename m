Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAAE3E9299
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369505; cv=none; b=aKXC7XZgv5c3Q9tmgbwOA8xBE67acFaOSSh1glOlPluGFzRwEY1rGF/ttXzV0mnwEoAfvNiDR4GD2rvVai6LEFfFyCZKCnsCXs+5WS56hItFRGBl7oT1GO/Xw/0h6bub5zyvM9q5aCbxXxDxOzhhLptBH6Yhrd3WMTM0XjiYsvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369505; c=relaxed/simple;
	bh=NTwlaax/lh6AG78S/JgsCIhqbIXpaLk3tcWX2JG/xaQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tP0IE02HlBrs2Ki/hl/xSKARlBcNOkQy2poeBIvtRyAdDvMbOf2+E3Ak0tIr+QWoc/82tigib3MTprwGaw+udOLRPa1hFgUO6MMhc6iB4W9L1InSxK4upOVUpn7VCV2HMJHCDsH/Aida32fAJ3aUT9SQL9nAeYv00yil2aUJlZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YzlVVREp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Bh1hvIfz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YzlVVREp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Bh1hvIfz"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LAXs27818832
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hMQJhPfnLBvDiSVCVF4l3ibrl3mzFihtcnE5yfd3vx8=; b=YzlVVREpIkFlU72G
	eaaDHr8OlGNN9XqSQxBleR+N//2LDh2Ce4STJzEVdNEI4KYKnaWha2PdXQHZr37f
	LlL7PpEIaiC2Pot5ICYHIER4/PSHJL/R5zYqeb/SstmJ5iO5CLpgwth8tKxWBnkG
	mLEHazhEoqi0daBpuXpb59Vbk4jBZa8fisESsSrcn/Ht9d/uWdTHruXlWXTe8Leq
	X9/iwt7RoN6Pke0itZSXpcKINtortlnkRMGwi5PDcgREuTYQugIvQOXRgBlWx6ir
	3xADQ4ghm5rcoJcLle3uSjnKq7L5teRKV0apHO9UO0W+Jk9oZ42b1uu7F5kOXZ9e
	SidbSg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea0dkgjqb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:23 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-83f24cd00f8so3298656b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779369503; x=1779974303; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMQJhPfnLBvDiSVCVF4l3ibrl3mzFihtcnE5yfd3vx8=;
        b=Bh1hvIfzV0GAsi5DZwlI/3eLUx53+v4T7Mnjj5bO6EKjHSbCFLWpvnr0mAVrBOpkQ/
         FRtVcx0kgHp4t66n2XzWbMUH/dmkyktWzW11zsx2jbsOkcABa9lcjwZ7BM9PS4aZhlQ/
         h7CHCLDpe/HQkTdbvLz9OzM8O5IuGAZk2ZKGG7SLsEWuFbC6AM3LakUPfwG2Lp1GRN6d
         1BJ+5ubOtM9EXIDzbhwg7SWMpg4lJXyPJIA8+mQ5ooAMYOslj9TbVEydkts3kGgCewRR
         AaVQxEOV87LIuCH1ejuM6YwpWxFhH0hDOdeCvuauAl0WMZkVxc5X+m2dzMVxOPhw0qeH
         LIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369503; x=1779974303;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hMQJhPfnLBvDiSVCVF4l3ibrl3mzFihtcnE5yfd3vx8=;
        b=EimC6tLZFL0JP522itO5rLbOobse0nePNIIW0ErzIJP/8tEz05L06+F18pI3lTo+Ph
         7jdFl/hsEB5DSmgcz5iMhuOvZfIhzPp6pZVNRnMRRvEJOfrogtqMCSkLJFuqevRGI6hK
         +0LS2IpHAvqJjQ+x2hbysphTn7HMssM6xWAqglA2dULoy4SBbVtCXmGc9heckVIcgOsp
         X++qZzKXuWyTlEu16xGyFgwpAEUzxkf0Mn9fMPn9i8fovXt3/jP+dO9eDbDkIhR8//Bf
         jlrJqkQH7yhUDVyl3Bq8XxOB/VelvqbBboG2XwJUJjcc70+EWUnyDYh2/qRk7M7iZxxR
         fPQA==
X-Forwarded-Encrypted: i=1; AFNElJ9ijFxQM+KUc0Ea2qQdgRMHrbtZvihXSJAnOKudSvcjwUV0OafBdoCT5OQeLAdHXaoInlfWy/wxXnWamvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlpaprIV+/Pxnoo7hQ+43NPzE1l9awnDskcDac+n3FV71BI+WI
	m5b4zt+GLEv4NwOnDHRJR8Nm3d427zu8efeE1NRUXtDtR/uXUJ7F2sONxW/BNcxIgUMJTLn9m2K
	TMOpLKpy4WL7Sc5jkxyBZLKmvvAof4iOB+fjjgrn6yAEYbXrMARApXSj4+oJwgkbfMwY=
X-Gm-Gg: Acq92OHFIMfBhsSSVfXAaYJHWa8FvXivGhmvJ2lpjBUzZAsYCIQc3y3v7vsc0/LGLNq
	1mktpsPbW2JXujWKszQj1qJ3ZCExBBeSFKUfGvxiFigxzyyq1hc8283C2wxhVZ+QzwVdR8pZ8R6
	Gm5IzN70WUdE4YUHgoAqK39T6vIFPqei1qcstAs2hbAoEu0CgcM7cAxMQ69vqvdLvM8jOSLYKnS
	3rV6fmpzqKBBzjaKyM+lb0edzZUONmvuD2ScGaK+TlODVgaAZ/Buig8ToqA3DpC4EAL36VeScHH
	GpTyQH0oztpW9tw4RV31ZK06qM551h3wCEMFNYa9NHYyG/6rS6krpC+mIA2GpR78DzKKoac7Xsk
	d3mNGX1YBIfye0EO4C3XZETU51W/rg5zMh/QbY4oPsBWQL0/llFoa1nw=
X-Received: by 2002:a05:6a00:3394:b0:839:dd77:3505 with SMTP id d2e1a72fcca58-8414ad0bcd3mr3150662b3a.22.1779369502786;
        Thu, 21 May 2026 06:18:22 -0700 (PDT)
X-Received: by 2002:a05:6a00:3394:b0:839:dd77:3505 with SMTP id d2e1a72fcca58-8414ad0bcd3mr3150613b3a.22.1779369502244;
        Thu, 21 May 2026 06:18:22 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154e22f1esm1687731b3a.47.2026.05.21.06.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:18:21 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 21 May 2026 18:47:10 +0530
Subject: [PATCH 3/5] dt-bindings: crypto: qcom-qce: Document the Shikra
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260521-shikra_crypto_changse-v1-3-0154cc9cc0de@oss.qualcomm.com>
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
In-Reply-To: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEzMyBTYWx0ZWRfXyTeT47oryDBh
 7pWRo3dd4NR8praND5NOsxHOpdDagL/Y6f2hezHndDeGnd/rkicghVW9ZCTGbKT2iUrASJfIRMw
 vHDKq1L3c/U5CBOLlswLz+1Q5alsH/5k2TaohmGuRl9YXfj/7g6AU5Q6Q/R13KXHEjys05AniDo
 MVk8LClfTfnzW0JgJeqQHJYjRcegAFrYz8k5McE+Jkf4rCNRe58RSKHpGOrhuCiaC+2xIAUtLBC
 lTvzjCll5qRadJ7uUn4Jzh5Mu9K0EmkSGUPuN19MvJu0Ctw4hjysFD/MP81l3+EKhFSLFxOqWrE
 CqIko5MYQMGTr76bFKVZvEgimByTNFSdEsBUCGhx8FmwE3xB4Cuyfu9edd3UpN0kv17xL35tmPl
 hazfcK7VXmnvl6r/wjMagzy7f0Jfosi1d9F+NG7Hg/kRwfbKdOqkKnHnPiczXGS0ogd4q24DVuz
 nlpLbpPBURZfW7LzbAQ==
X-Authority-Analysis: v=2.4 cv=aueCzyZV c=1 sm=1 tr=0 ts=6a0f061f cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=mnL63iHeaYg7R5sIRJMA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: mp5VQfrkC-C8ExPc1SfCE8xdjC4cO1nZ
X-Proofpoint-ORIG-GUID: mp5VQfrkC-C8ExPc1SfCE8xdjC4cO1nZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210133

Document the crypto engine on the Qualcomm Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
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

