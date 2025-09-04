Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7062C21F9;
	Thu,  4 Sep 2025 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001597; cv=none; b=LgWOvBpRG55Tzof++MGWmp7gNvi2Kwt3WMOcqOBelMLGadpDKs8NRLoOLkTVaC4GOxl0gHB20qrYcG47E4WbPP3liWbEk87buZjBjflWYbYOghP/Gkj4pfOSIfcXbS5/6bjjvshTJ9ZudlAi5XfobX1j3DlNoztaO2ZPPzw1V6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001597; c=relaxed/simple;
	bh=3chTI+iaRKsWWyIV0KBa7Nq8xEZwFDgEqkV+/IR8Of4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ER9GTWnlx/aKosOruwQVL1KQ23uF7HlfWuwfBNmaGQCOYxrjZqxTBZKSTUqlNKgVWSqGwe2YCBh2CNxs3gno9MWZvrFkv6HXShsf5hXeZ/ZL01THZ5i8uHM6pEHO+kIyr+kOKDB+JLYyEmoQWeajQqYjay5wLGOZibz0pWN4+nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NIgFhbwW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NIgFhbwW"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiWp023800;
	Thu, 4 Sep 2025 15:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=kS1gU
	9d3pVWKcVWOPDI1w1qkImnLQ4Z/nKiBmhIoFQ8=; b=NIgFhbwWcLqSiDZVGa2wz
	27qUGJaLI/a0PD+ARncjCtrQm3VpXy+NsoQr7awCLOL25o9wS7Moa2n6ts2n/53M
	/51PDrvrFOSkHST1rcMufXVefJk2U6B8g4kanDT5tdyvsvrTJFbZKajF2+r5vRj3
	dlGpbY4p8rLxm9LwM0HgmftAwNj4oUY5pQt4rtIk1dF+GU1oRS68w/v0LdpOq4Ec
	ibc3QnwtHO+6W69KR6w8mWOKj7TZOytHTMthNZObWJT1pTfdUfzQ2dHSqjtA1J3s
	SgPxFYAYIAeOSWSQmShiWNrYFVCMMqHw3kdCFSShE3h1fJSr0tTYi5P3Q8lsi+UB
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd02b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FELue040036;
	Thu, 4 Sep 2025 15:59:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:43 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7C000707;
	Thu, 4 Sep 2025 15:59:43 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-73;
	Thu, 04 Sep 2025 15:59:43 +0000
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
Subject: [PATCH RFC 072/104] crypto: fips140: convert crypto/simd.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:44 +0200
Message-Id: <20250904155216.460962-73-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX2APGZWnUeDem
 lWHqSUDkzInze3THRWMX+qewAo8+n787gyFjO3iX6f9e2N8tJBFE7VKc/yAM1oAV1j+3Gs5q3cJ
 TffSL7N7CFjsEtoO5CIAl0IphqsupiIltdXwOzAX2d1P+P46Xxrc0qsjHHZdKYb4yljmFnV0F6R
 wN0KvQ6qSFEV+Fg6F6P++rqC4xvTsFJ60OfdTKlapdWakLEg6l3p6I1hHgogmDaA13+l99U57ca
 FREynV9izygpOHI62gQdDNsHYw7jACHi4NOXKeeSNJDF8OltXSTkqi99T3Rl0RfPpm+9jdQDiFd
 2LtMvGVIKcWRf4Uw/AmK3t5Ljuxg8iOpW2RjXx5eVJtwZhy093xn1WwleFtAUkpRFwq2UI9dZD0
 gloA5wO/6QxB/scqUZBfcR9D2DinBQ==
X-Proofpoint-GUID: G6d-oFm1kh4PwktU3ke734hKp2haqOOh
X-Proofpoint-ORIG-GUID: G6d-oFm1kh4PwktU3ke734hKp2haqOOh
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b770 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=CYsGSl3Qh4rxA5LVBUoA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SIMD --source crypto/simd.c --header include/crypto/internal/simd.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c           | 16 ++++++++++++++++
 crypto/simd.c                  | 24 ++++++++++++------------
 include/crypto/internal/simd.h | 32 +++++++++++++++++++-------------
 3 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index c4e66d008be2..112212b32d6d 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -562,3 +562,19 @@ DEFINE_CRYPTO_API_STUB(crypto_grab_sig);
 
 #endif
 
