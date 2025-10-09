Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3500A29992E
	for <linux-crypto@vger.kernel.org>; Thu,  9 Oct 2025 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759990760; cv=none; b=iCS47KxXhKn3Wx3bHh2UrwW0l8EKE2yqhk3zICf3yihH4rBCF4RiA3cv6Cwq3tMAr7roDv2+bDlFT6tkBX0tf165IlvBG/Jt6dYyTnaxd3X+5Ha6+S2MTYvGjNTlRXZtLluwLKy3QqjgUku+eQz791Kk3WARD7pMYcTuGzw7qqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759990760; c=relaxed/simple;
	bh=mhm3iyRHbrd6C1T0gzq8dZ3Be4D6uDhl+Lr3IO84qiM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qOuC/9aBPp6AoWfyq16v4C3TNbAF6dtTSsx+XqgptojQyhOjGCo925acaTomJ9H5GU+gYs7OaXgUgaYNYSJ/6ez3/f1/aj9PHZHNxrv6oLtcH38CiUnNRXhOiIkbOd7Bjf8bc6dH7R37ENHvik+qdtLsk2OQLYrJR0kPIbMLhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ga/+tSM9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ga/+tSM9"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5996EGOi004118
	for <linux-crypto@vger.kernel.org>; Thu, 9 Oct 2025 06:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ATUO9sxjCo5PUTMu4Z+g3kwu8CIesdgQ1LufySgyaP0=; b=Ga/+tSM9v0/LYuuH
	USW0Yiye6GxscVBv/DS8sLMt5yjAdBTAwmsordoas+3voS77lpWVXnEmUGDcyV9e
	ckJUuZj4j+T9TdFiPFW6kIibNrV3SvE6nb2fFA1B4tlTWxPNMQO9jmUEvagiWY1E
	L8f9gX5yhpOHw8j1JO66PE9T072HtyK0yMtkSDjxDvmhcSCIIgntkxCCoB8O8TmN
	M75RpwzO5K46RNhqI0KVBz0AT9ciw9SDThKdvo04uw4XZEZJE41S4FjSJ7vaqRf8
	PMM+HQC/onikNKcGUD94RZTgCvu4JN3GYZ45iDqTI8IcLKNFcXavzEuLyubah/zS
	lyIIZQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4j1pmt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Oct 2025 06:19:18 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32eae48beaaso1447853a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 23:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990758; x=1760595558;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ATUO9sxjCo5PUTMu4Z+g3kwu8CIesdgQ1LufySgyaP0=;
        b=lZizkZXKg/gOXghZUjtUNum9UYo73Qja/bf7f+hahjjhrm6uq2wRDf4CV4qxUWmwOA
         XrsC4FGLWdPYiPpK4LTmVevC82TZhlQ/kv3eg9brHHS6aoi2ZB2xG7qNJ8r1SRGayO+B
         3j/Hdk+r3AAFj8E62BO3bqdAoiCBgDhjnnTz/ST+j6wKWZNr14m6dG6OWdA3m5NqYM80
         CjDXwtTjyUF4U4dfdS0q68AdO5zwCwuEfU1vD9k4SAwjv4ov4P1ycpUiyudzMonEcBFr
         GWLH1Qr9qhNrvLVPUN+7uNYTWmTjemVYgJFueM4mnfXmBe9yvMpOZlZ4gs6pmr7hr0zs
         m7zA==
X-Forwarded-Encrypted: i=1; AJvYcCXr/48OK/DRER6NE8hcVv4TdKHM7vtXI6pw3vkaT38M8HiQTsJ4HgD447yNo51OFBd/giPMDCFKi5vG/CM=@vger.kernel.org
X-Gm-Message-State: AOJu0YySYFCYSu24VYdCWeo0FYIptnQIFt1eilhzBFjXOrTTiJ2U1hSz
	vk/RVmI2EpYu45ShtTCYfhmkYi5epfQg0ekuPfAHpueuCZAvhWJiiCq73YlWuGphQeJ8htCTCbW
	z4GNJWszQYiA9bv/FHYoDkDkQQ4ozZSdP0EzfhacC6wQJg0RNVDcwUQxDBYYPGjWufbU=
