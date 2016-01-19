From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ixp4xx: avoid uninitialized variable use
Date: Tue, 19 Jan 2016 09:00:21 +0800
Message-ID: <20160119010021.GB5571@gondor.apana.org.au>
References: <4569235.PkyVAB6DSj@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39944 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbcASBA0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 20:00:26 -0500
Content-Disposition: inline
In-Reply-To: <4569235.PkyVAB6DSj@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 18, 2016 at 04:40:15PM +0100, Arnd Bergmann wrote:
> The move to the new AEAD interface introduced a path through the
> aead_perform() function in the ixp4xx_crypto driver that leaves
> lastlen uninitialized, as gcc warns:
> 
> crypto/ixp4xx_crypto.c:1072:5: error: 'lastlen' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> crypto/ixp4xx_crypto.c: In function 'aead_perform':
>   if (unlikely(lastlen < authsize)) {
> 
> I don't really understand what the code does, but the warning
> appears to be correct, and this is my best guess at how it
> should behave instead: I'm introducing a temporary variable
> that indicates whether we need to allocate an extra buffer
> or not, and defaults that variable to 'false', so we only
> allocate the buffer if one of the cases happen where we know
> that "lastlen < authsize".
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: d7295a8dc965 ("crypto: ixp4xx - Convert to new AEAD interface")
> ---
> 
> Hi Herbert,
> 
> It was one of your patches that introduced the warning, so you may
> be able to come up with a better fix than I did. Please see this as
> a bug report. I have applied it in my ARM randconfig test tree to shut
> up the warning for now.

How about this?

---8<---
Subject: crypto: ixp4xx - Fix false lastlen uninitialised warning

This patch fixes a false positive uninitialised variable warning
in aead_perform by moving the source processing in front of the
destination processing, thus ensuring that the initialisation of
lastlen is always visible to gcc.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index e52496a..2296934 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1031,6 +1031,18 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	BUG_ON(ivsize && !req->iv);
 	memcpy(crypt->iv, req->iv, ivsize);
 
+	buf = chainup_buffers(dev, req->src, crypt->auth_len,
+			      &src_hook, flags, src_direction);
+	req_ctx->src = src_hook.next;
+	crypt->src_buf = src_hook.phys_next;
+	if (!buf)
+		goto free_buf_src;
+
+	lastlen = buf->buf_len;
+	if (lastlen >= authsize)
+		crypt->icv_rev_aes = buf->phys_addr +
+				     buf->buf_len - authsize;
+
 	req_ctx->dst = NULL;
 
 	if (req->src != req->dst) {
@@ -1055,20 +1067,6 @@ static int aead_perform(struct aead_request *req, int encrypt,
 		}
 	}
 
-	buf = chainup_buffers(dev, req->src, crypt->auth_len,
-			      &src_hook, flags, src_direction);
-	req_ctx->src = src_hook.next;
-	crypt->src_buf = src_hook.phys_next;
-	if (!buf)
-		goto free_buf_src;
-
-	if (!encrypt || !req_ctx->dst) {
-		lastlen = buf->buf_len;
-		if (lastlen >= authsize)
-			crypt->icv_rev_aes = buf->phys_addr +
-					     buf->buf_len - authsize;
-	}
-
 	if (unlikely(lastlen < authsize)) {
 		/* The 12 hmac bytes are scattered,
 		 * we need to copy them into a safe buffer */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
