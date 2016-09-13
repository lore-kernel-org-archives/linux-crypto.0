From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3] crypto: only call put_page on referenced and used pages
Date: Tue, 13 Sep 2016 10:18:54 +0200
Message-ID: <1794862.SeMhQgguHO@positron.chronox.de>
References: <13399079.xub8KL5p6S@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47942 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752008AbcIMITD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 04:19:03 -0400
In-Reply-To: <13399079.xub8KL5p6S@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 12. September 2016, 14:43:45 CEST schrieb Stephan Mueller:

Hi Herbert,

> Hi Herbert,
> 
> after getting the AIO code working on sendmsg, tried it with vmsplice/splice
> and I get a memory corruption. Interestingly, the stack trace is partially
> garbled too. Thus, tracking this one down may be a bit of a challenge.

The issue is a NULL pointer dereference in skcipher_free_async_sgls. The issue is that SGs may not have even a page mapped to them and thus the page entry is NULL.

The following patch fixes the issue and replaces the patch I sent earlier.

---8<---

For asynchronous operation, SGs are allocated without a page mapped to
them or with a page that is not used (ref-counted). If the SGL is freed,
the code must only call put_page for an SG if there was a page assigned
and ref-counted in the first place.

This fixes a kernel crash when using io_submit with more than one iocb
using the sendmsg and sendpage (vmsplice/splice) interface

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 28556fc..45af0fe 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -86,8 +86,13 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
 	}
 	sgl = sreq->tsg;
 	n = sg_nents(sgl);
-	for_each_sg(sgl, sg, n, i)
-		put_page(sg_page(sg));
+	for_each_sg(sgl, sg, n, i) {
+		struct page *page = sg_page(sg);
+
+		/* some SGs may not have a page mapped */
+		if (page && page_ref_count(page))
+			put_page(page);
+	}
 
 	kfree(sreq->tsg);
 }
-- 
2.7.4
