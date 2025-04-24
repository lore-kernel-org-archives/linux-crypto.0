Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B77B19D892
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745509009; cv=none; b=BDvTMYbAkj3vhAG8ozt5LbnhMrfCGRDjxSmL9v/UIzPH7wfkYVn0KSBAkdmAJgWPKtrFaYEg/MhffZYF4k2vf76TiUM7QltR+vETu6TknfoAddJ81fkQmQ/BeVu3HqFPrbe/hmPo/boK28cnAPgPBw5sDY8O5CIGayLrquyAoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745509009; c=relaxed/simple;
	bh=gNfm1yJONZofOLudEv2H1uK98TJvf1UWHNBOBk5NheQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=De5YIN3vXQwHPdO4asJOqNj9FehyjcCOWBOxWEdeg9D1Dwx295365RDHaVTfP5DcsoOZ5JFj1fvR2xwzD/E5jq2LSRifbyhuObrzHIpREP+YJBVEHK5S3rWk8repp7MTNrlQqPrWW3v7T7PrD+jG5kAZeQ9xLg/7RsX4VgKXf8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4fdVXzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4fdVXzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75C9C4CEE3;
	Thu, 24 Apr 2025 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745509008;
	bh=gNfm1yJONZofOLudEv2H1uK98TJvf1UWHNBOBk5NheQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T4fdVXzXOIPUMtDts8AFNfSSTugxxvenNIHke1ujq7Bg0ye7Pw9RFVoH+ZpaSLQNc
	 jD65nO+vED8tCkbbhx+TLoJfIOJWOUrkVBD76vIF9FQ0p9IFTm0hqXuQ3vlYWdj+oJ
	 4lKsEhCtrQ2KtHSO5CjKXcYJ60IzY8cvGzYDFw1mN8x7DT4de+nNCZO4ArIJJ4UKyk
	 uEEat0MTQwgDOKUt/cqywqJlbzuuLrcsf/xS0nf3jN9y2T9f83pIDUlq0Gco1e3E7c
	 7O+yS792jj6UpLeyd1gGyZOVMBOoyw9lSoHXPF1nnlI1Ojm0zPk0p4LTBe+Nok0QmL
	 LBLz6kcU8lhxg==
Date: Thu, 24 Apr 2025 08:36:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 08/15] crypto: poly1305 - Use API partial block handling
Message-ID: <20250424153647.GA2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <20c70ad952dc0893294f490a1e31c9cfe90812a9.1745490652.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20c70ad952dc0893294f490a1e31c9cfe90812a9.1745490652.git.herbert@gondor.apana.org.au>

On Thu, Apr 24, 2025 at 06:47:14PM +0800, Herbert Xu wrote:
> Also add a setkey function that may be used instead of setting
> the key through the first two blocks.

So now users randomly need to "clone" the tfm for each request.  Which is easy
to forget to do (causing key reuse), and also requires a memory allocation.

Well, good thing most of the users are just using the Poly1305 library instead
of the broken Crypto API mess.

- Eric
