Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A54281352;
	Thu,  4 Sep 2025 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001414; cv=none; b=bEGxbPGPi5nvGcOJN1/KuE3Ldq4tDZFi2QPDpQbdAzjmHTntejzJdX0h2U9RDjyBcDPmVC2MCVwzzuJaDaGAlEc7McAB9Dy8V2ZmnHvokZGufMLa6mc9djDBO5GOhyHaj172JkR5itSAefni5iTQ0ZeA9OD/2KNJNgJB27HXB7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001414; c=relaxed/simple;
	bh=nUOpSzqGWGbjibOBgUMFu7SnDTv0BbhLzhk9aXKxuvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VQfKAJRJW16gp64VaRsY5yTVwaWcg/AcinSmClej0yN5Ze1uVjQm56n3kbwzk2Wo4MOPQ4lsXdmjS0EcM/I8MRP3I9vUykipoWruIy9xTWC1sxXHgQM+PiJql8ZNDDMepeN/LmcirihTeKVUW1skB+9nae8Fz5XcULe9r1aFvVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ikXQxjaC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ikXQxjaC"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Ftj1X010474;
	Thu, 4 Sep 2025 15:56:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=XfAQl
	l7ZTg1r9RNtMWwZXeqKdqG+S6OWtnPjD01t8hY=; b=ikXQxjaCZQdHjoBi238af
	2O1u9l8dMJGbURsLC/WbG24gamBn55hhg3hjd0Hd1dcvc4o09PrB3ygIH0kX/EiL
	1wsw+q/1Z6kntIUvvy6g3Yq0zXjlJqq/CrdTk1oaZxPXGEMRij1UyaJrmc+9+5vQ
	hIb5hqcwK2bG5ITkJcacoDi8dryLiGtXXA0XcmLrzNPeODEOpTNm8y9zWdnYb6Zh
	4u21UNGweMRIrMErUeZ5eCN7NIOwp8GQ4vuczXFDGU31VuaiOUa3i0naTPzXh9nm
	Wkx4DdV1rUkJjpx0xbuTowpsCHVK9F6H607Va9CHt76VVbVuL/6148l9s4ctl/MM
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FELtD040036;
	Thu, 4 Sep 2025 15:56:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtn80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:39 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5e000707;
	Thu, 4 Sep 2025 15:56:38 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-27;
	Thu, 04 Sep 2025 15:56:37 +0000
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
Subject: [PATCH RFC 026/104] crypto: fips140: convert lib/crypto/sha256.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:50:58 +0200
Message-Id: <20250904155216.460962-27-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: z48eow7xyWFb_oDLQmacLjrmUaD4KH-8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX5IlzagIkAinc
 7dH87z8HJyDvJehPQO/0i1MIA84oPCUy205juFqfWZeeoPLzE2m0mOpPWTKZ2EP/fm/0jJZ8mke
 WIFSl7bbSYdVIeO/rgLKU3nK2W72HoUCfm3KXXP+QBlJr4F7J2trTY/FvgQ+x+cumm3o6G4cn/2
 4kQCsJwefEa5ieIeyfJ9UdyGAs5OfrbQ8Pf5caYQdaeT9L6E8VZ/YlNNOHpKB8KDyqTvwK5Hqqz
 xUHXIuBtzKXfwhWS2uzwxV7jlckkovrXdy4KA94Y+NvYttjZWeN2lUVH5g1L0jRoMNEuhwXzTz+
 hDDlREmY8gR/xegtOHo/4tW2waPPodlb0VAI1fKzPdcWKp+g7Q0/gAG6+ZfP51UfXZ/qpdLw13R
 x51QtDyhuWaAKSOqaCi197+WAzPcdA==
X-Proofpoint-ORIG-GUID: z48eow7xyWFb_oDLQmacLjrmUaD4KH-8
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6b8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=kFetbNxbF81__x-6cPgA:9 cc=ntf
 awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_SHA256 --source lib/crypto/sha256.c --header include/crypto/sha2.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c  | 28 +++++++++++++++
 include/crypto/sha2.h | 84 ++++++++++++++++++++++++++++---------------
 lib/crypto/sha256.c   | 76 +++++++++++++++++++--------------------
 3 files changed, 121 insertions(+), 67 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 16d0d8afebe7..3b1677049c55 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -60,3 +60,31 @@ DEFINE_CRYPTO_API_STUB(__crypto_memneq);
 
 #endif
 
