Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF03B3880;
	Fri,  4 Sep 2026 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515622; cv=none; b=ZPnOKubQt5cWuGTDLgLxy2nfa4I/RsAqEy85Ue1weiCS9t9Au1bRfN0sd/GygqtKJD4mMPHq6kJLxsqmzaGbVMMhIrsjNclU17ugsI9flhqNfGUyxThrftNBJt9qPLA+loi4OjI5obaFynREJ5rQ++RbeRBkTN7vLtdt3j9oDnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515622; c=relaxed/simple;
	bh=p4S04UxSxgYl0ywD58ZtfvG/VjgaEbzxecsYPoSChM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGq9bPO77kuKjRPeUzBsUaFjXyiv2v1GgImfnD/2XKWRIxJNTivRMpNTlmtztr+Wd99PtedTpknIehPM1hGpoxq/ngDoo6mvxuKrQqPuB8wkrvteJsl1FTXM/be3UEH1SErIku3zNQ/AyP5MpC5/ymFElQlugcxwk4UIAs2+ELc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Xi5vAUtS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Xi5vAUtS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JJkuRkjxUYFLsiGPs68kkV7q5nQ0iBlCWJIq/a2K4UY=; 
	b=Xi5vAUtSZnbfBxf/cq3LSRiMtRjzYBk99ZV+lhnQWJ4poDxSwBGC3q1vZVIUo2crm+j7klIACyu
	TC7e4XRleJR7FimXbg6YZ18bkqNwsfMTy/aEE6i8OZbrfDB3tvtuPTxwmr7+5p1WOnCAsQN1ChvOv
	1JQ17U7LPzgCuCbJXQvxNUY+PS4DMcJ4SCIK8a/TC/jyGrfvsutTsPrkTmOj5cWTwyD/rlYd5kenP
	KUtbMOUBFrH0+qXAlN1fDXtpdFUA04s+mrfoUrZj/XRRvMoXP82twZxJyzS/l48AG2WgupKzqfRjE
	bmEWHwo4r+20KdHanisx811/REe47bTjOHBg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qc1-0000000An5t-0i5T;
	Fri, 04 Sep 2026 17:53:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:53:33 +1000
Date: Fri, 4 Sep 2026 19:53:33 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Huth <thuth@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v5 00/10] crypto: Provide a function for zeroizing
 crypto_aes_ctx
Message-ID: <apqVHUZYdHd_RiW1@gondor.apana.org.au>
References: <20260810093009.608090-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810093009.608090-1-thuth@redhat.com>

On Mon, Aug 10, 2026 at 11:29:55AM +0200, Thomas Huth wrote:
> Several crypto drivers need to zeroize their local crypto_aes_ctx
> structures after use to avoid leaking key material on the stack.
> Currently some call sites do this with their own memzero_explicit()
> call, which is error-prone since it is easy to miss a return path
> (what already happened in a driver). Some other call sites miss
> to clear crypto_aes_ctx completely.
> 
> To improve this situation, the first patch introduces an aes_zeroize_ctx()
> helper that can be used with __cleanup() to automatically zeroize the
> context when it goes out of scope. The following 6 patches add this
> __cleanup() to spots in the code where this has been forgotten so far.
> The final patches change some files to do the zeroization with
> the new __cleanup() way instead of calling memzero_explicit() manually.
> 
> v5:
> - Use aes_check_keylen() in the eip93 patch and in the 1st safexcel patch
> 
> v4:
> - Updated the function description in the first patch
> - Fixed "return err" bug in the "safexcel - Rework cleanup..." patch
> 
> v3:
> - Renamed aes_clear_ctx() to aes_zeroize_ctx()
> - Split up the safeexcel patch to rework safexcel_aead_setkey in a
>   separate patch
> - Removed goto in the padlock patch
> 
> v2:
> - Rebased onto cryptodev master branch, updated the "qat" patch accordingly
> 
> Thomas Huth (10):
>   crypto: Provide a wrapper function for zeroizing crypto_aes_ctx
>   crypto: aspeed - clear the crypto_aes_ctx when done
>   crypto: padlock-aes - clear the crypto_aes_ctx when done
>   crypto: sa2ul - clear the crypto_aes_ctx when done
>   crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
>   crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
>   crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
>   crypto: safexcel - Simplify the check for a valid AES key
>   crypto: safexcel - zeroize crypto_aes_ctx with
>     __cleanup(aes_zeroize_ctx)
>   crypto: eip93 - Simplify the check for a valid AES key
> 
>  arch/arm/crypto/aes-neonbs-glue.c             |  2 +-
>  arch/arm64/crypto/aes-neonbs-glue.c           |  2 +-
>  drivers/crypto/aspeed/aspeed-hace-crypto.c    |  3 +--
>  .../crypto/inside-secure/eip93/eip93-aead.c   |  3 +--
>  .../crypto/inside-secure/safexcel_cipher.c    | 16 +++++---------
>  drivers/crypto/inside-secure/safexcel_hash.c  |  3 +--
>  .../crypto/intel/qat/qat_common/qat_algs.c    |  3 +--
>  drivers/crypto/padlock-aes.c                  | 22 +++++++++----------
>  drivers/crypto/sa2ul.c                        |  2 +-
>  include/crypto/aes.h                          | 13 +++++++++++
>  10 files changed, 35 insertions(+), 34 deletions(-)
> 
> -- 
> 2.55.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
