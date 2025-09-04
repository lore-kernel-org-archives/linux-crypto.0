Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF40284696;
	Thu,  4 Sep 2025 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001399; cv=none; b=QVTcrrWEcqhCnjtbEUq8Qc+J5O08M4g5YtRtNcdcA4eqZQIpP7Xx7CWRbwEoIVb+oCP30FqQLIQfFSa0iaPf8fdLu3R+ca6gQnRxogRaF4yvlAClGjg9/CGBTi9iizDWJwm6NsSB4WB0qEgichVwEzWBRDItnaTj2/wzAZcRsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001399; c=relaxed/simple;
	bh=5bMoslryKYUHNSLWM5dQ8ZVrJKrm7x5CgJRd2Xde+5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i/RedKBwHmfOCD56O0FV0yUh+TCkfk5EfY2eAAzF8SS242UIPPOgmK0JQ46PUPixFrvHU2ZslkUoAfX05hg7tX7TOrkIQMGVmMmz+mLzDj2uJ14T4YWSDxIEQ65FYirtSGQi3ySKN68MPsWS+bY/K2OqHuOEsooV35fBSCza9Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oZbU6Vdc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oZbU6Vdc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiGK026687;
	Thu, 4 Sep 2025 15:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Kfir0
	tywxLHkdEOQpdZUroz7ASjmJgIXwjC4GNJQW1k=; b=oZbU6Vdcm8xf//7QGixGT
	mpR6PxdehX/8iuc2grKVxIrsv1roY6CN8claOfQ2GwRbViauN95n6IndHv71F1WY
	6w8Y9tCHmxd7f1wiyMpuBhumiN65rYK4x8wCWg6TO7zjARRe5dJeT7b48SOnWHwx
	DEvGkS2LZgmNJyU7btCfMUECyFzHPAZwi1wedIC3rHOiko6wzLnf0JVpB/uCqYm5
	qNcsecPYEnR9vBSAokfB0ZILhvspJFCVKZRet0Fh8fFVN8ptTGoVxQ/blBpjAAzQ
	7D/qHH+5HpODCiOt1kFTHu8lmgcqW9BvtJ6JJJCR34NIzxrDlgw1umm+6moT+OVa
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd1004vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FPlVG040063;
	Thu, 4 Sep 2025 15:56:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtn1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5W000707;
	Thu, 4 Sep 2025 15:56:25 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-23;
	Thu, 04 Sep 2025 15:56:24 +0000
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
Subject: [PATCH RFC 022/104] crypto: fips140: convert lib/crypto/aes.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:50:54 +0200
Message-Id: <20250904155216.460962-23-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfX5ggwbz+Z2yIT
 XghmkJ5fM+5Bt+pwMiVg6UbGEpMEv8bktl0omt/cO/U6Za1t4mi0ShBCZIPN2L8FJbt+/oNfOue
 X/Sfwipq+EamhdwnU+dg75PYdg+wNWdOvajQMtwrp0zPxUiGq1sCCIZhIQUq0LnJGKJ+NVwvvzC
 TKcg658zX3KZKU0G4HCzOy4j1qC3erSV2TeLOoMXAolNEBXfz44OEui/71eHFcxh/J2cHzdIFGl
 N2vcQs11Tfuud5kBWGQfyN5TgmOnRYWd7qUBI1OXK4bvL7XEwRB8ZRhv9yTeBCsUvD/Iq3AG2IR
 S+imWCp47FQ65nxTd7oKnuXog00pXA0mNaeiNKlqrfTIsrFNgul9fwonvkFgstRKBCkSxbasBb+
 1dDiRl1uTVXymzEoYqQKu52tziYHww==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b6aa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=KKAkSRfTAAAA:8 a=lP6ErJPjkfyAI_jvGEoA:9
 a=cvBusfyB2V15izCimMoJ:22 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: B7rAfRzMOkmkNPSobvy1v5dZWWhifTYU
