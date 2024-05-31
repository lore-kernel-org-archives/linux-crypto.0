Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD9D322A;
	Fri, 31 May 2024 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717116817; cv=none; b=VDRWwag/j9jAxAXG8p++HYktu/01s5IR6oE9imxtvAD2hW4661TPh0etGGfaUyvtG6LoC8gpTMGbCBQYxPeDnWDRSnDACpgLtl6gPRFCrQm/+4logoZpkTeyqrTWQwyKTGmEu7H0ZbQjXDJTmy5aUqpZdP/NeRbBhUQidAIqxa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717116817; c=relaxed/simple;
	bh=Mw1oL9sdafUoY4MhV8f9PQm63vS1qe+VApJa7ikXoM8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=PsEDxFTZJAZfVnkkzRsP/Z5RfCFL8FNx0aO1fPRAgJauzhIaFTx6ZxlRbEHkRKpY3MEoOpqX+NlhXY3GR3zoKdGXInZeMgfUG3HmCu5i5wrFPmye4y4P7G08al+2rvUQ9Mx07GG2tMRvcIB+faL/nq+JLrfdOW3Ri9vf/KD9meo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=BkA9m2NT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="BkA9m2NT"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44UJ6iKa012837;
	Fri, 31 May 2024 00:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=8N4sIf9xZAt909SNCE1IP2
	Br36KKZ3iY6WzOZ4HpDR0=; b=BkA9m2NT7nJeTKV9jh3w2EFTqHspAPlU2a+Fg5
	x15O7oxn7TvlFf1YHDYh68L9+tTEsl7XN8WI8dDsRozxnVV9ndstZvUtyrkMU5Is
	beixQvAs0yKn40fCOTnSO3TBFgVhUvJD7j0rambN6OSzxykg/Q0xkbg9a4c2MFbJ
	+K2RuGrfwXhfVC6w2e9luKsr956XxPY/o+P0oDqoCeT6TkJCsYlGUYzqCkMSp2qQ
	s7Btye1LqJ/wGDZa8oMjApzcuRsAQ0BZ0B4Yl5slNBG4A7z8mNoQvN4MQySSztQF
	NAIe4R+iAmviCgBeMnS1i2iOzvlb1bGSUHWYYsus3yiDCzGg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba0qnetn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 00:53:18 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44V0rHKF007129
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 00:53:17 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 30 May
 2024 17:53:17 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Thu, 30 May 2024 17:53:17 -0700
Subject: [PATCH] crypto: x86 - add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240530-md-x86-crypto-v1-1-b480cbcc6bdf@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAHwfWWYC/x3MwQ6CMAyA4VchPdtkTlmMr2I8lK1KExmkBTNCe
 Hemx+/w/xsYq7DBvdlA+SsmY644nxqIPeU3o6Rq8M5fXXtxOCQst4BR12keMVEg8q5NHAPUZlJ
 +Sfn/Hs/qjoyxU8qx/10+kpeCA9nMCvt+AH+zadh+AAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin"
	<hpa@zytor.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: IwbYgAE4N56bvjZ05olor3sQg6bMlXBr
X-Proofpoint-ORIG-GUID: IwbYgAE4N56bvjZ05olor3sQg6bMlXBr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405310004

On x86, make allmodconfig && make W=1 C=1 warns:

WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/crypto/crc32-pclmul.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/crypto/curve25519-x86_64.o

Add the missing MODULE_DESCRIPTION() macro invocations.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/x86/crypto/crc32-pclmul_glue.c | 1 +
 arch/x86/crypto/curve25519-x86_64.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/crypto/crc32-pclmul_glue.c b/arch/x86/crypto/crc32-pclmul_glue.c
index 98cf3b4e4c9f..9f5e342b9845 100644
--- a/arch/x86/crypto/crc32-pclmul_glue.c
+++ b/arch/x86/crypto/crc32-pclmul_glue.c
@@ -195,6 +195,7 @@ module_init(crc32_pclmul_mod_init);
 module_exit(crc32_pclmul_mod_fini);
 
 MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
+MODULE_DESCRIPTION("CRC32 algorithm (IEEE 802.3) accelerated with PCLMULQDQ");
 MODULE_LICENSE("GPL");
 
 MODULE_ALIAS_CRYPTO("crc32");
diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index d55fa9e9b9e6..dcfc0de333de 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -1720,5 +1720,6 @@ module_exit(curve25519_mod_exit);
 
 MODULE_ALIAS_CRYPTO("curve25519");
 MODULE_ALIAS_CRYPTO("curve25519-x86");
+MODULE_DESCRIPTION("Curve25519 algorithm, ADX optimized");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");

---
base-commit: 4a4be1ad3a6efea16c56615f31117590fd881358
change-id: 20240530-md-x86-crypto-da6aa205dec6

