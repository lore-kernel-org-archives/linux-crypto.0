From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - fix operator precedence in shared descriptor
 allocation
Date: Mon, 23 May 2011 18:45:23 -0500
Message-ID: <20110523184523.62654cb1.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:20425
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755927Ab1EWXqe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 May 2011 19:46:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

setkey allocates 16 bytes (CAAM_CMD_SZ *
DESC_AEAD_SHARED_TEXT_LEN) shy of what is needed to
store the shared descriptor, resulting in memory
corruption.  Fix this.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
Bug introduced in commit 4427b1b - "crypto: caam - add support for
sha512 variants of existing AEAD algorithms".

 drivers/crypto/caam/caamalg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d0e65d6..676d957 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -238,9 +238,9 @@ static int build_sh_desc_ipsec(struct caam_ctx *ctx)
 
 	/* build shared descriptor for this session */
 	sh_desc = kmalloc(CAAM_CMD_SZ * DESC_AEAD_SHARED_TEXT_LEN +
-			  keys_fit_inline ?
-			  ctx->split_key_pad_len + ctx->enckeylen :
-			  CAAM_PTR_SZ * 2, GFP_DMA | GFP_KERNEL);
+			  (keys_fit_inline ?
+			   ctx->split_key_pad_len + ctx->enckeylen :
+			   CAAM_PTR_SZ * 2), GFP_DMA | GFP_KERNEL);
 	if (!sh_desc) {
 		dev_err(jrdev, "could not allocate shared descriptor\n");
 		return -ENOMEM;
-- 
1.7.5.1
