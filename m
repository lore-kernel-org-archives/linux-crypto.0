From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Git bisected regression for ipsec/aead
Date: Thu, 25 Aug 2016 16:49:51 +0800
Message-ID: <20160825084951.GA11496@gondor.apana.org.au>
References: <20160819192124.GF25320@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, joshua.a.hay@intel.com,
        steffen.klassert@secunet.com
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44043 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756897AbcHYIvU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 04:51:20 -0400
Content-Disposition: inline
In-Reply-To: <20160819192124.GF25320@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 19, 2016 at 03:21:24PM -0400, Sowmini Varadhan wrote:
> 
> Hi Herbert,
> 
> In the process of testing ipsec I ran into panics (details below)
> with  the algorithm
> "aead rfc4106(gcm(aes)) 0x1234567890123456789012345678901234567890 64"
> 
> git-bisect analyzed this down to
> 
>    7271b33cb87e80f3a416fb031ad3ca87f0bea80a is the first bad commit
>    commit 7271b33cb87e80f3a416fb031ad3ca87f0bea80a
>    Author: Herbert Xu <herbert@gondor.apana.org.au>
>    Date:   Tue Jun 21 16:55:16 2016 +0800
> 
>     crypto: ghash-clmulni - Fix cryptd reordering

This bisection doesn't make much sense as this patch just causes
cryptd to be used a little more more frequently.  But it does
point the finger at cryptd.
 
> [  124.627594] BUG: unable to handle kernel paging request at 00000001000000c5
> [  124.627612] ------------[ cut here ]------------
> [  124.627620] WARNING: CPU: 3 PID: 0 at lib/list_debug.c:62 __list_del_entry+0x
> 86/0xd0
> [  124.627621] list_del corruption. next->prev should be ffff88085cebd168, but w
> as 00000000ffffff8d
> [  124.627622] Modules linked in:

So we have list corruption here, possibly caused by use-after-free.
I did spot one bug in the AEAD cryptd path where we end up using
the wrong tfm to track refcnt.

Does this patch help?

---8<---
Subject: crypto: cryptd - Use correct tfm object for AEAD tracking

The AEAD code path incorrectly uses the child tfm to track the
cryptd refcnt, and then potentially frees the child tfm.

Fixes: 81760ea6a95a ("crypto: cryptd - Add helpers to check...")
Reported-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index cf8037a..77207b4 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -733,13 +733,14 @@ static void cryptd_aead_crypt(struct aead_request *req,
 	rctx = aead_request_ctx(req);
 	compl = rctx->complete;
 
+	tfm = crypto_aead_reqtfm(req);
+
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 	aead_request_set_tfm(req, child);
 	err = crypt( req );
 
 out:
-	tfm = crypto_aead_reqtfm(req);
 	ctx = crypto_aead_ctx(tfm);
 	refcnt = atomic_read(&ctx->refcnt);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
