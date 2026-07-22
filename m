Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FD949251F
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712442; cv=none; b=t9aE+1AAAZXsvD9eQMo5cC5yXiVzoCBKcwiboArOXLOMoA5Sc7u3fkakm7AfLYLrOhJgIjBrQbiP05iN3YCdMEFdmTELqmEVqmxGJzFdspAMGalSmrjZjY2SWZLE+uoQDNNOcmjygM2jgsfUQb9i7z2U7Hzf1Mf5iVs2K+CAylc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712442; c=relaxed/simple;
	bh=fa2aG4LS+9chhSCsFbGu/wjgtsk1e/yb206cFj8AyGw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UxID95depr8kbluCcK5mnnfpoROYFKX954Fk1klS/CYxfq8RtnqEtRAMSJOP/atl0OUNGYwgEGlFM8xPbX+W+PQVCcNcxpGGpYVkf2ji9yDL/SeKs9tLZorpkPvSMGrNojbrGNfqhUgm323+kjqexO0usvFFARvuamenYj9pXVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TT4qpn7F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ReKBspa7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TT4qpn7F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ReKBspa7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M8xPWO412647
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gkxmfdLNOJUpwYPfIJkn4kXdiPR1BCGkIFMX7SQ4GxQ=; b=TT4qpn7Fxu9pKbr3
	Mh7Ou/DhMBpBfC4/LXy3JrQxrNgjrYNaQAm2shLYW+/rj4qsaUaCrgS9m1vi243e
	omUSOftuCWXdS30l2fDTiurZ5GDf3/jJTTNEyw47E3eoX9eOV6eXghOR9Eypa3AW
	FkeqnX/a65Kxd6Xexu0QoSPOfCr2aZDK0j81bDu7HO9O9onufiIJMzU6UvCMuliH
	73NbQfxTVLaxukx4yonMdVnwzXc8nGIUAlljNzzV7q46LFbwdOf2htLBRSoYKcrc
	MRdxnTXGdOSRkvDsuM28VvP7Yh85eRpoc/00Pq9DrytZzmSlcPDp8tB3HTAFGtg5
	DjBGNQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjpxdh4cx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:20 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb835525b10so3401012a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 02:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784712439; x=1785317239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gkxmfdLNOJUpwYPfIJkn4kXdiPR1BCGkIFMX7SQ4GxQ=;
        b=ReKBspa7XKogpK7/RmP/7CdoTh+dAazYiJUXaXOCd272R3CnpgWxQ0MZY+z4tX08hW
         3H7c3LK5vBwBvbwlQdo57K3pI/VZJuz6KiF8qzrEUbLKKPNwJMcstNlQNVhhhBwH3jqi
         7yiLwQy4p3f01SL/+hA730nyhNekySOpGYd0jh9UUDgpfxHyrsGgrHLQe2uSr3AmlvxG
         M407Pg3ASOj17imgzJuzAEZbXxEpGOBWCna6mPGhtHiDoqGgkym2f3xmFv32suM5ixfp
         2VwEILmhAUEQInHBd9ofZUNrHVEZ+81kIdSnY8dqICEEh3okvoJotjyWRQ0ia2QKVrAz
         ypVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712439; x=1785317239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gkxmfdLNOJUpwYPfIJkn4kXdiPR1BCGkIFMX7SQ4GxQ=;
        b=C4hEMtoaoNrkhN4xaIPCMHtmM6ZnAkjJ8Esv+4VbyZDmISej0SPhMR0B0X1z7KuUiL
         UV/6uTb5c+M08dGHRx/MN6QkHiuViYrLTYU45pTmXOCKULFmDmJyQmbZ9y21VI9VKhcF
         aMkUr2Be92+Qj+2l/NPWt60hI8fhhScVLulWp0evCNabmt6IA5zUKE+mwSdeT8H00PWG
         ne2EKGBGkOgG26YHsDf0oAbOAMGn9ZFWGgpHDfiI4to/oBxV7lyuGrE7HBL6HXVdBfD2
         vLnOeaVcEvPwgZTsMrYGJdUg/1+GvUoe66qWHEdz2RDDX8m3w8nSvuD/dRYlGDjI1sKJ
         e2EQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSgQPEuGzeGGvdjcYsBwIfdP6q8sIcMb/YAIVvcBlEPu3m8MBlKbikbdGny1ESmBb/Liz+UcAntJRGaFU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Deg/PlqzIrfDpmqMGqy5yaIhKPeMjjGBzP4X0ZJS9cedYCCv
	CTnw4xVTfwei7lNfdZ3UXg2pit2KrhD2NZkrBUTs/FVnEQorMWqbZMG5n8NeZV1yfdcb7v3XCJF
	Qg+a0yGcBxVIkSDno/O+cIvLVIVO/NXg7w6ZMQjUINbWDPhn/qxK+lLJwR3ucJCXMHYc=
