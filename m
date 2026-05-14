Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC443A7198
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778786636; cv=none; b=fixayiVcUVjgM03xwK93X72aA25zownlFqmvGm8i5+VgPBPd3dCm7ZhCTZk4QiABPXBUHapdmNilsciVMppW7hNstXMbryUXBkytJUw55uYmEz1ll4omZJ/mosH+20gohp/bVYVBmB8e3e0+WDEg1vaYm5OruABmWKzLYVy1ca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778786636; c=relaxed/simple;
	bh=DxqT2cvoH6Wzau5SQ2ljRCq3jMDOB/VO0j9w7wJrsgs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lhT//mKVoESA8iW3cos3IwxpnQfX6alANhfcTiP6d/KqGOowr/L/bJDatz4hlZ6arwUT/dpCydP8HFZDIB2GmHmoFIlCzyvPVWQdfIjyAhlZqTCt8crg8KqLG7c3neSDOQx245QfOgm0Gs+fkQp2dnRz2YyEDnayuRxJSPKjrQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pabTrzxT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FwCJIt1Q; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pabTrzxT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FwCJIt1Q"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIpjEI718701
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:23:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=9vZ4RhN48Kw7Wcf5kxfM7+
	mj8r3upSAqu9EEnlAYB/0=; b=pabTrzxTe2gE0SOae+152E2T8v/2gWAufTdJZW
	+nWwvGMSEOkTbDxaCglm1BvDpMKeGZezKA+ZKRzwRRJClS9h8Xurhr5gHh1d/05r
	lBecHTbm52BiQ9qE+ijf74dbK3T+1sPh3n/M8XIr5vR0T+S3x+UglrAOvNeJsBTt
	HrEB9ybkqdBcHRilD0AjEzEGKsynIoCLEAFZBnULfV+/y/JGCcf5a0a/qm2YfT1w
	eBSj0AfyQyt/D8ZNSLiGt5h7hYpwUbXjpkVA8WLoHzz01wgKp90+dKooC6jzDXYo
	+JmAZP/Eu3SEVHdByvXdYMG8/G2/PB730Oud/Tv+nJ/1hO0Q==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1x0384-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:23:54 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2babc42244aso154250595ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 12:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778786634; x=1779391434; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9vZ4RhN48Kw7Wcf5kxfM7+mj8r3upSAqu9EEnlAYB/0=;
        b=FwCJIt1Qpy1Hh1SMf+x2wBXc7vInNLvici50gCRa1W4JRGqZGKro1MWl16PifKIkZw
         C2pSl7KPYzwo1qVnQbbu+YXsAHJyYcf7A7Lp5Hw6j0tMgPj5+WtP4iTg7Gb1vddI5Td7
         /fPv7vWZj8W6Rw62BhaDLDTm1OFh31/dbjPNnvRHbZPR5Eg33Lj+yMD8QCGXhJ3p+Pud
         cdnjBJbVy5fQ8SOB5VKufdozOVjdGQif/iWtACoA+UuUFWlSXwWmF2hb6gpugq7uqbPT
         7kmGx7S4Hb6O6G8L7UWn4bkwFBUJi0JoiWxna1/zqFbeY/KAjAmHmNtAfqN3BrsGuN5o
         yPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778786634; x=1779391434;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vZ4RhN48Kw7Wcf5kxfM7+mj8r3upSAqu9EEnlAYB/0=;
        b=hTbYdNohOVzias2GnjASyivXHILZnsyq36YudVlbcSgB7VXmFWHQwqllU0S0IIpfgv
         GUypnVmjszc9evlRmCF3zYICTas8jrt7NRkpI92psRhU0BRYhdKKfofcqJms5mL/pNVn
         tzmZMmpLCNUrK8ffeGAcqnEwzEiX8Hwz462TjAllbbZdH0yfPIIT2mGVGXzI88VETkhU
         VDj67lp55ZH3XhvsEgSrT5IwrSGmW0REduBSzaakvQVbtWUBkP4Kyh00m1lFOsA3hQyk
         lolOrWvKdXwTz0KPOa2BjQHieCsjAL2U07KTVcK4Hgn5x1vgNT0sn0rvbhAcPcvQRVzm
         x7oQ==
X-Forwarded-Encrypted: i=1; AFNElJ8AEY2Pz9EJVyN86YXMOIZxdtpS8s5KatwGVYsFeD/z3QDr6C3El4EmDAYCeWZuDiVhx9Fl1cSn63LQzXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhugLpdHqY0x/W7zoS9+KE2TiGTfpcFLRcUwBfZ1qvw/JRLrqD
	UYSifrPsKK4g2N+AGoH9opQzVwzivA/s7wWzKrbuvB+biuHip2pd9c+vtBavswiT5+apcBvMFiV
	QJ9LHhEJBkDT9OWo2vTlm9m5PsSgqe3zo8yM1Dfdua57BmSXbYbX715qAAKNHx54O0JM=
