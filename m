Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3EA283FF8;
	Thu,  4 Sep 2025 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001585; cv=none; b=tdwyuUsDWnhlKoWqjNzLT5m/0WaIF0WPAW/pabJ48zuesktjxwSvQMP+ZN5WEltGJQvdKp3a/iY4yC64cvxRGqjXua7NbEV5a+f5gjRopOWy+b5Gnnu4WR4qHrQ37MmE3qWINo27bJg6gFA6296T9jLtZT9QWyGoE35ptXVErZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001585; c=relaxed/simple;
	bh=jO5uiMM4Q0l32dc1a8vl+JOxeq5aArix+YHP8EFiSk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XD43g6Fs5aNj1HlAY8z7gJMfP5LeTg6eDR3S9DVI73rVobj84Hd36VonWQ+iVpYuGH+jCuacmr2Oes7KOcr+rL0h0ZShH1D7soG91rBKDhQJ9+lB7oeG3fgKJzdgR3yIGkkReuBZ02UAwsZgIqhG2PLYA/xNf113xWvW+tb4GoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AVOibUpR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AVOibUpR"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fuf1d004081;
	Thu, 4 Sep 2025 15:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=QkwL9
	DPVPqsWlgJ2nK1a2y+K/2yszCGfGSJX4jTH/BI=; b=AVOibUpRMFfeCp+xXzknX
	tL1lxmVegYNjfo0gtiYwNYcprDgYYyLGTACwCgIKNSzTv4jSoGzfwBo2Jr2uzTCx
	7nRyChy9DYaOCEExN/KxiuSwcxehaR4aZ9dxrwvexlG43mSE/vcPzx0gqCZt44Kt
	TG6gOer7g4AiOrDHXLJ8+Vl6oFpWlvpQsAo9Xtgf0tojEbpSBEmWktCaDD5aImq8
	QCPkc9oV7BB/cX8FEtahOY3bHj+QeeIwtjd9a9aKd5punVy8+AU7jveQhdnEP4ts
	W4uCb1zO1ew4i+X609HwbgENQySz9dOLUSpakBlkoEgrI+Xc9i32RKEGGRoOQn2+
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun006t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584Fu9Pj040030;
	Thu, 4 Sep 2025 15:59:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtqtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:59:30 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx74000707;
	Thu, 4 Sep 2025 15:59:29 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-69;
	Thu, 04 Sep 2025 15:59:29 +0000
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
Subject: [PATCH RFC 068/104] crypto: fips140: convert crypto/sha3_generic.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:40 +0200
Message-Id: <20250904155216.460962-69-vegard.nossum@oracle.com>
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
X-Proofpoint-ORIG-GUID: rVj_PronpucXFafNNximFsqfMnk8SM1Z
X-Proofpoint-GUID: rVj_PronpucXFafNNximFsqfMnk8SM1Z
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b763 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=0qE9t6RD9ku-ga3FS6cA:9 cc=ntf
 awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX3yMF6K89+gKY
 Rgr4IkmJSdHYKwMzLySMW33f3ulHa/ttrR1LyL1oZqnQMgDID+kHFInEMnwgQdVgUTYCaHabB5X
 Jar4THIIfthv22p8Jj0s8odJHXHiorfEdwHBe9BcnJGfAVjYWK+wYfjuYmfHFSg6mfznzPV15jJ
 QF7YHi7xGJGC2Y/YVWnYewvWf42brMsvoyQD/KNyEx6ue/1SpkHJ0nwFc1hviSfmm0k0vp2N9vr
 2SDEgAW5lbcFIzWO6ntk/rQ/Z0T97pXmuMiLuHX//l17A3QclYtuF1KnZFxtNY+j6lrzG4DiqpC
 JNbDt778ihLAkF2pc51zs7Luq9dqLC/2oRXnbhqp8kzCQO1/ffPyxrVH1xpMAaInn0qmFkBWtpI
 TTcXYyusV/a0L/8OsRuyVGrnrC9DxQ==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_SHA3 --source crypto/sha3_generic.c --header include/crypto/sha3.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c  | 11 +++++++++++
 crypto/sha3_generic.c |  8 ++++----
 include/crypto/sha3.h |  5 ++++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 47977f5b8554..2567c6d6622f 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -500,3 +500,14 @@ DEFINE_CRYPTO_API_STUB(rsa_parse_priv_key);
 
 #endif
 
+/*
+ * crypto/sha3_generic.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_SHA3)
+
+#include <crypto/sha3.h>
+
+DEFINE_CRYPTO_API_STUB(crypto_sha3_init);
+
+#endif
+
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 41d1e506e6de..b04bd86d6d2f 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -158,14 +158,14 @@ static void keccakf(u64 st[25])
 	}
 }
 
-int crypto_sha3_init(struct shash_desc *desc)
+int CRYPTO_API(crypto_sha3_init)(struct shash_desc *desc)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 
 	memset(sctx->st, 0, sizeof(sctx->st));
 	return 0;
 }
-EXPORT_SYMBOL(crypto_sha3_init);
+DEFINE_CRYPTO_API(crypto_sha3_init);
 
 static int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len)
@@ -274,8 +274,8 @@ static void __exit sha3_generic_mod_fini(void)
 	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
 }
 
-module_init(sha3_generic_mod_init);
-module_exit(sha3_generic_mod_fini);
+crypto_module_init(sha3_generic_mod_init);
+crypto_module_exit(sha3_generic_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-3 Secure Hash Algorithm");
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 41e1b83a6d91..7ae0affff089 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -5,6 +5,7 @@
 #ifndef __CRYPTO_SHA3_H__
 #define __CRYPTO_SHA3_H__
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 #define SHA3_224_DIGEST_SIZE	(224 / 8)
@@ -31,6 +32,8 @@ struct sha3_state {
 	u64		st[SHA3_STATE_SIZE / 8];
 };
 
-int crypto_sha3_init(struct shash_desc *desc);
+DECLARE_CRYPTO_API(crypto_sha3_init, int,
+	(struct shash_desc *desc),
+	(desc));
 
 #endif
-- 
2.39.3

