Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406B33A0E8E;
	Fri, 11 Sep 2026 05:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104454; cv=none; b=rVUmegoyiOy8zW9moogvJH5zYqr/wfCTo6yH8ZWTiz9JDrbnOjsFB0fO5SlCBBz+JaOcMeBYVcScwY8rQnZjwLSX226uo6E5ysMdIVLfnSrU12aIc9I5RmxV+7vrSjSty+JNkVko/v/3lgllJcl+xpbNy+uHPXtJMUG1XIzNb90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104454; c=relaxed/simple;
	bh=Dy4opR0CeGsyxt4DpWQpJaX3Zjw0cFdBtpfspe064dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rxnv+jwpVM+y246tPoZyLmIqwiVrAPb/h59ItTY6RFKWsDMZ+5QdqDg53AcG4YNh0FfddK7v0sbArD9UA/yvKHpKDiNRLn+jPIAeeD5O0mxaVixOvnSyq/sRD2SV+vheBdXPRK9IIWJwmiZUDhd9ZEIXcIRhoG8VvjpVjksG84I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cMQgv6ti; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cMQgv6ti"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yBbfFsSrgM9t52fCDZQYLlTDnOIYSbkM0146kLmwG9k=; 
	b=cMQgv6tik2dQBnfSkI97vriuleXjk9NjlqdPi7BzbUoo1pLwGYwoRN9+CEjZE5lApgAEF05uFv0
	bZopOZKA2RJn5VVcbf5CuPkgKQqJCsdgNIORiqKwK22BGhkprbCJXETMTOfazCJDlwqgCQS8ykYf7
	ObEpwJz150fyD45FFIpoyaLcmpes/ndJ0BY2iDnPhl0sx2MxGv3wMGfGDnLaDN2KPBJjRN5dbBtwl
	SZnfMb7IlMdp9rC/fDn7QcYtxT3wTEiMqdbaCAKar1Mc0mXojj3InN74ppFJrApK+0VUAhRQa94aP
	XuOqg8Tkx5sOGo11WSBjQjGQGOooFczHgC7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tnJ-0000000Cu6H-3lqT;
	Fri, 11 Sep 2026 13:27:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:27:25 +1000
Date: Fri, 11 Sep 2026 15:27:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: davem@davemloft.net, dsterba@suse.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, terrelln@fb.com, hannes@cmpxchg.org,
	yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 0/2] crypto: zstd - avoid initializing the workspace twice
Message-ID: <aqORPVwA_8lpNT8V@gondor.apana.org.au>
References: <20260825220616.3842633-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825220616.3842633-1-usama.arif@linux.dev>

On Tue, Aug 25, 2026 at 03:06:00PM -0700, Usama Arif wrote:
> Both zstd_compress() and zstd_decompress() set up the shared per-CPU
> workspace as a C/DStream before walking the request, and then, when the
> first source and destination fragments each span the whole request, hand
> off to zstd_compress_one()/zstd_decompress_one(), which immediately
> overwrite that same ctx->wksp with a CCtx/DCtx. The stream setup is
> discarded without a byte having been processed.
> 
> That one-shot path is not a corner case: zswap always takes it when
> storing, and takes it for a load whenever the stored object lies within a
> single zsmalloc page.
> 
> These two patches defer the stream initialization to the first walk
> iteration that actually streams, guarded by a flag because that iteration
> can be reached more than once.
> 
> A 4 KiB crypto_acomp benchmark [1], twelve runs of nine 30,000-operation
> rounds. Bare metal is an Intel Xeon Platinum 8321HC, turbo off,
> performance governor, pinned to one core; the VM is a one-vCPU KVM guest
> on a faster host.
> 
>                   baseline    patched     delta
>   bare metal
>     compress      52,283 ns   51,038 ns   1,245 ns   2.4%
>     decompress     2,317 ns    1,998 ns     319 ns  13.8%
>   one-vCPU KVM
>     compress      16,675 ns   15,050 ns   1,625 ns   9.8%
>     decompress     3,516 ns    2,265 ns   1,251 ns  35.6%
> 
> The guest numbers are larger because the two CPUID instructions in
> ZSTD_cpuid() become unconditional VM exits there. 
> 
> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
>  
> Usama Arif (2):
>   crypto: zstd - Avoid redundant cstream initialization
>   crypto: zstd - Avoid redundant dstream initialization
> 
>  crypto/zstd.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> 
> base-commit: 4b18edbd8e70f7e6860d56370f13244896d0f95c
> -- 
> 2.53.0-Meta

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
