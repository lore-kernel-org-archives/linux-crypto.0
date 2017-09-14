From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: DRBG - fix freeing of resources
Date: Thu, 14 Sep 2017 17:10:28 +0200
Message-ID: <5295371.QYDBsUotKj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34722 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbdINPKf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2017 11:10:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

During the change to use aligned buffers, the deallocation code path was
not updated correctly. The current code tries to free the aligned buffer
pointer and not the original buffer pointer as it is supposed to.

Thus, the code is updated to free the original buffer pointer and set
the aligned buffer pointer that is used throughout the code to NULL.

Fixes: 3cfc3b9721123 ("crypto: drbg - use aligned buffers")
CC: <stable@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 633a88e93ab0..70018397e59a 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1133,10 +1133,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
-	kzfree(drbg->V);
-	drbg->Vbuf = NULL;
-	kzfree(drbg->C);
-	drbg->Cbuf = NULL;
+	kzfree(drbg->Vbuf);
+	drbg->V = NULL;
+	kzfree(drbg->Cbuf);
+	drbg->C = NULL;
 	kzfree(drbg->scratchpadbuf);
 	drbg->scratchpadbuf = NULL;
 	drbg->reseed_ctr = 0;
-- 
2.13.5
