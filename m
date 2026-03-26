Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EE23603F8;
	Thu, 26 Mar 2026 09:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516424; cv=none; b=ap6EbY7RgUFDc6BN9ZHcz0qjYFUyWdlN3HiLbB/S8lTppe5FRVGa1031ZhAOPef4rRnsQG3370RPHuT3bWetbpFQFAfWyti5IuWQ6LphH3ujMPR12gB8YHdA9Gqf2wZScIAliU1OWIElvN7RWE1sWQ46/isV1RE7FpTFSQh1wvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516424; c=relaxed/simple;
	bh=TkjcpSbGaKVmBl031mSS6ieanqz+GuZBMOqtcqFwr+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+Od382TsmFW+DZhM8M154trNELdBcTvU8+D8ZTNFWXkZ196UHwfEnl9ehn3yGv3kIPDfMCMv8oje97KksN1p0cnSUXRWx1RhZMy7DEdJGlpbJ4DBkdsktFThujna1QNV7IkodZ+IgJj3DHVcI7UOM5HfUa7NwibGlr9a6avJHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ckVuESrW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ckVuESrW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=XKaq7aORbC/ZEtWldVF64pO4QPNHEjZ4d3bJU/Rxw3k=; 
	b=ckVuESrWWHWhkoaItMn7Ll2wA5crY4z3t8vkibiMm8UeDJgpuhiAi8eQZrcQrwnYYdfgAF8uOzP
	z/63JuaTgzWm85q6LMIM9DJ6CSaUN2jFeS6FIYbdzPFRB08q17HKIDXCna08eo1lCQe8aPzktUh57
	2N4eyYW7NYOMXkQo2dG4sMllC3ddAI1BrbR6FuJ2KnQc/SH+E/Lcyokkf3vI6tn0IKfbVDExMxI3l
	3eehXVi2+CzLfiOcSe17Hc+oywoC6hoTS4VBq6e7crHppYVmsbXH7N2PZHGxHAOs8KGIUVLgI4pHC
	UYjYj8ZEAafT7NBRABFN4zIcmEuRFNFesALQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5gN6-001Fqb-1M;
	Thu, 26 Mar 2026 17:13:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 18:13:39 +0900
Date: Thu, 26 Mar 2026 18:13:39 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] crypto-deflate: fix spurious -ENOSPC
Message-ID: <acT4w_1OifZthFYs@gondor.apana.org.au>
References: <f6a1465f-c4f1-6847-9e3c-d7225bad4059@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6a1465f-c4f1-6847-9e3c-d7225bad4059@redhat.com>

On Wed, Mar 25, 2026 at 04:31:38PM +0100, Mikulas Patocka wrote:
> Hi Herbert
> 
> I am developing a new device mapper target that compresses data and I 
> found a bug in crypto/deflate.c that it sometimes returns -ENOSPC even if 
> the decompressed data fits into the destination buffer. I'm submitting 
> this patch to fix it.
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The code in deflate_decompress_one may erroneously return -ENOSPC even if
> it didn't run out of output space. The error happens under this
> condition:
> 
> - Suppose that there are two input pages, the compressed data fits into
>   the first page and the zlib checksum is placed in the second page.
> 
> - The code iterates over the first page, decompresses the data and fully
>   fills the destination buffer, zlib_inflate returns Z_OK becuse zlib
>   hasn't seen the checksum yet.
> 
> - The outer do-while loop is iterated again, acomp_walk_next_src sets the
>   input parameters to the second page containing the checksum.
> 
> - We go into the inner do-while loop, execute "dcur =
>   acomp_walk_next_dst(&walk);". "dcur" is zero, so we break out of the
>   loop and return -ENOSPC, despite the fact that the decompressed data
>   fit into the destination buffer.
> 
> In order to fix this bug, this commit changes the logic when to report
> the -ENOSPC error. We report the error if the destination buffer is empty
> *and* if zlib_inflate didn't make any progress consuming the input
> buffer. If zlib_inflate consumes the trailing checksum, we see that it
> made progress and we will not return -ENOSPC.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  crypto/deflate.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
