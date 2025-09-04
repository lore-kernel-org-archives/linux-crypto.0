Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E934828314E;
	Thu,  4 Sep 2025 15:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001418; cv=none; b=B0A5Zcb0kl2nm8i5SRtP3T9s08fn3ncogmTGO9DlUkUqRs4AdDtRsoV67A9wOBvw9q0M5XgP7fu+7SbJnebr0+cEnSuizoyo1VFGYX/lXNkxy5NZX1U8QQoziEa3YPAg18WhlJVQ08fpfsXhSJFZiA0yGLd6YFNWbaB1nX42QKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001418; c=relaxed/simple;
	bh=5xH7vAy2ru/rN+QKdAC+fJlbgXfgYzKo5Rw8DGMWPCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K3Sk/ybYVMizlJCqLlWBgejVjPzFXUt1S5mlWmrIsFEzkN/+Pg2Zoa4VCJ2u6xUL6Rm+lkjJXkLcEwyWftPJihM0SCrDzKnDPyyt/VaIn0Eb3GG/II3boWWJvw7HlJfsg4ogfUii+YqW+a9zJO2deQNby++lonwb6+5RSLfdykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O8spRm34; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O8spRm34"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjP1027677;
	Thu, 4 Sep 2025 15:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=R8i2s
	FVvqJ1dnan8FKpom3Ka3fGIjitmqidm4VZJWc4=; b=O8spRm34uJ8Po6yTT1GC2
	KSwTKBB6WQY1awjwu71N6KGlnGtNX9cQpeXjq4fHWsVe7bW0DnXxRNRRMzbBBPov
	76vUVFgvTmMQZV/fRw4UPA3Pf+vPifGkhfnlMbVIUMuTeauyvLagacBRn96V1IiP
	Ipk8lE9ENQBQxq+WlwrlCXQ0YNdBf5mGMeEohjqshSXitIbm9aPDFGEKuWFEDfB+
	nC7ZVt9MQoDTXds/sSLbuPTKXmf1eDmZJF+nQ4Yb+YExXs864Xsxy2LX57H1K+hJ
	DsdjgzN/fy1mphkuoQ7JBxu7Bl4ZoXNZAuSQMihTqWJPRAsEBRSk8vxfKMJ2hZ+s
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ycgn070u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FG6wN040116;
	Thu, 4 Sep 2025 15:56:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtn9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:42 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5g000707;
	Thu, 4 Sep 2025 15:56:41 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-28;
	Thu, 04 Sep 2025 15:56:41 +0000
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
Subject: [PATCH RFC 027/104] crypto: fips140: convert lib/crypto/sha512.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:50:59 +0200
Message-Id: <20250904155216.460962-28-vegard.nossum@oracle.com>
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
 definitions=main-2509040156
X-Authority-Analysis: v=2.4 cv=evbfzppX c=1 sm=1 tr=0 ts=68b9b6bc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=b0DYlPbuKVRLWjpdWTYA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: iqxmpP0MXuyxK01ZhJ7Av2qXuA3F8Og1
X-Proofpoint-ORIG-GUID: iqxmpP0MXuyxK01ZhJ7Av2qXuA3F8Og1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0MiBTYWx0ZWRfXy4ytscKObk8Q
 DcsXhfyugiiXleTKGRnVG4pe8oLvCRta9O0N2wEq0Z0/zo3RpcUt2HV07GlXuiL46rkLCLCa3TO
 76bcUHApsi5S6LTvOgpv3TUKX4V4UaB5VFDm0avZbug0Vv7KQcZen+4LOrvP4VyaHbiDeCJO/DR
 hmcYZGrW9IAf7uSpxsgrpanHCpSrWOxCQT/OUY98WfpwHcUdEvnf7FomEFfazCXno4uoMszwL6m
 /mInCBU6K1+tv23/gWCK+RaZNaprhaVkMWsT+i/4QUrnujXzCIUk3Tohj+D2WEGXzv0rh9pm9ke
 l/DV2+YNoKF/xyeAqIbjOpaca1No4hJw0PJGmiv7eZ95nfK/cc0RAmfbGDbUXF9QpAaRHOP4Gf5
 Xvee8yKAPs/a8i2lqKCHn0ktLkrZeA==

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_SHA512 --source lib/crypto/sha512.c --header include/crypto/sha2.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c  | 28 +++++++++++++++
 include/crypto/sha2.h | 83 ++++++++++++++++++++++++++++---------------
 lib/crypto/sha512.c   | 76 +++++++++++++++++++--------------------
 3 files changed, 120 insertions(+), 67 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 3b1677049c55..13148a3d3519 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -88,3 +88,31 @@ DEFINE_CRYPTO_API_STUB(hmac_sha256_usingrawkey);
 
 #endif
 
