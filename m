Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4CE253350
	for <linux-crypto@vger.kernel.org>; Fri, 16 May 2025 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415211; cv=none; b=sVkkEvvtKevFl17CLBCdHSBb4fZCBRmOW/OBJKL9MnwWNx5hC6QGsOEvg6cmB37FwwKAiq2I0KCQFMZuNjKq1fc886RxSO4aOIAdSMCe7slZ83h/YAnM+uBO7e3piu3Uug51sGOJ9kgg0XPFcmTbQyuBrdtB0JUDPiB5xqW4DgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415211; c=relaxed/simple;
	bh=R7QIYpQH+jgbnPECgS7oVfLM2H5KMg6kfNW7qC9q0bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RyEx1+zRtXgP05zapAhsURNfl+OssQuTwDbQJlFfqXPuE9OcA0SSYA/emqAZ9QF/tZnWNUtWGPE1D9VtpJ+yKFzc0NQv1mCBx3l4GAQWtV0IsBVjQhFpp3mg5DaRmct8+LrDjNEQPPVs63Z9FBpTTjteTYFFNhyaulHKOVOClfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hs1xOVnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hs1xOVnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC81C4CEE4;
	Fri, 16 May 2025 17:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747415210;
	bh=R7QIYpQH+jgbnPECgS7oVfLM2H5KMg6kfNW7qC9q0bE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hs1xOVnCNVk655Fj0iz1nACIHwxDGdIYa/c7rVupxUHI/nrky+1wZGiPkZd/T5RkM
	 lu7WqHjbJh4C3WXXuSimu/N917pjpq0sUUhiOpCHAZo9pC4cDem2LrHLT88YQzHkFf
	 TvrGiU1G0CDL5GRIoaXg7uyVeZe30sJeLRhi6T+JSphk5cfLgtiRD+LgIzRm5qoeHI
	 ea7j9C3pthnMtxS8BRucuZ2WgWC3fHjTJCYJBQZHWXzopo4MyfqYwiMT18D/ux0qhf
	 Y+dud6qpoLhcMLX4rkcmoSGJnlM1x8uAxG6uQheTeJGXxbE58P07599jg9rdEV90Y7
	 +kvtZ+C9enAYQ==
Date: Fri, 16 May 2025 10:06:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, terrelln@fb.com, dsterba@suse.com
Subject: Re: [PATCH] crypto: zstd - convert to acomp
Message-ID: <20250516170642.GE1241@sol>
References: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516154331.1651694-1-suman.kumar.chakraborty@intel.com>

On Fri, May 16, 2025 at 04:43:31PM +0100, Suman Kumar Chakraborty wrote:
> Convert the implementation to a native acomp interface using zstd
> streaming APIs, eliminating the need for buffer linearization.

How does this affect performance?

- Eric
