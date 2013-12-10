From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 1/3] crypto: ccp - Fix sparse warnings in ccp-crypto-sha.c
Date: Tue, 10 Dec 2013 10:38:33 -0600
Message-ID: <20131210163833.24304.95555.stgit@tlendack-t1.amdoffice.net>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:50062
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962Ab3LJQip (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:45 -0500
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sha initialization data generated the following sparse warnings:

   sparse: incorrect type in initializer (different base types)
      expected unsigned int
      got restricted __be32 [usertype] <noident>

Change the initialization data type from u32 to __be32.


Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c |    8 ++++----
 drivers/crypto/ccp/ccp-crypto.h     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index a6ef183..b0881df 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -324,20 +324,20 @@ static void ccp_hmac_sha_cra_exit(struct crypto_tfm *tfm)
 	ccp_sha_cra_exit(tfm);
 }
 
-static const u32 sha1_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
+static const __be32 sha1_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA1_H0), cpu_to_be32(SHA1_H1),
 	cpu_to_be32(SHA1_H2), cpu_to_be32(SHA1_H3),
 	cpu_to_be32(SHA1_H4), 0, 0, 0,
 };
 
-static const u32 sha224_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
+static const __be32 sha224_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA224_H0), cpu_to_be32(SHA224_H1),
 	cpu_to_be32(SHA224_H2), cpu_to_be32(SHA224_H3),
 	cpu_to_be32(SHA224_H4), cpu_to_be32(SHA224_H5),
 	cpu_to_be32(SHA224_H6), cpu_to_be32(SHA224_H7),
 };
 
-static const u32 sha256_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
+static const __be32 sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA256_H0), cpu_to_be32(SHA256_H1),
 	cpu_to_be32(SHA256_H2), cpu_to_be32(SHA256_H3),
 	cpu_to_be32(SHA256_H4), cpu_to_be32(SHA256_H5),
@@ -347,7 +347,7 @@ static const u32 sha256_init[CCP_SHA_CTXSIZE / sizeof(u32)] = {
 struct ccp_sha_def {
 	const char *name;
 	const char *drv_name;
-	const u32 *init;
+	const __be32 *init;
 	enum ccp_sha_type type;
 	u32 digest_size;
 	u32 block_size;
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 45f17c3..13ea6ea 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -39,7 +39,7 @@ struct ccp_crypto_ablkcipher_alg {
 struct ccp_crypto_ahash_alg {
 	struct list_head entry;
 
-	const u32 *init;
+	const __be32 *init;
 	u32 type;
 	u32 mode;
 
