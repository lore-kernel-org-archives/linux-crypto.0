Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022AA27D770;
	Thu,  4 Sep 2025 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001405; cv=none; b=TKZlzOCCHbXgjxmyEqMPss39V4hBje4zUTOlny0D7x7jg+zWFb9zEc4jmeex416o5ylIqEnWp2Gj0wljTW5eENVekdH13BuVx/0I30EyDtvUhlHW7dBI49kH9oZMBL/UEtsJO29z7ahTB6NlpVptaWR3WvhoblXFP5LlBRqlJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001405; c=relaxed/simple;
	bh=GlE/LyD1WFiFaLTfhEom12wAqKe+ReNomUqxX1JcDYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NeKIDEAxPp6iUZkLIyzDdM3M7Q/bC8BbwsFNU3TPEJjdHlRsJzxPrJbtRKK7xT6gppSU6a+2m59Vt3pt6JDRZFi9KnMLG4eFD0pL0ieTfJjLyf3Thn8ClLiYaSAWpd2v6PwrAOVBtqtVIjbY+nQ6G91fy3PtkyLRlxyz4k0gxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VEOfsDgn; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VEOfsDgn"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjJh010465;
	Thu, 4 Sep 2025 15:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=DsL1H
	KveutpUKfoHRAEKaXT0Rlje4juQV4XUyoT3D7Y=; b=VEOfsDgn9bn1bXmlztg0m
	Y9HWsshHlGvEstfJhut80snLuQQ3ztnLG7R/iT6yyv4N/yqFxOmScPA8rVXliYM9
	11DWUVmF5rIJa1L32tL4cHqguS/d7a4pfvqC2//Mlp5wZOhhIiA98MA0gK7buHli
	/gJyspEnY8MbPqrHipH8gXrrVMXYge3WQgBY+bm2IwD0w9GEWfqnhD2ZioxtQt1H
	Of4XUDfTgczI6DIXC8aafrU6uCJioUZW3KwVarvqISfn13MkBXXfxj7PAoHM4ZHq
	krJ5l3tuq+5ifUgvxE/McQqlagHr2pwOb8JguF41SON4Wbs2paqAYhLm/M0Wxrw9
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydacr2pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FjIUl040126;
	Thu, 4 Sep 2025 15:56:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtn3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:56:29 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx5Y000707;
	Thu, 4 Sep 2025 15:56:28 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-24;
	Thu, 04 Sep 2025 15:56:28 +0000
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
Subject: [PATCH RFC 023/104] crypto: fips140: convert lib/crypto/aesgcm.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:50:55 +0200
Message-Id: <20250904155216.460962-24-vegard.nossum@oracle.com>
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
X-Proofpoint-GUID: nH-lKFz1GpD2q91R46WWPiIwXFapNZYt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MCBTYWx0ZWRfX+d2XeUxGDCaV
 xdwCmi57At1R9rnfn7WeCOUlC54BxlgQv51jOxTuu45q/QOsvGFRMSCtagYyt4ZvdZGQkppCMEG
 pyKNNg8kwvPXhwaqKGpzMDDvzGrhx6sTMDbaaz8CPxRPe8HGLBoxepw5wdS3zDMiJ1/ZCd1FNE4
 36O5ODFLzt9ntZ1habFRTWbVdekDvkdpCPHb5we2g7WZ+HvRP/H5SGy/qheAi0n4Cq/cCq/QBlj
 gWeaonyoU5nuzG19yX143bIfUv7mO6CklHxkVbbFKv+ChhpdGMxmN3qqlM9kAvHtUduseKhnrbk
 Rd82LIv4stXvYL9NstGSpZo9JwlpTMgva5Oz36FpaZtoClOvb0AQFh+dEdNhg87uSopcNSqQMco
 Vg4MQANnfL0Cb2ONL7aXWEzyIaYkxg==
X-Proofpoint-ORIG-GUID: nH-lKFz1GpD2q91R46WWPiIwXFapNZYt
X-Authority-Analysis: v=2.4 cv=TuTmhCXh c=1 sm=1 tr=0 ts=68b9b6ae b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=opW2vFFDzM6jMY83o74A:9
 cc=ntf awl=host:12068

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_LIB_AESGCM --source lib/crypto/aesgcm.c --header include/crypto/gcm.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/fips140-api.c | 13 +++++++++++++
 include/crypto/gcm.h | 19 ++++++++++---------
 lib/crypto/aesgcm.c  | 16 ++++++++--------
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 029d06763f5a..4924b11ec592 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -19,3 +19,16 @@ DEFINE_CRYPTO_API_STUB(aes_decrypt);
 
 #endif
 
