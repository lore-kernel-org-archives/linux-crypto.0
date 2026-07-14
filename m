Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388CE36309B
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023555; cv=none; b=ukGcrn+HvO3VKDBPkeZAtZ9HciuUZjMqlzU9egQRSWcO2m1NCnPbc/cOo9IcSKv+/864cEFXa2q1Mo5pyv2Ovu4PzplJHw8w6y2ezuTE4IIWPg1CMQg5tWlTjoC9Le7T1yhRz11ewP1q3/Sn6mQeulK6oVslP829/YGpM4sspB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023555; c=relaxed/simple;
	bh=eaLOALOt3CvzVzqyBJIw46fZOpNHjs/TGcOVYyRBjWE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oNk9YU7hhO+HQeCwOti3magKhIfz/rOu3mr49blYJdTzQzQf9w04ZzUvmXVE5X75nWS4j9rz3m/lB7XtzMj5It6CKd7xnK8Ei/FW9f/k9VDPEOga3sV+jOK9rFEiyeHq85SzTwYUNYxPCrLwVlF1NK4qoEvdU0mu9fzdqEVVvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=k13I5Q1g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HqvyvyQ3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="k13I5Q1g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HqvyvyQ3"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SRNq3912767
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2db7vq0piVVlS+4APeSpwvKH2xENTUkfi168JwODX5Q=; b=k13I5Q1g1Ih60WsZ
	t9cYVlXw/I+Oga6DX5GMnoPGGBp0aMkZdusKzUBjLohNEbJvdAKeoOYpuxAsrEFR
	ytzX7uCwziARrJRUD7RfoDwOpegfL8plvRMdfw/4cadVL2QFfV98O1XPZ2WgJlXt
	YO892B+2F4Cp4RedmAkIC0mu77whOdx/BixhL1x7PdLFfQAF/0eI4UdnZDNQSXMZ
	7Wq9LJnodz0gxN1ppURmnzOnwJG2Ndyz+UOBEjWCkZ3VMK+qD08xamRkc9j4e5un
	6n3wuKn7A1BexXgIu4NfC/vUgW1oiGCXeeDhyhvHpMvgTuIxQ0QEF1bDpIbsC6fc
	1hB4Cw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fdeu4h4k6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:53 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dff6253so9884335ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 03:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784023552; x=1784628352; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2db7vq0piVVlS+4APeSpwvKH2xENTUkfi168JwODX5Q=;
        b=HqvyvyQ3YeCw8B+SRFLbhayWwUnD095MGdtazm/Y3TpNHm9s/bq0XGbMqRdObdJuw7
         u1MXqUYJvW4PkjnmpKxF0QBCS09YmqcYsdFwmPHhzBmsqT99jxkiLqwah/1BfhnP1LEZ
         kOmWZauK2YgwGgAH1HzvK4ER91aB5CeI9X6gQdyzJEowEj83AeJtORvebEDbpmzAaMcT
         e+DecLC00Cstz75mFiHQpFgIST1gUucnbpDCIYrDoLdEhUIvE6hLXPFIjLSyZSLwJNSc
         TeuhrcLYUGZvuKZplyV1t5IKDopxEULRa2bLmBkdQT7NIAST8LXEUH1lWUJIT7BDrXFS
         GSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784023552; x=1784628352;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2db7vq0piVVlS+4APeSpwvKH2xENTUkfi168JwODX5Q=;
        b=LDWbBMarQ0N78Ii88kE49COkZpmk+7yJQlFZbxLLSi8Cr+nq/wDDxsDL5ckQdHcxhp
         JNNBA4+JnmPmxHyPYm+v6lyLgVgAEFbMuFCd+CENgytA9Dyat5v/pdQmpRAteZCfRllc
         K5VLWPPJ+aafT4/xEG8/8qkheAFXAyjOpdUFElaTI6vpgsE9OIcL0ADjBPdQLiNC7zfR
         RMOAakx4VQ86lYqPSdY429G9vQsZ8iyc8jxCMMRGCvJAFttgLA/hKexccroWQbc1lsws
         i1HBdxJLUaMAzbGeAGo9XQQboL83NLzDlcFLpN0ID2Y2ktya/DRvT+2cFlugHC+S2noA
         EA6g==
