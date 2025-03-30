Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F83111A8;
	Sun, 30 Mar 2025 02:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743302018; cv=none; b=n6sv9ib/g3DVE7W7Er0cDj8vO//qB4mZju76fAaCBMaw7mHUJEaFLWaNqkpj6mRfQ4KydKVQBgt6yBcPwdMwg02NQ6y+uLavxr8zZzVdOQg1vXZl+yBYtEaf01vjggerdIEo6c5CS4eLpOlH3wNurxBPjn/G+y/QrKscv9Kg2pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743302018; c=relaxed/simple;
	bh=OG8Yi0SRKxYev1nne9MYL4tm0CrSp5Oyh/QSP/vQLMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6bQe3Dijw4r20eI+LrUV4ukObOaoA5By7B4NXQ79BO8IbegF/DObhKV3Ybs5kpvdAWSWyJqVZtuB7YiFrgJEc9hhQ15jPT83q6d4EqGgCcDKjpvOE7vLM+A3VjMumfZlOF/oOhYQRt9MhNM9pxwQhYVrPxQDR8luLzBmPYfick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kzqVuQf5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kzqVuQf5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HiZuM37wp6Xjo8xbzUiIRld2m8B+pGa49B34abe81/8=; b=kzqVuQf56hvvvPjS4jHY57JoA+
	lMcbU91Dd2xnKqIRjmPIbGylJCzawK3omiPaBmTZV336wGWYc5Wwq6FEARmIG4rRlkPkFJD6pQsmS
	leo5BnaChb2Sxuew6R7xQ2NPDI/0h1UWbh2dkXU+DjMfQnTM0d/ocdFR70lnGYFVyuRHwbzxOG2DW
	+jhVTgdeQoQUxsd25F+UY2/O11uq9I1PGXh6rIoT+nt/GoRngWYfi4+DxNJ81w0j36y5ZKZyOsgv2
	TVH1RnOGfTwcX4gjT8koOEd6s9X16M8YsaujHfgizoBg3Yf1AjWntIb4uIF+sOP2AhdR9x26E8T9O
	DR2aICRw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tyiUF-00BHnJ-1z;
	Sun, 30 Mar 2025 10:33:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 30 Mar 2025 10:33:23 +0800
Date: Sun, 30 Mar 2025 10:33:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Chaining is dead
Message-ID: <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
References: <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-N55Yjve6wTnPqm@gondor.apana.org.au>

On Wed, Mar 26, 2025 at 11:52:05AM +0800, Herbert Xu wrote:
>
> they don't need it.  Take ext4 as an example:
> 
> 	ext4 calls verity
> 	schedule_work(verity_work);
> 	return asynchronously!
> 
> verity_work:
> 	do the crypto work
> 	__read_end_io(bio);

