From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: call put_page on used pages only
Date: Sat, 10 Sep 2016 13:50:09 +0200
Message-ID: <49118797.WdfLSz7urc@positron.chronox.de>
References: <8008966.Q0OrxOpoA1@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47918 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbcIJLuU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Sep 2016 07:50:20 -0400
In-Reply-To: <8008966.Q0OrxOpoA1@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This patch fixes the reported BUG reliably that I was able to
create with my (faulty) libkcapi test code.

However, I am yet unable to pinpoint the code that allocates an
SG without an associated page that would trigger the BUG.

In any case, if you approve, I would recommend that this patch
should go to 4.8 and to stable as well.

---8<---

Ensure that put_page is only invoked on pages that were used by
algif_skcipher.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index d7acb73..bc36a9a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -179,7 +179,7 @@ static void skcipher_pull_sgl(struct sock *sk, size_t used, int put)
 
 			if (sg[i].length)
 				return;
-			if (put)
+			if (put && page_ref_count(sg_page(sg + i)))
 				put_page(sg_page(sg + i));
 			sg_assign_page(sg + i, NULL);
 		}
-- 
2.7.4
