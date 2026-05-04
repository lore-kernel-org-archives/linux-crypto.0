Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF01A175A87;
	Mon,  4 May 2026 03:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777866030; cv=none; b=GQbpZT3WVYKYzeAdXXP32oknVZHPgsBHiPyV4wIrzUiOE0TfzIsnLdLY8gmaXYzMl0/bbc46aP5SfLFvkeawEEyO/bSHQd/adeZ9r3staAgp3jIbKvmaW8Jb5CmWJH50CaL3kchAgBe72ouy1AcDf3hqtRAVaVVkJouTn8R3xhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777866030; c=relaxed/simple;
	bh=L/5hYeq42nefPoLmdSTevU3TzEJu+VM/m5h4DsTIocU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XldVogpW2puqFdZhS4o9lmeA+vczN98bOIlyIG6CYrP5134DK4GAzBKGe3wk4BY3JF8JntA7ZrodnPTBYXAnnNL+KxgoxgwZcnZEaV9Tak1RvQOAg6v8H1K9UIrAGx+1rXLxia/WWu4uapMJ+ancFHPVrIrKi4SsYJMqERoJIOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TvhnYT/0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TvhnYT/0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=D7J5eN2Qkz3LgzL7cSDsCUuLaMs1LZ9q7TSbPaSdqsA=; 
	b=TvhnYT/0CfnQyVut5gPwpNVqNRMhR6G7iB2FdA8jzZxkEsQWQabFiPuVMzi2rHjpi3PR77FXcCx
	l21MJ0pP1n/GRFFJy+Uec4BClGgLMxk4z0syBQ+dMfQy0aKu5C7GX9vJXArxFCxTjtFxO8hmGMZg8
	CRa8BO35lvE4W79FiY/cQSgB8mVohyF1PQYrLaubGH0DXu6RqzLdt5oTL5vqzJjYlzhNNRfPHBEpT
	qnbmofQk5t/byg9SiAJG3NF0eKd5ik73TJql0mZX6kl2rPBipnGW5wTR23qLhU0/UDJLr+zEXv1ZV
	9R2Na+EEFJ7GSjFGsb6X5lYzxILLsbswLfCg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wJkAI-00AyPE-38;
	Mon, 04 May 2026 11:40:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 04 May 2026 11:40:14 +0800
Date: Mon, 4 May 2026 11:40:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wesley Atwell <atwellwea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: zstd - fix segmented acomp streaming paths
Message-ID: <afgVHnFH9WCNXKvO@gondor.apana.org.au>
References: <20260320215124.389938-1-atwellwea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320215124.389938-1-atwellwea@gmail.com>

On Fri, Mar 20, 2026 at 03:51:24PM -0600, Wesley Atwell wrote:
> The zstd acomp implementation does not correctly handle segmented
> source and destination walks.
> 
> The compression path advances the destination walk by the full
> segment length rather than the bytes actually produced, and it only
> calls zstd_end_stream() once even though the streaming API requires it
> to be called until it returns 0. With segmented destinations this can
> leave buffered output behind and misaccount the walk progress.
> 
> The decompression path has the same destination accounting issue, and
> it stops when the source walk is exhausted even if
> zstd_decompress_stream() has not yet reported that the frame is fully
> decoded and flushed. That can report success too early for segmented
> requests and incomplete frames.
> 
> Fix both streaming paths by advancing destination segments by actual
> output bytes, refilling destination segments as needed, draining
> zstd_end_stream() until completion, and continuing to flush buffered
> decompression output after the source walk is exhausted. Return
> -EINVAL if decompression cannot finish once the input has been fully
> consumed.
> 
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Assisted-by: Codex:GPT-5
> Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
> ---
> Changes in v2:
> - always finalize acomp walk mappings in the direct one-shot paths
> - add mapped src/dst cleanup on streaming error exits
> - reacquire a destination segment in decompression before resuming after a
>   full output-chunk completion
> 
> Local validation:
> - built bzImage with CONFIG_CRYPTO_SELFTESTS=y and
>   CONFIG_CRYPTO_SELFTESTS_FULL=y
> - exercised segmented zstd acomp requests using temporary local testmgr
>   scaffolding
> - booted under virtme and verified zstd-generic selftest passed in
>   /proc/crypto

Thanks for the patch.  But please redo this as a series of incremental
patches, each of which fixing a specific problem so that it is
more amenable to review.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