+/*
+ * lib/crypto/sha512.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_SHA512)
+
+#include <crypto/sha2.h>
+
+DEFINE_CRYPTO_API_STUB(__sha512_update);
+DEFINE_CRYPTO_API_STUB(__hmac_sha512_init);
+DEFINE_CRYPTO_API_STUB(sha384_init);
+DEFINE_CRYPTO_API_STUB(sha384_final);
+DEFINE_CRYPTO_API_STUB(sha384);
+DEFINE_CRYPTO_API_STUB(hmac_sha384_preparekey);
+DEFINE_CRYPTO_API_STUB(hmac_sha384_init_usingrawkey);
+DEFINE_CRYPTO_API_STUB(hmac_sha384_final);
+DEFINE_CRYPTO_API_STUB(hmac_sha384);
+DEFINE_CRYPTO_API_STUB(hmac_sha384_usingrawkey);
+DEFINE_CRYPTO_API_STUB(sha512_init);
+DEFINE_CRYPTO_API_STUB(sha512_final);
+DEFINE_CRYPTO_API_STUB(sha512);
+DEFINE_CRYPTO_API_STUB(hmac_sha512_preparekey);
+DEFINE_CRYPTO_API_STUB(hmac_sha512_init_usingrawkey);
+DEFINE_CRYPTO_API_STUB(hmac_sha512_final);
+DEFINE_CRYPTO_API_STUB(hmac_sha512);
+DEFINE_CRYPTO_API_STUB(hmac_sha512_usingrawkey);
+
+#endif
+
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 9fafcd99e9ce..ce908568009a 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -535,7 +535,9 @@ struct __sha512_ctx {
 	u64 bytecount_hi;
 	u8 buf[SHA512_BLOCK_SIZE] __aligned(__alignof__(__be64));
 };
-void __sha512_update(struct __sha512_ctx *ctx, const u8 *data, size_t len);
+DECLARE_CRYPTO_API(__sha512_update, void,
+	(struct __sha512_ctx *ctx, const u8 *data, size_t len),
+	(ctx, data, len));
 
 /*
  * HMAC key and message context structs, shared by HMAC-SHA384 and HMAC-SHA512.
@@ -550,8 +552,9 @@ struct __hmac_sha512_ctx {
 	struct __sha512_ctx sha_ctx;
 	struct sha512_block_state ostate;
 };
-void __hmac_sha512_init(struct __hmac_sha512_ctx *ctx,
-			const struct __hmac_sha512_key *key);
+DECLARE_CRYPTO_API(__hmac_sha512_init, void,
+	(struct __hmac_sha512_ctx *ctx, const struct __hmac_sha512_key *key),
+	(ctx, key));
 
 /**
  * struct sha384_ctx - Context for hashing a message with SHA-384
@@ -569,7 +572,9 @@ struct sha384_ctx {
  *
  * Context: Any context.
  */
-void sha384_init(struct sha384_ctx *ctx);
+DECLARE_CRYPTO_API(sha384_init, void,
+	(struct sha384_ctx *ctx),
+	(ctx));
 
 /**
  * sha384_update() - Update a SHA-384 context with message data
@@ -596,7 +601,9 @@ static inline void sha384_update(struct sha384_ctx *ctx,
  *
  * Context: Any context.
  */
