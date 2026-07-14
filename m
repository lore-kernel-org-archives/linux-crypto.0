Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D375B36403C
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023574; cv=none; b=lXjJtmqiNOckLofkhjygIDKYDCbBQ9SLlRcM8DkohIh0bQMclmHmcEEZ2V14thHAankAfMhGmpB4i/8NLAn6/ML8xRDAYBihmIxCkK4uxQS2u5WJe/5AcgNdaaiECbiltS3k1+053LOKCLxNFi502xW1NvxP63gXRQNU7Sjfwqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023574; c=relaxed/simple;
	bh=UoSRo1GW6MYk2CQkM+hrKXykAmZ+r0PsRTTvloWVEdI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SpsEkPk1ZP5MjZnPpbTdbi0zkalImkpmUwfWULLjglC93oF36qXqdyxVVEJSN2O22oncQHoeOthiJDkHQQFFxPbgm8FG3YUshn2ERH1L1APKuMy9SCGUYoX1Ibs2vnHKPr+26mnT0pAJcXQfHUQEs4zMr7vkxwhnp0dqoewzcM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cMxlrDUu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ftNVt4qq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cMxlrDUu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ftNVt4qq"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SSnn3743626
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T6ytOIDKhwkP2y8jVaN1ZuW7AxSttUCjFdaRma57k3Q=; b=cMxlrDUuEEEfhQiR
	xftx2pzAUcDNd4SpwQMFGiO0lAP3EBjagcqcMMHYgo1Gdcjlw4oYsFX/q0/8mg69
	Qc493r/zU2IBvMbja8P+SQ+HvDATPSodWNiSCk+MmDCbmpPvp1AaSyvFgCJJuwha
	7pkfpMXStKn2KBy/r6w3sh8Q4vyddf0rtVA1XNgMzmeMRHnV82k/CfdKO3dom1ly
	I3SlQ8W86dVwKnZTvx1h1FHw2Jfc4vCkG3Xt5/IeGCe9/4GOmIse5GzGmRUlJx+C
	mRc6rgrmBF59g7gvFy4QwnYGMmKSnTKBwRrcQxvNqxVsajUJUP7Rn2/ep50wOOE8
	sMLQ9w==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fd44p3516-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:06:10 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce8a76df2dso73892125ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 03:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784023570; x=1784628370; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T6ytOIDKhwkP2y8jVaN1ZuW7AxSttUCjFdaRma57k3Q=;
        b=ftNVt4qq2AmWMuzAS8jRQeBXjSdbpp8cKU0ISjLVUurcJOwaRQwexcA08L2L7dq3vc
         tlUIyyT8ycZhvWc3m9SidzwElswAPl/lrpxVxbXktk4yiccfhF6+6PomowWhtKvbbOQh
         9XN46W78dOGTrpWaRJ27SigwugpCFUaMVedXaKu4BWdZpjcCCtmfS0pfUSE9ZDjrJ4QE
         579n8abER9l6qi2da7izk6M09F7DamcZU4YaoTZU4xCbQuEfm+NJj3rsBaTSl2vLlK8T
         pzDzAzO9TGpqjPSjLjWPCdeG/g7nHPg8tJlBZSJDQV5IzTPAg1QFN3M1Z2fupNwgwyEh
         BK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784023570; x=1784628370;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T6ytOIDKhwkP2y8jVaN1ZuW7AxSttUCjFdaRma57k3Q=;
        b=Y5xadE12pVyCJqoaSLsR77Owkaz9FXGphGak+uTBXYWRt8u//npOZ+ydXo8VimUtby
         q9b1VHgIOgv1hZu6ZTsSc6T3secu0RPyy+yxoLGZNPICTBC7Oq4/pxUker7RS1i0aRx3
         cqZOdkqo2bfOGrz9IEBFQ86sM1kdRCYxM358TT49evX9OhZSpEDME2pHrSTPnHPcDVFc
         aStQaBDIwA7kha5mszEFkbkE/EbdrcbkrxcUl9jWy2Qp8tIwKy0Zp7VCisbjas0yTRiv
         qZirOMM9E0hMJpSyO8jLsjww/pHoNJ7lksuo+trLrQ/PwFfwCcf0l1JvikhpWGaoqZ2+
         GmgQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqz3Z6tiXYxORjkWfF69e6ApB0T9yapxHY3aGl7OtNkEHTHPqguBTNVA7iiv9w5P0OKrHDnulFOufAQfIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu+J+aF19+4ETo2/8pWtxg9IQeYwF8TwKji1MDqlpdt6FviKdq
	PRj5XHavKpfsvXcn/72v7GAGjgq++KvsVoOBf1VKup7kXDK+Z68hXzDWooJTFozIXY5I3d8J/qU
	0c6EaeXPbuuu06e1jiy7k4Q0gxiiWodU2WJ9ykhRAegcIimm3fDvHwbZ/pTsKqJoMiwo=
