From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 2/2] crypto: shash - no kmap of zero SG
Date: Sun, 24 Sep 2017 08:25:17 +0200
Message-ID: <25135634.rNEetDmbAf@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34928 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbdIXGZs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2017 02:25:48 -0400
In-Reply-To: <3874163.dZU00zCVt8@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case the caller provides an SG with zero data, prevent a kmap of the
page pointed to by the SG. In this case, it is possible that the page
does not exist.

This fixes a crash in authenc() when the plaintext is zero and thus the
encryption operation is a noop. In this case, no input data exists that
can be hashed. The crash is triggerable via AF_ALG from unprivileged
user space.

Fixes: 3b2f6df08258e ("crypto: hash - Export shash through ahash")
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: <stable@vger.kernel.org>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/shash.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 5e31c8d776df..32d0e1806bf4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -278,9 +278,11 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	struct scatterlist *sg = req->src;
 	unsigned int offset = sg->offset;
 	unsigned int nbytes = req->nbytes;
+	unsigned int process = min(sg->length,
+				   ((unsigned int)(PAGE_SIZE)) - offset);
 	int err;
 
-	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
+	if (process && nbytes < process) {
 		void *data;
 
 		data = kmap_atomic(sg_page(sg));
-- 
2.13.5
