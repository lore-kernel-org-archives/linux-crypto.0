From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 1/6] crypto: ccp - Add SHA-2 support
Date: Thu, 13 Oct 2016 09:52:48 -0500
Message-ID: <20161013145248.19759.23166.stgit@taos>
References: <20161013144542.19759.6924.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0062.outbound.protection.outlook.com ([104.47.34.62]:53712
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751971AbcJMPJD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 11:09:03 -0400
In-Reply-To: <20161013144542.19759.6924.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Incorporate 384-bit and 512-bit hashing for a version 5 CCP
device


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c |   22 +++++++++++
 drivers/crypto/ccp/ccp-crypto.h     |    9 +++--
 drivers/crypto/ccp/ccp-ops.c        |   70 +++++++++++++++++++++++++++++++++++
 include/linux/ccp.h                 |    3 ++
 4 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 84a652b..6b46eea 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -146,6 +146,12 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	case CCP_SHA_TYPE_256:
 		rctx->cmd.u.sha.ctx_len = SHA256_DIGEST_SIZE;
 		break;
+	case CCP_SHA_TYPE_384:
+		rctx->cmd.u.sha.ctx_len = SHA384_DIGEST_SIZE;
+		break;
+	case CCP_SHA_TYPE_512:
+		rctx->cmd.u.sha.ctx_len = SHA512_DIGEST_SIZE;
+		break;
 	default:
 		/* Should never get here */
 		break;
@@ -393,6 +399,22 @@ static struct ccp_sha_def sha_algs[] = {
 		.digest_size	= SHA256_DIGEST_SIZE,
 		.block_size	= SHA256_BLOCK_SIZE,
 	},
+	{
+		.version	= CCP_VERSION(5, 0),
+		.name		= "sha384",
+		.drv_name	= "sha384-ccp",
+		.type		= CCP_SHA_TYPE_384,
+		.digest_size	= SHA384_DIGEST_SIZE,
+		.block_size	= SHA384_BLOCK_SIZE,
+	},
+	{
+		.version	= CCP_VERSION(5, 0),
+		.name		= "sha512",
+		.drv_name	= "sha512-ccp",
+		.type		= CCP_SHA_TYPE_512,
+		.digest_size	= SHA512_DIGEST_SIZE,
+		.block_size	= SHA512_BLOCK_SIZE,
+	},
 };
 
 static int ccp_register_hmac_alg(struct list_head *head,
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 8335b32..ae442ac 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -137,9 +137,12 @@ struct ccp_aes_cmac_exp_ctx {
 	u8 buf[AES_BLOCK_SIZE];
 };
 
-/***** SHA related defines *****/
-#define MAX_SHA_CONTEXT_SIZE	SHA256_DIGEST_SIZE
-#define MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
+/*
+ * SHA-related defines
+ * These values must be large enough to accommodate any variant
+ */
+#define MAX_SHA_CONTEXT_SIZE	SHA512_DIGEST_SIZE
+#define MAX_SHA_BLOCK_SIZE	SHA512_BLOCK_SIZE
 
 struct ccp_sha_ctx {
 	struct scatterlist opad_sg;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 50fae44..8fedb14 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -41,6 +41,20 @@ static const __be32 ccp_sha256_init[SHA256_DIGEST_SIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
 };
 
+static const __be64 ccp_sha384_init[SHA512_DIGEST_SIZE / sizeof(__be64)] = {
+	cpu_to_be64(SHA384_H0), cpu_to_be64(SHA384_H1),
+	cpu_to_be64(SHA384_H2), cpu_to_be64(SHA384_H3),
+	cpu_to_be64(SHA384_H4), cpu_to_be64(SHA384_H5),
+	cpu_to_be64(SHA384_H6), cpu_to_be64(SHA384_H7),
+};
+
+static const __be64 ccp_sha512_init[SHA512_DIGEST_SIZE / sizeof(__be64)] = {
+	cpu_to_be64(SHA512_H0), cpu_to_be64(SHA512_H1),
+	cpu_to_be64(SHA512_H2), cpu_to_be64(SHA512_H3),
+	cpu_to_be64(SHA512_H4), cpu_to_be64(SHA512_H5),
+	cpu_to_be64(SHA512_H6), cpu_to_be64(SHA512_H7),
+};
+
 #define	CCP_NEW_JOBID(ccp)	((ccp->vdata->version == CCP_VERSION(3, 0)) ? \
 					ccp_gen_jobid(ccp) : 0)
 
@@ -963,6 +977,16 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			return -EINVAL;
 		block_size = SHA256_BLOCK_SIZE;
 		break;
+	case CCP_SHA_TYPE_384:
+		if (sha->ctx_len < SHA384_DIGEST_SIZE)
+			return -EINVAL;
+		block_size = SHA384_BLOCK_SIZE;
+		break;
+	case CCP_SHA_TYPE_512:
+		if (sha->ctx_len < SHA512_DIGEST_SIZE)
+			return -EINVAL;
+		block_size = SHA512_BLOCK_SIZE;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1050,6 +1074,21 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		sb_count = 1;
 		ooffset = ioffset = 0;
 		break;
+	case CCP_SHA_TYPE_384:
+		digest_size = SHA384_DIGEST_SIZE;
+		init = (void *) ccp_sha384_init;
+		ctx_size = SHA512_DIGEST_SIZE;
+		sb_count = 2;
+		ioffset = 0;
+		ooffset = 2 * CCP_SB_BYTES - SHA384_DIGEST_SIZE;
+		break;
+	case CCP_SHA_TYPE_512:
+		digest_size = SHA512_DIGEST_SIZE;
+		init = (void *) ccp_sha512_init;
+		ctx_size = SHA512_DIGEST_SIZE;
+		sb_count = 2;
+		ooffset = ioffset = 0;
+		break;
 	default:
 		ret = -EINVAL;
 		goto e_data;
@@ -1068,6 +1107,11 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	op.u.sha.type = sha->type;
 	op.u.sha.msg_bits = sha->msg_bits;
 
+	/* For SHA1/224/256 the context fits in a single (32-byte) SB entry;
+	 * SHA384/512 require 2 adjacent SB slots, with the right half in the
+	 * first slot, and the left half in the second. Each portion must then
+	 * be in little endian format: use the 256-bit byte swap option.
+	 */
 	ret = ccp_init_dm_workarea(&ctx, cmd_q, sb_count * CCP_SB_BYTES,
 				   DMA_BIDIRECTIONAL);
 	if (ret)
@@ -1079,6 +1123,13 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		case CCP_SHA_TYPE_256:
 			memcpy(ctx.address + ioffset, init, ctx_size);
 			break;
+		case CCP_SHA_TYPE_384:
+		case CCP_SHA_TYPE_512:
+			memcpy(ctx.address + ctx_size / 2, init,
+			       ctx_size / 2);
+			memcpy(ctx.address, init + ctx_size / 2,
+			       ctx_size / 2);
+			break;
 		default:
 			ret = -EINVAL;
 			goto e_ctx;
@@ -1145,6 +1196,15 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 					sha->ctx, 0,
 					digest_size);
 			break;
