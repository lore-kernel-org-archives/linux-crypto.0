From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH 06/17] powerpc: crypto: AES-CBC mode routines for nx
 encryption
Date: Wed, 21 Mar 2012 16:39:28 -0500
Message-ID: <1332365968.3858.34.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, rcj@linux.vnet.ibm.com,
	benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332365297.3858.5.camel@key-ThinkPad-W510>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These routines add support for AES in CBC mode on the Power7+ CPU's
in-Nest accelerator driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 arch/powerpc/crypto/nx/nx-aes-cbc.c |  135 +++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/crypto/nx/nx-aes-cbc.c

diff --git a/arch/powerpc/crypto/nx/nx-aes-cbc.c b/arch/powerpc/crypto/nx/nx-aes-cbc.c
new file mode 100644
index 0000000..01fa5cb
--- /dev/null
+++ b/arch/powerpc/crypto/nx/nx-aes-cbc.c
@@ -0,0 +1,135 @@
+/**
+ * AES CBC routines supporting the Power 7+ Nest Accelerators driver
+ *
+ * Copyright (C) 2011-2012 International Business Machines Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 only.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: Kent Yoder <yoder1@us.ibm.com>
+ */
+
+#include <crypto/aes.h>
+#include <crypto/algapi.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/crypto.h>
+#include <asm/vio.h>
+
+#include "nx_csbcpb.h"
+#include "nx.h"
+
+
+static int cbc_aes_nx_set_key(struct crypto_tfm *tfm,
+			      const u8          *in_key,
+			      unsigned int       key_len)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+
+	nx_ctx_init(nx_ctx, HCOP_FC_AES);
+
+	switch (key_len) {
+	case AES_KEYSIZE_128:
+		csbcpb->cpb.hdr.key_size = NX_KS_AES_128;
+		nx_ctx->ap = &nx_ctx->props[NX_PROPS_AES_128];
+		break;
+	case AES_KEYSIZE_192:
+		csbcpb->cpb.hdr.key_size = NX_KS_AES_192;
+		nx_ctx->ap = &nx_ctx->props[NX_PROPS_AES_192];
+		break;
+	case AES_KEYSIZE_256:
+		csbcpb->cpb.hdr.key_size = NX_KS_AES_256;
+		nx_ctx->ap = &nx_ctx->props[NX_PROPS_AES_256];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	csbcpb->cpb.hdr.mode = NX_MODE_AES_CBC;
+	memcpy(csbcpb->cpb.aes_cbc.key, in_key, key_len);
+
+	return 0;
+}
+
+static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
+			    struct scatterlist    *dst,
+			    struct scatterlist    *src,
+			    unsigned int           nbytes,
+			    int                    enc)
+{
+	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
+	int rc;
+
+	if (nbytes > nx_ctx->ap->databytelen)
+		return -EINVAL;
+
+	csbcpb->cpb.hdr.fdm.ende = enc;
+
+	rc = nx_build_sg_lists(nx_ctx, desc, dst, src, nbytes,
+			       csbcpb->cpb.aes_cbc.iv);
+	if (rc)
+		goto out;
+
+	if (!nx_ctx->op.inlen || !nx_ctx->op.outlen)
+		return -EINVAL;
+
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op);
+	if (rc)
+		goto out;
+
+	atomic_inc(&(nx_ctx->stats->aes_ops));
+	atomic64_add(csbcpb->csb.processed_byte_count,
+		     &(nx_ctx->stats->aes_bytes));
+out:
+	return rc;
+}
+
+static int cbc_aes_nx_encrypt(struct blkcipher_desc *desc,
+			      struct scatterlist    *dst,
+			      struct scatterlist    *src,
+			      unsigned int           nbytes)
+{
+	return cbc_aes_nx_crypt(desc, dst, src, nbytes, 1);
+}
+
+static int cbc_aes_nx_decrypt(struct blkcipher_desc *desc,
+			      struct scatterlist    *dst,
+			      struct scatterlist    *src,
+			      unsigned int           nbytes)
+{
+	return cbc_aes_nx_crypt(desc, dst, src, nbytes, 0);
+}
+
+struct crypto_alg nx_cbc_aes_alg = {
+	.cra_name        = "cbc(aes)",
+	.cra_driver_name = "cbc-aes-nx",
+	.cra_priority    = 300,
+	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize   = AES_BLOCK_SIZE,
+	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
+	.cra_type        = &crypto_blkcipher_type,
+	.cra_module      = THIS_MODULE,
+	.cra_list        = LIST_HEAD_INIT(nx_cbc_aes_alg.cra_list),
+	.cra_init        = nx_crypto_ctx_aes_cbc_init,
+	.cra_exit        = nx_crypto_ctx_exit,
+	.cra_blkcipher = {
+		.min_keysize = AES_MIN_KEY_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE,
+		.ivsize      = AES_BLOCK_SIZE,
+		.setkey      = cbc_aes_nx_set_key,
+		.encrypt     = cbc_aes_nx_encrypt,
+		.decrypt     = cbc_aes_nx_decrypt,
+	}
+};
-- 
1.7.1
