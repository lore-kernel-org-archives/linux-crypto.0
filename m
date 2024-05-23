Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCAD83CBE;
	Thu, 23 May 2024 19:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716493668; cv=none; b=cAxlQOAwuGZVDVc/GI3DBgtPIledFPLIN6/2X+S74NlDrhKasd6fjvaWHlVyR1pzNqLp+6bGzCVEWJYXfbX5Ltjeu2SAiHQMRELrVlxO+Pfeo0AJaBEjCaqEExng1PDvs5wxaCxESJrwAfc8l0sqEFVTDG9wNRNChWwORNCZElM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716493668; c=relaxed/simple;
	bh=GA52NJWp+1h8u4tby4+gGoB82JoXzqIxQTsoH7PKXfA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=E3TE0U8sxFr0/2cud+0mRExzqEaJp9hJG3YS/Hz5Bn+e6bCGa6MHNYWbTYNgYT9zlzun9I00FDE2t4886/lSB5BRBaFqd7J7YsiH7tnub3w8lTezjFlr1AZxZ6MKCMYBLL8VMrk0E3x4CRn6mZyDs4pAlLjFIVfGryXTixTTk/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=WTIc1S3M; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="WTIc1S3M"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44NHTpDn020409;
	Thu, 23 May 2024 19:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ol9wNVVAuaiGKkQ9S3XpDe
	s5jFnSQ+wjUvQI60yY5m4=; b=WTIc1S3M4PvjohxCi2lIePT+XntJi9PJtuTw1f
	b9vZgzDd1igQ6wg8qYcKzGAU5y4gnjPDoTkr2BO7UE7Ctd9vGwxs11fxzt16RW9t
	uFfSAW1OZzFUswGyQDGlqZqQl217guEIbg35YNyWj6uM7eTirVrNFhonznMyQFEX
	rntCyglP61DV4BRmWYr4zMPhAKwvox9EC/xEe6Rzc9yIdurzAp6bp1DUNRboLPLI
	n5I4g3H7Kmv46ClxIgHb24mJRrSeL4GCue57Wl76yPkBy+0WhDj5HYr8dGONtXwJ
	z01DWe/Dd4NoTJ9SjA5YzwOep6EXuRzs9TsXMdLNVzP/8sIQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yaa8kg973-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 19:47:41 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44NJleLi013435
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 19:47:40 GMT
Received: from [169.254.0.1] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 23 May
 2024 12:47:40 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Thu, 23 May 2024 12:47:39 -0700
Subject: [PATCH] crypto: Add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240523-md-crypto-v1-1-eb68e4aa5592@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAFqdT2YC/x3MQQrCQAxA0auUrA2MY0XwKuIik6Y2YKdD0kpL6
 d0dXT74/B1cTMXh3uxg8lHXKVecTw3wQPklqF01xBDbcI0XHDtk28o8IdEtSUsxcM9Q+2LS6/p
 /PZ7ViVwwGWUefoe35mXFkXwWw7LVFI7jCy8u8laAAAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: GOnCjqdKltJlcKC13t2aAjMTqsYyPci-
X-Proofpoint-GUID: GOnCjqdKltJlcKC13t2aAjMTqsYyPci-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_11,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405230136

Fix the 'make W=1' warnings:
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/cast_common.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/af_alg.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/algif_hash.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/algif_skcipher.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/ecc.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/curve25519-generic.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/xor.o
WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/crypto_simd.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 crypto/af_alg.c             | 1 +
 crypto/algif_hash.c         | 1 +
 crypto/algif_skcipher.c     | 1 +
 crypto/cast_common.c        | 1 +
 crypto/curve25519-generic.c | 1 +
 crypto/ecc.c                | 1 +
 crypto/simd.c               | 1 +
 crypto/xor.c                | 1 +
 8 files changed, 8 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 18cfead0081d..0da7c1ac778a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1317,5 +1317,6 @@ static void __exit af_alg_exit(void)
 
 module_init(af_alg_init);
 module_exit(af_alg_exit);
+MODULE_DESCRIPTION("Crypto userspace interface");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(AF_ALG);
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 7c7394d46a23..5498a87249d3 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -471,4 +471,5 @@ static void __exit algif_hash_exit(void)
 
 module_init(algif_hash_init);
 module_exit(algif_hash_exit);
+MODULE_DESCRIPTION("Userspace interface for hash algorithms");
 MODULE_LICENSE("GPL");
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 02cea2149504..125d395c5e00 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -437,4 +437,5 @@ static void __exit algif_skcipher_exit(void)
 
 module_init(algif_skcipher_init);
 module_exit(algif_skcipher_exit);
+MODULE_DESCRIPTION("Userspace interface for skcipher algorithms");
 MODULE_LICENSE("GPL");
diff --git a/crypto/cast_common.c b/crypto/cast_common.c
index 9b2f60fd4cef..fec1f6609a40 100644
--- a/crypto/cast_common.c
+++ b/crypto/cast_common.c
@@ -282,4 +282,5 @@ __visible const u32 cast_s4[256] = {
 };
 EXPORT_SYMBOL_GPL(cast_s4);
 
+MODULE_DESCRIPTION("Common lookup tables for CAST-128 (cast5) and CAST-256 (cast6)");
 MODULE_LICENSE("GPL");
diff --git a/crypto/curve25519-generic.c b/crypto/curve25519-generic.c
index d055b0784c77..68a673262e04 100644
--- a/crypto/curve25519-generic.c
+++ b/crypto/curve25519-generic.c
@@ -87,4 +87,5 @@ module_exit(curve25519_exit);
 
 MODULE_ALIAS_CRYPTO("curve25519");
 MODULE_ALIAS_CRYPTO("curve25519-generic");
+MODULE_DESCRIPTION("Curve25519 elliptic curve (RFC7748)");
 MODULE_LICENSE("GPL");
diff --git a/crypto/ecc.c b/crypto/ecc.c
index fe761256e335..af698f8852fb 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1715,4 +1715,5 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 }
 EXPORT_SYMBOL(crypto_ecdh_shared_secret);
 
+MODULE_DESCRIPTION("core elliptic curve module");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/simd.c b/crypto/simd.c
index edaa479a1ec5..2aa4f72e224f 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -523,4 +523,5 @@ void simd_unregister_aeads(struct aead_alg *algs, int count,
 }
 EXPORT_SYMBOL_GPL(simd_unregister_aeads);
 
+MODULE_DESCRIPTION("Shared crypto SIMD helpers");
 MODULE_LICENSE("GPL");
diff --git a/crypto/xor.c b/crypto/xor.c
index 8e72e5d5db0d..a1363162978c 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -165,6 +165,7 @@ calibrate_xor_blocks(void)
 
 static __exit void xor_exit(void) { }
 
+MODULE_DESCRIPTION("RAID-5 checksumming functions");
 MODULE_LICENSE("GPL");
 
 #ifndef MODULE

---
base-commit: 5c4069234f68372e80e4edfcce260e81fd9da007
change-id: 20240523-md-crypto-aa7be4a20cfc