X-Gm-Gg: ASbGnctm+SnKvN63Hpy/OzTzgbvwHyEUV1yqn3FwM9xrM13J0bEgG0NlFNzk5nBeebT
	tlVROd7/KdhX47rgx+Azqp4drZ1ZKyk80pxafOhywiNfAyicQd8Zaq5ED8rJnxoDN18AWfALo7z
	P9/AdUQGTgE5CVOTyCtTxo77UtSOBSkv9HXd5tMZ7xqrbCd444ef9IWk+Y/jNIrcbr/srueFB2r
	MBoPfcKsULANCkVbvGgeyeUPuqKOC7tBvfXDVdcsNNfOWOOORxKHpGpF9bGwAiBAIQ8zAIW0V9b
	mn6A0ab0/DZ66HiZMHc0yPRh6X4xkLrhao3u9Yk6PC1/4vP4WGaiU2V5ugKoJYLW25c7XOl0TS7
	Z7m2h/4o=
X-Received: by 2002:a17:90b:33c9:b0:32e:e18a:3691 with SMTP id 98e67ed59e1d1-33b513ebbc0mr8788421a91.35.1759990757579;
        Wed, 08 Oct 2025 23:19:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFAqILhWyE/XzKX2WhRN71ULW8L8fSTk+2psqr5ZcNytsqF57WijfbGOqYcU3wUDR0qZ960g==
X-Received: by 2002:a17:90b:33c9:b0:32e:e18a:3691 with SMTP id 98e67ed59e1d1-33b513ebbc0mr8788392a91.35.1759990757080;
        Wed, 08 Oct 2025 23:19:17 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099adbcbesm19239671a12.4.2025.10.08.23.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:19:16 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Oct 2025 11:48:51 +0530
Subject: [PATCH 1/5] dt-bindings: mmc: add qcom,ice phandle to mmc
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-1-2a34d8d03c72@oss.qualcomm.com>
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
X-Proofpoint-GUID: BsRw4xmgIcJTIMiGAVZh-nwpP9u9fxcc
X-Proofpoint-ORIG-GUID: BsRw4xmgIcJTIMiGAVZh-nwpP9u9fxcc
X-Authority-Analysis: v=2.4 cv=f91FxeyM c=1 sm=1 tr=0 ts=68e753e6 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=bQkk_NDItiJHBMw_kacA:9
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXwxJUhiboFWYk
 6pB+d+U/KqMLOOcwPcDbA9YI2c4SSyi2dEXD8i4XqbP7O+hm291HBUvWWAgOX/XBDFDn98hx4is
 MssDqV73nKx7GmHGUzP1p2Kz2k7NdPmGA1hwKOIc3V2ARjZmk2l8DSQcJNo89DkKBbtn6SPiq7g
 +Syg686GTMrN4mfSo5jCOJrLf0aEzjBYQi+KIuDhUnqzW+NpJiUUDIWAGokYOazTLb9clPBSY8R
 bENCF3PPt9i5mSVMllrei51A1perBtWi1ATgTg1QbPgVXzs2mLf1jDe7LZFZMpyZ8D4vQLJh1g9
 EXHk5oj27k8b9ihCBfNszLtZ2Md9O8Aa7CUKyErbUTr0kI1bfqcwJsyuy3TgEpLd1oD1F2kuljY
 P6F/YT/HNBkQOLwgrQfcY1lCsZncVg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

Add the 'qcom,ice' phandle to the MMC device tree binding to support
reference to an Inline Crypto Engine (ICE) device node.

ICE hardware is now represented as a separate device node, and its
clock and frequency configuration are managed independently by
the ICE driver.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/mmc/sdhci-msm.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
index 594bd174ff211e1bb262ad8d8c7fe1c77f1e7170..9d6be27b43cdfb349a1dc96a6687b5863af844d7 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.yaml
@@ -138,6 +138,10 @@ properties:
     $ref: /schemas/types.yaml#/definitions/uint32
     description: platform specific settings for DLL_CONFIG reg.
 
+  qcom,ice:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the Inline Crypto Engine node
+
   iommus:
     minItems: 1
     maxItems: 8

-- 
2.34.1

