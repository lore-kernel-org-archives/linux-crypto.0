From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH resend] crypto: get rid of superfluous __GFP_REPEAT
Date: Thu, 14 Apr 2016 10:51:42 +0200
Message-ID: <1460623902-7109-1-git-send-email-mhocko@kernel.org>
References: <1460372892-8157-19-git-send-email-mhocko@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33296 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbcDNIv5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Apr 2016 04:51:57 -0400
In-Reply-To: <1460372892-8157-19-git-send-email-mhocko@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Michal Hocko <mhocko@suse.com>

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

lzo_init uses __GFP_REPEAT to allocate LZO1X_MEM_COMPRESS 16K. This is
order 3 allocation request and __GFP_REPEAT is ignored for this size
as well as all <= PAGE_ALLOC_COSTLY requests.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 crypto/lzo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 4b3e92525dac..c3f3dd9a28c5 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -32,7 +32,7 @@ static int lzo_init(struct crypto_tfm *tfm)
 	struct lzo_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->lzo_comp_mem = kmalloc(LZO1X_MEM_COMPRESS,
-				    GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
+				    GFP_KERNEL | __GFP_NOWARN);
 	if (!ctx->lzo_comp_mem)
 		ctx->lzo_comp_mem = vmalloc(LZO1X_MEM_COMPRESS);
 	if (!ctx->lzo_comp_mem)
-- 
2.8.0.rc3
