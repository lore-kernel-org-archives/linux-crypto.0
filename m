Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370F141D4F8
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337560; cv=none; b=p2urWqE/ITd+dcktsipYunLc4wXBgO3Ae8uD/ADDY9MEvq5Z4l2xXRoUZHU8RX9JELXHnVrXfn4/uvBY//0OxIj31dG2U8ftefa9QRvKZrMG8iUcNs7RqF4jGAkzh+y0RQCbryYk70bnxYfmZQxHd3ZnGl9XXKTX51GaT0GWpeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337560; c=relaxed/simple;
	bh=cAJA12cau20p7KLPFzYEIrSS6Dvfi3o2tA5fDVTUt8c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c4B17xYdLIEhW4SxKAUsFSuyK8ax4gP1WPzvJqkOAli2jW11OGY4KY1l7ritCdEwWEcVCAncXilPQBxiimbh/7yKuz6KBVhrzEhEFTDPVl0vJm1mtTxSP2TfbtE5uMOmST+cXfbZtnxvyhx9n9SJirw+o0h88chIT61wtJvecDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=I5IQXplB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g/pYXUAT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="I5IQXplB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g/pYXUAT"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxJ0J316469
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	q9s3aaO7TdbWU8wQVqIVUSSkTdkTZOTjFslg4CjFXd8=; b=I5IQXplBqJ+g4WvD
	3xBaHm3WYz+gjMJuVflFBf3Uzhhp+ZP7N5HgyS1J8+0beIOs8KN4pP/AaDIlz7p7
	mx0achNEF+v/zf50Yaf17n2/2+Z9b2+3JHAyYcNxs9csB7mAp+9rFlzK2CBtVR2U
	7IEtkJI2ScOmzzlPRkwE/IKZMBQw4sc+HwtTwrdpGkUeVmfljLNKRW7LXveV5kAq
	FYdToZ8QU5vLEDlb7T6fxUjklZCWI9DA3ao3k5dfnVZT9li0tv1KTSRaEJGKtS46
	d5uMH1x7JlgukHG4pOemzmVdwnVcCoYwC2Angzh5Kn4JycmuSrkGWRLA+w+CWOyk
	OG3OyQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f87q7h0r5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:38 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8479b7c3adbso5043284b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337557; x=1783942357; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9s3aaO7TdbWU8wQVqIVUSSkTdkTZOTjFslg4CjFXd8=;
        b=g/pYXUATlZKda2OR3Pl2/Lxwshw5IlQu3Z22BL54jyQ69fP2mlhqjHv0p6ChJlbB7m
         oVXZ3jWP9R4CMWptcWZG1VXPlQx0Y16J6SHUZq1E+S2xsHeGoOFbAAK7lo4+imIonaIv
         89i4wsU63tjgQJwUFLH/JTAYc+BFfVYsHfqZffroFZqQkMlRwdo6bytiJEGZ0fQXvdWD
         0DOxwIcGisWhoCfqPw1DUjYKyIho29fkYHeTWxpyOR1WcEwEYzn9mIJRYw13XBV1s6c5
         WEKEnbQOfJFKWXddWh4I/mehYgFGGsJyK+rnHvp3K2TbjDbIAXKQJMaG2BVD4gyrzMje
         hBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337557; x=1783942357;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q9s3aaO7TdbWU8wQVqIVUSSkTdkTZOTjFslg4CjFXd8=;
        b=IsP+IEHUrDGRvD5Yf3ZGMwWBPA5+qe1wQ4CmxShmGkKTToTkVf3EV71qPzoeInSDIF
         K36LKSk7THyIUrmi69mNrPKDOtW/Ut+BAe25tOlBC1TmCt4ic8ID8Jzr0tAsssZbS+bR
         DLG73lI+PIJR+mP6W4UGdbU8UCyP8rSpQSlFOu7SbSvz/I6NceNIYTqlJmBATWEb9Fah
         XnOUoAfMYxPMzC9T5G/S+cBvwWNawd8UEMh2IGWfybDJzbnzf20hQZTUB/pWcu6yjF0C
         vqrZ9ZWzWeoKPPDmiANdUZejtYCOQhj/INKEMMQwzsacv1BGFpJx5Z1WUa6d3px4f8Mh
         QuOQ==