+/*
+ * lib/crypto/aesgcm.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_LIB_AESGCM)
+
+#include <crypto/gcm.h>
+
+DEFINE_CRYPTO_API_STUB(aesgcm_expandkey);
+DEFINE_CRYPTO_API_STUB(aesgcm_encrypt);
+DEFINE_CRYPTO_API_STUB(aesgcm_decrypt);
+
+#endif
+
diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index fd9df607a836..7275507b3689 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -1,6 +1,7 @@
 #ifndef _CRYPTO_GCM_H
 #define _CRYPTO_GCM_H
 
+#include <crypto/api.h>
 #include <linux/errno.h>
 
 #include <crypto/aes.h>
@@ -70,16 +71,16 @@ struct aesgcm_ctx {
 	unsigned int		authsize;
 };
 
-int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
-		     unsigned int keysize, unsigned int authsize);
+DECLARE_CRYPTO_API(aesgcm_expandkey, int,
+	(struct aesgcm_ctx *ctx, const u8 *key, unsigned int keysize, unsigned int authsize),
+	(ctx, key, keysize, authsize));
 
-void aesgcm_encrypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
-		    int crypt_len, const u8 *assoc, int assoc_len,
-		    const u8 iv[GCM_AES_IV_SIZE], u8 *authtag);
+DECLARE_CRYPTO_API(aesgcm_encrypt, void,
+	(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src, int crypt_len, const u8 *assoc, int assoc_len, const u8 iv[GCM_AES_IV_SIZE], u8 *authtag),
+	(ctx, dst, src, crypt_len, assoc, assoc_len, iv, authtag));
 
-bool __must_check aesgcm_decrypt(const struct aesgcm_ctx *ctx, u8 *dst,
-				 const u8 *src, int crypt_len, const u8 *assoc,
-				 int assoc_len, const u8 iv[GCM_AES_IV_SIZE],
-				 const u8 *authtag);
+DECLARE_CRYPTO_API(aesgcm_decrypt, bool __must_check,
+	(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src, int crypt_len, const u8 *assoc, int assoc_len, const u8 iv[GCM_AES_IV_SIZE], const u8 *authtag),
+	(ctx, dst, src, crypt_len, assoc, assoc_len, iv, authtag));
 
 #endif
diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index ac0b2fcfd606..1fe4333c0335 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -42,7 +42,7 @@ static void aesgcm_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
  * Returns: 0 on success, or -EINVAL if @keysize or @authsize contain values
  * that are not permitted by the GCM specification.
  */
-int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
+int CRYPTO_API(aesgcm_expandkey)(struct aesgcm_ctx *ctx, const u8 *key,
 		     unsigned int keysize, unsigned int authsize)
 {
 	u8 kin[AES_BLOCK_SIZE] = {};
@@ -58,7 +58,7 @@ int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
 
 	return 0;
 }
-EXPORT_SYMBOL(aesgcm_expandkey);
+DEFINE_CRYPTO_API(aesgcm_expandkey);
 
 static void aesgcm_ghash(be128 *ghash, const be128 *key, const void *src,
 			 int len)
@@ -144,7 +144,7 @@ static void aesgcm_crypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
  *		tag should be stored. The buffer is assumed to have space for
  *		@ctx->authsize bytes.
  */
-void aesgcm_encrypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
+void CRYPTO_API(aesgcm_encrypt)(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
 		    int crypt_len, const u8 *assoc, int assoc_len,
 		    const u8 iv[GCM_AES_IV_SIZE], u8 *authtag)
 {
@@ -155,7 +155,7 @@ void aesgcm_encrypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
 	aesgcm_crypt(ctx, dst, src, crypt_len, ctr);
 	aesgcm_mac(ctx, dst, crypt_len, assoc, assoc_len, ctr, authtag);
 }
-EXPORT_SYMBOL(aesgcm_encrypt);
+DEFINE_CRYPTO_API(aesgcm_encrypt);
 
 /**
  * aesgcm_decrypt - Perform AES-GCM decryption on a block of data
@@ -174,7 +174,7 @@ EXPORT_SYMBOL(aesgcm_encrypt);
  * Returns: true on success, or false if the ciphertext failed authentication.
  * On failure, no plaintext will be returned.
  */
-bool __must_check aesgcm_decrypt(const struct aesgcm_ctx *ctx, u8 *dst,
+bool __must_check CRYPTO_API(aesgcm_decrypt)(const struct aesgcm_ctx *ctx, u8 *dst,
 				 const u8 *src, int crypt_len, const u8 *assoc,
 				 int assoc_len, const u8 iv[GCM_AES_IV_SIZE],
 				 const u8 *authtag)
@@ -192,7 +192,7 @@ bool __must_check aesgcm_decrypt(const struct aesgcm_ctx *ctx, u8 *dst,
 	aesgcm_crypt(ctx, dst, src, crypt_len, ctr);
 	return true;
 }
-EXPORT_SYMBOL(aesgcm_decrypt);
+DEFINE_CRYPTO_API(aesgcm_decrypt);
 
 MODULE_DESCRIPTION("Generic AES-GCM library");
 MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
@@ -730,10 +730,10 @@ static int __init libaesgcm_init(void)
 	}
 	return 0;
 }
-module_init(libaesgcm_init);
+crypto_module_init(libaesgcm_init);
 
 static void __exit libaesgcm_exit(void)
 {
 }
-module_exit(libaesgcm_exit);
+crypto_module_exit(libaesgcm_exit);
 #endif
-- 
2.39.3

