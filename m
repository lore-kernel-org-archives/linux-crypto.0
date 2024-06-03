Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805982D8E;
	Mon,  3 Jun 2024 14:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717426553; cv=none; b=VGl9nzUkjVagvvcySNkg0EdP6HapMhD1LcKjiLOJ5kwVuly6BTuk690pM8/GDvXamekVHt/lEKBNCq46HH6wqOi/ATORdQv3HcaBPP7LILZQnbXQRwtpKZfiuANuDyq0odRV+vCKwRp6YIBRLPo02G1HllaQzv3qwD5ClzSe6Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717426553; c=relaxed/simple;
	bh=rRYL5O5uFxrfPXRTXGs3PdFwo4eiDRSxI+b2OAvAt4o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=eXdzT0kN5FUFjeueRI/6qGqJg54bW8IMc/X9JI6B8Au7tBovYSSc+Gs3uQCFWTs13XSXzIXneWyb1+ACGQycd6SSB4vUleFC1WbYSJT/piAAt3W133qRNF4MemMid9S+MUjgApuzXl7JhY8xneQJ75al4HeIi/H6xdT/nxhHyAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ljM1N9SP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ljM1N9SP"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 453BpubJ029103;
	Mon, 3 Jun 2024 14:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DcwwxU9+7NAcu8GIP/a4Nl
	2gakVndejm2PrNifddhM8=; b=ljM1N9SPH5qGBOS2927rCIeAV4wORbWOaYEnuV
	k4ah+KJrM617ieyHw3AtkPRzYTinPazXLWrW9MeZDQTAnHxLtCx/Cn5QDKjs2094
	AvpFZe1tx0wwczHmM4Xipu/HMx2MzoeIJi5Zp0IdC9/Ag/R+FDL9tQ7JKtU6nw9r
	cqsB98E9smxR/Vhw83hHvakqNCY8P4mZsgmDCq275d5hgG/N5QAwhyB4Itf/BNtm
	WJi4Mgp29uVizSSMDJZ/myOoYnSeJHCvafdtDBV8MGS9h51NAlGQeEReQVqs3o7B
	QCEq4VtbY1Fbp75lh7wIdHO16eqWk2bLAhf9tmvlYNYT3i8A==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yfw4bc7gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 14:55:42 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 453Etf9E029276
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 3 Jun 2024 14:55:41 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 3 Jun 2024
 07:55:41 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Mon, 3 Jun 2024 07:55:39 -0700
Subject: [PATCH] hwrng: omap - add missing MODULE_DESCRIPTION() macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20240603-md-hw_random-omap-v1-1-89400f524bbe@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAGrZXWYC/x3MQQrCMBBA0auUWTsQa4jgVURkkkzNgEnKpGqh9
 O5Gl2/x/waNVbjBZdhA+S1Nauk4HgYIicqDUWI3jGa0xpkT5ojpc1cqsWasmWa0MRg3+bOLwUL
 vZuVJ1v/zeuv21Bh9L0L6nZ5SXitmagsr7PsXpuTPiYIAAAA=
To: Deepak Saxena <dsaxena@plexity.net>, Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: YgRAG3nxFmXTHBxUvwThQVvpDaDH842y
X-Proofpoint-GUID: YgRAG3nxFmXTHBxUvwThQVvpDaDH842y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_11,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=962 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406030123

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/omap-rng.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/omap3-rom-rng.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/char/hw_random/omap-rng.c      | 1 +
 drivers/char/hw_random/omap3-rom-rng.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d4c02e900466..4914a8720e58 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -564,4 +564,5 @@ static struct platform_driver omap_rng_driver = {
 module_platform_driver(omap_rng_driver);
 MODULE_ALIAS("platform:omap_rng");
 MODULE_AUTHOR("Deepak Saxena (and others)");
+MODULE_DESCRIPTION("RNG driver for TI OMAP CPU family");
 MODULE_LICENSE("GPL");
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
index 18dc46b1b58e..8064c792caf0 100644
--- a/drivers/char/hw_random/omap3-rom-rng.c
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -178,4 +178,5 @@ module_platform_driver(omap3_rom_rng_driver);
 MODULE_ALIAS("platform:omap3-rom-rng");
 MODULE_AUTHOR("Juha Yrjola");
 MODULE_AUTHOR("Pali Rohár <pali@kernel.org>");
+MODULE_DESCRIPTION("RNG driver for TI OMAP3 CPU family");
 MODULE_LICENSE("GPL");

---
base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
change-id: 20240603-md-hw_random-omap-4dc06fb76dc4

