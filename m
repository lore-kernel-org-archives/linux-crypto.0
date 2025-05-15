Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAFD198E60
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747337564; cv=none; b=h6eKKJe6ef9HLCfLp49QuY4wlfajgBxsmXvzHMDrAZJfG2f2Q3pC1OKbgvFjiQbDdCcHnMFUJQ8jyH41LmKGwVK8msMJobVsWx5A5lsFt8I2INXwKPs8PjOpaoptZgY5eomXz8KYuCghybwnXyUEF7IfQ8c1sOz0ayxVfjhiDNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747337564; c=relaxed/simple;
	bh=y493A98NG+xu3exhxBGQR+07SYYFJR7uwUw15J/CYHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ANMF7ndka8rJpwv76LzTwDHJAA2YBHF4cUjbjY2OXtmfyNu0R2BQWDnfVUaksvhB6+eOoNJaPs3fnybn+OqwNNA7AUXyMeyS7a8jkwGd5J+vxOEzu+BPZvQfncrYRZp9cwxtCDjs+pvKYRRj/tpMIKXNjxXwkGXK09CIPsYbZgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AI1wF7N0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AI1wF7N0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E5AC4CEE7;
	Thu, 15 May 2025 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747337563;
	bh=y493A98NG+xu3exhxBGQR+07SYYFJR7uwUw15J/CYHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AI1wF7N0Lb7hw0Bd36hoH3uwihwTEBbfy/KtQ5t/binoTaSooGYtiEvp1iZ+/FRix
	 sdz2zZGL+2zirC76HslcHlaB9FwNqd7p1Uu0hvdjD7aaKRkxJRYcqqVykOegXHcK00
	 Q87NFrKlsJo4pZIUU+es9OneNB+4ct50XlTfN1+J5UhjLeFcu6owaOfBUFRZtbhJLf
	 zDUMKGXKut2JQQV/bhDvYSGTKu67R2UMG0xY/sBPMQ3ARYjCk8lwr6r2coZlsfI3eR
	 bbXOUO1QfTg8w6bXTKl5Wta7tz9sgbPaUW/qmiabQlPeVRhPukkoezLr97l3NO45jc
	 7by3uu8YacQPg==
Date: Thu, 15 May 2025 12:32:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 06/11] crypto: shash - Set reqsize in shash_alg
Message-ID: <20250515193241.GH1411@quark>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <fd7a42ad4da30a7f9020d1095554a4a4272f40d6.1747288315.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd7a42ad4da30a7f9020d1095554a4a4272f40d6.1747288315.git.herbert@gondor.apana.org.au>

On Thu, May 15, 2025 at 01:54:44PM +0800, Herbert Xu wrote:
> Make reqsize static for shash algorithms.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Commit message doesn't explain why the change is being made.

- Eric