+		case CCP_SHA_TYPE_384:
+		case CCP_SHA_TYPE_512:
+			ccp_get_dm_area(&ctx, 0,
+					sha->ctx, LSB_ITEM_SIZE - ooffset,
+					LSB_ITEM_SIZE);
+			ccp_get_dm_area(&ctx, LSB_ITEM_SIZE + ooffset,
+					sha->ctx, 0,
+					LSB_ITEM_SIZE - ooffset);
+			break;
 		default:
 			ret = -EINVAL;
 			goto e_ctx;
@@ -1182,6 +1242,16 @@ static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 			       ctx.address + ooffset,
 			       digest_size);
 			break;
+		case CCP_SHA_TYPE_384:
+		case CCP_SHA_TYPE_512:
+			memcpy(hmac_buf + block_size,
+			       ctx.address + LSB_ITEM_SIZE + ooffset,
+			       LSB_ITEM_SIZE);
+			memcpy(hmac_buf + block_size +
+			       (LSB_ITEM_SIZE - ooffset),
+			       ctx.address,
+			       LSB_ITEM_SIZE);
+			break;
 		default:
 			ret = -EINVAL;
 			goto e_ctx;
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index a765333..1a3e0b5 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -249,8 +249,11 @@ enum ccp_sha_type {
 	CCP_SHA_TYPE_1 = 1,
 	CCP_SHA_TYPE_224,
 	CCP_SHA_TYPE_256,
+	CCP_SHA_TYPE_384,
+	CCP_SHA_TYPE_512,
 	CCP_SHA_TYPE__LAST,
 };
+#define	CCP_SHA_CTXSIZE		SHA512_DIGEST_SIZE
 
 /**
  * struct ccp_sha_engine - CCP SHA operation