X-Forwarded-Encrypted: i=1; AHgh+Roz8XwFFByuxrawxjMXpy38pygYiOg7nuIw/MNcjIJP3T4JCzGYAElruoTR9Pq/yFb9iKrHvw1pZd1uEsg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyrzPvBXHCRoc6odj38vAwF6FSW4zrPV/2oiWKysmKUOY+ybtJ
	OjQ++LrwyS6j1hZcYhq4eBZA43yiVDZSvxJ20l3VXq80Y/VByWbqr4j50jdW+58bPdi6IKLOHKW
	TwmmPK19l5wCbhtj+yBRjWLkIUvqGJjyF7EipPv/uljsgFYGRi+VMlpSZffoeCbgnBjA=
X-Gm-Gg: AfdE7cm5IpcTKPytGIJN4hzzgkArYgDSXyss5Tx8hxsdBNtcu+18BXFXOz1PRd3PVyI
	w3ehZ/71OBOnUXKHv5uXrH35MvxMR886B5OpQRvoHDj9HUm2cyYqTRUMYy20N6NYUB4HPB8V7/H
	TiLK5qASMGgd+/UnAtrnmYRbA3TiVT8u8SgJakKKS6OMsaFpG4pOj4P5YVLMsIxc68xs8vLA6cG
	uNbMiIHsepSs8Q/5Qkzmsa6A/JAE6u8088qpb3/IAqMYzdGYgVb9f3NJv9pVsF//vT5Aa6GjOyy
	u8KtjYA30aYN9PHnUlcsiUeaCUVI08inB/QvdbeqhqBnIsGNr32KZ/klX6k+gWh6CyPyhIBthcg
	RP6x0yrJ++AsOXWWtITS3h9TggFzktLHjnJ7FTG/TI/Ph
X-Received: by 2002:a17:903:110f:b0:2cc:92ae:b36 with SMTP id d9443c01a7336-2ce82970406mr156260945ad.24.1784023552428;
        Tue, 14 Jul 2026 03:05:52 -0700 (PDT)
X-Received: by 2002:a17:903:110f:b0:2cc:92ae:b36 with SMTP id d9443c01a7336-2ce82970406mr156260655ad.24.1784023552026;
        Tue, 14 Jul 2026 03:05:52 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf737bsm112653485ad.19.2026.07.14.03.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:05:51 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 15:35:13 +0530
Subject: [PATCH v4 2/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-b4-shikra_crypto_changse-v4-2-06a4ea97c209@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: V9QOAsUh7GLzS8geILn_N42oq5zPQ_gk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX0pnSH8GJVY+z
 mKA5enqoBX6nB2q0Q8BgyxV8nQDXbHksdJzJY4p4Fd2BlSOskRHn2Fj4+Ob7PfEThiLh5N7AdX9
 +PMrsfbdkPypfKMQq2hbLG+nrEbQ29v7trqahOD76ilMPieydrNGii6VXkAHEpfIjSo3GbYTG5l
 h8J0Wwp+WFWrxMbxdp5wN8gPZQRl9WeBtyC3KPVl3F/zOaV3jVzgAePVn7dvLflyLcsErIvzIQa
 8Uf3SUKZidi53GV7fDuszt9U2xc6+R7Rs7ZQGkg1zK5MQkmiM8O9Xv5luTbAuxDKK8o3a6H0oym
 i2NEPg/Gj+pwP/6gE+AIojE8R6EkCjS7cPQ3P7tjEYgy/C+Q8xlC3PDUq/NNgi+6XqMxPrb8OFe
 tsbRhgaKUBmKJ3eq2bGjIcKxS0pripu7xE2t6xpcDn69pKfLfHBJlotuIvCdn2Bgs9/+SOuEcFP
 MEoHM3SROcj1SxFClLw==
X-Proofpoint-GUID: V9QOAsUh7GLzS8geILn_N42oq5zPQ_gk
X-Authority-Analysis: v=2.4 cv=cN3QdFeN c=1 sm=1 tr=0 ts=6a560a01 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=hDoUnBfku3VNtUQ37LIA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX7wxJqx547lm6
 X/xb0CVZB637a7anPqw5CTcz+oNyKG43aXy1ukaqsBgUwp2S17y7gcF5BeBlwqIwUvu8Ado6TSj
 F5DIv1ujEfut4AluCVt8lrG0UI4iKhA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140105

Document the Inline Crypto Engine (ICE) on the Qualcomm Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index cce21aae6499..ed2dd99eb1b1 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -23,6 +23,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
+          - qcom,shikra-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

-- 
2.34.1