X-Gm-Gg: AfdE7ckn5jQaB5QuXGuHaAO0HqVbSEdb5/6OnInUnuuetoL1A4fQx2JJLiwO9ilXbET
	0NWLtDrD12VTxnQATQMM0QsE8YIu3XTKw+uwyetUzFYrD73NiwS0rcZjvQtOpI/rhOGMJEgwby/
	ceBMVP6PqaFX8de4/YpaIqBAZgzoNsBlVYM1eqz7GtIi1Wd/txfMAWR9quE6/Jccv9ugTi28rj5
	m8hoM86Tm+ow0MI38GCdhS4Lk9dpMehAouGp0Inn8vqgU4L1UNAP+a3bzFpr7bHdEB5bqRhDySy
	rsitehpSwNR7Ljngj44nQe7QM4dsml1zQpo70v4Z0EEttznatKHPxVC/7fej0koHVf4MB2Tya6x
	9UtcNbvzRbXS/ymzU1gitIy/SLKY5tddNgxEwZG9vhx0D
X-Received: by 2002:a17:902:f70f:b0:2ba:6518:a6d4 with SMTP id d9443c01a7336-2cef11ec5b1mr20323155ad.20.1784023569996;
        Tue, 14 Jul 2026 03:06:09 -0700 (PDT)
X-Received: by 2002:a17:902:f70f:b0:2ba:6518:a6d4 with SMTP id d9443c01a7336-2cef11ec5b1mr20322545ad.20.1784023569452;
        Tue, 14 Jul 2026 03:06:09 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf737bsm112653485ad.19.2026.07.14.03.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:06:09 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 15:35:16 +0530
Subject: [PATCH v4 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to 7
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-b4-shikra_crypto_changse-v4-5-06a4ea97c209@oss.qualcomm.com>
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
        dmaengine@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfXydgbUlKhQuyI
 +VLX5hxfVWDU4pqR4nBO81kvNU6aieSikBPPts5HgnVmsVZZ+h/Q/6Jddhzur1eLZAAERA8hRYS
 nzTb/rU/+p1B8dvASqZ4T2oCWAFFQ24=
X-Proofpoint-GUID: HezhjCiS7F-ZAd1WdfUazQTQ46cOIEvD
X-Proofpoint-ORIG-GUID: HezhjCiS7F-ZAd1WdfUazQTQ46cOIEvD
X-Authority-Analysis: v=2.4 cv=BZroFLt2 c=1 sm=1 tr=0 ts=6a560a12 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=h8YGW4MSmiDDVbuT7RUA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX6u8aFgxeEAYM
 w6g8C8Z4vE+4GGlJ26rUHIcGCWcgGGRWPVT2Fa1oLc4Bb8KCvWS3v2EoKvlbVWp5R9iOOI0/rPZ
 2KCm4EuwfKu1b3VLkaznWfMzL/4YVTSA1LGNYrZ1jI1qi0fQRBm5ekZN4NKLh4oQqv5b4rKcCAP
 Umd/oVSpwNi7aWfh+5WtNs4wwMbn4bun/XcPa7OshVhUm7eYJ051CTM+pjJ1kCLXht53KyYod+p
 8Nuo8QMvCwOYeZOQdwOxvXctQGjIhc+Eynlr/bdtIp2mDiS0xKH94mqpNRV6Cv37Fx/5tvPKt4R
 GvHahBM/09t5eyh4nbdh45nAz1AEH4wuSQ4xk0QQeiBrSznl5T14+apPA6/qC58QBLWmTE1oEx/
 3C7iqzEjGOOfEgFsLRUcIVaKGVdaxRkGAo+leDM/aW5EYYMs5fL6GWUnSwlsWmnoDmUU1jMecUK
 LVa8Y8iWI92V1avMa8A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140105

Qualcomm Shikra platform describes the BAM DMA node with 7 iommus
entries. The current schema limit to 6, so update the binding to allow
up to 7 entries.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
index 0923fb189ada..e72adc172af1 100644
--- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
@@ -48,7 +48,7 @@ properties:
 
   iommus:
     minItems: 1
-    maxItems: 6
+    maxItems: 7
 
   num-channels:
     $ref: /schemas/types.yaml#/definitions/uint32

-- 
2.34.1

