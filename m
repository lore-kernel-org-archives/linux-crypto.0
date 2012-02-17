From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 6/6] crypto: twofish-x86_64/i586 - set alignmask to zero
Date: Fri, 17 Feb 2012 22:49:03 +0200
Message-ID: <20120217204903.3744.60713.stgit@localhost6.localdomain6>
References: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34794 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2BQUtF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Feb 2012 15:49:05 -0500
In-Reply-To: <20120217204837.3744.54155.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

x86 has fast unaligned accesses, so twofish-x86_64/i586 does not need to enforce
alignment.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index dc6b3fb..359ae08 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -68,7 +68,7 @@ static struct crypto_alg alg = {
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TF_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct twofish_ctx),
-	.cra_alignmask		=	3,
+	.cra_alignmask		=	0,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(alg.cra_list),
 	.cra_u			=	{
