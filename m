From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] crypto: lzo: use kvfree() helper
Date: Tue, 24 Jun 2014 01:23:45 -0700
Message-ID: <1403598225.27425.9.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140620184053.GC3169@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Seth Jennings <sjennings@variantweb.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48058 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFXIXu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Jun 2014 04:23:50 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so5450394wib.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jun 2014 01:23:49 -0700 (PDT)
In-Reply-To: <20140620184053.GC3169@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

kvfree() helper is now available, use it instead of open code it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 crypto/lzo.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 252e791d..a8ff2f7 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -45,10 +45,7 @@ static void lzo_exit(struct crypto_tfm *tfm)
 {
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (is_vmalloc_addr(ctx->lzo_comp_mem))
-		vfree(ctx->lzo_comp_mem);
-	else
-		kfree(ctx->lzo_comp_mem);
+	kvfree(ctx->lzo_comp_mem);
 }
 
 static int lzo_compress(struct crypto_tfm *tfm, const u8 *src,
