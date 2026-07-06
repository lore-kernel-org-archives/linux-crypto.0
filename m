Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630A241F7C7
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337541; cv=none; b=ThAdgRns/QDMGsq6XXzjSDis8TdNzdTvq6UMDAygl7/bzx9NHz7Hozv7+TAurSSk+i7I9KQxJz6b5SW+ljmu14UXJ1LTukyXpaVUd0qRyi6kuusHvfZ8OymfULlEA9fjF/j5Y+2OtesQKdztCzHBgwMG5RXDfzKR2fg4rCLtHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337541; c=relaxed/simple;
	bh=Tw77m65ctMpu+WdJ5WWdw8xSnLCdE2h/81HKHaG+/qI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CNPnRhjMMR5sakgG0Spy5avV4YWVL1lm1DOBoUP98XzY4QoJYU5hqZbw/yK7OPLtIunRiVT6zr7WSUXclSmsc/g0gFBIj/2eClEWE9+hiFVIytNfBPVAnZKxR8+85hNZnx75h+/VXNOl2iiW41NeBm89H+/AmJ/c2bqCgTlZiNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mBGbEjEo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=col0qm8z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mBGbEjEo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="col0qm8z"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxJEG401678
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EQSWpZpdZx1gdCMr14mQLPTR4DAVhMyhocFoNcUqucE=; b=mBGbEjEoRT5FKNQz
	4i8cFalxOlXZT7iErgvRyE24n9Hcg/kOqIY/S9wrLk+49HF1XKiMzOwpbhmjm9md
	ybFlQIQliBzJw6iy+LPwAN0Nks0H5xQ8uo86Zd8YehxXp5gAqLNUy+4o0pjPPPWz
	rTMuZJ5+8Hfsv6mM1gJAwzheh8weWvAP6SB8x12dXosiRWRFyLXUuNPHE1pQ0Lb6
	5fIbs0o553OTffegrMhMs/4aexvGDyZr8yhPe0x9o0tVPfqeNPL94TiFRIumQQf/
	FhaSUPqcDCpJZaMJ6iGwgrd6GQe50ljrZWCOuX4AWv1AtKGdJY/t0IJedxZeQxkq
	DWaIZQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f8a3grbyf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:18 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-847a5f03ff9so4436949b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337538; x=1783942338; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EQSWpZpdZx1gdCMr14mQLPTR4DAVhMyhocFoNcUqucE=;
        b=col0qm8zA4pT+AoQU68LJaCO7+oRtrV+2BklBeEGVSB1gnQrsAtzQDWzp8WLlT3E3w
         5tIIegVBnL+ssd67MiQXKkF1Rv4MCts/wV3fcjnOuMgOm5i1YRY/5Yf5l7GmBDGk1LNs
         BgLui1a1YPJ8XknEBQldmWnL1gEjPB5AWT6GZ2IPA4AfxLJP/IjFnIZ6medHBlbdV/lK
         Oq2nIrmDyAR9QVb5JAdAncPbTcgPp8uT8To6ekvZsA/haRBNYK2+GXBw233uo/aplmPJ
         rj944dIhpKWyGdUs+4kLTAop3BrQEqWFMWiwuUlv1yz8I8RUwZ/P/Y5gZ2aeHqX0ehYT
         zpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337538; x=1783942338;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EQSWpZpdZx1gdCMr14mQLPTR4DAVhMyhocFoNcUqucE=;
        b=UKMksJi9jqX4TNTG87nmw3ngGhHA9w1XVrtxyjnbbCVvG8OLRbLUJZWWokb8gY7UtN
         FSWDOgb5JBLA3Whv/ZTQxl/2nUJnsTYkdpliuSqJD36Bg4jaiZo9P8GiY7Ervemq+F3u
         DP1A6IaTV/MNHkpFpS7xpHI07QZ/IV65HhkzcH48BITfSebXIKpFb8d+4D0Xlk/DX/vC
         s0tR778Q/LwXvg4GWbrrDMLqx5lCLDUjTHfL41spchptipfKMVQFU7RMBemIEkoeqzgA
         ihgnO0gLf+aUFyv61KleciRWrgxAB22ctKUc6TEcjBKrU5uyZ9X+xXx0gutr1J2P4tkY
         QR7g==
