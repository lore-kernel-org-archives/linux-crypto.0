Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A9C3375CB;
	Fri, 29 May 2026 20:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780088054; cv=none; b=DeN7Mc8O73guxfUV1PuOrs3h7kCXC6RzP3Cdpxffo2YdX9qy4RFdS+MtXVfsucE/8E0S5L24fYRFY0ufS6iB7xBOEoy2WjR++j9dty8Xwd04AUpkmeweAcsXkBudu3mapknSn5pGeio2p+1H9e46pHrpBUSXSV9ji+UDSKCuI7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780088054; c=relaxed/simple;
	bh=tkC3ro4w7oFJawBaRS+aO1CeTD6ibX0dP0oJpaIKY8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgEiRpirqJp8CxagyO5Nt5XFAHqRUHEUhZuy1kJ0XZc3TaTcgoNC+/Ab8XkiOp5QfCwQerVJ2nL+LQJU9jUkrscoe8xRclK6cHHPNyPbrjyxibfnztOvfQpM8Hj8JqbgMHbtjrt7gYYwW9agRd78qTjUbJFYqx6Pj6pSg19ngnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZObPMGrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZObPMGrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556EC1F00893;
	Fri, 29 May 2026 20:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780088053;
	bh=SkBBYD/N4py2W5hIKTk1Rqq0JdxguQzYXWr8RYU+TUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZObPMGrqv0L/N9SGyaeQLtWm9+Yoy+xJBYQ5QoUg0zPPtUqkHF9hcEUH2m0aNGvQs
	 +Z+iJfosETxxOJi2HfMUyAi/uspEf1xmU8XJzjFyW+3YMs5b5jcWV+FqhMLYiLiaRX
	 bYhwmrkQu2b3WVbpgKvvMbYFRVTlg2kSa4uOAE/6A2+rjWbouXosyQ4FfYrrExtmIO
	 3ch7wNl23BGxF2LX089lWMUHzHa8B3xCt6W/sOMoAS2jzsg7DNwn4ukBLhaWI8whnz
	 lOeS32HXOqFx6CDTS9edMNMr1HzXLH2Jw2i6WeP3yBY+jznOGLVpfa/qeCQN6tW71O
	 3py40E2od4Dfg==
Date: Fri, 29 May 2026 20:54:11 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-sunxi@lists.linux.dev, linux-crypto@vger.kernel.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss - Remove insecure and unused rng_alg
Message-ID: <20260529205411.GA901806@google.com>
References: <20260529193648.18172-1-ebiggers@kernel.org>
 <20260529195725.5C7B91F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529195725.5C7B91F00898@smtp.kernel.org>

On Fri, May 29, 2026 at 07:57:24PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] The debugfs directory and files created during probe are never removed on driver unbind, module unload, or probe failure, leading to a resource leak and potential Use-After-Free or page fault.
> - [High] The driver modifies a static global array (`ss_algs`) to store per-device context (`ss`), which breaks if multiple instances of the device are probed.
> - [High] Missing check on `sg_miter_next` return value leads to an infinite loop (DoS) inside a `spin_lock_bh` critical section.

Just par for the course for drivers/crypto/.

- Eric
