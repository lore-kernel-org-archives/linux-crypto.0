From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: twofish-x86_64-3way: fix ctr blocksize to 1
Date: Mon, 10 Oct 2011 12:33:02 +0300
Message-ID: <20111010093302.7983.18671.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:58659 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJJdG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Oct 2011 05:33:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 0cbf9fa..5ede9c4 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -414,7 +414,7 @@ static struct crypto_alg blk_ctr_alg = {
 	.cra_driver_name	= "ctr-twofish-3way",
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_blocksize		= 1,
 	.cra_ctxsize		= sizeof(struct twofish_ctx),
 	.cra_alignmask		= 0,
 	.cra_type		= &crypto_blkcipher_type,
