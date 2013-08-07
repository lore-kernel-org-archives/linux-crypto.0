From: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH v2] drivers/crypto/nx: saves chaining value from co-processor
Date: Wed, 07 Aug 2013 18:15:50 -0500
Message-ID: <1375917350.16050.14.camel@what-is-leg>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	herbert@gondor.apana.org.au, fin@linux.vnet.ibm.com,
	mhcerri@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes a bug that is triggered when cts(cbc(aes)) is used with
nx-crypto driver on input larger than 32 bytes.

The chaining value from co-processor was not being saved. This value is
needed because it is used as the IV by cts(cbc(aes)).

Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
v2. changed signed-off-by to reviewed-by and added more details to
description

This bug appeared in the original submission (v3.5)
---
 drivers/crypto/nx/nx-aes-cbc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c
b/drivers/crypto/nx/nx-aes-cbc.c
index 35d483f..a2f99a9 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -95,6 +95,7 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc
*desc,
        if (rc)
                goto out;

+       memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
        atomic_inc(&(nx_ctx->stats->aes_ops));
        atomic64_add(csbcpb->csb.processed_byte_count,
                     &(nx_ctx->stats->aes_bytes));
-- 
1.7.10.4