X-Proofpoint-GUID: B7rAfRzMOkmkNPSobvy1v5dZWWhifTYU

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_AES --source lib/crypto/aes.c --header include/crypto/aes.h --vars crypto_aes_sbox crypto_aes_inv_sbox

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c | 21 +++++++++++++++++++++
 include/crypto/aes.h | 14 ++++++++++----
 lib/crypto/aes.c     | 12 ++++++------
 3 files changed, 37 insertions(+), 10 deletions(-)
 create mode 100644 crypto/fips140-api.c

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
new file mode 100644
index 000000000000..029d06763f5a
--- /dev/null
+++ b/crypto/fips140-api.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Define static call keys for any functions which are part of the crypto
+ * API and used by the standalone FIPS module but which are not built into
+ * vmlinux.
+ */
+
+/*
+ * lib/crypto/aes.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_AES)
+
+#include <crypto/aes.h>
+
+DEFINE_CRYPTO_API_STUB(aes_expandkey);
+DEFINE_CRYPTO_API_STUB(aes_encrypt);
+DEFINE_CRYPTO_API_STUB(aes_decrypt);
+
+#endif
+
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 9339da7c20a8..a72621f552d8 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -6,6 +6,7 @@
 #ifndef _CRYPTO_AES_H
 #define _CRYPTO_AES_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 
@@ -65,8 +66,9 @@ int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
  * described in FIPS-197. The first slot (16 bytes) of each key (enc or dec) is
  * for the initial combination, the second slot for the first round and so on.
  */
-int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
-		  unsigned int key_len);
+DECLARE_CRYPTO_API(aes_expandkey, int,
+	(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len),
+	(ctx, in_key, key_len));
 
 /**
  * aes_encrypt - Encrypt a single AES block
@@ -74,7 +76,9 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
  * @out:	Buffer to store the ciphertext
  * @in:		Buffer containing the plaintext
  */
-void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
+DECLARE_CRYPTO_API(aes_encrypt, void,
+	(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in),
+	(ctx, out, in));
 
 /**
  * aes_decrypt - Decrypt a single AES block
@@ -82,7 +86,9 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
  * @out:	Buffer to store the plaintext
  * @in:		Buffer containing the ciphertext
  */
-void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
+DECLARE_CRYPTO_API(aes_decrypt, void,
+	(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in),
+	(ctx, out, in));
 
 extern const u8 crypto_aes_sbox[];
 extern const u8 crypto_aes_inv_sbox[];
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index b57fda3460f1..ece5ce36a305 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -183,7 +183,7 @@ static u32 subw(u32 in)
  * described in FIPS-197. The first slot (16 bytes) of each key (enc or dec) is
  * for the initial combination, the second slot for the first round and so on.
  */
-int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
+int CRYPTO_API(aes_expandkey)(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		  unsigned int key_len)
 {
 	u32 kwords = key_len / sizeof(u32);
@@ -248,7 +248,7 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 
 	return 0;
 }
-EXPORT_SYMBOL(aes_expandkey);
+DEFINE_CRYPTO_API(aes_expandkey);
 
 /**
  * aes_encrypt - Encrypt a single AES block
@@ -256,7 +256,7 @@ EXPORT_SYMBOL(aes_expandkey);
  * @out:	Buffer to store the ciphertext
  * @in:		Buffer containing the plaintext
  */
-void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
+void CRYPTO_API(aes_encrypt)(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 {
 	const u32 *rkp = ctx->key_enc + 4;
 	int rounds = 6 + ctx->key_length / 4;
@@ -299,7 +299,7 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
 }
-EXPORT_SYMBOL(aes_encrypt);
+DEFINE_CRYPTO_API(aes_encrypt);
 
 /**
  * aes_decrypt - Decrypt a single AES block
@@ -307,7 +307,7 @@ EXPORT_SYMBOL(aes_encrypt);
  * @out:	Buffer to store the plaintext
  * @in:		Buffer containing the ciphertext
  */
-void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
+void CRYPTO_API(aes_decrypt)(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 {
 	const u32 *rkp = ctx->key_dec + 4;
 	int rounds = 6 + ctx->key_length / 4;
@@ -350,7 +350,7 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
 }
-EXPORT_SYMBOL(aes_decrypt);
+DEFINE_CRYPTO_API(aes_decrypt);
 
 MODULE_DESCRIPTION("Generic AES library");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-- 
2.39.3

