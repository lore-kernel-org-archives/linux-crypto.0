Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057DD8C1E;
	Mon, 28 Apr 2025 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868873; cv=none; b=cmZQHQesfqIFUwC4XeieLULfxELs71vqz0WYihBfIINKupfxSEfBsxTIDhl8Kx6q3ci/MLMKY+GjcfRMrsAJ36UNarteoahhcf6JDH6Hd1NiIobmzChIvYidn7K3KHfXJJLPYxcZ42pd1gP690TDKpnVrD43Q5w6XYSf5KW07ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868873; c=relaxed/simple;
	bh=O/XhKiRRyl6IGflfhMQsm6qz0jvPQrFNNodz6FocBek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNdb1Um4m+zCXGQjWiE2i54w4cJRcb83M9LuB17jqbfK9GJpprZ2iZLF2C1/Www3p4tF1SvFbFdEgkvyi8N9rErTFAtUsuBoja9MYQD9CcHCsR+znf65d3A4Ndn3mlCulX/uzCg6hopBT0OENrd/URkR3ahrOTGVEGEYyo59bDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhB5gZ5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhB5gZ5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3237EC4CEE4;
	Mon, 28 Apr 2025 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745868872;
	bh=O/XhKiRRyl6IGflfhMQsm6qz0jvPQrFNNodz6FocBek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XhB5gZ5jpUtXOkQUxZ9HB55IbOy2S3tX+HspcrduA4GmoTsOBT2auIqcDLx03kRfd
	 7iF0evJUDCpFd/i94ISdPqS9Mj64Xxi9uHqcrtGGPUQE+edo2W9sLFWLK7qFecLU/U
	 5McoESeglGSxrcn0bYQuJ3V62XLl8qH64bQx5EQ5aRO8PAagGlrl71YwmP1xX3Zock
	 BIBQpoeNXKAy4QJLhhr6XxJReo9SpRRKLfa+4TncDFx2/o07UOLbM02Hn2yObuQ7NI
	 qeQ1QfWUdptNkswKbvqfMP8e1f6Op0j2e77qRintQwc871mCswxzAwvBX3OyT6XV++
	 er9HMLsinSuUQ==
Date: Mon, 28 Apr 2025 12:34:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-sgx@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use SHA-256 library API instead of crypto_shash
 API
Message-ID: <20250428193430.GB1606@sol.localdomain>
References: <20250428183838.799333-1-ebiggers@kernel.org>
 <ae48d190-03fd-4f4d-ab6f-969301e8b96e@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae48d190-03fd-4f4d-ab6f-969301e8b96e@intel.com>

On Mon, Apr 28, 2025 at 12:19:50PM -0700, Dave Hansen wrote:
> On 4/28/25 11:38, Eric Biggers wrote:
> > -static int sgx_get_key_hash(const void *modulus, void *hash)
> > -{
> > -	struct crypto_shash *tfm;
> > -	int ret;
> > -
> > -	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
> > -	if (IS_ERR(tfm))
> > -		return PTR_ERR(tfm);
> > -
> > -	ret = __sgx_get_key_hash(tfm, modulus, hash);
> > -
> > -	crypto_free_shash(tfm);
> > -	return ret;
> > -}
> 
> Let's just say, theoretically, that there was some future hardware that
> also supported SHA384.  There doesn't seem to be a SHA-384 library API.
> 
> Would you leave the crypto_shash() in place if that were to be
> happening? Theoretically of course.

Currently SHA-384 is only available via crypto_shash, but I'm planning to add a
library API for that too.  (Well, I actually want SHA-512, but it's
straightforward to support SHA-384 alongside that.)  It's up to you if you'd
then want to use crypto_shash vs. the library functions for both, but I'd lean
towards just using the library functions.

- Eric
