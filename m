From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: CTR DRBG - advance output buffer pointer
Date: Fri, 18 Nov 2016 12:27:56 +0100
Message-ID: <18729386.1pHbKfYFYP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50976 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752295AbcKRLcC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 06:32:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CTR DRBG segments the number of random bytes to be generated into
128 byte blocks. The current code misses the advancement of the output
buffer pointer when the requestor asks for more than 128 bytes of data.
In this case, the next 128 byte block of random numbers is copied to
the beginning of the output buffer again. This implies that only the
first 128 bytes of the output buffer would ever be filled.

The patch adds the advancement of the buffer pointer to fill the entire
buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index fb33f7d..9a95b61 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1766,6 +1766,7 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 		init_completion(&drbg->ctr_completion);
 
 		outlen -= cryptlen;
+		outbuf += cryptlen;
 	}
 
 	return 0;
-- 
2.7.4