+/*
+ * lib/crypto/sha256.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_SHA256)
+
+#include <crypto/sha2.h>
+
+DEFINE_CRYPTO_API_STUB(__sha256_update);
+DEFINE_CRYPTO_API_STUB(__hmac_sha256_init);
+DEFINE_CRYPTO_API_STUB(sha224_init);
+DEFINE_CRYPTO_API_STUB(sha224_final);
+DEFINE_CRYPTO_API_STUB(sha224);
+DEFINE_CRYPTO_API_STUB(hmac_sha224_preparekey);
+DEFINE_CRYPTO_API_STUB(hmac_sha224_init_usingrawkey);
+DEFINE_CRYPTO_API_STUB(hmac_sha224_final);
+DEFINE_CRYPTO_API_STUB(hmac_sha224);
+DEFINE_CRYPTO_API_STUB(hmac_sha224_usingrawkey);
+DEFINE_CRYPTO_API_STUB(sha256_init);
+DEFINE_CRYPTO_API_STUB(sha256_final);
+DEFINE_CRYPTO_API_STUB(sha256);
+DEFINE_CRYPTO_API_STUB(hmac_sha256_preparekey);
+DEFINE_CRYPTO_API_STUB(hmac_sha256_init_usingrawkey);
+DEFINE_CRYPTO_API_STUB(hmac_sha256_final);
+DEFINE_CRYPTO_API_STUB(hmac_sha256);
+DEFINE_CRYPTO_API_STUB(hmac_sha256_usingrawkey);
+
+#endif
+
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 15e461e568cc..9fafcd99e9ce 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -6,6 +6,7 @@
 #ifndef _CRYPTO_SHA2_H
 #define _CRYPTO_SHA2_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 #define SHA224_DIGEST_SIZE	28
@@ -129,7 +130,9 @@ struct __sha256_ctx {
 	u64 bytecount;
 	u8 buf[SHA256_BLOCK_SIZE] __aligned(__alignof__(__be64));
 };
-void __sha256_update(struct __sha256_ctx *ctx, const u8 *data, size_t len);
+DECLARE_CRYPTO_API(__sha256_update, void,
+	(struct __sha256_ctx *ctx, const u8 *data, size_t len),
+	(ctx, data, len));
 
 /*
  * HMAC key and message context structs, shared by HMAC-SHA224 and HMAC-SHA256.
@@ -144,8 +147,9 @@ struct __hmac_sha256_ctx {
 	struct __sha256_ctx sha_ctx;
 	struct sha256_block_state ostate;
 };
-void __hmac_sha256_init(struct __hmac_sha256_ctx *ctx,
-			const struct __hmac_sha256_key *key);
+DECLARE_CRYPTO_API(__hmac_sha256_init, void,
+	(struct __hmac_sha256_ctx *ctx, const struct __hmac_sha256_key *key),
+	(ctx, key));
 
 /**
  * struct sha224_ctx - Context for hashing a message with SHA-224
@@ -163,7 +167,9 @@ struct sha224_ctx {
  *
  * Context: Any context.
  */
-void sha224_init(struct sha224_ctx *ctx);
+DECLARE_CRYPTO_API(sha224_init, void,
+	(struct sha224_ctx *ctx),
+	(ctx));
 
 /**
  * sha224_update() - Update a SHA-224 context with message data
@@ -190,7 +196,9 @@ static inline void sha224_update(struct sha224_ctx *ctx,
  *
  * Context: Any context.
  */
