From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH] crypto: aead - fix for multiple operations on AF_ALG sockets
Date: Tue, 25 Aug 2015 11:59:15 +0200
Message-ID: <1440496755-15105-1-git-send-email-larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:40867 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbbHYJ7a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2015 05:59:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The tsgl scatterlist must be re-initialized after each
operation. Otherwise the sticky bits in the page_link will corrupt the
list with pre-mature termination or false chaining.

Signed-off-by: Lars Persson <larper@axis.com>
---
 crypto/algif_aead.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 38a6cab..0aa6fdf 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -90,6 +90,7 @@ static void aead_put_sgl(struct sock *sk)
 		put_page(sg_page(sg + i));
 		sg_assign_page(sg + i, NULL);
 	}
+	sg_init_table(sg, ALG_MAX_PAGES);
 	sgl->cur = 0;
 	ctx->used = 0;
 	ctx->more = 0;
-- 
2.1.4
