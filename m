From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: blowfish-x86_64: fix ctr blocksize to 1
Date: Mon, 10 Oct 2011 12:32:15 +0300
Message-ID: <20111010093215.7547.44692.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:54152 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1JJJcS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Oct 2011 05:32:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/blowfish_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 40911ab..dd3964a 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -423,7 +423,7 @@ static struct crypto_alg blk_ctr_alg = {
 	.cra_driver_name	= "ctr-blowfish-asm",
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= BF_BLOCK_SIZE,
+	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct bf_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
