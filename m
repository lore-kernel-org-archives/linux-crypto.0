From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [HIFN] Use softirq kernel mapping in bh context.
Date: Mon, 24 Nov 2008 17:52:40 +0300
Message-ID: <20081124145240.GA13844@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net> <20081124140535.GD18313@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from corega.com.ru ([195.178.208.66]:35360 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYKXOwm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 09:52:42 -0500
Content-Disposition: inline
In-Reply-To: <20081124140535.GD18313@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use KM_SOFTIRQ instead of KM_IRQ in tasklet context.
Added bug_on on input no-page condition.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 26384e7..6e9b39c 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1393,10 +1393,12 @@ static int hifn_setup_dma(struct hifn_device *dev,
 	n = nbytes;
 	while (n) {
 		if (t->length && rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
+			BUG_ON(!sg_page(t));
 			dpage = sg_page(t);
 			doff = 0;
 			len = t->length;
 		} else {
+			BUG_ON(!sg_page(dst));
 			dpage = sg_page(dst);
 			doff = dst->offset;
 			len = dst->length;
@@ -1791,17 +1793,17 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 				continue;
 			}
 
-			saddr = kmap_atomic(sg_page(t), KM_IRQ1);
+			saddr = kmap_atomic(sg_page(t), KM_SOFTIRQ0);
 
 			err = ablkcipher_get(saddr, &t->length, t->offset,
 					dst, nbytes, &nbytes);
 			if (err < 0) {
-				kunmap_atomic(saddr, KM_IRQ1);
+				kunmap_atomic(saddr, KM_SOFTIRQ0);
 				break;
 			}
 
 			idx += err;
-			kunmap_atomic(saddr, KM_IRQ1);
+			kunmap_atomic(saddr, KM_SOFTIRQ0);
 		}
 
 		ablkcipher_walk_exit(&rctx->walk);


-- 
	Evgeniy Polyakov
