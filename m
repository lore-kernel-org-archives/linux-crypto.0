Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FC138642C
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 08:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776672835; cv=none; b=kMyT8qczqQ0cIZaqp9eiZuiaF1NYPQuobx2HN5HdV8GvmDYnd/bMhAqqUjaD6DywCdJlbDS471AR9J7uiYdxIXIX0iPiXp/Mx/puX1BKCbId+QktxPL8fwPp4aNA8u5q+JYtEnEQ07PmziEYGUOMhVIkDZh9uwY1hH98aszA2dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776672835; c=relaxed/simple;
	bh=jPa38Pwh1hialukoJ6ddXdRz0lTye+eXTsF1ZqTUUAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjVNlU57IwFkwak3xpldZDYio3t60bpm0+zj02CNsVzk7vq93gBhNQOC1NLX90IuiYD34PpT5qtNS3P3N6jXrnYmI+QXsu2H0YkBvCllH5bh+1IC0/MTxUpa/gGM5fuurOWoWd/9S3HEhmCa2WxmFf/N7zLnw47cW83D2aGknW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XNbhJGcj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XNbhJGcj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=G00g6ZzfcoWB31bEk6pRRncuIqqzGcmNkdfnuyGew0I=; 
	b=XNbhJGcjYeJQZjYPUYc+CIoqrU5/sa7TevF7ak14NEK6A9/MfRywQMft9fkswo5aGhfZ0/1LNA/
	IeB4OsMQXb//5y74YGwKSVzXADwLV+2bj87GOKECBQDn6ce7yUnVuNE/CRcwATCzprEiiYhQ2xBkK
	k/GoOpFr7d7mKzODajy8YkmK5s+BpDfHl41HgtKn5C4I0pzbqJ4/D9Op0UisKeSw7vx7iqwQM3/Bz
	dpKoxjYJ9wQYbjP1zv2ncZOETV2/xbN8zXzWLB98kZlzrBDpxNFK733uv/jGGaK6oaD1uX+bBfCkg
	49wpLSk16JZVXemcPtJ0U41vkB3yo8C0tSPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wEjlE-007LMo-1i;
	Mon, 20 Apr 2026 16:13:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Apr 2026 16:13:40 +0800
Date: Mon, 20 Apr 2026 16:13:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dudu Lu <phx0fer@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] crypto: krb5enc - fix async decrypt skipping hash
 verification
Message-ID: <aeXgNAUkzhe1iieX@gondor.apana.org.au>
References: <20260420044027.56413-1-phx0fer@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420044027.56413-1-phx0fer@gmail.com>

On Mon, Apr 20, 2026 at 12:40:27PM +0800, Dudu Lu wrote:
> krb5enc_dispatch_decrypt() sets req->base.complete as the skcipher
> callback, which is the caller's own completion handler. When the
> skcipher completes asynchronously, this signals "done" to the caller
> without executing krb5enc_dispatch_decrypt_hash(), completely bypassing
> the integrity verification (hash check).
> 
> Compare with the encrypt path which correctly uses
> krb5enc_encrypt_done as an intermediate callback to chain into the
> hash computation on async completion.
> 
> Fix by adding krb5enc_decrypt_done as an intermediate callback that
> chains into krb5enc_dispatch_decrypt_hash() upon async skcipher
> completion, matching the encrypt path's callback pattern.
> 
> Also fix EBUSY/EINPROGRESS handling throughout: remove
> krb5enc_request_complete() which incorrectly swallowed EINPROGRESS
> notifications that must be passed up to callers waiting on backlogged
> requests, and add missing EBUSY checks in krb5enc_encrypt_ahash_done
> for the dispatch_encrypt return value.
> 
> Fixes: d1775a177f7f ("crypto: Add 'krb5enc' hash and cipher AEAD algorithm")
> Signed-off-by: Dudu Lu <phx0fer@gmail.com>
> ---
>  crypto/krb5enc.c | 42 ++++++++++++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 16 deletions(-)

Thanks.  Your patch looks good to me.

However, while applying it against mainline I got a conflict because
of the recent change to unset the MAY_SLEEP flag on the async completion
path.

That got me thinking and I found one more issue, if we try to do a
MAY_BACKLOG operation on the async completion path, then the user
will see two back-to-back EINPROGRESS notifications which is wrong.

As David still hasn't indicated his preference to whether MAY_BACKLOG
should be supported or not, I've taken the easy option and
simply disallowed MAY_BACKLOG on the async completion path.  In order
to support it, you need to add a flag to the request context so that
the second EINPROGRESS notification can be selectively filtered out.

So this is what I ended up applying:

