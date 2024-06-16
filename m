Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB0169ADA;
	Sun, 16 Jun 2024 06:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718518506; cv=none; b=T+kNyxyHQ2QESbA/E+wKsVyiaHUN+OJGb8txzxVHieTiuCv+3F5A1720iYyDOIQ1NS8/rbGCXuyKHTMBRgRln5SrTRz1ZE80uld9IIhD6nt5kcznjEmHtq5pWyq0XZ+0ubDSBbKEa20PaoryxeenIThdIZFCyzghN1rC8LQJE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718518506; c=relaxed/simple;
	bh=KXEgR5GnqJoxLrzxenosBEsqW3oYDG4krnM+m4NIOnY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=BfOXNlVlIj+cVX0u01LVycl15k7bVrcgsgbMOL4VrxYYljRwyWiO9eRE9CXc5zMs03TxgApB2R1zbewUV3FAYwBhUvOQ36OOEfAWOQgS8GXshiN4bh534k9WODO4ZUeniMJZEpN8MLKTtbB903vEX+Nl0PMKtVq5Q+fOvLRWs4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=aT2WOcX6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="aT2WOcX6"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45G5QQau025146;
	Sun, 16 Jun 2024 06:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=JJBiIeUtBaLvynT/93cCjI
	OFgX6CDX3j2TJCH2/qi7E=; b=aT2WOcX64X/Drn+K8+gkK+4JRCVB0mneBZ9X8x
	xhkRcbTQG3qq/aN5UleWksMXofuxtAa4tUFPiiiTLwPuGjCbAaw81I2qyxd0L20v
	le14akPIb76k9U3JipzsO5cHnZ5g+Bnxg0BeOdDiEgPGHvFS9lwLDJWFVxZRU9dk
	7G1SNMC6NuwHjU37l5Y4tmFFc6hSKQOe+dkX6yDbF3omMWSxv9pnaD7jQzZyQIIJ
	BjQ49lkN+RzkKoxyVG75S06LSTw443nbol6JhzKxL3oTFXstNdVUvh7jK1+oc/Ne
	0jp/R3JJvKnNpTvC+LXmQLFIW9TodvZkenB6eZGMFgVxWWqA==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ys3639fmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Jun 2024 06:14:59 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45G6EwiP016005
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Jun 2024 06:14:58 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 15 Jun
 2024 23:14:58 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sat, 15 Jun 2024 23:14:57 -0700
Subject: [PATCH] crypto: lib - add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240615-md-arm-lib-crypto-v1-1-27b67bf8573c@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAOCCbmYC/x3MwQ6CMAyA4VchPdtkIDPGVzEeuq1KEzZICwZDe
 Henx+/w/zsYq7DBrdlB+S0mU6loTw3EgcqLUVI1dK7r3aX1mBOSZhwlYNTPvEzYe5/Yn326koP
 azcpP2f7P+6M6kDEGpRKH32mUsm6YyRZWOI4v32oM5oIAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: WbBa9OCnvlx8iAt0SIiTe41w_2CtzSEd
X-Proofpoint-ORIG-GUID: WbBa9OCnvlx8iAt0SIiTe41w_2CtzSEd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-16_05,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406160047

With ARCH=arm, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libsha256.o

Add the missing invocation of the MODULE_DESCRIPTION() macro to all
files which have a MODULE_LICENSE().

This includes sha1.c and utils.c which, although they did not produce
a warning with the arm allmodconfig configuration, may cause this
warning with other configurations.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 lib/crypto/sha1.c   | 1 +
 lib/crypto/sha256.c | 1 +
 lib/crypto/utils.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index 1aebe7be9401..6d2922747cab 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -137,4 +137,5 @@ void sha1_init(__u32 *buf)
 }
 EXPORT_SYMBOL(sha1_init);
 
+MODULE_DESCRIPTION("SHA-1 Algorithm");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 3ac1ef8677db..3f42d203c7bc 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -165,4 +165,5 @@ void sha256(const u8 *data, unsigned int len, u8 *out)
 }
 EXPORT_SYMBOL(sha256);
 
+MODULE_DESCRIPTION("SHA-256 Algorithm");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/utils.c b/lib/crypto/utils.c
index c852c7151b0a..373364141408 100644
--- a/lib/crypto/utils.c
+++ b/lib/crypto/utils.c
@@ -85,4 +85,5 @@ void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int len)
 }
 EXPORT_SYMBOL_GPL(__crypto_xor);
 
+MODULE_DESCRIPTION("Crypto library utility functions");
 MODULE_LICENSE("GPL");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240615-md-arm-lib-crypto-455de535d8a0