X-Forwarded-Encrypted: i=1; AHgh+RphLOiz1MnVDRw8gGd88PqYOz6b/3oD7qOYXgnLP2+3IIb6NK7+MJSeEMpUtEc99+W235y1Sl8vybUyfYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym8XAxCR3SMJHMoWjgS9DFdgfLKhhYHZ5Xqi0nsS1984v3/DNb
	Q2bw35I7QanqmZ3hR0kMhljbS4QwqYO/DANDbjRWr2tU/S3tvCAMz8qATuIqFvAiK1bctaHjeWC
	FSMHQzFsTZk1SBca9NM7iT5nZmWwEPGYYcl05LjpqhUma1apJhjihotOuGHceIIotSU4=
X-Gm-Gg: AfdE7cn+klNOUZiVkp3zF2R+9FVXA1s1RbW3IyVFbQKtk7D5EiS4LsGoum+3U6aOszW
	fGwGvYMAcMx2AuWJUhERO3LBNeD57zKAthoNNJ+1OONtfmAz3HLaQw9LUXbXUO682jTXGCtMJwF
	A3HjNt19tD/najGEo8hAb8gjsLiR1NclDEa+TkzlphNZDQ187lbcGPc5End/x5C2nU3zRc7Pdvr
	urerK/xzi2rMgOTX+MXyfbbjfqmnTI62e7iSy0ZsdEl+cQoTBLSpon4RCVPBneUqf257e7DLMUT
	rY2F+xalOJbqzKYJwfkJd6FuqJ3eaQJUXQUyBL7e83YjFSYC86wioNcxh88WYYCfjn7CbeHjDeg
	dKNfy9A1PYq8M70hXqeyFvpvV6sJu9nrV8oTTL9JBXvmi
X-Received: by 2002:a05:6a00:3027:b0:827:4bca:f1a2 with SMTP id d2e1a72fcca58-84826bf903cmr128495b3a.10.1783337538075;
        Mon, 06 Jul 2026 04:32:18 -0700 (PDT)
X-Received: by 2002:a05:6a00:3027:b0:827:4bca:f1a2 with SMTP id d2e1a72fcca58-84826bf903cmr128452b3a.10.1783337537616;
        Mon, 06 Jul 2026 04:32:17 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:16 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 17:01:30 +0530
Subject: [PATCH v3 2/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-b4-shikra_crypto_changse-v3-2-23b4c2054227@oss.qualcomm.com>
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
In-Reply-To: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
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
X-Proofpoint-GUID: cDntSYJkAtquw5rCD7sBzfg2P4I1yOQm
X-Proofpoint-ORIG-GUID: cDntSYJkAtquw5rCD7sBzfg2P4I1yOQm
X-Authority-Analysis: v=2.4 cv=CPYamxrD c=1 sm=1 tr=0 ts=6a4b9242 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=hDoUnBfku3VNtUQ37LIA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX7ZWqoRJ3mV2/
 TCO3dPydxwCWoG00cnd2cfNXjm6v6ARQFFCm4eHuBQHYq85YrjA7jflJfWRlUsHQv2Kw/BFpQ0P
 MsGRlNcnQdARskJgFPcF+FDa4yrgEpe6sUVZQv656Gko4OsvYJ6VDz2+5eKNs+BEHXOO2Y7bJgT
 tRE6pBhzL3VkNz6YIvMi93wKLIREQUfB+/xWXug4CTI9OBatOninZxAdmLe8B1H00+ksdIfxW16
 887/t6/AwMlmNExJmyYs6vlpr1eNljLzx0Zv3dq+AQPAZHKuDRPKYSm6HUBlzga4ywMMUN2qz2h
 IJlMpFNPYhOexIXGCYXlZvL3swqjeCVqe1VeMmlD3VMdDjvI070mDD9+MBlMheP2sqERWWx/IJ6
 FPMvZsHE0g4Ycs44f+vCEy1YhYBBq8olJNz2G9n5sRGtex9q0gBpHkamSCCRH1QC7mh+8PHSjfB
 Eutx0S+lmwHEEFhQzHA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX6ybz0dnCZu/w
 GFu8EB0o+pVKH6dbFhp0JqsyiSJtkedtS/tMU4v+Un8Xldsnsk8nCaATazdSak1zQxX5CAB/NwF
 YaXaCY5YvUS5eG9+X+zs3vmIOuktlKc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060116

Document the Inline Crypto Engine (ICE) on the Qualcomm Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
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