commit b51261043f3b6863ed4b65ccad967d998cd302f5
Author: Dudu Lu <phx0fer@gmail.com>
Date:   Mon Apr 20 12:40:27 2026 +0800

    crypto: krb5enc - fix async decrypt skipping hash verification
    
    krb5enc_dispatch_decrypt() sets req->base.complete as the skcipher
    callback, which is the caller's own completion handler. When the
    skcipher completes asynchronously, this signals "done" to the caller
    without executing krb5enc_dispatch_decrypt_hash(), completely bypassing
    the integrity verification (hash check).
    
    Compare with the encrypt path which correctly uses
    krb5enc_encrypt_done as an intermediate callback to chain into the
    hash computation on async completion.
    
    Fix by adding krb5enc_decrypt_done as an intermediate callback that
    chains into krb5enc_dispatch_decrypt_hash() upon async skcipher
    completion, matching the encrypt path's callback pattern.
    
    Also fix EBUSY/EINPROGRESS handling throughout: remove
    krb5enc_request_complete() which incorrectly swallowed EINPROGRESS
    notifications that must be passed up to callers waiting on backlogged
    requests, and add missing EBUSY checks in krb5enc_encrypt_ahash_done
    for the dispatch_encrypt return value.
    
    Fixes: d1775a177f7f ("crypto: Add 'krb5enc' hash and cipher AEAD algorithm")
    Signed-off-by: Dudu Lu <phx0fer@gmail.com>
    
    Unset MAY_BACKLOG on the async completion path so the user won't
    see back-to-back EINPROGRESS notifications.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/krb5enc.c b/crypto/krb5enc.c
index 1bfe8370cf94..fefa8d2c7532 100644
--- a/crypto/krb5enc.c
+++ b/crypto/krb5enc.c
@@ -39,12 +39,6 @@ struct krb5enc_request_ctx {
 	char tail[];
 };
 
-static void krb5enc_request_complete(struct aead_request *req, int err)
-{
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
-}
-
 /**
  * crypto_krb5enc_extractkeys - Extract Ke and Ki keys from the key blob.
  * @keys: Where to put the key sizes and pointers
@@ -127,7 +121,7 @@ static void krb5enc_encrypt_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	krb5enc_request_complete(req, err);
+	aead_request_complete(req, err);
 }
 
 /*
@@ -188,14 +182,16 @@ static void krb5enc_encrypt_ahash_done(void *data, int err)
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 
 	if (err)
-		return krb5enc_request_complete(req, err);
+		goto out;
 
 	krb5enc_insert_checksum(req, ahreq->result);
 
-	err = krb5enc_dispatch_encrypt(req,
-				       aead_request_flags(req) & ~CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (err != -EINPROGRESS)
-		aead_request_complete(req, err);
+	err = krb5enc_dispatch_encrypt(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
 }
 
 /*
@@ -265,17 +261,16 @@ static void krb5enc_decrypt_hash_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	if (err)
-		return krb5enc_request_complete(req, err);
-
-	err = krb5enc_verify_hash(req);
-	krb5enc_request_complete(req, err);
+	if (!err)
+		err = krb5enc_verify_hash(req);
+	aead_request_complete(req, err);
 }
 
 /*
  * Dispatch the hashing of the plaintext after we've done the decryption.
  */
-static int krb5enc_dispatch_decrypt_hash(struct aead_request *req)
+static int krb5enc_dispatch_decrypt_hash(struct aead_request *req,
+					 unsigned int flags)
 {
 	struct crypto_aead *krb5enc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(krb5enc);
@@ -291,7 +286,7 @@ static int krb5enc_dispatch_decrypt_hash(struct aead_request *req)
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, req->dst, hash,
 				req->assoclen + req->cryptlen - authsize);
-	ahash_request_set_callback(ahreq, aead_request_flags(req),
+	ahash_request_set_callback(ahreq, flags,
 				   krb5enc_decrypt_hash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
@@ -301,6 +296,21 @@ static int krb5enc_dispatch_decrypt_hash(struct aead_request *req)
 	return krb5enc_verify_hash(req);
 }
 
+static void krb5enc_decrypt_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (err)
+		goto out;
+
+	err = krb5enc_dispatch_decrypt_hash(req, 0);
+	if (err == -EINPROGRESS)
+		return;
+
+out:
+	aead_request_complete(req, err);
+}
+
 /*
  * Dispatch the decryption of the ciphertext.
  */
@@ -324,7 +334,7 @@ static int krb5enc_dispatch_decrypt(struct aead_request *req)
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, aead_request_flags(req),
-				      req->base.complete, req->base.data);
+				      krb5enc_decrypt_done, req);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
 
@@ -339,7 +349,7 @@ static int krb5enc_decrypt(struct aead_request *req)
 	if (err < 0)
 		return err;
 
-	return krb5enc_dispatch_decrypt_hash(req);
+	return krb5enc_dispatch_decrypt_hash(req, aead_request_flags(req));
 }
 
 static int krb5enc_init_tfm(struct crypto_aead *tfm)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
