Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA833A640C
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715524; cv=none; b=AV48JMLvxcZMZxPQ5PPHKcwdktvAOtyXzbo68CpIrOXaiynt5TS/O68gbchef3o92mAdFrsHLHoqvGyJgRmub/zCmFj65zpZA/koOIE1ukMkTy+xzofwkHJz2hB71y3gHrM+YvLmlgiDEprUyWMlOxK5ssj49vBwMqsUN87UVcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715524; c=relaxed/simple;
	bh=kk1qLiHbm9kGC88siDX2uJHWpbpOShI7URZ6J+nyVZk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tmhjsYab8aby6e7Mn7tLb4Pr7h6q0SWhZ3S+MIY3DD1zsttQ4r51ExFCFgLDqAZelFMfFPXErgeXuQhFF06rkDDyFhwD0JoLb2lCUKSRXbYj3jv5AX1KKqbqSFzk/8xIjbWlTU3coBt7BjEWH6JsQSQ4/62xqmQX/TyD9zqhNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JPcT5U6Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AthzSxBd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JPcT5U6Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AthzSxBd"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T4Nl751767364
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=8PdsckrsHW27B6ZB1p1bQm
	yhKvBOYA3Ngl87ZlyvU+8=; b=JPcT5U6YG2SwN6sUZGm8skqWqL/y7rwEVvNqtZ
	d354V9KRm3+fdLFC+6Y9ZNGJHE+t1Q1mqpJGXn9LzXjbFM9BcfJuVUPH20NBgBwJ
	jkMoXyRgV5TLu8vHoTxtetfWJyv557++4sRKOVeDhJ79r0t0FYYzoy6Sbhv8xuF7
	e526fJXJooakrCEV55MIaV1A+nt6Ng68FthhWl/EmcLaqBs4DH4VTmVcdvPNUwZ+
	imh3gAZIe/AXWgDKygiQigk0XhZiwa4mkEIwAb8o2bhJu3y1TXpywkQjfhtxuBFO
	J3D1oWHEBE9f5q/lC7elj37ZD+mT0h64h/n0jv753eXnbIXA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f270a540p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:22 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30e773699d6so1678432eec.0
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 23:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782715521; x=1783320321; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8PdsckrsHW27B6ZB1p1bQmyhKvBOYA3Ngl87ZlyvU+8=;
        b=AthzSxBdyDYUUu5D/Pf8ptDyhYj7X/LweERe1JjxHWGjUHJBp91RaoQwX47pCjjpP8
         n0EqRysUzat2MP0UTDfFMFnAUBxSxuOwlRCYmsJPcZSbduarTZIMRq88jgWswbAg+lyp
         ZCpo5E22ubAeMPOPzWFuGYyiMCC2CDGjn4XtF30gvznwN+MqElyYl2Lovt53wgMe5bqI
         hxUcgQLLNmwcgBFu2evuEvpFPGTXcrxTmRadI2qOXOc/yLHfEK0z66ISFuJcM5Op6YYm
         fG9eZ3uSOicyWkE+8V0+h/9a34ulgN+jnd9PMa5o8zLJYcHciaULbhHslPpFb2cgzjQP
         9k/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782715521; x=1783320321;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PdsckrsHW27B6ZB1p1bQmyhKvBOYA3Ngl87ZlyvU+8=;
        b=UDCQi49YcEdO8BDfxgscIPUMXfxDRMwS/WkAOWSwP0ljRdVT8Jt6cBk3TWLt9e2Xa5
         Qp6AmuRgRhBkJoeQgYZGJVYJ4oQOmqnEF0Fyob4uXrI6VKwO1zB/8H9Gedt3LPwzgY/2
         i18KyCMb2+7yLyYKugdoWrwSv7N3Oj48QLOBn8NiHEhnZ9v3S3tx3e09jiDeRHVo3NuJ
         KJEM9bPU6cz3MzEiZLXtn5NQDmQfhZDAPcc9Ky6UJHcTed2j6uthqgxvOckFICOwsaRM
         KS6L+FEowIz9UdIsi2KvqWpbtDzfeBZ9UsdeGdsp6cYK9TsHTlfvAUS+71qnoufW5iDq
         yN6w==
X-Forwarded-Encrypted: i=1; AHgh+RpgusjBy8meaftgDPpKSflUO8jlunxtKRBnrukw7Juw7mzqqrMtmPqxt7FpWBOpyZkNNCQvsMVLFlYoV58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg9buqHyHK2lfK42YKFGSPSznXMUm4VKA3YMEFOAl8/XkLZsHZ
	Ukp0opduGfNPYKr4sgV9UqvmT5G6P+XorNgpZlpRhY/rxhsyOLyS7ZkDsY4IMFKqIvP9C/29bOr
	qMsIEiZhug1wyLslRGk4fBfT/DRxTBp6W0x5rY29/FuFKUYGfi7F6ZPbsX4Q9Hg0yAHw=
