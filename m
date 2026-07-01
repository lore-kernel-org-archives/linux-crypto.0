Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0377D3BBFC4
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 20:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782937063; cv=none; b=B5t7zzLvSuWJpofP+UfD1C5psUUnc2Tc2R9d6wrd1DIEubYhTqc0nPO0TWGRW0HR9+CQioS2r2eMW19emY4U6t5ut10VTfNRY+hI34e/7A3cmeSZlkWz3YHuDwIbbp4fiz9oe43PdgifVtiDmVFWA8c7VqtJkkzQRfa0h2WCC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782937063; c=relaxed/simple;
	bh=fUfTQ+WGGqb9ciSQbpp28uE1qLiRFaDJmt4FAE0yCHw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EOmSluKlfzfSypSqBESRQk9ApIvAHCfVXmgu6gvL3VQOt7to2fMCPMgoElbWzeR3hFPvV/G633wc1JVRhsQUHFMcspy8FTT/msMbreWvSV7AsGVt8gUv44fDPSpsZ8Hhch7+T6PeYbiP4uHP0XPwl40otqeocoHVSdK5WkXWq1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TifYpNU8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gn8Qz9kW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TifYpNU8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gn8Qz9kW"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661GmdPt1627582
	for <linux-crypto@vger.kernel.org>; Wed, 1 Jul 2026 20:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hIELCf9duknysKswcBTO3BHzbOM16+pkKsWIvb8AmDE=; b=TifYpNU8yhMH0nWe
	tBrcEwKQl4WmWmPsPzppe1M5omDMVDtEt4HwlaKGJ5q5DNOVp/kEIC5QtbWFu2NR
	TeG9CwOqTU45vvqWFNCHozxviaQRgL8uBTVwD2583ccZiQCurwK3d8NfZs3ANUdJ
	SXMCboVQc81nWk1JsbIfPihFogNJb7V2RvQPZGGYIKpKq+XOWaWtc6LmIyWI1oZP
	ZjKT1sWwVgASZqida9xHLs2wVJEvKYP6Am8Ns97Ncruj13doGdmK+L7W1XcrYPuU
	iNs3i1+eMrEuqSyEB4bp8Vdmt6M9eubEL7u2TEi7pjC5wZBaiNd8YcPwKX+2Tp4N
	nn4tfQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f563090sr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 20:17:41 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c889d1eebafso1637325a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 13:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782937061; x=1783541861; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hIELCf9duknysKswcBTO3BHzbOM16+pkKsWIvb8AmDE=;
        b=gn8Qz9kWq0DFs90gf8cdEtEfHaGbaICONRbZHUYmZ4UGzt9Tm5tdEvuyhvtxElxNRv
         6MwOD3j7MOWPvu8A2bdJfEpfWOnarKJEq/cGm2dwSSWqvGsImTZAccuC684aArrcp5iL
         C1+gZ2T2CeDWG6uLHY8ATqmoDMW0r9BKSG+4liQ3/KTmY5+V5WL4hHpuzmFL1+8oGmY9
         sLxZiSFkcP8t50/stH76Cx6IZdFd0oGTq/OUtdepG9t9zpUkuQw8T0pnTvFZJ0BYdp72
         O4N5jlWt0KDNcY24kjKyi9+G8PpDsQB4OH9jygu/dQa+noqWJbfI6v7pC8M6rWivz8+A
         WbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782937061; x=1783541861;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hIELCf9duknysKswcBTO3BHzbOM16+pkKsWIvb8AmDE=;
        b=OUyrYsXGiqFXapFYI+sFovu4ztqK/K4jr/viTHyFbL5tZqGBp/zeQ8g/WOVMc+fiNi
         NmTeronVx/KnwXWjLEpKUgtUTzxH5+5Q6KD4tq4dxmraYwxsRnV0NCe/r3ezw8g+AYUg
         Bii5hCYHQl3cnbESvxBYeHj+ogW8CD74pDxegwZ4wdTc/cd3K7ht3+uj79QtzmmyPopu
         pH6JV0JWnXGZ2rZIjKWayRnslIbvKsa1afV5lV2PKkjwVw85TJ/e9IvPic1J0Bd/UEQr
         1ZB44KmUt8lJigEUBNaDDRVQ2SI0Nu09/KiOuOXUW3ljKaN2LJJIFjXSp14aHp6cSy7D
         56KA==
