Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAD042F71B;
	Mon, 27 Jul 2026 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785172821; cv=none; b=JZia0KVZUFCFp2G5bopAUCpJ8zBQOhMDOxBygjSJCaz+Tx3axVUf97aR5b6xl+tlk0Ij0W0WpoqXSQfcI9uXI/LKA4l5bjFnan3T8todh8LVH3myC3CHApFlrcwMn0jU0FcvOTqQUiKTJYfAG2NwsWKUJ0jgJr6zfAAUv6ZPsAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785172821; c=relaxed/simple;
	bh=iHVqW26uqMIGtwL7D6jwQT5OzT/Dmcvycs+bVve51TM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/j/JDg4AeFEwO0Hk+uY/CerdH5OnD53zEqVCRcPugZWqXiuipWrxl4OqgXmDq9IScvVmYsZ+eP5rOtCgVoeMUT1rqTt7NbBYFx+GaHrUlnw8ztrSE4DwcLPq5vZcfsobdbJ41xgG9OY8aef6DhgAWLw5Z8kiBGjUXb9HTXOFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iH5r3gl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iH5r3gl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CFE1F000E9;
	Mon, 27 Jul 2026 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785172807;
	bh=UVccbVTzUoYV0KQWNuk0uyfzJqKVf1DPYNfNQhr1Nkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iH5r3gl34aaayTvPfEcv7gNRsA9jchZSuYSuwPNrFgrkNWRmMNmovv+NyzxNf6aQq
	 shH9zFige9pcptY+jfid9o8v5U685oEy1TeVyBNfwV+yZxOvBBOgl6Q+hxsNGgyx3O
	 rNjf45oeghZRTG9f3sHOiFX6pDRKi96uDnV2ePLjQiyvfN2Ih5RrHO1VoVzFoXzQs0
	 NeXmWyRcTh5EfKOfZWtV/SfoiNhZT58VJaY6oUHSqLVaj6Z8jEny9bgUJtbr4LI0aX
	 gJP8mbeE4IDJHv2P8/NZ7GU3ipfmfw5O2PAg8yOpY1gx6QpJ29Wp0Tl/S3KtcUrQOh
	 kx8qDGfsYYcjg==
Date: Mon, 27 Jul 2026 17:20:04 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>, demiobenour@gmail.com,
	Harald Freudenberger <freude@linux.ibm.com>, acme@kernel.org,
	adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
	ardb@kernel.org, axboe@kernel.dk, corbet@lwn.net,
	davem@davemloft.net, edumazet@google.com,
	herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <20260727172004.GA877700@google.com>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol>
 <amOTjPW__CNZui3_@codewreck.org>
 <CAFLxGvy+ec3nQLrQtwFZgGELhT2pKBDnHdD0pMvEGh-Mf3rjgQ@mail.gmail.com>
 <20260725220443.GA41199@quark>
 <CAFLxGvyBGzfwh61F5YkYqctNPCQJCpFOwTtKfDs4L+iK8WJZpQ@mail.gmail.com>
 <20260726155024.GB1673@sol>
 <CAFLxGvzaAH+ZGr-OFo=Li1aOxgwBjjR76T7m1CjFaL-6w3KPPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvzaAH+ZGr-OFo=Li1aOxgwBjjR76T7m1CjFaL-6w3KPPQ@mail.gmail.com>

On Sun, Jul 26, 2026 at 10:10:48PM +0200, Richard Weinberger wrote:
> On Sun, Jul 26, 2026 at 5:52 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > Then I would suggest that skcipher_bind() should check if the name is
> > "cbc(paes)", and if so use 0 instead of AF_ALG_CRYPTOAPI_MASK.  Please
> > go ahead and send a patch against mainline (for v7.2-rc6) if you're
> > interested.
> 
> Patch sent.
> 
> > On cryptodev/master (future 7.3) it should get an entry in the new
> > skcipher_allowlist as well: { "cbc(paes)", true }.  That would be a
> > separate patch.
> 
> Do you mind a new field in struct af_alg_allowlist_entry which indicates
> that  AF_ALG_CRYPTOAPI_MASK should get bypassed?
> 
> bool bypass_apimask;?

Let's wait and see if it's needed for another algorithm before
generalizing this.

Note: if it does happen, the list definitions should start using
designated initializers so that it's clear what the bools are.
Alternatively, it could be a flags field with possible values
AF_ALG_UNPRIVILEGED and AF_ALG_ALLOW_OFF_CPU.

- Eric