X-Forwarded-Encrypted: i=1; AHgh+Rolhak7knGjHZ0+cciKQNSXGnC7/SsbUvdLKxcegbkmy2SJS7sh/uRvstlV1yGdvC2sioNBCLjfYJutqG4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr/wld67XbL0ByZPqMsYEAMQGbB1xLY/00StEXAJTWLhOgoB6A
	rYixa/W7yGPBBnW7AIg7V4Bc+7vkcGCccwIMnr3uMLRYzq20kVM9M4UZdVzJPrYqfTyqyHbNT8e
	85PmJ+6+5bGjIlZfpT/uvUQ30risfCTUQAaTCqy5YsDn6dfRaqqs0AwCXmQYPUbR44F4=
X-Gm-Gg: AfdE7cnVP9IE9UA/cfEvosUUWhV+y1vTy2hPP1jtIBhC/knUFQVLK6QISDSQeXtM6WP
	9DC0S/cz9wrBx/tBu3CpzRBJmgtrSEyv0CjBuTgckBxo/hEta9VvM6rO2zaOI9L1SIYFZ1XTnxd
	CtgaAizHn7v6BAPQHXD/89MCXB7x97O/4+9QzMjccnxV7sdCuCwxwclPksXBIXrfGJqfz9nqh7q
	HRmmmM4LoA+CRmk6Rlwnc401X5F5gwl+LJb7mT84VN7URfZOqOrPzhHpxucEdi/INm84ChHuTEW
	RnkiXymHql3tQU1pe4pnvMHxvInDORRxQofXzo1uiW3vx8pfsM9uHussTONHvejJhXoKvGRpzoo
	yLBoVbPk+cIMkX4l0rnHsW6XNEfHAul+6jNODwbl7gUzl
X-Received: by 2002:a05:6a00:1493:b0:847:80f5:c616 with SMTP id d2e1a72fcca58-84826bb45eamr152674b3a.10.1783337556804;
        Mon, 06 Jul 2026 04:32:36 -0700 (PDT)
X-Received: by 2002:a05:6a00:1493:b0:847:80f5:c616 with SMTP id d2e1a72fcca58-84826bb45eamr152613b3a.10.1783337556043;
        Mon, 06 Jul 2026 04:32:36 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:35 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 17:01:33 +0530
Subject: [PATCH v3 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to 7
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-b4-shikra_crypto_changse-v3-5-23b4c2054227@oss.qualcomm.com>
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
        dmaengine@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX+27lndl60aQp
 f331/AZkaHJ5mt7eLn7O/QKADVvGozhV9bckEMKaaGBTCxEecAUw6UTVUH80ZrI63gFjBFZLjvE
 P8pJywvbXs8TZoXYJJ22aCTjHzqf+jqB0vr0A3xF2MwFb1x+ptCgBKAfkr+rfoIZpXtBTrfB6df
 l9hQe5XTsF5/I7Oc8eWdu0864dCOsCuCmBgxHNqVNTbxYpRxoJ/7RaqssnxnjDsGtp16eESfapx
 cS8pTWkjjotSmQUgfPO6DShTPNWny0sImNcRKRdhcGq7Oi4XT4ZuskscxqAR3R+j75PIsGkUEwo
 XVoTl/E6r5q8V0UE57BmPJCEHeImf92G2PprBwb2Cdeogzt0I/j/JRUsB+jOkL/zOuialFPzh7i
 bXfvLolCMLbf6CyT0+kx5mLckZsHIs4fFr+2dUVGXKhgyvADQNIZ0tNk5tKOZASg2ARbEWcfFbE
 hBWZgLoJRRoNwBIqUnQ==
X-Proofpoint-ORIG-GUID: It3OHpNDGvU0LSA9Wm2P5obDOPx1U-ej
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX8tu3U9QixHOo
 tliPdTRJINOeaZQjd/XlSPGJ0o3exLnwR+70+14/gJnu1XLp/HUPw/v2+ANDQCj8/cIF1zk82iW
 Uemd9N2yv2hBFUpToE/xCyETT9Q20R0=
X-Proofpoint-GUID: It3OHpNDGvU0LSA9Wm2P5obDOPx1U-ej
X-Authority-Analysis: v=2.4 cv=f9N4wuyM c=1 sm=1 tr=0 ts=6a4b9256 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=56hBLZIh0n9IShKQQEcA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060116

Qualcomm Shikra platform describes the BAM DMA node with 7 iommus
entries. The current schema limit to 6, so update the binding to allow
up to 7 entries.

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

