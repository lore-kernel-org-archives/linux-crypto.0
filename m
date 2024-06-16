Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC25A2F2A;
	Sun, 16 Jun 2024 05:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718515975; cv=none; b=eSwIVq/Y6MH5wEGKghfZYICw+c42w3eNQ3063EWAzknEhKuylgZF/8RfQcyh5i9Blj6HhW+ZocMmKzgQzFKHEgE8cCTARkoEvNuaBuz2kFu1e7ThFUQwcfJ2+/Oh9/UQuxhf17XQYPRtM2lIhV2gaVv8y/So4BAYMECrP9gby0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718515975; c=relaxed/simple;
	bh=fEjLMLkd9UF8/WoELO3lTJMGRHiovIM7tCtVYaw88Xw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=PtwghAdUf3JdJznF+xc9d7iXoC/oSESad7rQYRWy2bnaKZ7PGMMJJN0umQtiS2bi3TQ13wjtse6FvJaHvgsJiO0BCSBdpGTrxcn+6bHPl5Tef5BrptRxx0NY7TYqMsPEwYeGBoRQyubIssTWcO1eDKSsLjHoNTkoIlvmQrsgZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=U6wk1tUF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="U6wk1tUF"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45G5Vg0g019998;
	Sun, 16 Jun 2024 05:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=H6noi8ErVlOkg1/+VhAOxj
	v7AOAPlIdBK9S1Ro/vRuo=; b=U6wk1tUFcrGs8AiT5zfIezaNETyeDj5r3fLj7W
	NvXcBvnKW7/+v4qPqamOgQQpYOIJzSO1izvbBqNdyQMb+YCQGeNJHPyoUY+uXYva
	6YSixsgRbtz38upQ1Q/F8CcliVcnCApQvbr3OE/WiCMHCzjAR0ZkvTS/XitHvK0l
	RkitA4E5hzKL53BovEJ9w2uIg+26b43D8a5rJ4fiiJramcPnWMmEeR+9qZhS+tmy
	oKErdYZX0qRdbmotWuCL3ODc+g7yPU0eaDHvz+xnbpSiISRkqEaAra5dtCT9477N
	qqPrhKXF8q6pMqvp+S9ZqVSn/L2ABMZxjnuqlpHTIMswKDGg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ys29gsghh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Jun 2024 05:32:41 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45G5WdFh005140
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Jun 2024 05:32:39 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 15 Jun
 2024 22:32:39 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sat, 15 Jun 2024 22:32:37 -0700
Subject: [PATCH] crypto: arm: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240615-md-arm-arch-arm-crypto-cont-v1-1-f15541b5db02@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAPR4bmYC/x3MQQ6CMBCF4auQWTtJC2jUqxgW7TDYSWwh02owh
 LtbWbzk/Ztvg8wqnOHebKD8kSxzqmFPDVBw6ckoY21oTdubiz1jHNFprKNwHNLvUmakORU0ZCf
 q+u5K/gZVWJQnWQ/9MdT2LjN6dYnC33xJeq8YXS6ssO8/0s1+AIwAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: gHcgwPRw3-1QGifa2Xo_xZCktpzRj3u1
X-Proofpoint-ORIG-GUID: gHcgwPRw3-1QGifa2Xo_xZCktpzRj3u1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-16_04,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=944
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406160041

With ARCH=arm, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/crypto/aes-arm-bs.o
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/crypto/crc32-arm-ce.o

Add the missing invocation of the MODULE_DESCRIPTION() macro to all
files which have a MODULE_LICENSE().

This includes crct10dif-ce-glue.c and curve25519-glue.c which,
although they did not produce a warning with the arm allmodconfig
configuration, may cause this warning with other configurations.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/arm/crypto/aes-neonbs-glue.c   | 1 +
 arch/arm/crypto/crc32-ce-glue.c     | 1 +
 arch/arm/crypto/crct10dif-ce-glue.c | 1 +
 arch/arm/crypto/curve25519-glue.c   | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f00f042ef357..201eb35dde37 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_DESCRIPTION("Bit sliced AES using NEON instructions");
 MODULE_LICENSE("GPL v2");
 
 MODULE_ALIAS_CRYPTO("ecb(aes)");
diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
index 2208445808d7..4ff18044af07 100644
--- a/arch/arm/crypto/crc32-ce-glue.c
+++ b/arch/arm/crypto/crc32-ce-glue.c
@@ -241,6 +241,7 @@ module_init(crc32_pmull_mod_init);
 module_exit(crc32_pmull_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_DESCRIPTION("Accelerated CRC32(C) using ARM CRC, NEON and Crypto Extensions");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("crc32");
 MODULE_ALIAS_CRYPTO("crc32c");
diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
index e9191a8c87b9..79f3b204d8c0 100644
--- a/arch/arm/crypto/crct10dif-ce-glue.c
+++ b/arch/arm/crypto/crct10dif-ce-glue.c
@@ -84,5 +84,6 @@ module_init(crc_t10dif_mod_init);
 module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_DESCRIPTION("Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("crct10dif");
diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
index 9bdafd57888c..e7b87e09dd99 100644
--- a/arch/arm/crypto/curve25519-glue.c
+++ b/arch/arm/crypto/curve25519-glue.c
@@ -133,4 +133,5 @@ module_exit(arm_curve25519_exit);
 
 MODULE_ALIAS_CRYPTO("curve25519");
 MODULE_ALIAS_CRYPTO("curve25519-neon");
+MODULE_DESCRIPTION("Public key crypto: Curve25519 (NEON-accelerated)");
 MODULE_LICENSE("GPL v2");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240615-md-arm-arch-arm-crypto-cont-0c1fc3438cb9

