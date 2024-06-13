Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B112D1386C9;
	Thu, 13 Jun 2024 20:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718311683; cv=none; b=XruXv2jHqmBMdt/qIkXFUdgETGEA5tYVgxioksjCdnwFHpcoSaKm7OrzUKnWfIrdencXHy3Mp0qW2uD6tEBLVxT3pI8hVz5CbNOJCl7/gg+aVgQ6bY3pMfSKcOHn8Ga8ooLPVStc+v66hBsJ47wjJMTuFzC9cIFD52891bHTS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718311683; c=relaxed/simple;
	bh=6BS/ly5LvjKO90g7ZkMuzmvpyc38t0RX0vtsYlXIktQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=GzuPNyKL9SHTr2F/TvUFtYwYNpGQVzLT/rQubgYQ/RW+z0LMkgqJLCrmPBQNFpl6cV9WhfCQURV2VIpGDgO2Ub9tveOjxMP13RmOs5KD7k6HqUj+8NiqSQX1pDkHOrjfhB2rojqmN++//+WNxHwDFRUHaDODDpIl0KBt8npfItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=i0ZuYLut; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="i0ZuYLut"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DJGdhx029245;
	Thu, 13 Jun 2024 20:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=zDk10OmL3EGJ9oNDxRF5WL
	p7TSm5maTr8R+cE1Q4DaE=; b=i0ZuYLutqQbs/KUG3dhc4HXwSWzusCSNFLj4ah
	MosVa+o7J2mdnfF1BnM4/dcKwyCTSR7EcvxpeNhm5psUN8Lb6sIDA4oa0H7UV+NQ
	Qp/vt+C846nYHgFxv1tG9q6P1OfgYNaUY+JQYmH+MlRtJ9NbrwqFG2+YGxrUskjT
	JNAsOCY/T/umAYnMF3PPzSAV/mQJKiKB9yANZhi5/WtloD+v7fobbY4B6hmv18ir
	zIoAEMBUV+49jUhX6x+ct/kXn8c/W6JBzOjjhiuSyeNrlnZbtDPAQWXvEGyjhtlf
	Ln63KrXCipB4zFHTF6JhB+hmP7I9mabYqe7xxAMHVykm4Yvw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yr6q289ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 20:47:52 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45DKlpmq031384
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 20:47:51 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 13 Jun
 2024 13:47:50 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Thu, 13 Jun 2024 13:47:49 -0700
Subject: [PATCH] hwrng: add missing Arm & Cavium MODULE_DESCRIPTION()
 macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240613-md-arm64-drivers-char-hw_random-v1-1-8bc3cc208333@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAPRaa2YC/x2N0QrCMAwAf2Xk2UBXR7H+ioh0bbQB20ky52Ds3
 60+Hhx3GygJk8K520BoYeWpNugPHcQc6oOQU2Owxg7G9UcsCYMUN2ASXkgUmyaYPzcJNU0FTXT
 OeG9PwTtolZfQndf/4XJtPAYlHJsc86/75PpesQSdSWDfv9z2N5WQAAAA
To: Olivia Mackall <olivia@selenic.com>,
        Herbert Xu
	<herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: eLATcnT8dpxCzaatrOWlj12MwzQQLOIX
X-Proofpoint-ORIG-GUID: eLATcnT8dpxCzaatrOWlj12MwzQQLOIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_13,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxlogscore=903 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406130149

With ARCH=arm64, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/cavium-rng.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/cavium-rng-vf.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/char/hw_random/arm_smccc_trng.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/char/hw_random/arm_smccc_trng.c | 1 +
 drivers/char/hw_random/cavium-rng-vf.c  | 1 +
 drivers/char/hw_random/cavium-rng.c     | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/char/hw_random/arm_smccc_trng.c b/drivers/char/hw_random/arm_smccc_trng.c
index 7e954341b09f..dcb8e7f37f25 100644
--- a/drivers/char/hw_random/arm_smccc_trng.c
+++ b/drivers/char/hw_random/arm_smccc_trng.c
@@ -118,4 +118,5 @@ module_platform_driver(smccc_trng_driver);
 
 MODULE_ALIAS("platform:smccc_trng");
 MODULE_AUTHOR("Andre Przywara");
+MODULE_DESCRIPTION("Arm SMCCC TRNG firmware interface support");
 MODULE_LICENSE("GPL");
diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index c99c54cd99c6..c1b8918b2292 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -266,4 +266,5 @@ static struct pci_driver cavium_rng_vf_driver = {
 module_pci_driver(cavium_rng_vf_driver);
 
 MODULE_AUTHOR("Omer Khaliq <okhaliq@caviumnetworks.com>");
+MODULE_DESCRIPTION("Cavium ThunderX Random Number Generator VF support");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/char/hw_random/cavium-rng.c b/drivers/char/hw_random/cavium-rng.c
index b96579222408..d9d7b6038c06 100644
--- a/drivers/char/hw_random/cavium-rng.c
+++ b/drivers/char/hw_random/cavium-rng.c
@@ -88,4 +88,5 @@ static struct pci_driver cavium_rng_pf_driver = {
 
 module_pci_driver(cavium_rng_pf_driver);
 MODULE_AUTHOR("Omer Khaliq <okhaliq@caviumnetworks.com>");
+MODULE_DESCRIPTION("Cavium ThunderX Random Number Generator support");
 MODULE_LICENSE("GPL v2");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240613-md-arm64-drivers-char-hw_random-0c6609928a96

