Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1CC1DE886
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 18:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740681228; cv=none; b=FoFpCf3SRDfJt1hvtqAoOvijoIbiWWfpP45Hxq4Y7OJOWqloDi9XAFGROPz4Rn3XlwNBKLJzf7wUnR0Uo5KVH7qbPrDeNaOwPdm/I6awi7YLP88BM7UKYdHlCGdPTl8jBW4MpT3fdtJgiveqC8OSstAgomrlU1sTVXuKN+ctQ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740681228; c=relaxed/simple;
	bh=aC3m1LSDHVrfSOBH0I/OhRkU4TX84vtl9CGdv3j+9vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fX0QomsrHYpujy5biEars6JYSuK3xNKesRFRFrCDMsbAPAQpo5pAoyJi7iTycZVhYl8qaqMBpsbwimzJoAfwBM7exxDnSLW602q7FPA0qv/PRP5WrbPBoZLVtCqMLt4I1jfIWVgR8bMwa4QEn4FL4V60mrPSqRJnmc/tM8IDDl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kw4cOzQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kw4cOzQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34DEC4CEDD;
	Thu, 27 Feb 2025 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740681228;
	bh=aC3m1LSDHVrfSOBH0I/OhRkU4TX84vtl9CGdv3j+9vQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kw4cOzQlRpeV9zSODW3BUkesE402bhPte/7wM4moaYwIj9YKXXE2jtophmaR/PPHX
	 25kdWlVcG/YUl/UwDr02UlpkFpt0Oq4QUsiCj9NX9dr+2ZAU646ibwflnkEI2XKcTn
	 P8jyjpLdiM5sFVSrVBg5HnCKyG0x+OgCXuieO4KmVhoEP9nxyHPwuSNofzvVfIPXQN
	 RVO7H/fYcg+YNb06p5P7nzhEXek0/eu7JkDM0QBdyN7Mua5kio/r0iZDcbL/pZsSlX
	 ET9aUY0gU/1zOFpBj4DiZS1rWg9VApQic1ZDTcJ1qx8QJ13xBlgeTpv70dLfuBARvm
	 pFrSC68vQ/NOA==
Date: Thu, 27 Feb 2025 10:33:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <20250227183346.GA1613@sol.localdomain>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <c4725c40e2c36e0f8954d3a3b20bb6099317f73b.1740651138.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4725c40e2c36e0f8954d3a3b20bb6099317f73b.1740651138.git.herbert@gondor.apana.org.au>

On Thu, Feb 27, 2025 at 06:15:00PM +0800, Herbert Xu wrote:
> This adds request chaining and virtual address support to the
> acomp interface.
> 
> It is identical to the ahash interface, except that a new flag
> CRYPTO_ACOMP_REQ_NONDMA has been added to indicate that the
> virtual addresses are not suitable for DMA.  This is because

As with ahash, the request chaining support is a huge mistake.  The problem is
much better solved by adding methods that explicitly take an array of data
buffers (i.e., batch_compress and batch_decompress in the case of compression).
"Request chaining" is unnecessarily complex and creates a lot of edge cases and
ambiguities.  E.g. it would make it ambiguous whether every function operates on
a single request or on the whole list of requests.  It also doesn't even work in
the expected way, as submitting a list of requests won't be equivalent to
submitting them individually.

And as usual for your submissions it's also undocumented and has no tests.

- Eric
