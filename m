From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH 10/10] crypto: nx - fix SHA-2 for chunks bigger than block size
Date: Fri, 23 Aug 2013 17:01:14 -0300
Message-ID: <1377288074-18998-11-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43954 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab3HWUBy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Aug 2013 16:01:54 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Fri, 23 Aug 2013 17:01:51 -0300
In-Reply-To: <1377288074-18998-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Each call to the co-processor, with exception of the last call, needs to
send data that is multiple of block size. As consequence, any remaining
data is kept in the internal NX context.

This patch fixes a bug in the driver that causes it to save incorrect
data into the context when data is bigger than the block size.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-sha256.c | 2 +-
 drivers/crypto/nx/nx-sha512.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index 6547a71..da0b24a 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -129,7 +129,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		total -= to_process;
-		data += to_process;
+		data += to_process - sctx->count;
 		sctx->count = 0;
 		in_sg = nx_ctx->in_sg;
 	} while (leftover >= SHA256_BLOCK_SIZE);
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 236e6af..4ae5b0f 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -131,7 +131,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		total -= to_process;
-		data += to_process;
+		data += to_process - sctx->count[0];
 		sctx->count[0] = 0;
 		in_sg = nx_ctx->in_sg;
 	} while (leftover >= SHA512_BLOCK_SIZE);
-- 
1.7.12