X-Forwarded-Encrypted: i=1; AFNElJ8RaM3EjdxXBoD5N+lTej7KWrkOvfWttc52/8j7Ej7U74PMxb3yQvFY82rjy31GN4moUx4t0zVHtSoLlY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxFlTyJaawfZ5tL+iGF5cmab4DcAK1eK4dxYO7Jf4A2judCYKc
	8M24ODv478WR1/U2OfsbsziNyyWsSBrUV/HNK8/vPvF9ahIMk/P9jOGYSUTe/+sfzwoejbnkm9J
	yWQiA5ZbIeZqBRCV547krfvLBw1aZAwxz7KMW5DSdf4agmbpkdxVXFI3/lqwo13kuhoc=
X-Gm-Gg: AfdE7cmt6qx3LDqhBNHbcO1kgCr0T4CLNbwIrIQfZU7h4bGmg/IkDMj/iKGr4EmQnd/
	gE8fB2UZJJhskueydCnPgMZaBLuZWkmWKl3e0nbljCIoqDlAfBx37eiGXoaiaDTCqFIPhd1U/dS
	61RariViKEaxpdfN/zrk06xluWQrgCRajKWQUJO0/GODdHtynRbyEjqdpOKn+05LHpDQWELFlyf
	d5ecByAJNRDr9tcPLLJgmcvazM1vRHaIXvLtCsfWD4o1yRoqPwx2k1zUjAPult4iTSYK6ryz79t
	Rxs0B6ps2SI0VsUFKnKT3giotQ+OzbNe9bZvr/lka1Tg/GDwEOzydjehn/L4p83zvyKPO2z8lfo
	VKiFnYDAk89lJBV+Y+Oc/hcKpWB5+QNnC9SZs7ROsztVl
X-Received: by 2002:a05:6a20:7490:b0:3bd:203b:b587 with SMTP id adf61e73a8af0-3bff42828a1mr2740850637.40.1782937060625;
        Wed, 01 Jul 2026 13:17:40 -0700 (PDT)
X-Received: by 2002:a05:6a20:7490:b0:3bd:203b:b587 with SMTP id adf61e73a8af0-3bff42828a1mr2740802637.40.1782937060021;
        Wed, 01 Jul 2026 13:17:40 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bc79231sm948685eec.31.2026.07.01.13.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 13:17:39 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 02 Jul 2026 01:47:12 +0530
Subject: [PATCH v2 2/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-b4-shikra_crypto_changse-v2-2-66173f2f28b3@qti.qualcomm.com>
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
In-Reply-To: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
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
        dmaengine@vger.kernel.org
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=JdiMa0KV c=1 sm=1 tr=0 ts=6a4575e5 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=qMhC6LGQ_1aKn5J9HqIA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDIxNiBTYWx0ZWRfX2lmFZKtAuR08
 2xtRF0vmaw0bl7ZZQWdPekmR+T1tqXYBGFB1APfpvcqzk3O5IfTMaSjVir65FgAJZMLppuVEalc
 iefhTBWqDVNsaMYriIm62Q7vHoKypYo=
X-Proofpoint-ORIG-GUID: HTdfrJOX4BRJe3iixbN5T1yu07gSbBdS
X-Proofpoint-GUID: HTdfrJOX4BRJe3iixbN5T1yu07gSbBdS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDIxNiBTYWx0ZWRfX3FZn5P49aOTX
 gfi+h8M9GizP0Nq473/bYWCiXcONM08yQYLoFDd4EKay9oo+gz2vvoyuCdJj/rj505hzuvH44lN
 UwgPvKnuYpUi78PHGHES2ZWKM6sGx/r3bdPjla630p7QeLLPGesaYPpAShPD+tmM8byRZ5juU7s
 FJs0toBtF/2aJvHfIjcNy9fS/nq8KzVsvoov27CUtlGsvN8Ws2S5IFzUOJJM82fCd1QNIPk07jN
 datrbh7Qa93+1tsoo8sXB3OD0Vq8joOqG/LvMJxHEZa0ovA0mxnf+eOMk8VORthklD6pf4JP+2M
 1cOTH6tyD59K1s92UymBrsl2KBchFi6tiK8wMdOhdYxWMfsducL9I+baYB/jDEdgRYjN/NsM00d
 32oem3fZ6HkwJBGTIo0++e+pQFbBNBGp4hXAmtAj2KNfN7PfBeRP6PT2TTnJUxxCvu3/852sDI2
 cb9J8udHrvgadmFGXbQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010216

Document the Inline Crypto Engine (ICE) on the Qualcomm Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 4f3689a24410..9e6d3af42971 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -21,6 +21,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
+          - qcom,shikra-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

-- 
2.34.1

