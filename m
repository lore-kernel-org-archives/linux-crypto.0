Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7792EDF
	for <linux-crypto@vger.kernel.org>; Sat, 24 Feb 2024 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708735945; cv=none; b=UIT3EjIVG5HmvKgfKqDEhzUAvjeNDmeOCZMC2puckUIe5z35GzHTELQ9vYmPUupmQraJod5sxlvCTEwaWivtM/LGzEnNsKFC92N/NPR/LJE6nm/SMmRk2bq4HQcUzb4Kp3ShCZAq/PnEzqkfrp5azN5kcZbb2XioUKhfOHa4fmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708735945; c=relaxed/simple;
	bh=8vhDjJ5NkpLiLsGAVlE3HsvYDjCj/cQOQxZHvhXzKak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZBAvfPX0bM7n9DwFuDoyaRRUJyPaRAT8DEc9rXZqRUrsQLIR4/3DVUeOBwp08y8zzbLs+bkn+BaWaa1Y3bUPvs+NA/Bnpuk0usvUqbbICnTTm1RosxsIfH9KXjQVsho9rUTdTapZVy4+paDLLxgAEaStdW/LXac57KyUhBq5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rdgH5-00HE05-Pr; Sat, 24 Feb 2024 08:52:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Feb 2024 08:52:34 +0800
Date: Sat, 24 Feb 2024 08:52:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2] crypto: arm64/neonbs - fix out-of-bounds access on
 short input
Message-ID: <Zdk90hKLkPcb2NcD@gondor.apana.org.au>
References: <20240223132035.3174952-1-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223132035.3174952-1-ardb+git@google.com>

On Fri, Feb 23, 2024 at 02:20:35PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The bit-sliced implementation of AES-CTR operates on blocks of 128
> bytes, and will fall back to the plain NEON version for tail blocks or
> inputs that are shorter than 128 bytes to begin with.
> 
> It will call straight into the plain NEON asm helper, which performs all
> memory accesses in granules of 16 bytes (the size of a NEON register).
> For this reason, the associated plain NEON glue code will copy inputs
> shorter than 16 bytes into a temporary buffer, given that this is a rare
> occurrence and it is not worth the effort to work around this in the asm
> code.
> 
> The fallback from the bit-sliced NEON version fails to take this into
> account, potentially resulting in out-of-bounds accesses. So clone the
> same workaround, and use a temp buffer for short in/outputs.
> 
> Fixes: fc074e130051 ("crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk")
> Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-neonbs-glue.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
