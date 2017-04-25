From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] crypto: sha512-mb - add some missing unlock on error
Date: Tue, 25 Apr 2017 12:18:54 +0300
Message-ID: <20170425091854.6fryhkc2v4tf4dnl@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Megha Dey <megha.dey@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Tucker <greg.b.tucker@intel.com>,
        Xiaodong Liu <xiaodong.liu@intel.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35198 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932864AbdDYJTd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 05:19:33 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We recently added some new locking but missed the unlocks on these
error paths in sha512_ctx_mgr_submit().

Fixes: c459bd7beda0 ("crypto: sha512-mb - Protect sha512 mb ctx mgr access")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/crypto/sha512-mb/sha512_mb.c b/arch/x86/crypto/sha512-mb/sha512_mb.c
index 2dd3674b5a1e..458409b7568d 100644
--- a/arch/x86/crypto/sha512-mb/sha512_mb.c
+++ b/arch/x86/crypto/sha512-mb/sha512_mb.c
@@ -269,19 +269,19 @@ static struct sha512_hash_ctx
 		 * LAST
 		 */
 		ctx->error = HASH_CTX_ERROR_INVALID_FLAGS;
-		return ctx;
+		goto unlock;
 	}
 
 	if (ctx->status & HASH_CTX_STS_PROCESSING) {
 		/* Cannot submit to a currently processing job. */
 		ctx->error = HASH_CTX_ERROR_ALREADY_PROCESSING;
-		return ctx;
+		goto unlock;
 	}
 
 	if ((ctx->status & HASH_CTX_STS_COMPLETE) && !(flags & HASH_FIRST)) {
 		/* Cannot update a finished job. */
 		ctx->error = HASH_CTX_ERROR_ALREADY_COMPLETED;
-		return ctx;
+		goto unlock;
 	}
 
 
@@ -363,6 +363,7 @@ static struct sha512_hash_ctx
 	}
 
 	ctx = sha512_ctx_mgr_resubmit(mgr, ctx);
+unlock:
 	spin_unlock_irqrestore(&cstate->work_lock, irqflags);
 	return ctx;
 }
