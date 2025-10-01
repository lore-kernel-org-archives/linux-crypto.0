Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09521579F;
	Wed,  1 Oct 2025 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335868; cv=none; b=nf5zN+bItdb57T4ekAD2lRozcbkdR8sEbK99OFmXGDHpMBG5s018HMMlsbVz6y2UakHvICfIm6hjJin2XD5Y0KGd4cDTQamVBX19hwbgTetxFBjedXoqu+gA+tgiP3x9vz5uBYr8aco0BOPkaBNeyUyJbCDx/FYxQsVAeZZMRZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335868; c=relaxed/simple;
	bh=01AGB1gdjYvOKf0TM/UPBA1tCLQ+5X4VqqcP/0Bwqw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFEjxiFLSjawreA1+qRn4GZoPJ168JJ2x3rboSm909P0BzR1Kj/OsZisap1C5kvvb6CXh138oa+gkp4Tu/TSUAPUDb5PGtRkztnuPKnqOwhtUmm6xMd2dCySWOhQkuczIjOyIm47Hl+nCBsVonfE86GfFUjfniZcib0GBTnSyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZL/3jqA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZL/3jqA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A004DC4CEF5;
	Wed,  1 Oct 2025 16:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759335868;
	bh=01AGB1gdjYvOKf0TM/UPBA1tCLQ+5X4VqqcP/0Bwqw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZL/3jqA2aka2NqH6Al6isbHvtsnXOZebLu5d8qM8TlwC3ikLyeh7111BkaVlk628A
	 bSm3KRucyThqtk3VGqnBxFrQ21ZSvqWUHl+xyczKdXMJxZBTs4zarSAr8at2+SQ5t+
	 f/RCqcYbpVyQtqGGyx17D7582WQ2wwc+3n4VgFSvs5SdgTG58HPd7OUqYBeqPCWLpK
	 eUIRZWQ0/aFD9H0EUS5oL7m0L7U6retsnfr56hHam3lI3kZzG1RexJHhCyb/yp/Evv
	 y3ZfJLOT2nMhShedooEm2ntvSUKqjS2tO/gw8AJX9tkUcZATE+sCYyQ+hbgxYLojJ5
	 tSH7b/U64cHdw==
Date: Wed, 1 Oct 2025 09:23:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Michael van der Westhuizen <rmikey@meta.com>,
	Tobias Fleig <tfleig@meta.com>
Subject: Re: [PATCH] stable: crypto: sha256 - fix crash at kexec
Message-ID: <20251001162305.GE1592@sol>
References: <20251001-stable_crash-v1-1-3071c0bd795e@debian.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001-stable_crash-v1-1-3071c0bd795e@debian.org>

On Wed, Oct 01, 2025 at 09:07:07AM -0700, Breno Leitao wrote:
> Loading a large (~2.1G) files with kexec crashes the host with when
> running:
> 
>   # kexec --load kernel --initrd initrd_with_2G_or_more
> 
>   UBSAN: signed-integer-overflow in ./include/crypto/sha256_base.h:64:19
>   34152083 * 64 cannot be represented in type 'int'
>   ...
>   BUG: unable to handle page fault for address: ff9fffff83b624c0
>   sha256_update (lib/crypto/sha256.c:137)
>   crypto_sha256_update (crypto/sha256_generic.c:40)
>   kexec_calculate_store_digests (kernel/kexec_file.c:769)
>   __se_sys_kexec_file_load (kernel/kexec_file.c:397 kernel/kexec_file.c:332)
>   ...
> 
> (Line numbers based on commit da274362a7bd9 ("Linux 6.12.49")
> 
> This is not happening upstream (v6.16+), given that `block` type was
> upgraded from "int" to "size_t" in commit 74a43a2cf5e8 ("crypto:
> lib/sha256 - Move partial block handling out")
> 
> Upgrade the block type similar to the commit above, avoiding hitting the
> overflow.
> 
> This patch is only suitable for the stable tree, and before 6.16, which
> got commit 74a43a2cf5e8 ("crypto: lib/sha256 - Move partial block
> handling out")
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Fixes: 11b8d5ef9138 ("crypto: sha256 - implement base layer for SHA-256") # not after v6.16
> Reported-by: Michael van der Westhuizen <rmikey@meta.com>
> Reported-by: Tobias Fleig <tfleig@meta.com>
> ---
>  include/crypto/sha256_base.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
> index e0418818d63c8..fa63af10102b2 100644
> --- a/include/crypto/sha256_base.h
> +++ b/include/crypto/sha256_base.h
> @@ -44,7 +44,7 @@ static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
>  	sctx->count += len;
>  
>  	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
> -		int blocks;
> +		size_t blocks;
>  
>  		if (partial) {
>  			int p = SHA256_BLOCK_SIZE - partial;
> 
> ---

This looks fine, but technically 'unsigned int' would be more
appropriate here, given the context.  If we look at the whole function
in 6.12, we can see that it took an 'unsigned int' length:

 static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
 					    const u8 *data,
 					    unsigned int len,
 					    sha256_block_fn *block_fn)
 {
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
 
 	sctx->count += len;
 
 	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
-		int blocks;
+		size_t blocks;
 
 		if (partial) {
 			int p = SHA256_BLOCK_SIZE - partial;
 
 			memcpy(sctx->buf + partial, data, p);
 			data += p;
 			len -= p;
 
 			block_fn(sctx, sctx->buf, 1);
 		}
 
 		blocks = len / SHA256_BLOCK_SIZE;
 		len %= SHA256_BLOCK_SIZE;
 
 		if (blocks) {
 			block_fn(sctx, data, blocks);
 			data += blocks * SHA256_BLOCK_SIZE;
 		}
 		partial = 0;
 	}
 	if (len)
 		memcpy(sctx->buf + partial, data, len);
 
 	return 0;
 }

This also suggests that files with lengths greater than UINT_MAX are
still broken.  Is that okay?

Anyway, I'm glad that I fixed all these functions to use size_t lengths
in newer kernels...

- Eric