X-Gm-Gg: AfdE7clG9g17YNqBrm33YOr6BaZmQqlR+8YGnECVxVVlkdUFyM3lcW/geFsHJaXv32t
	g9Bm+rEvrKp+4vKID/zYbVyR/97ZTX5Xu+ATAe16hlDyVAEc5/+NxfXVTcLobRtBWosB5hCUc7x
	FVmTBaxlzktnOy5a3QZK1CxG+T3HmKp6AHdPalzdcnGKID2L81/ba9RNEo5gm6uHYZE/RisqKfG
	ctDnMglvjtN0EloPkFTI7aVtQDzczSdAqdUY3TB9uJg29Qe6sU87w2rDq44ES/V5xZWmx/uCzCK
	+PoNXd18QXLF+Z0/K0wnSO5ab9FUFt6jfXMC3lt2SfsLYaJ9LN7CP6OzQstt8tQGAb9cNAGv9x9
	wO2tZr9mIeMOREl0w8p+Vc9SjZLJv90IXNSSpuqWXQS7nYZaQl3ioTWCFEZJW6g==
X-Received: by 2002:a05:7300:503:b0:30c:a943:ea14 with SMTP id 5a478bee46e88-30ca943f3d5mr10942265eec.2.1782715521006;
        Sun, 28 Jun 2026 23:45:21 -0700 (PDT)
X-Received: by 2002:a05:7300:503:b0:30c:a943:ea14 with SMTP id 5a478bee46e88-30ca943f3d5mr10942233eec.2.1782715520350;
        Sun, 28 Jun 2026 23:45:20 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c52d669sm43580424eec.11.2026.06.28.23.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 23:45:20 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Subject: [PATCH v2 0/3] dt-bindings: crypto: Add Qualcomm Maili crypto
 support
Date: Sun, 28 Jun 2026 23:44:34 -0700
Message-Id: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFIUQmoC/3WNwQqDMBBEf0X23EgSMNae+h/FwxqTuqBGs1Yq4
 r83eu9l4MHMmx3YRXIMj2yH6FZiCmMCfcvAdji+naA2MWipjTSyEgNST8LGbVqCKFqjtDe6Qus
 hTaboPH0v3atO3CA70UQcbXdKkuB+1jriJcTtOl3VWf7jX5WQQvqiLFtfGDTqGZjz+YO9DcOQp
 4D6OI4fgChNmsYAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-3d134
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782715519; l=987;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=kk1qLiHbm9kGC88siDX2uJHWpbpOShI7URZ6J+nyVZk=;
 b=MhAbpbKRo7Zykw6jlz0gqg10926e4hrk6nA1uGswCGHP91EWYV+4HPlWpGir/87RD3v+ZBp2T
 OEXjZkgSya8CoSLiJOwKJjFudKrgaf3MEKZWSJOa4UQ6tS5/Z5iDffN
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX6LwRP5U3IJyw
 bTZvQ7kdZt8+tZz+3/77caiP79qZq+173wCQ0LucC6d7OOJeZxldnYK353SSCirOm+PY6v4d30i
 NafGLKhr80le7bGic6GJv5CdOf0wboB0r823TgRnBDhS6Pn46L5d30bvHGwpXGFpkRaLNoLGP2v
 f7mm2FYGF69Lrim2Ej4IPpY7Xvgq3/TsjjdkJenrdscZx+hkmDt1ml40IzrDYAUqVOXr9tImMxo
 t2z5zrFsiDIj5rS709oo0L+BdEtfjI6yTBy6tQklVU/6v7b6cul+xhNidOzAw47iGGdjYAPZnwe
 1fK9sMnJpy6Pxyr6YAqOsmWhXWA+AlPdyYicHUdRKib6icaEOAmLPUMdoOUAMkIbM5okKJN244T
 MBUQN5yuvQFfnsalj2NJLmiBCbroPO+JJnFddtDs/zt/+Z8JybxeTxHVyPA/sDdu+GOqWBBpopI
 c4ZkAIsPosClGjNSsMw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX/TH0HU3BO1kF
 zpFst8Tm3OOZjl5a3wNV/BdVDBUok4zOeHyGnq6S2nRN4100e/10Nf+dYSHMv3djM+UIF3jiL2K
 gMsfxWb1NrVFmC+PszV00gnxBwlC8JM=
X-Proofpoint-GUID: 52u15W3BjV3CjSA6ND5MDQp5Xnp63b9v
X-Proofpoint-ORIG-GUID: 52u15W3BjV3CjSA6ND5MDQp5Xnp63b9v
X-Authority-Analysis: v=2.4 cv=Fe4HAp+6 c=1 sm=1 tr=0 ts=6a421482 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=R6wdMziQwWSI7NrRmIEA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290055

Add crypto(ICE and TRNG) dt-binding support for Qualcomm upcoming Maili
SoC. Meanwhile fix the power-domain and clk missing on Hawi.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
Changes in v2:
- add power-domain and clk constraint
- add acked-by tag
- Link to v1: https://lore.kernel.org/r/20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com

---
Jingyi Wang (3):
      dt-bindings: crypto: qcom,prng: Document Maili TRNG
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Maili ICE
      dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk on Hawi

 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml          | 3 +++
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml                | 1 +
 2 files changed, 4 insertions(+)
---
base-commit: a87737435cfa134f9cdcc696ba3080759d04cf72
change-id: 20260609-maili-crypto-5d612f629acf

Best regards,
-- 
Jingyi Wang <jingyi.wang@oss.qualcomm.com>

