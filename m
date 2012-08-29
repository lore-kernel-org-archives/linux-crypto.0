From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: 842 - remove .cra_list initialization
Date: Wed, 29 Aug 2012 23:37:25 +0300
Message-ID: <20120829203725.6424.60519.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:60183 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2H2Uh2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2012 16:37:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

.cra_list initialization is unneeded and have been removed from all other
crypto modules except 842.

Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

---

I don't have ppc64 cross-compiler set up, so I couldn't test this. However
patch is obvious and should work.
---
 crypto/842.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/842.c b/crypto/842.c
index 144767d..65c7a89c 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -157,7 +157,6 @@ static struct crypto_alg alg = {
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct nx842_ctx),
 	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(alg.cra_list),
 	.cra_init		= nx842_init,
 	.cra_exit		= nx842_exit,
 	.cra_u			= { .compress = {