X-Gm-Gg: Acq92OHfZAnJQxXnQosDsup2JwG+qf1bqZPvYWTbSb+pnfnrDHkUG1DPc/xlG4Iog6d
	SruUPbRAUb5wgMXKPoshFoP7hkYKVLLYZ6/Q5gwRAOORumVx/cMCbeR604mMAWv2B3o8Jwd1Uv1
	i7Yqhr0rivXAr0Pvy0S6wOkqxmWcVl8l8sswULJYgtI5JIPvf9c7SsWUvDivAEmeP8gAHRi8rbO
	TwCG6ekbf32/zWqb5puX89xtnmZQ3BrvtgdemOaxR0cQCi6Z6zzG4kyHuL9aPQB5+qMico45MF+
	kqXBlcSL5PTW40HzToITTaJvaGHhSEqSqToQmIjCraT62THBEYyv1rnzsZ5wBquq4jqFE6YF97m
	C/N8GMEVjqjzJyMk8/I2Dx9Pv53K0/rjGe0TAN0lKOh3RWyWnpUGMC38=
X-Received: by 2002:a17:902:d505:b0:2b0:67a7:5c4b with SMTP id d9443c01a7336-2bd7e8f0ff3mr8554695ad.28.1778786633914;
        Thu, 14 May 2026 12:23:53 -0700 (PDT)
X-Received: by 2002:a17:902:d505:b0:2b0:67a7:5c4b with SMTP id d9443c01a7336-2bd7e8f0ff3mr8554455ad.28.1778786633362;
        Thu, 14 May 2026 12:23:53 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f291sm35506535ad.15.2026.05.14.12.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 12:23:52 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/3] Add support for qcrypto on shikra
Date: Fri, 15 May 2026 00:53:35 +0530
Message-Id: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADchBmoC/yXMSQqEMBBA0atIrTtgHLLoq4g0MVa0bHCoUlHEu
 xt1+Rb/HyDIhALf6ADGlYSGPkB/InCt7RtUVAdDEicmznWmpKU/29/keB/nQXmjfVanJkWDEKK
 R0dP2DIvytSxVh26+L3CeF3Nw12VyAAAA
X-Change-ID: 20260514-shikra_qcrypto-f61f4d363e6e
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE5MyBTYWx0ZWRfX6yRAnTQoM9Nd
 5Pad5nsmz0xlPQ6IDtT7SWJXmrW7J068fcjjRj3jTXEiIOuQLyfxf1m7aJMp230jHHBE+Ay6nWG
 8UbCfQRDXCbGeBV9jkNfW9gBEySjQ3VP4sUo71veTe31GevCtiGAqrFj3ZDP75574KwKL5ZuBf1
 z8Ke5mwSFQNrXMXDk1sI+7cEGCWPIeOZhZO52mGonS39uAqZqKnA5mjea0PMii5osJhhh52fC9r
 4LDW/spq4lpd6+n6FxH7EJY6mdM2aqlDdEO1RIzol96ptnvYBMd9IvSsK1pKBRGSHIz1Z3KZOu3
 Hxe0FUG9nSnUcDkSGyOpQbnuj39FCJK0HHBfqhiT1bc0XN1HNh4GvjhND/K+nbWjuHSpICT3HDv
 QUhoNQHn7xUl0wpw9hml7OI9wwCxO49LzVqnvchjCH0sA/lST0EyOaQAsPJR30MGhCqUxSAnBHY
 E7k7NHfD9/269slGD+A==
X-Proofpoint-GUID: NfvvEDgmbs5ICMOgFV-LnmBMTa3S7sjD
X-Authority-Analysis: v=2.4 cv=GL441ONK c=1 sm=1 tr=0 ts=6a06214a cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lj5ddwVos5PUyyIFQj0A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: NfvvEDgmbs5ICMOgFV-LnmBMTa3S7sjD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140193

Add qcrypto and cryptobam DT nodes for enabling qcrypto on kaanapali.
Shikra bam dma supports 7 iommus so update dt-bindings accordingly.

The patchset depends on below. There's recursive dependency so referred
to base DT patch here.
- https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/

Validations:
- make ARCH=arm64 DT_CHECKER_FLAGS=-m DT_SCHEMA_FILES=Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml dt_binding_check
- make ARCH=arm64 qcom/shikra-cqs-evk.dtb CHECK_DTBS=1 DT_SCHEMA_FILES=Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
- cryptobam and crypto driver probe
- kcapi test

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (3):
      dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine
      dt-bindings: bam-dma: Increase maxItems to seven for iommus
      arm64: dts: qcom: shikra: Add qcrypto node support

 .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
 .../devicetree/bindings/dma/qcom,bam-dma.yaml      |  2 +-
 arch/arm64/boot/dts/qcom/shikra.dtsi               | 35 ++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)
---
base-commit: 33c8e3305b65a2e757e68b10af521ad54ea051a6
change-id: 20260514-shikra_qcrypto-f61f4d363e6e

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

