Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5124F222594
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 01:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745716111; cv=none; b=kqAg2Wg7TiJqwHyVZtw0dFkL+/yrxjqH7/P4Bct5QUSTIdWYEEZACfqeA7bc14UP8dYUSRFF99ApL8EuGUVsjQBOI9HOuQ8xiiLZjpqnReBD/A34GqJKllL0TUFz+69bWU72uPaO8SFG5o0BtDeMRmd1ubezSRrGM7s4YtjvDqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745716111; c=relaxed/simple;
	bh=QmkD/5aO5rVsG+8P+u5+F6V6AIaM+Ylbm4EEcY5yDb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeRhVl6QHEpJyYjs6NZrs7G5YjLG5ZjJ/9z4NCytq9tuTTGHDMuqt7KhCjNHzAoTPcTYlOpa1Dqnngo3bxKex/2zdYwX5vTTOuyO49qffIbDOlHcrqIT9ZNYE6iQTfSlnWDsfxbnBvnYRKmxnf/o92a/eYMgnYGskFH4PuMHs7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGI0N65M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGI0N65M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D15C4CEE2;
	Sun, 27 Apr 2025 01:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745716110;
	bh=QmkD/5aO5rVsG+8P+u5+F6V6AIaM+Ylbm4EEcY5yDb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RGI0N65MtUySmUSw7iq4KkKOvdRsFw8aDPzvBPPJHX/CC6x2elq/ceCPh1efQUliH
	 bCLkENuvkc+mWh9dlZP2s5VS799CT7MXs6lCBHOFDCcsxW2Yr1a6e0QjcmBVnc4XoM
	 dUpBQEWNZt8gZU0NwnO/Rx4YktH+SmTcrQ9hl7Gt3mB/0+NsjFMujAQHoNvEiCp35n
	 oLdzuJBtD1WQQCxk96B/5Ky8gO7vETi67BLrVDoSKHa5keWmuVNL+29Jnvpswl2qwA
	 U6k6aYd087Fw6P6JR7GdskYF5WUBRoUHF04lBCioMn2xD2ya4qAAnH5M34IGwWYEpF
	 5ECpJzO7nU1eg==
Date: Sat, 26 Apr 2025 18:08:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/2] crypto: scatterwalk - Move skcipher walk and use it
 for memcpy_sglist
Message-ID: <20250427010834.GB68006@quark>
References: <cover.1745714222.git.herbert@gondor.apana.org.au>
 <8a564443ba01b29418291a4e3045e2546cd9e3a8.1745714222.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a564443ba01b29418291a4e3045e2546cd9e3a8.1745714222.git.herbert@gondor.apana.org.au>

On Sun, Apr 27, 2025 at 08:42:54AM +0800, Herbert Xu wrote:
> Move the generic part of skcipher walk into scatterwalk, and use
> it to implement memcpy_sglist.
> 
> This makes memcpy_sglist do the right thing when two distinct SG
> lists contain identical subsets (e.g., the AD part of AEAD).
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I think it would end up faster and simpler to just implement the copy from first
principles instead of trying to share the code with skcipher_walk.  There is way
too much stuff that skcipher_walk has to handle that isn't relevant for a simple
copy.

- Eric
