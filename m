From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PROBLEM: unable to decrypt LUKS partition since v4.9-rc6
 (bisected)
Date: Mon, 21 Nov 2016 15:34:00 +0800
Message-ID: <20161121073400.GA6357@gondor.apana.org.au>
References: <20161121065638.GA540@pks-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Patrick Steinhardt <ps@pks.im>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36018 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752180AbcKUHeR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 02:34:17 -0500
Content-Disposition: inline
In-Reply-To: <20161121065638.GA540@pks-pc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 21, 2016 at 07:56:38AM +0100, Patrick Steinhardt wrote:
> 
> I'm using cryptsetup 1.7.2 via the kernel's crypto API. Since
> version v4.9-rc6, I'm unable to decrypt my LUKS partitions
> (aes-xts-plain64, sha512). cryptsetup simply aborts with the
> message "No such passphrase available" after inputting the
> passphrase.
> 
> After bisecting the issue, this points to commit a8348bc (crypto:
> algif_hash - Fix NULL hash crash with shash, 2016-11-17). After
> reverting this particular commit, everything works correctly
> again.

Sorry, I screwed up that patch.  Please try the following fix.
Thanks!

---8<---
crypto: algif_hash - Fix result clobbering in recvmsg

Recently an init call was added to hash_recvmsg so as to reset
the hash state in case a sendmsg call was never made.

Unfortunately this ended up clobbering the result if the previous
sendmsg was done with a MSG_MORE flag.  This patch fixes it by
excluding that case when we make the init call.

Fixes: a8348bca2944 ("algif_hash - Fix NULL hash crash with shash")
Reported-by: Patrick Steinhardt <ps@pks.im>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 05e21b4..d19b09c 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -214,7 +214,7 @@ static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);
 
-	if (!result) {
+	if (!result && !ctx->more) {
 		err = af_alg_wait_for_completion(
 				crypto_ahash_init(&ctx->req),
 				&ctx->completion);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
