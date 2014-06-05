From: Amos Kong <akong@redhat.com>
Subject: [PATCH] crypto/xor.c: use 2 pages for xor speed testing
Date: Thu,  5 Jun 2014 09:11:33 +0800
Message-ID: <1401930693-6549-1-git-send-email-akong@redhat.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, marex@denx.de
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaFEBLo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Jun 2014 21:11:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crypto/xor.c: calibrate_xor_blocks(), we allocated total 4 pages to
do xor speed testing, the BENCH_SIZE is 1 page, and we skipped 2 pages
when we set b2.

It seems that total 2 pages are enough without skipping 2 pages.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 crypto/xor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index 35d6b3a..609dfb5 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -114,12 +114,12 @@ calibrate_xor_blocks(void)
 	 * test the XOR speed, we don't really want kmemcheck to warn about
 	 * reading uninitialized bytes here.
 	 */
-	b1 = (void *) __get_free_pages(GFP_KERNEL | __GFP_NOTRACK, 2);
+	b1 = (void *) __get_free_pages(GFP_KERNEL | __GFP_NOTRACK, 1);
 	if (!b1) {
 		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
-	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
+	b2 = b1 + BENCH_SIZE;
 
 	/*
 	 * If this arch/cpu has a short-circuited selection, don't loop through
@@ -154,7 +154,7 @@ calibrate_xor_blocks(void)
 #undef xor_speed
 
  out:
-	free_pages((unsigned long)b1, 2);
+	free_pages((unsigned long)b1, 1);
 
 	active_template = fastest;
 	return 0;
-- 
1.9.3
