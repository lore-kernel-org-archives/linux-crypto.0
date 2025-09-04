Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406762EFDA5;
	Thu,  4 Sep 2025 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001609; cv=none; b=riMoe4+4LiRfOan+wGrh1OfBrqCUcQQGAWM+o429s1jj4rYMl2sbivxmhXTOBsPmWHbrUfIJ8sGD/DTRbkWbezURITaL4XLc4+6jjWOVkLEncQX38KMky+qqBrlNLr9zF0NoSMwMWzxdQvHuX46jpHGXPTmbunaMsTcSx5kRn/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001609; c=relaxed/simple;
	bh=8hC08At/IEipd0Gtkwz+lI4pWRRtS2/sViKY1mldPto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jyCAeif/Nw4evBFMXiIKYoUsC49GxaWeN0ju5yaU46tg8O1ebfhlYZtUGVkfi53xeqTGbZrLXzxYvv7Bjxovp6MuA/KxE4R3InmCEkTwTX6ZhO4dCEOFOSwYe7q4ZkSXMed3h/Vp1vJMxn3tHphK3gpQ08jVJtLcoiXYyWTl+eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XXWOQMcT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XXWOQMcT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FthoK009040;
	Thu, 4 Sep 2025 15:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=N9Jf+
	nn6pSM6Fwasj822KHB8CTTaOJMAysblnqdCD8Q=; b=XXWOQMcT2WJ1lp87T9DWV
	XH5iydcqxtrePkI8spWKR5wwKDnNjIRAleo3zzbRRZ53xIVgRSBq9FvRiiFZ0f7o
	Eoj236t/kgUZI6hqrMT52N6+do8nrcKN1nGVKhJgTfPeNOdeIlsc0+fM+vXXLmNG
	UuD+UtW1h/vjRhPo5+/qSMu7jwS0RZ2IB3GsNwvKx9jniSqgeYtg5nzt6scMGkxT
	kwM4X5OSIfRK+w3dZpXndeI990yaJlzPxuUya/QOuCHLD1m7CBOd6McTrZMJYQP8
	ZiDvK/DMzxTeEUsy+24DHZ76ljYOY2Kg9dWij5OkzF4aL0pE/rap3oT3v09s/2aK
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FLHeR040062;
	Thu, 4 Sep 2025 15:59:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtr5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:56 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7I000707;
	Thu, 4 Sep 2025 15:59:55 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-76;
	Thu, 04 Sep 2025 15:59:55 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 075/104] crypto: fips140: convert crypto/testmgr.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:47 +0200
Message-Id: <20250904155216.460962-76-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Proofpoint-ORIG-GUID: LRpXXAuR3kyd9HZSvjyVMw1G97cXMT9b
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b77c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=0EPD4FprRVkn1_r9_xkA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX+RwgZKJE8kyd
 +xHk93aSP0iQNqYKh9Ncw6N4dstWuZOV2ea/EXjbONqugureT49SNDP/6GkG3SQ3CJmTreyTj0/
 HpFG+Uvtr66afbW5i65pm2IBMNqChZsDGrzj9+z1cOdGLIzkY+r5o8MwenGpDhtHnRi8c/8n04O
 DLXHpvGZMuxzupcmbVVuFgs35v4aVEI3W1Y6ew1J9e6I4G7tbJarrL83IL4vs683AwthjfEaSFW
 BkJxs2RZ4OUk2SPneey3j6pwfLT6Rm95uP5FIQ2/oHKmpvSEE8edmuXw7fOfm05+GHacTmQagCB
 2SVZG43keg0A1mlP0yx2Z4c9M0gmH8i5T412z8QTYRGEk4iNmDtPiDJU9YBd1nhUoDTfwHO+zXN
 q1W6HNoCSu9C6I1OluWEOsrhJnXaaA==
X-Proofpoint-GUID: LRpXXAuR3kyd9HZSvjyVMw1G97cXMT9b

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_MANAGER2 --source crypto/testmgr.c --header crypto/internal.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c | 11 +++++++++++
 crypto/internal.h    |  4 +++-
 crypto/testmgr.c     |  6 +++---
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 115a0fc99e31..5599cfa963d8 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -609,3 +609,14 @@ DEFINE_CRYPTO_API_STUB(skcipher_alloc_instance_simple);
 
 #endif
 
+/*
+ * crypto/testmgr.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_MANAGER2)
+
+#include <crypto/internal.h>
+
+DEFINE_CRYPTO_API_STUB(alg_test);
+
+#endif
+
diff --git a/crypto/internal.h b/crypto/internal.h
index 700280457bf6..f4b12863d922 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -66,7 +66,9 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
-int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask);
+DECLARE_CRYPTO_API(alg_test, int,
+	(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask),
+	(alg, driver, name, type, mask));
 
 #if !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) || !IS_ENABLED(CONFIG_CRYPTO_SELFTESTS)
 static inline bool crypto_boot_test_finished(void)
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 35626ae18c60..54560f3431ca 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
 #ifndef CONFIG_CRYPTO_SELFTESTS
 
 /* a perfect nop */
-int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
+int CRYPTO_API(alg_test)(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
 {
 	return 0;
 }
@@ -5864,7 +5864,7 @@ static int alg_test_fips_disabled(const struct crypto_alg *alg, const struct alg
 	return !(desc->fips_allowed & FIPS_NON_CRYPTOGRAPHIC);
 }
 
-int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
+int CRYPTO_API(alg_test)(struct crypto_alg *alg, const char *driver, const char *name, u32 type, u32 mask)
 {
 	int i;
 	int j;
@@ -5967,4 +5967,4 @@ int alg_test(struct crypto_alg *alg, const char *driver, const char *name, u32 t
 
 #endif /* CONFIG_CRYPTO_SELFTESTS */
 
-EXPORT_SYMBOL_GPL(alg_test);
+DEFINE_CRYPTO_API(alg_test);
-- 
2.39.3

