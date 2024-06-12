Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1B1C14;
	Wed, 12 Jun 2024 20:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718223137; cv=none; b=GpR3RJAT3qq/lFchSWZUVVBD3zcOP2CPUu5sYQ+0b83fgr12EhHuichHJKN4N9uTJVKLisJanINW69DBlGka7WLiOOcvxY/4SkR6NB04ZTM5j9tPGrTVib+q0daQFivTXTyI3ltYFEFLiQKVhYmXhi3y8yB6j4GTwMwrKpnL5LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718223137; c=relaxed/simple;
	bh=aiB+HcNQdSbdAWf84cErkGgK/8MxwjwOmssmKmpzNu0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=gHqCmPq+fTmcWmRjUa1sjSuBti+hnSEkDqw5QiQrgjQuIntyrq0gbNH9Eo3aiQKyQf/1ywaEnG+gcDl6qoh19y8qBN0zzYGI1yD9bg/xLnOv1LZkKBaOaDjwBGE7lBFyGkkLljGP8Pj0RlyUgCh+gfaBSMhgLpKHn77LL7sGFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=W95BQyoM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="W95BQyoM"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45CGOUa9011256;
	Wed, 12 Jun 2024 20:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=sTDbAm0FX2VDGPeO43Y89C
	dUZ8GzetNQp4r9jYVATMQ=; b=W95BQyoM7DV8Tp4UqvPRVsne0PWaMQLfTe+gyi
	ym3mRP7rqKudiLubyMe5uqDubUXqIJxJ/xRsWrzrTdgsMPyLODd/FRZgjwcvAcrI
	BBxuVjnyIW954gjci7M+/lTKYrYqz49pMb/turk6rTL1FiG7EBePRm4n80MKtwVL
	t2GuQPzmBFaOPWHoIJVlv9KA4sSzJs+1+lgZKUjZCyPOMNcmrnociTSD8+wDDgmo
	0L8q19HETU4ZB9ENomaI7STfTIaYu3ugjnwGFd0majw2Tdpgx5BsLiQu8Sbry4Do
	Hur0lFxlhzdnbSzf0jCV7f0O0RkEuOIEzQ+WpMNUM9izoOcA==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yq83whcjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 20:12:00 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45CKBw0Y022137
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 20:11:59 GMT
Received: from [169.254.0.1] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 12 Jun
 2024 13:11:58 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Wed, 12 Jun 2024 13:11:57 -0700
Subject: [PATCH] crypto: arm64 - add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240612-md-arch-arm64-crypto-v1-1-7a0e83d83cda@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAAwBamYC/x3MQQrCMBCF4auUWTuQ1lCpVxEXk+nUDJi0TKpUS
 u9udPPgW7x/hyKmUuDa7GDy1qJzrmhPDXCk/BDUsRo613nXtx2mEck41km9R7bPss54YTfQmUM
 YJg/1uphMuv2zt3t1oCIYjDLHX+yp+bVhorKKwXF8AWT2/oaFAAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon
	<will@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: dPFcgKCpPLXktockCe95fvolI67ewKud
X-Proofpoint-ORIG-GUID: dPFcgKCpPLXktockCe95fvolI67ewKud
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_10,2024-06-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406120143

With ARCH=arm64, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm64/crypto/crct10dif-ce.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm64/crypto/poly1305-neon.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm64/crypto/aes-neon-bs.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/arm64/crypto/aes-neonbs-glue.c   | 1 +
 arch/arm64/crypto/crct10dif-ce-glue.c | 1 +
 arch/arm64/crypto/poly1305-glue.c     | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 467ac2f768ac..46425e7b9755 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_DESCRIPTION("Bit sliced AES using NEON instructions");
 MODULE_LICENSE("GPL v2");
 
 MODULE_ALIAS_CRYPTO("ecb(aes)");
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 09eb1456aed4..57036a02634b 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -138,6 +138,7 @@ module_cpu_feature_match(ASIMD, crc_t10dif_mod_init);
 module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_DESCRIPTION("CRC-T10DIF using arm64 NEON and Crypto Extensions");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("crct10dif");
 MODULE_ALIAS_CRYPTO("crct10dif-arm64-ce");
diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index 1fae18ba11ed..9c4bfd62e789 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -226,6 +226,7 @@ static void __exit neon_poly1305_mod_exit(void)
 module_init(neon_poly1305_mod_init);
 module_exit(neon_poly1305_mod_exit);
 
+MODULE_DESCRIPTION("Poly1305 transform using NEON instructions");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("poly1305");
 MODULE_ALIAS_CRYPTO("poly1305-neon");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240612-md-arch-arm64-crypto-7c09a3cbb9f4

