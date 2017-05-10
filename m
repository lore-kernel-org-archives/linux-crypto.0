From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] crypto: glue_helper - Delete some dead code
Date: Wed, 10 May 2017 08:52:26 +0300
Message-ID: <20170510055226.5mlkw654cl6djc65@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16974 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdEJFxH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 01:53:07 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We checked (nbytes < bsize) inside the loops so it's not possible to hit
the "goto done;" here.  This code is cut and paste from other slightly
different loops where we don't have the check inside the loop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 24ac9fad832d..d61e57960fe0 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -176,9 +176,6 @@ __glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
 				src -= 1;
 				dst -= 1;
 			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				goto done;
 		}
 	}
 