I went ahead and removed the work queue for fsverity and fscrypt
(except for the reading of the Merkle tree which is still done in
a work queue because I'm too lazy to make that async), and it
actually turned out to be slower than using a work queue.

I was testing with an encrypted 8GB file over ext4 mounted over a
loopback device in tmpfs.  The encryption is with xts-vaes.  It turns
out that not using a work queue actually made reading the entire file
go from 2.4s to 2.5s.

I then tried passing the whole bio (256KB per crypto request in my
test as opposed to the data unit size of 4KB per crypto request)
through using chaining to skcipher, with xts-vaes doing the requests
one-by-one.  Against my expectations, this didn't speed things up at
all (but at least it didn't slow things down either).  All the
benefits of aggregating the data were offset by the extra setup cost
of creating the chained requests.

So chaining is clearly not the way to go because it involves cutting
up into data units at the start of the process, rather than the end.

Finally I hacked up a patch (this goes on top of the skcipher branch
in cryptodev) to pass the whole bio through the Crypto API all the
way to xts-vaes which then unbundled it.  This turned out to be a
winner, taking the read time for 8GB from 2.4s down to 2.1s.

In view of this result, I'm going to throw away chaining, and instead
work on an interface that can take a whole bio (or folio), then cut
it up into the specified data unit size before processing.

The bottom-end of the interface should be able to feed two (or whatever
number you fancy) data units to the actual algorithm.

This should work just as well for compression, since their batching
input is simply a order-N folio.  The compression output is a bit
harder because the data unit size is not constant, but I think I
have a way of making it work by adding a bit to the scatterlist data
structure to indicate the end of each data unit.

PS For fsverity a 256KB bio size equates to 64 units of hash input.
My strategy is to allocate the whole thing if we can (2KB or 4KB
depending on your digest size), and if that fails, fall back to
a stack buffer of 512 bytes (or whatever number that keeps the
compiler quiet regarding stack usage).  Even if we're on the stack,
it should still give more than enough to data to satiate your
multibuffer hash code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 4f721760ebf1..57d149c223bd 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -17,6 +17,7 @@
  * Copyright 2024 Google LLC
  */
 
+#include <linux/bio.h>
 #include <linux/hardirq.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -480,7 +481,7 @@ xts_crypt_slowpath(struct skcipher_request *req, xts_crypt_func crypt_func)
 
 /* __always_inline to avoid indirect call in fastpath */
 static __always_inline int
-xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
+xts_crypt_one(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
 	  xts_crypt_func crypt_func)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -511,6 +512,42 @@ xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
 	return xts_crypt_slowpath(req, crypt_func);
 }
 
+static __always_inline int
+xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
+	  xts_crypt_func crypt_func)
+{
+	unsigned int du_bits = req->cryptlen;
+	unsigned int du_size = 1U << du_bits;
+	__le64 *iv = (void *)req->iv;
+	struct folio_iter fi;
+	struct bio *bio;
+	int err;
+
+	if (!(req->base.flags & CRYPTO_SKCIPHER_REQ_BIO))
+		return xts_crypt_one(req, encrypt_iv, crypt_func);
+
+	bio = (void *)req->src;
+
+	for (bio_first_folio(&fi, bio, 0); fi.folio; bio_next_folio(&fi, bio)) {
+		size_t i = fi.offset;
+
+		for (; i < fi.offset + fi.length; i += du_size) {
+			skcipher_request_set_folio(req, fi.folio, i, fi.folio, i, du_size, iv);
+			err = xts_crypt_one(req, encrypt_iv, crypt_func);
+			if (err)
+				goto out;
+
+			*iv = cpu_to_le64(le64_to_cpu(*iv) + 1);
+		}
+	}
+
+out:
+	req->src = (void *)bio;
+	req->dst = (void *)bio;
+	req->cryptlen = du_bits;
+	return err;
+}
+
 static void aesni_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 				 u8 iv[AES_BLOCK_SIZE])
 {
diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 0ad8c30b8fa5..9f52dc7f7889 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2015, Motorola Mobility
  */
 
+#include <crypto/skcipher.h>
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/bio.h>
@@ -30,16 +31,49 @@
  */
 bool fscrypt_decrypt_bio(struct bio *bio)
 {
+	struct folio *folio = bio_first_folio_all(bio);
+	const struct inode *inode = folio->mapping->host;
+	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
+	const unsigned int du_bits = ci->ci_data_unit_bits;
+	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	SKCIPHER_REQUEST_ON_STACK(req, tfm, sizeof(bio));
+	struct bio **ctx = skcipher_request_extra(req);
+	DECLARE_CRYPTO_WAIT(wait);
 	struct folio_iter fi;
+	union fscrypt_iv iv;
+	u64 index;
+	int err;
 
-	bio_for_each_folio_all(fi, bio) {
-		int err = fscrypt_decrypt_pagecache_blocks(fi.folio, fi.length,
-							   fi.offset);
+	*ctx = bio;
 
-		if (err) {
-			bio->bi_status = errno_to_blk_status(err);
-			return false;
-		}
+	bio_first_folio(&fi, bio, 0);
+	if (!fi.folio)
+		return true;
+
+	index = fi.offset;
+	index = ((u64)fi.folio->index << (PAGE_SHIFT - du_bits)) +
+		(index >> du_bits);
+	fscrypt_generate_iv(&iv, index, ci);
+
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+					   CRYPTO_SKCIPHER_REQ_BIO,
+				      NULL, NULL);
+	skcipher_request_set_crypt(req, (struct scatterlist *)bio,
+				   (struct scatterlist *)bio, du_bits, &iv);
+
+	err = crypto_skcipher_decrypt(req);
+	if (err == -EAGAIN) {
+		req = SKCIPHER_REQUEST_CLONE(req, GFP_ATOMIC);
+		skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+						   CRYPTO_SKCIPHER_REQ_BIO,
+					      crypto_req_done, &wait);
+		err = crypto_skcipher_decrypt(req);
+	}
+	err = crypto_wait_req(err, &wait);
+	skcipher_request_free(req);
+	if (err) {
+		bio->bi_status = errno_to_blk_status(err);
+		return false;
 	}
 	return true;
 }
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index e159ea68124e..931585f864d1 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -26,6 +26,8 @@
 #define CRYPTO_SKCIPHER_REQ_CONT	0x00000001
 /* Set this bit if the skcipher operation is not final. */
 #define CRYPTO_SKCIPHER_REQ_NOTFINAL	0x00000002
+/* Set this bit if the skcipher is made of bio. */
+#define CRYPTO_SKCIPHER_REQ_BIO		0x00000004
 
 /**
  *	struct skcipher_request - Symmetric key cipher request
