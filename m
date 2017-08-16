From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v4] crypto: only call put_page on referenced and used pages
Date: Wed, 16 Aug 2017 11:56:24 +0200
Message-ID: <3026257.T9F4K2f5sf@positron.chronox.de>
References: <2922624.oQubu9mOmR@positron.chronox.de> <3178607.Y0F1IYYMXo@tauon.chronox.de> <20170816093731.GA21573@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58908 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdHPJ40 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 05:56:26 -0400
In-Reply-To: <20170816093731.GA21573@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This patch was created against the current Linus development tree.

The functional test was conducted at the time v3 was aired. The patch
v4 is compile-tested.

Ciao
Stephan

---8<---
For asynchronous operation, SGs are allocated without a page mapped to
them or with a page that is not used (ref-counted). If the SGL is freed,
the code must only call put_page for an SG if there was a page assigned
and ref-counted in the first place.

This fixes a kernel crash when using io_submit with more than one iocb
using the sendmsg and sendpage (vmsplice/splice) interface.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 43839b00fe6c..903605dbc1a5 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -87,8 +87,13 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
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
2.13.4