-void sha384_final(struct sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha384_final, void,
+	(struct sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * sha384() - Compute SHA-384 message digest in one shot
@@ -606,7 +613,9 @@ void sha384_final(struct sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void sha384(const u8 *data, size_t len, u8 out[SHA384_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha384, void,
+	(const u8 *data, size_t len, u8 out[SHA384_DIGEST_SIZE]),
+	(data, len, out));
 
 /**
  * struct hmac_sha384_key - Prepared key for HMAC-SHA384
@@ -635,8 +644,9 @@ struct hmac_sha384_ctx {
  *
  * Context: Any context.
  */
-void hmac_sha384_preparekey(struct hmac_sha384_key *key,
-			    const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha384_preparekey, void,
+	(struct hmac_sha384_key *key, const u8 *raw_key, size_t raw_key_len),
+	(key, raw_key, raw_key_len));
 
 /**
  * hmac_sha384_init() - Initialize an HMAC-SHA384 context for a new message
@@ -665,8 +675,9 @@ static inline void hmac_sha384_init(struct hmac_sha384_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha384_init_usingrawkey(struct hmac_sha384_ctx *ctx,
-				  const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha384_init_usingrawkey, void,
+	(struct hmac_sha384_ctx *ctx, const u8 *raw_key, size_t raw_key_len),
+	(ctx, raw_key, raw_key_len));
 
 /**
  * hmac_sha384_update() - Update an HMAC-SHA384 context with message data
@@ -693,7 +704,9 @@ static inline void hmac_sha384_update(struct hmac_sha384_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha384_final(struct hmac_sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha384_final, void,
+	(struct hmac_sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * hmac_sha384() - Compute HMAC-SHA384 in one shot, using a prepared key
@@ -706,8 +719,9 @@ void hmac_sha384_final(struct hmac_sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void hmac_sha384(const struct hmac_sha384_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA384_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha384, void,
+	(const struct hmac_sha384_key *key, const u8 *data, size_t data_len, u8 out[SHA384_DIGEST_SIZE]),
+	(key, data, data_len, out));
 
 /**
  * hmac_sha384_usingrawkey() - Compute HMAC-SHA384 in one shot, using a raw key
@@ -722,9 +736,9 @@ void hmac_sha384(const struct hmac_sha384_key *key,
  *
  * Context: Any context.
  */
-void hmac_sha384_usingrawkey(const u8 *raw_key, size_t raw_key_len,
-			     const u8 *data, size_t data_len,
-			     u8 out[SHA384_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha384_usingrawkey, void,
+	(const u8 *raw_key, size_t raw_key_len, const u8 *data, size_t data_len, u8 out[SHA384_DIGEST_SIZE]),
+	(raw_key, raw_key_len, data, data_len, out));
 
 /**
  * struct sha512_ctx - Context for hashing a message with SHA-512
@@ -742,7 +756,9 @@ struct sha512_ctx {
  *
  * Context: Any context.
  */
-void sha512_init(struct sha512_ctx *ctx);
+DECLARE_CRYPTO_API(sha512_init, void,
+	(struct sha512_ctx *ctx),
+	(ctx));
 
 /**
  * sha512_update() - Update a SHA-512 context with message data
@@ -769,7 +785,9 @@ static inline void sha512_update(struct sha512_ctx *ctx,
  *
  * Context: Any context.
  */
-void sha512_final(struct sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha512_final, void,
+	(struct sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * sha512() - Compute SHA-512 message digest in one shot
@@ -779,7 +797,9 @@ void sha512_final(struct sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha512, void,
+	(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE]),
+	(data, len, out));
 
 /**
  * struct hmac_sha512_key - Prepared key for HMAC-SHA512
@@ -808,8 +828,9 @@ struct hmac_sha512_ctx {
  *
  * Context: Any context.
  */
-void hmac_sha512_preparekey(struct hmac_sha512_key *key,
-			    const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha512_preparekey, void,
+	(struct hmac_sha512_key *key, const u8 *raw_key, size_t raw_key_len),
+	(key, raw_key, raw_key_len));
 
 /**
  * hmac_sha512_init() - Initialize an HMAC-SHA512 context for a new message
@@ -838,8 +859,9 @@ static inline void hmac_sha512_init(struct hmac_sha512_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha512_init_usingrawkey(struct hmac_sha512_ctx *ctx,
-				  const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha512_init_usingrawkey, void,
+	(struct hmac_sha512_ctx *ctx, const u8 *raw_key, size_t raw_key_len),
+	(ctx, raw_key, raw_key_len));
 
 /**
  * hmac_sha512_update() - Update an HMAC-SHA512 context with message data
@@ -866,7 +888,9 @@ static inline void hmac_sha512_update(struct hmac_sha512_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha512_final(struct hmac_sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha512_final, void,
+	(struct hmac_sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * hmac_sha512() - Compute HMAC-SHA512 in one shot, using a prepared key
@@ -879,8 +903,9 @@ void hmac_sha512_final(struct hmac_sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void hmac_sha512(const struct hmac_sha512_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA512_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha512, void,
+	(const struct hmac_sha512_key *key, const u8 *data, size_t data_len, u8 out[SHA512_DIGEST_SIZE]),
+	(key, data, data_len, out));
 
 /**
  * hmac_sha512_usingrawkey() - Compute HMAC-SHA512 in one shot, using a raw key
@@ -895,8 +920,8 @@ void hmac_sha512(const struct hmac_sha512_key *key,
  *
  * Context: Any context.
  */
-void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
-			     const u8 *data, size_t data_len,
-			     u8 out[SHA512_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha512_usingrawkey, void,
+	(const u8 *raw_key, size_t raw_key_len, const u8 *data, size_t data_len, u8 out[SHA512_DIGEST_SIZE]),
+	(raw_key, raw_key_len, data, data_len, out));
 
 #endif /* _CRYPTO_SHA2_H */
diff --git a/lib/crypto/sha512.c b/lib/crypto/sha512.c
index d8062188be98..9a170bf1a48c 100644
--- a/lib/crypto/sha512.c
+++ b/lib/crypto/sha512.c
@@ -147,19 +147,19 @@ static void __sha512_init(struct __sha512_ctx *ctx,
 	ctx->bytecount_hi = 0;
 }
 
-void sha384_init(struct sha384_ctx *ctx)
+void CRYPTO_API(sha384_init)(struct sha384_ctx *ctx)
 {
 	__sha512_init(&ctx->ctx, &sha384_iv, 0);
 }
-EXPORT_SYMBOL_GPL(sha384_init);
+DEFINE_CRYPTO_API(sha384_init);
 
-void sha512_init(struct sha512_ctx *ctx)
+void CRYPTO_API(sha512_init)(struct sha512_ctx *ctx)
 {
 	__sha512_init(&ctx->ctx, &sha512_iv, 0);
 }
-EXPORT_SYMBOL_GPL(sha512_init);
+DEFINE_CRYPTO_API(sha512_init);
 
-void __sha512_update(struct __sha512_ctx *ctx, const u8 *data, size_t len)
+void CRYPTO_API(__sha512_update)(struct __sha512_ctx *ctx, const u8 *data, size_t len)
 {
 	size_t partial = ctx->bytecount_lo % SHA512_BLOCK_SIZE;
 
@@ -191,7 +191,7 @@ void __sha512_update(struct __sha512_ctx *ctx, const u8 *data, size_t len)
 	if (len)
 		memcpy(&ctx->buf[partial], data, len);
 }
-EXPORT_SYMBOL_GPL(__sha512_update);
+DEFINE_CRYPTO_API(__sha512_update);
 
 static void __sha512_final(struct __sha512_ctx *ctx,
 			   u8 *out, size_t digest_size)
@@ -215,21 +215,21 @@ static void __sha512_final(struct __sha512_ctx *ctx,
 		put_unaligned_be64(ctx->state.h[i / 8], out + i);
 }
 
-void sha384_final(struct sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE])
+void CRYPTO_API(sha384_final)(struct sha384_ctx *ctx, u8 out[SHA384_DIGEST_SIZE])
 {
 	__sha512_final(&ctx->ctx, out, SHA384_DIGEST_SIZE);
 	memzero_explicit(ctx, sizeof(*ctx));
 }
-EXPORT_SYMBOL_GPL(sha384_final);
+DEFINE_CRYPTO_API(sha384_final);
 
-void sha512_final(struct sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE])
+void CRYPTO_API(sha512_final)(struct sha512_ctx *ctx, u8 out[SHA512_DIGEST_SIZE])
 {
 	__sha512_final(&ctx->ctx, out, SHA512_DIGEST_SIZE);
 	memzero_explicit(ctx, sizeof(*ctx));
 }
-EXPORT_SYMBOL_GPL(sha512_final);
+DEFINE_CRYPTO_API(sha512_final);
 
-void sha384(const u8 *data, size_t len, u8 out[SHA384_DIGEST_SIZE])
+void CRYPTO_API(sha384)(const u8 *data, size_t len, u8 out[SHA384_DIGEST_SIZE])
 {
 	struct sha384_ctx ctx;
 
@@ -237,9 +237,9 @@ void sha384(const u8 *data, size_t len, u8 out[SHA384_DIGEST_SIZE])
 	sha384_update(&ctx, data, len);
 	sha384_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(sha384);
+DEFINE_CRYPTO_API(sha384);
 
-void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE])
+void CRYPTO_API(sha512)(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE])
 {
 	struct sha512_ctx ctx;
 
@@ -247,7 +247,7 @@ void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE])
 	sha512_update(&ctx, data, len);
 	sha512_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(sha512);
+DEFINE_CRYPTO_API(sha512);
 
 static void __hmac_sha512_preparekey(struct sha512_block_state *istate,
 				     struct sha512_block_state *ostate,
@@ -282,31 +282,31 @@ static void __hmac_sha512_preparekey(struct sha512_block_state *istate,
 	memzero_explicit(&derived_key, sizeof(derived_key));
 }
 
-void hmac_sha384_preparekey(struct hmac_sha384_key *key,
+void CRYPTO_API(hmac_sha384_preparekey)(struct hmac_sha384_key *key,
 			    const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha512_preparekey(&key->key.istate, &key->key.ostate,
 				 raw_key, raw_key_len, &sha384_iv);
 }
-EXPORT_SYMBOL_GPL(hmac_sha384_preparekey);
+DEFINE_CRYPTO_API(hmac_sha384_preparekey);
 
-void hmac_sha512_preparekey(struct hmac_sha512_key *key,
+void CRYPTO_API(hmac_sha512_preparekey)(struct hmac_sha512_key *key,
 			    const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha512_preparekey(&key->key.istate, &key->key.ostate,
 				 raw_key, raw_key_len, &sha512_iv);
 }
-EXPORT_SYMBOL_GPL(hmac_sha512_preparekey);
+DEFINE_CRYPTO_API(hmac_sha512_preparekey);
 
-void __hmac_sha512_init(struct __hmac_sha512_ctx *ctx,
+void CRYPTO_API(__hmac_sha512_init)(struct __hmac_sha512_ctx *ctx,
 			const struct __hmac_sha512_key *key)
 {
 	__sha512_init(&ctx->sha_ctx, &key->istate, SHA512_BLOCK_SIZE);
 	ctx->ostate = key->ostate;
 }
-EXPORT_SYMBOL_GPL(__hmac_sha512_init);
+DEFINE_CRYPTO_API(__hmac_sha512_init);
 
-void hmac_sha384_init_usingrawkey(struct hmac_sha384_ctx *ctx,
+void CRYPTO_API(hmac_sha384_init_usingrawkey)(struct hmac_sha384_ctx *ctx,
 				  const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha512_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
@@ -314,9 +314,9 @@ void hmac_sha384_init_usingrawkey(struct hmac_sha384_ctx *ctx,
 	ctx->ctx.sha_ctx.bytecount_lo = SHA512_BLOCK_SIZE;
 	ctx->ctx.sha_ctx.bytecount_hi = 0;
 }
-EXPORT_SYMBOL_GPL(hmac_sha384_init_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha384_init_usingrawkey);
 
-void hmac_sha512_init_usingrawkey(struct hmac_sha512_ctx *ctx,
+void CRYPTO_API(hmac_sha512_init_usingrawkey)(struct hmac_sha512_ctx *ctx,
 				  const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha512_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
@@ -324,7 +324,7 @@ void hmac_sha512_init_usingrawkey(struct hmac_sha512_ctx *ctx,
 	ctx->ctx.sha_ctx.bytecount_lo = SHA512_BLOCK_SIZE;
 	ctx->ctx.sha_ctx.bytecount_hi = 0;
 }
-EXPORT_SYMBOL_GPL(hmac_sha512_init_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha512_init_usingrawkey);
 
 static void __hmac_sha512_final(struct __hmac_sha512_ctx *ctx,
 				u8 *out, size_t digest_size)
@@ -345,21 +345,21 @@ static void __hmac_sha512_final(struct __hmac_sha512_ctx *ctx,
 	memzero_explicit(ctx, sizeof(*ctx));
 }
 
-void hmac_sha384_final(struct hmac_sha384_ctx *ctx,
+void CRYPTO_API(hmac_sha384_final)(struct hmac_sha384_ctx *ctx,
 		       u8 out[SHA384_DIGEST_SIZE])
 {
 	__hmac_sha512_final(&ctx->ctx, out, SHA384_DIGEST_SIZE);
 }
-EXPORT_SYMBOL_GPL(hmac_sha384_final);
+DEFINE_CRYPTO_API(hmac_sha384_final);
 
-void hmac_sha512_final(struct hmac_sha512_ctx *ctx,
+void CRYPTO_API(hmac_sha512_final)(struct hmac_sha512_ctx *ctx,
 		       u8 out[SHA512_DIGEST_SIZE])
 {
 	__hmac_sha512_final(&ctx->ctx, out, SHA512_DIGEST_SIZE);
 }
-EXPORT_SYMBOL_GPL(hmac_sha512_final);
+DEFINE_CRYPTO_API(hmac_sha512_final);
 
-void hmac_sha384(const struct hmac_sha384_key *key,
+void CRYPTO_API(hmac_sha384)(const struct hmac_sha384_key *key,
 		 const u8 *data, size_t data_len, u8 out[SHA384_DIGEST_SIZE])
 {
 	struct hmac_sha384_ctx ctx;
@@ -368,9 +368,9 @@ void hmac_sha384(const struct hmac_sha384_key *key,
 	hmac_sha384_update(&ctx, data, data_len);
 	hmac_sha384_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha384);
+DEFINE_CRYPTO_API(hmac_sha384);
 
-void hmac_sha512(const struct hmac_sha512_key *key,
+void CRYPTO_API(hmac_sha512)(const struct hmac_sha512_key *key,
 		 const u8 *data, size_t data_len, u8 out[SHA512_DIGEST_SIZE])
 {
 	struct hmac_sha512_ctx ctx;
@@ -379,9 +379,9 @@ void hmac_sha512(const struct hmac_sha512_key *key,
 	hmac_sha512_update(&ctx, data, data_len);
 	hmac_sha512_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha512);
+DEFINE_CRYPTO_API(hmac_sha512);
 
-void hmac_sha384_usingrawkey(const u8 *raw_key, size_t raw_key_len,
+void CRYPTO_API(hmac_sha384_usingrawkey)(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
 			     u8 out[SHA384_DIGEST_SIZE])
 {
@@ -391,9 +391,9 @@ void hmac_sha384_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 	hmac_sha384_update(&ctx, data, data_len);
 	hmac_sha384_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha384_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha384_usingrawkey);
 
-void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
+void CRYPTO_API(hmac_sha512_usingrawkey)(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
 			     u8 out[SHA512_DIGEST_SIZE])
 {
@@ -403,7 +403,7 @@ void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 	hmac_sha512_update(&ctx, data, data_len);
 	hmac_sha512_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha512_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha512_usingrawkey);
 
 #ifdef sha512_mod_init_arch
 static int __init sha512_mod_init(void)
@@ -411,12 +411,12 @@ static int __init sha512_mod_init(void)
 	sha512_mod_init_arch();
 	return 0;
 }
-subsys_initcall(sha512_mod_init);
+crypto_subsys_initcall(sha512_mod_init);
 
 static void __exit sha512_mod_exit(void)
 {
 }
-module_exit(sha512_mod_exit);
+crypto_module_exit(sha512_mod_exit);
 #endif
 
 MODULE_DESCRIPTION("SHA-384, SHA-512, HMAC-SHA384, and HMAC-SHA512 library functions");
-- 
2.39.3