-void sha224_final(struct sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha224_final, void,
+	(struct sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * sha224() - Compute SHA-224 message digest in one shot
@@ -200,7 +208,9 @@ void sha224_final(struct sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void sha224(const u8 *data, size_t len, u8 out[SHA224_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha224, void,
+	(const u8 *data, size_t len, u8 out[SHA224_DIGEST_SIZE]),
+	(data, len, out));
 
 /**
  * struct hmac_sha224_key - Prepared key for HMAC-SHA224
@@ -229,8 +239,9 @@ struct hmac_sha224_ctx {
  *
  * Context: Any context.
  */
-void hmac_sha224_preparekey(struct hmac_sha224_key *key,
-			    const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha224_preparekey, void,
+	(struct hmac_sha224_key *key, const u8 *raw_key, size_t raw_key_len),
+	(key, raw_key, raw_key_len));
 
 /**
  * hmac_sha224_init() - Initialize an HMAC-SHA224 context for a new message
@@ -259,8 +270,9 @@ static inline void hmac_sha224_init(struct hmac_sha224_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha224_init_usingrawkey(struct hmac_sha224_ctx *ctx,
-				  const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha224_init_usingrawkey, void,
+	(struct hmac_sha224_ctx *ctx, const u8 *raw_key, size_t raw_key_len),
+	(ctx, raw_key, raw_key_len));
 
 /**
  * hmac_sha224_update() - Update an HMAC-SHA224 context with message data
@@ -287,7 +299,9 @@ static inline void hmac_sha224_update(struct hmac_sha224_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha224_final(struct hmac_sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha224_final, void,
+	(struct hmac_sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * hmac_sha224() - Compute HMAC-SHA224 in one shot, using a prepared key
@@ -300,8 +314,9 @@ void hmac_sha224_final(struct hmac_sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void hmac_sha224(const struct hmac_sha224_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA224_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha224, void,
+	(const struct hmac_sha224_key *key, const u8 *data, size_t data_len, u8 out[SHA224_DIGEST_SIZE]),
+	(key, data, data_len, out));
 
 /**
  * hmac_sha224_usingrawkey() - Compute HMAC-SHA224 in one shot, using a raw key
@@ -316,9 +331,9 @@ void hmac_sha224(const struct hmac_sha224_key *key,
  *
  * Context: Any context.
  */
-void hmac_sha224_usingrawkey(const u8 *raw_key, size_t raw_key_len,
-			     const u8 *data, size_t data_len,
-			     u8 out[SHA224_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha224_usingrawkey, void,
+	(const u8 *raw_key, size_t raw_key_len, const u8 *data, size_t data_len, u8 out[SHA224_DIGEST_SIZE]),
+	(raw_key, raw_key_len, data, data_len, out));
 
 /**
  * struct sha256_ctx - Context for hashing a message with SHA-256
@@ -336,7 +351,9 @@ struct sha256_ctx {
  *
  * Context: Any context.
  */
-void sha256_init(struct sha256_ctx *ctx);
+DECLARE_CRYPTO_API(sha256_init, void,
+	(struct sha256_ctx *ctx),
+	(ctx));
 
 /**
  * sha256_update() - Update a SHA-256 context with message data
@@ -363,7 +380,9 @@ static inline void sha256_update(struct sha256_ctx *ctx,
  *
  * Context: Any context.
  */
-void sha256_final(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha256_final, void,
+	(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * sha256() - Compute SHA-256 message digest in one shot
@@ -373,7 +392,9 @@ void sha256_final(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(sha256, void,
+	(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]),
+	(data, len, out));
 
 /**
  * struct hmac_sha256_key - Prepared key for HMAC-SHA256
@@ -402,8 +423,9 @@ struct hmac_sha256_ctx {
  *
  * Context: Any context.
  */
-void hmac_sha256_preparekey(struct hmac_sha256_key *key,
-			    const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha256_preparekey, void,
+	(struct hmac_sha256_key *key, const u8 *raw_key, size_t raw_key_len),
+	(key, raw_key, raw_key_len));
 
 /**
  * hmac_sha256_init() - Initialize an HMAC-SHA256 context for a new message
@@ -432,8 +454,9 @@ static inline void hmac_sha256_init(struct hmac_sha256_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha256_init_usingrawkey(struct hmac_sha256_ctx *ctx,
-				  const u8 *raw_key, size_t raw_key_len);
+DECLARE_CRYPTO_API(hmac_sha256_init_usingrawkey, void,
+	(struct hmac_sha256_ctx *ctx, const u8 *raw_key, size_t raw_key_len),
+	(ctx, raw_key, raw_key_len));
 
 /**
  * hmac_sha256_update() - Update an HMAC-SHA256 context with message data
@@ -460,7 +483,9 @@ static inline void hmac_sha256_update(struct hmac_sha256_ctx *ctx,
  *
  * Context: Any context.
  */
-void hmac_sha256_final(struct hmac_sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha256_final, void,
+	(struct hmac_sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]),
+	(ctx, out));
 
 /**
  * hmac_sha256() - Compute HMAC-SHA256 in one shot, using a prepared key
@@ -473,8 +498,9 @@ void hmac_sha256_final(struct hmac_sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
-void hmac_sha256(const struct hmac_sha256_key *key,
-		 const u8 *data, size_t data_len, u8 out[SHA256_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha256, void,
+	(const struct hmac_sha256_key *key, const u8 *data, size_t data_len, u8 out[SHA256_DIGEST_SIZE]),
+	(key, data, data_len, out));
 
 /**
  * hmac_sha256_usingrawkey() - Compute HMAC-SHA256 in one shot, using a raw key
@@ -489,9 +515,9 @@ void hmac_sha256(const struct hmac_sha256_key *key,
  *
  * Context: Any context.
  */
-void hmac_sha256_usingrawkey(const u8 *raw_key, size_t raw_key_len,
-			     const u8 *data, size_t data_len,
-			     u8 out[SHA256_DIGEST_SIZE]);
+DECLARE_CRYPTO_API(hmac_sha256_usingrawkey, void,
+	(const u8 *raw_key, size_t raw_key_len, const u8 *data, size_t data_len, u8 out[SHA256_DIGEST_SIZE]),
+	(raw_key, raw_key_len, data, data_len, out));
 
 /* State for the SHA-512 (and SHA-384) compression function */
 struct sha512_block_state {
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 8fa15165d23e..36a9f2bf77e2 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -162,19 +162,19 @@ static void __sha256_init(struct __sha256_ctx *ctx,
 	ctx->bytecount = initial_bytecount;
 }
 
-void sha224_init(struct sha224_ctx *ctx)
+void CRYPTO_API(sha224_init)(struct sha224_ctx *ctx)
 {
 	__sha256_init(&ctx->ctx, &sha224_iv, 0);
 }
-EXPORT_SYMBOL_GPL(sha224_init);
+DEFINE_CRYPTO_API(sha224_init);
 
-void sha256_init(struct sha256_ctx *ctx)
+void CRYPTO_API(sha256_init)(struct sha256_ctx *ctx)
 {
 	__sha256_init(&ctx->ctx, &sha256_iv, 0);
 }
-EXPORT_SYMBOL_GPL(sha256_init);
+DEFINE_CRYPTO_API(sha256_init);
 
-void __sha256_update(struct __sha256_ctx *ctx, const u8 *data, size_t len)
+void CRYPTO_API(__sha256_update)(struct __sha256_ctx *ctx, const u8 *data, size_t len)
 {
 	size_t partial = ctx->bytecount % SHA256_BLOCK_SIZE;
 
@@ -205,7 +205,7 @@ void __sha256_update(struct __sha256_ctx *ctx, const u8 *data, size_t len)
 	if (len)
 		memcpy(&ctx->buf[partial], data, len);
 }
-EXPORT_SYMBOL(__sha256_update);
+DEFINE_CRYPTO_API(__sha256_update);
 
 static void __sha256_final(struct __sha256_ctx *ctx,
 			   u8 *out, size_t digest_size)
@@ -227,21 +227,21 @@ static void __sha256_final(struct __sha256_ctx *ctx,
 		put_unaligned_be32(ctx->state.h[i / 4], out + i);
 }
 
-void sha224_final(struct sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE])
+void CRYPTO_API(sha224_final)(struct sha224_ctx *ctx, u8 out[SHA224_DIGEST_SIZE])
 {
 	__sha256_final(&ctx->ctx, out, SHA224_DIGEST_SIZE);
 	memzero_explicit(ctx, sizeof(*ctx));
 }
-EXPORT_SYMBOL(sha224_final);
+DEFINE_CRYPTO_API(sha224_final);
 
-void sha256_final(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE])
+void CRYPTO_API(sha256_final)(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE])
 {
 	__sha256_final(&ctx->ctx, out, SHA256_DIGEST_SIZE);
 	memzero_explicit(ctx, sizeof(*ctx));
 }
-EXPORT_SYMBOL(sha256_final);
+DEFINE_CRYPTO_API(sha256_final);
 
-void sha224(const u8 *data, size_t len, u8 out[SHA224_DIGEST_SIZE])
+void CRYPTO_API(sha224)(const u8 *data, size_t len, u8 out[SHA224_DIGEST_SIZE])
 {
 	struct sha224_ctx ctx;
 
@@ -249,9 +249,9 @@ void sha224(const u8 *data, size_t len, u8 out[SHA224_DIGEST_SIZE])
 	sha224_update(&ctx, data, len);
 	sha224_final(&ctx, out);
 }
-EXPORT_SYMBOL(sha224);
+DEFINE_CRYPTO_API(sha224);
 
-void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
+void CRYPTO_API(sha256)(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 {
 	struct sha256_ctx ctx;
 
@@ -259,7 +259,7 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 	sha256_update(&ctx, data, len);
 	sha256_final(&ctx, out);
 }
-EXPORT_SYMBOL(sha256);
+DEFINE_CRYPTO_API(sha256);
 
 /* pre-boot environment (as indicated by __DISABLE_EXPORTS) doesn't need HMAC */
 #ifndef __DISABLE_EXPORTS
@@ -296,47 +296,47 @@ static void __hmac_sha256_preparekey(struct sha256_block_state *istate,
 	memzero_explicit(&derived_key, sizeof(derived_key));
 }
 
-void hmac_sha224_preparekey(struct hmac_sha224_key *key,
+void CRYPTO_API(hmac_sha224_preparekey)(struct hmac_sha224_key *key,
 			    const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha256_preparekey(&key->key.istate, &key->key.ostate,
 				 raw_key, raw_key_len, &sha224_iv);
 }
-EXPORT_SYMBOL_GPL(hmac_sha224_preparekey);
+DEFINE_CRYPTO_API(hmac_sha224_preparekey);
 
-void hmac_sha256_preparekey(struct hmac_sha256_key *key,
+void CRYPTO_API(hmac_sha256_preparekey)(struct hmac_sha256_key *key,
 			    const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha256_preparekey(&key->key.istate, &key->key.ostate,
 				 raw_key, raw_key_len, &sha256_iv);
 }
-EXPORT_SYMBOL_GPL(hmac_sha256_preparekey);
+DEFINE_CRYPTO_API(hmac_sha256_preparekey);
 
-void __hmac_sha256_init(struct __hmac_sha256_ctx *ctx,
+void CRYPTO_API(__hmac_sha256_init)(struct __hmac_sha256_ctx *ctx,
 			const struct __hmac_sha256_key *key)
 {
 	__sha256_init(&ctx->sha_ctx, &key->istate, SHA256_BLOCK_SIZE);
 	ctx->ostate = key->ostate;
 }
-EXPORT_SYMBOL_GPL(__hmac_sha256_init);
+DEFINE_CRYPTO_API(__hmac_sha256_init);
 
-void hmac_sha224_init_usingrawkey(struct hmac_sha224_ctx *ctx,
+void CRYPTO_API(hmac_sha224_init_usingrawkey)(struct hmac_sha224_ctx *ctx,
 				  const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha256_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
 				 raw_key, raw_key_len, &sha224_iv);
 	ctx->ctx.sha_ctx.bytecount = SHA256_BLOCK_SIZE;
 }
-EXPORT_SYMBOL_GPL(hmac_sha224_init_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha224_init_usingrawkey);
 
-void hmac_sha256_init_usingrawkey(struct hmac_sha256_ctx *ctx,
+void CRYPTO_API(hmac_sha256_init_usingrawkey)(struct hmac_sha256_ctx *ctx,
 				  const u8 *raw_key, size_t raw_key_len)
 {
 	__hmac_sha256_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
 				 raw_key, raw_key_len, &sha256_iv);
 	ctx->ctx.sha_ctx.bytecount = SHA256_BLOCK_SIZE;
 }
-EXPORT_SYMBOL_GPL(hmac_sha256_init_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha256_init_usingrawkey);
 
 static void __hmac_sha256_final(struct __hmac_sha256_ctx *ctx,
 				u8 *out, size_t digest_size)
@@ -357,21 +357,21 @@ static void __hmac_sha256_final(struct __hmac_sha256_ctx *ctx,
 	memzero_explicit(ctx, sizeof(*ctx));
 }
 
-void hmac_sha224_final(struct hmac_sha224_ctx *ctx,
+void CRYPTO_API(hmac_sha224_final)(struct hmac_sha224_ctx *ctx,
 		       u8 out[SHA224_DIGEST_SIZE])
 {
 	__hmac_sha256_final(&ctx->ctx, out, SHA224_DIGEST_SIZE);
 }
-EXPORT_SYMBOL_GPL(hmac_sha224_final);
+DEFINE_CRYPTO_API(hmac_sha224_final);
 
-void hmac_sha256_final(struct hmac_sha256_ctx *ctx,
+void CRYPTO_API(hmac_sha256_final)(struct hmac_sha256_ctx *ctx,
 		       u8 out[SHA256_DIGEST_SIZE])
 {
 	__hmac_sha256_final(&ctx->ctx, out, SHA256_DIGEST_SIZE);
 }
-EXPORT_SYMBOL_GPL(hmac_sha256_final);
+DEFINE_CRYPTO_API(hmac_sha256_final);
 
-void hmac_sha224(const struct hmac_sha224_key *key,
+void CRYPTO_API(hmac_sha224)(const struct hmac_sha224_key *key,
 		 const u8 *data, size_t data_len, u8 out[SHA224_DIGEST_SIZE])
 {
 	struct hmac_sha224_ctx ctx;
@@ -380,9 +380,9 @@ void hmac_sha224(const struct hmac_sha224_key *key,
 	hmac_sha224_update(&ctx, data, data_len);
 	hmac_sha224_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha224);
+DEFINE_CRYPTO_API(hmac_sha224);
 
-void hmac_sha256(const struct hmac_sha256_key *key,
+void CRYPTO_API(hmac_sha256)(const struct hmac_sha256_key *key,
 		 const u8 *data, size_t data_len, u8 out[SHA256_DIGEST_SIZE])
 {
 	struct hmac_sha256_ctx ctx;
@@ -391,9 +391,9 @@ void hmac_sha256(const struct hmac_sha256_key *key,
 	hmac_sha256_update(&ctx, data, data_len);
 	hmac_sha256_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha256);
+DEFINE_CRYPTO_API(hmac_sha256);
 
-void hmac_sha224_usingrawkey(const u8 *raw_key, size_t raw_key_len,
+void CRYPTO_API(hmac_sha224_usingrawkey)(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
 			     u8 out[SHA224_DIGEST_SIZE])
 {
@@ -403,9 +403,9 @@ void hmac_sha224_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 	hmac_sha224_update(&ctx, data, data_len);
 	hmac_sha224_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha224_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha224_usingrawkey);
 
-void hmac_sha256_usingrawkey(const u8 *raw_key, size_t raw_key_len,
+void CRYPTO_API(hmac_sha256_usingrawkey)(const u8 *raw_key, size_t raw_key_len,
 			     const u8 *data, size_t data_len,
 			     u8 out[SHA256_DIGEST_SIZE])
 {
@@ -415,7 +415,7 @@ void hmac_sha256_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 	hmac_sha256_update(&ctx, data, data_len);
 	hmac_sha256_final(&ctx, out);
 }
-EXPORT_SYMBOL_GPL(hmac_sha256_usingrawkey);
+DEFINE_CRYPTO_API(hmac_sha256_usingrawkey);
 #endif /* !__DISABLE_EXPORTS */
 
 #ifdef sha256_mod_init_arch
@@ -424,12 +424,12 @@ static int __init sha256_mod_init(void)
 	sha256_mod_init_arch();
 	return 0;
 }
-subsys_initcall(sha256_mod_init);
+crypto_subsys_initcall(sha256_mod_init);
 
 static void __exit sha256_mod_exit(void)
 {
 }
-module_exit(sha256_mod_exit);
+crypto_module_exit(sha256_mod_exit);
 #endif
 
 MODULE_DESCRIPTION("SHA-224, SHA-256, HMAC-SHA224, and HMAC-SHA256 library functions");
-- 
2.39.3

