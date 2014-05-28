From: Amos Kong <akong@redhat.com>
Subject: RFC: 2 pages are enough for xor speed testing
Date: Wed, 28 May 2014 13:01:52 +0800
Message-ID: <20140528050152.GA2948@z.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaE1FCG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2014 01:02:06 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crypto/xor.c: calibrate_xor_blocks(), we allocated total 4 pages to
do xor speed testing, the BENCH_SIZE is 1 page. Why do we skip 2 pages
when we set *b2?

It seems that total 2 pages are enough.

diff --git a/crypto/xor.c b/crypto/xor.c
index 35d6b3a..38421a1 100644
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
+	free_pssssages((unsigned long)b1, 1);
 
 	active_template = fastest;
 	return 0;
