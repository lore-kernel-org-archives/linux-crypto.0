Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB53183CC3
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 11:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747999482; cv=none; b=CV84HeuCK5nKmy4g1XgqPU3MclZ2JJi6DevO3013aCWOVlPud7MnMaMf/aqbdlQtXoXG1SjqJ2S5ry2AqMAUfjCxne1JtcDew6Gz8hej7P2ZXtz5Chb9nvK7C9W8CDMlqP1f5y8IYqsXb3OtuTSuvBS2D18M/zQ1OsfaeS4Kaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747999482; c=relaxed/simple;
	bh=9mMH0+qS2+FRf4v4tKTwA5fM8bgg5PmVeeqvziw4ioE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inZ1GWt01fCvKTEIHW6faeKq3GhCAPTXlazGAoFmroai88x19NLhHVvDBIoiIdEgqTnvr8X/Dx/Ay5u4xgBohpspNK0IuvrCWHuRGPebDe9/Uc3P7TMiE92JwY1mPwIont/0yyX2xdh3b+oQ22h88yVKVkZp5Ei5HtvHrmGjhTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EfF/iauz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EfF/iauz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qHzX0h8MOD5qxbKmfmtqC6qPyNtfJAkoA9NN73r0YCI=; b=EfF/iauzVRYNZ43foaEt54Lc/K
	HYKfcwnjqRLwlvd9+r+VZprAEashxfTRw4UQvMC1pR8d7ZOOP/6/ncX/b0bFYFDCv7jqzTGCcodoT
	VI6K644E3j9Lh4UajT2z6MzI/rwsLRF1Nfso/LXgnnCxmB2H17yvcfiG7x6WBmVYUDDkBGgR8+CCb
	ss+vicm/usP5UbK0hR6lq889ze8FtKrkpYlMHY+f2jbyMUmkKJGiWwOSgncPGeTdEW5ewDLZTf0d0
	6+jE/TEYlK6cYKRb5W3tz0GLgtYRxRDG+IUx00iRaGviZ8YyDiEuzRKvWCSLqYZ0lCdq69Oghdo1e
	bW9WQGdg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIQVu-008L2I-39;
	Fri, 23 May 2025 19:24:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 19:24:34 +0800
Date: Fri, 23 May 2025 19:24:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: [PATCH] crypto: s390/hmac - Fix counter in export state
Message-ID: <aDBa8tuSvw1mnnKL@gondor.apana.org.au>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDAM9LKOWSKBbIUn@gondor.apana.org.au>
 <152288d2-a034-4594-a5cc-d46faf34ac24@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152288d2-a034-4594-a5cc-d46faf34ac24@linux.ibm.com>

On Fri, May 23, 2025 at 10:02:18AM +0200, Ingo Franzki wrote:
> 
> Yes, indeed, reverting this commit makes the problem to go away. 

Great.  While I've got your attenttion, could you also test this
patch to see if it makes the hmac errors go away?

Thanks,

---8<---
The hmac export state needs to be one block-size bigger to account
for the ipad.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Fixes: 08811169ac01 ("crypto: s390/hmac - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index 93a1098d9f8d..58444da9b004 100644
--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -290,6 +290,7 @@ static int s390_hmac_export(struct shash_desc *desc, void *out)
 	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int bs = crypto_shash_blocksize(desc->tfm);
 	unsigned int ds = bs / 2;
+	u64 lo = ctx->buflen[0];
 	union {
 		u8 *u8;
 		u64 *u64;
@@ -301,9 +302,10 @@ static int s390_hmac_export(struct shash_desc *desc, void *out)
 	else
 		memcpy(p.u8, ctx->param, ds);
 	p.u8 += ds;
-	put_unaligned(ctx->buflen[0], p.u64++);
+	lo += bs;
+	put_unaligned(lo, p.u64++);
 	if (ds == SHA512_DIGEST_SIZE)
-		put_unaligned(ctx->buflen[1], p.u64);
+		put_unaligned(ctx->buflen[1] + (lo < bs), p.u64);
 	return err;
 }
 
@@ -316,14 +318,16 @@ static int s390_hmac_import(struct shash_desc *desc, const void *in)
 		const u8 *u8;
 		const u64 *u64;
 	} p = { .u8 = in };
+	u64 lo;
 	int err;
 
 	err = s390_hmac_sha2_init(desc);
 	memcpy(ctx->param, p.u8, ds);
 	p.u8 += ds;
-	ctx->buflen[0] = get_unaligned(p.u64++);
+	lo = get_unaligned(p.u64++);
+	ctx->buflen[0] = lo - bs;
 	if (ds == SHA512_DIGEST_SIZE)
-		ctx->buflen[1] = get_unaligned(p.u64);
+		ctx->buflen[1] = get_unaligned(p.u64) - (lo < bs);
 	if (ctx->buflen[0] | ctx->buflen[1])
 		ctx->gr0.ikp = 1;
 	return err;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