+/*
+ * crypto/simd.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_SIMD)
+
+#include <crypto/internal/simd.h>
+
+DEFINE_CRYPTO_API_STUB(simd_skcipher_create_compat);
+DEFINE_CRYPTO_API_STUB(simd_skcipher_free);
+DEFINE_CRYPTO_API_STUB(simd_register_skciphers_compat);
+DEFINE_CRYPTO_API_STUB(simd_unregister_skciphers);
+DEFINE_CRYPTO_API_STUB(simd_register_aeads_compat);
+DEFINE_CRYPTO_API_STUB(simd_unregister_aeads);
+
+#endif
+
diff --git a/crypto/simd.c b/crypto/simd.c
index b07721d1f3f6..32e3eb04462c 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -136,7 +136,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
 	return 0;
 }
 
-struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
+struct simd_skcipher_alg *CRYPTO_API(simd_skcipher_create_compat)(struct skcipher_alg *ialg,
 						      const char *algname,
 						      const char *drvname,
 						      const char *basename)
@@ -195,16 +195,16 @@ struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
 	salg = ERR_PTR(err);
 	goto out;
 }
-EXPORT_SYMBOL_GPL(simd_skcipher_create_compat);
+DEFINE_CRYPTO_API(simd_skcipher_create_compat);
 
-void simd_skcipher_free(struct simd_skcipher_alg *salg)
+void CRYPTO_API(simd_skcipher_free)(struct simd_skcipher_alg *salg)
 {
 	crypto_unregister_skcipher(&salg->alg);
 	kfree(salg);
 }
-EXPORT_SYMBOL_GPL(simd_skcipher_free);
+DEFINE_CRYPTO_API(simd_skcipher_free);
 
-int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
+int CRYPTO_API(simd_register_skciphers_compat)(struct skcipher_alg *algs, int count,
 				   struct simd_skcipher_alg **simd_algs)
 {
 	int err;
@@ -236,9 +236,9 @@ int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
 	simd_unregister_skciphers(algs, count, simd_algs);
 	return err;
 }
-EXPORT_SYMBOL_GPL(simd_register_skciphers_compat);
+DEFINE_CRYPTO_API(simd_register_skciphers_compat);
 
-void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
+void CRYPTO_API(simd_unregister_skciphers)(struct skcipher_alg *algs, int count,
 			       struct simd_skcipher_alg **simd_algs)
 {
 	int i;
@@ -252,7 +252,7 @@ void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
 		}
 	}
 }
-EXPORT_SYMBOL_GPL(simd_unregister_skciphers);
+DEFINE_CRYPTO_API(simd_unregister_skciphers);
 
 /* AEAD support */
 
@@ -427,7 +427,7 @@ static void simd_aead_free(struct simd_aead_alg *salg)
 	kfree(salg);
 }
 
-int simd_register_aeads_compat(struct aead_alg *algs, int count,
+int CRYPTO_API(simd_register_aeads_compat)(struct aead_alg *algs, int count,
 			       struct simd_aead_alg **simd_algs)
 {
 	int err;
@@ -459,9 +459,9 @@ int simd_register_aeads_compat(struct aead_alg *algs, int count,
 	simd_unregister_aeads(algs, count, simd_algs);
 	return err;
 }
-EXPORT_SYMBOL_GPL(simd_register_aeads_compat);
+DEFINE_CRYPTO_API(simd_register_aeads_compat);
 
-void simd_unregister_aeads(struct aead_alg *algs, int count,
+void CRYPTO_API(simd_unregister_aeads)(struct aead_alg *algs, int count,
 			   struct simd_aead_alg **simd_algs)
 {
 	int i;
@@ -475,7 +475,7 @@ void simd_unregister_aeads(struct aead_alg *algs, int count,
 		}
 	}
 }
-EXPORT_SYMBOL_GPL(simd_unregister_aeads);
+DEFINE_CRYPTO_API(simd_unregister_aeads);
 
 MODULE_DESCRIPTION("Shared crypto SIMD helpers");
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index 9e338e7aafbd..a1a419f7fd57 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -6,6 +6,7 @@
 #ifndef _CRYPTO_INTERNAL_SIMD_H
 #define _CRYPTO_INTERNAL_SIMD_H
 
+#include <crypto/api.h>
 #include <asm/simd.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
@@ -15,28 +16,33 @@
 struct simd_skcipher_alg;
 struct skcipher_alg;
 
-struct simd_skcipher_alg *simd_skcipher_create_compat(struct skcipher_alg *ialg,
-						      const char *algname,
-						      const char *drvname,
-						      const char *basename);
-void simd_skcipher_free(struct simd_skcipher_alg *alg);
+DECLARE_CRYPTO_API(simd_skcipher_create_compat, struct simd_skcipher_alg *,
+	(struct skcipher_alg *ialg, const char *algname, const char *drvname, const char *basename),
+	(ialg, algname, drvname, basename));
+DECLARE_CRYPTO_API(simd_skcipher_free, void,
+	(struct simd_skcipher_alg *alg),
+	(alg));
 
-int simd_register_skciphers_compat(struct skcipher_alg *algs, int count,
-				   struct simd_skcipher_alg **simd_algs);
+DECLARE_CRYPTO_API(simd_register_skciphers_compat, int,
+	(struct skcipher_alg *algs, int count, struct simd_skcipher_alg **simd_algs),
+	(algs, count, simd_algs));
 
-void simd_unregister_skciphers(struct skcipher_alg *algs, int count,
-			       struct simd_skcipher_alg **simd_algs);
+DECLARE_CRYPTO_API(simd_unregister_skciphers, void,
+	(struct skcipher_alg *algs, int count, struct simd_skcipher_alg **simd_algs),
+	(algs, count, simd_algs));
 
 /* AEAD support */
 
 struct simd_aead_alg;
 struct aead_alg;
 
-int simd_register_aeads_compat(struct aead_alg *algs, int count,
-			       struct simd_aead_alg **simd_algs);
+DECLARE_CRYPTO_API(simd_register_aeads_compat, int,
+	(struct aead_alg *algs, int count, struct simd_aead_alg **simd_algs),
+	(algs, count, simd_algs));
 
-void simd_unregister_aeads(struct aead_alg *algs, int count,
-			   struct simd_aead_alg **simd_algs);
+DECLARE_CRYPTO_API(simd_unregister_aeads, void,
+	(struct aead_alg *algs, int count, struct simd_aead_alg **simd_algs),
+	(algs, count, simd_algs));
 
 /*
  * crypto_simd_usable() - is it allowed at this time to use SIMD instructions or
-- 
2.39.3