X-Gm-Gg: AR+sD13REfdQq/JQJrT/9sxDF6ozgWKhxEWSUl0IMqcgKdYNJTpuaOo0ejK/xEhfyvi
	U2hfoWj6r6madP9BiBzhAgVY5VL9gBvxkigMBZmg3ef/PyhpqvpRd7pE2z5NO5f2/M5YDEwsrpO
	trfNsmj+odKFfRe2TB2j6BB9wIf8FSaSR3VYCqGPo55aEugT+vsufHO41UYYTH4JiOukASLapwa
	Lv1sOd+WN3mY/UMWcPow1FAw/I58BD6CL1aujZ+2qLtyXh2lkec6IC9g/5QjxlZf+SjNRqesmTc
	7HZY2gJep7OCz4UfEWuzGC0YJhTGNi1PpqRhuFoK4NUn2/92ktNf/6XIyQYfjyMQiVAufBHdrIp
	zQECqhXuCgMcROpEPiw2Sl5DR9ocUBCsRWnGOypj6L5FYVUis2460jSioxEzR0uL9MQ8VOYDv7g
	==
X-Received: by 2002:a05:6a21:a8b:b0:3c3:83e6:c6e6 with SMTP id adf61e73a8af0-3c3ad9bb9dcmr25135437637.55.1784712436476;
        Wed, 22 Jul 2026 02:27:16 -0700 (PDT)
X-Received: by 2002:a05:6a21:a8b:b0:3c3:83e6:c6e6 with SMTP id adf61e73a8af0-3c3ad9bb9dcmr25135406637.55.1784712436026;
        Wed, 22 Jul 2026 02:27:16 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f18f08asm850677a12.21.2026.07.22.02.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:27:15 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 17:26:28 +0800
Subject: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 x1e80100 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-devtool-v2-1-d7e609ef7388@oss.qualcomm.com>
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
In-Reply-To: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>, kernel@quicinc.com
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4OCBTYWx0ZWRfX7Etlhz2xwabO
 iUpW/+6TOGUYqgmsbglWviBx2EFIVPSd64/Dz4B08Sost1h5KEfPSRFZk7ZcVGsXnPh01wTU4f/
 jlDlXc2P4uR7zO5y93NZ5wxLhIqSsibPpeaU1OArelIVeQx331qn+mSRmnC9pmySewY7UVdPrDu
 bZS11LWo4gS7wbQGKvAl06ZjuGQj+vt8pAl70cd91wCmpH2Vatx7sWZIYCRy+gkrcASspcoibB/
 VwNROLCdRhkn0UZ+pebRGQz9gbyguG8hKGTnrLbO3fnqCw+hBtr7Ps1zcxcfQOFsTtzpmCvlgKQ
 1IfsGFiKFgaUrcQDiY4OfH6I+BggQXQZ6ShPAX3RoKA5oSgkxI7P2dNnwNqOdJcljuM6BBBTBza
 G6Z7L0YKgIZof3Z3Zxth0l21fLcTtYsacLvLN68HN5BnIZFrC17tCh3XFXYLcWLefViK+KtY/Um
 eyr5PY+UEV6lyxf5CIg==
X-Proofpoint-GUID: HL5KGJ1ydBlGxEMNiLNFM7G1OxKnZToG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4OCBTYWx0ZWRfXzboCCtcpWh7Y
 jgKYhEmfcdNDX+sbzLUz67FpBaF//tOX8Kx+E5oBW4Wpm5mAgdcFDhVO3Monn9j4gOzT7Mgmzr9
 yAJCSonDDoOIlt/oDSVvnhFB1B5Nw6Q=
X-Authority-Analysis: v=2.4 cv=b7iCJNGx c=1 sm=1 tr=0 ts=6a608cf8 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=94x6OeD_fArCBOibklkA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: HL5KGJ1ydBlGxEMNiLNFM7G1OxKnZToG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220088

Document the compatible string for inline crypto engine found
on the Qualcomm X1E80100 SoC, used by the Hamoa IoT EVK board.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 92c3ba6eae13dbd8a6a448057e942a08cc3a3ea7..07d6778a287631262282d75c0d233919f4241edd 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -25,6 +25,7 @@ properties:
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine
           - qcom,sm8750-inline-crypto-engine
+          - qcom,x1e80100-inline-crypto-engine
       - const: qcom,inline-crypto-engine
 
   reg:

-- 
2.43.0

