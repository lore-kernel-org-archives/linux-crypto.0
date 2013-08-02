From: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH] drivers/crypto/nx: saves chaining value from co-processor
Date: Fri, 02 Aug 2013 18:13:58 -0500
Message-ID: <1375485238.32477.41.camel@what-is-leg>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, mhcerri@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:33348 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3HBXOD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Aug 2013 19:14:03 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <fin@linux.vnet.ibm.com>;
	Fri, 2 Aug 2013 17:14:02 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The chaining value from co-processor was not being saved. This value is
needed because it is used as the IV, for example by cts(cbc(aes)).

Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-aes-cbc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 35d483f..a2f99a9 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -95,6 +95,7 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
        if (rc)
                goto out;

+       memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
        atomic_inc(&(nx_ctx->stats->aes_ops));
        atomic64_add(csbcpb->csb.processed_byte_count,
                     &(nx_ctx->stats->aes_bytes));
-- 
1.7.10.4
