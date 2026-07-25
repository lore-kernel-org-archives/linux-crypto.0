Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B3B21CC44;
	Sat, 25 Jul 2026 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785001751; cv=none; b=ZN46YRGm91Lfy3ok6XDcXSYrj+QYgIIVALzFAIcCSVDWtIO//3+zjBk1hfJVbkDDF/1kfj/ejeLshm7oooJh3T4p1X3/adDK0hOihx6FIw4ddHw2kFecmlx2yXf8bywmAMB4q4hYq0lWXKJt9ptbI3IWTHSxvc7nNbdheD15VeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785001751; c=relaxed/simple;
	bh=g2zxBVtQ/1sgGgGkuKKbs+j8xl+qgJFofasBkoJyQdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HYsk2Iu/g0/VJfGkKlMva/phmU1eyeZx+lKTHE5jI6Cv4cNziV0TOcgeGDZGWxiGJrdLjnJ8IjvPvK61u/XB5uh4w6xpXwunB8a44VkSS3dBTvqIAFX1nVX8W0XKNdHWpXvVR4/jcWYJZmaQbDvZ1aklkzoCUaUNJjBEGNPXGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8I4b6Er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8I4b6Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3AB1F000E9;
	Sat, 25 Jul 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785001749;
	bh=2Qn9qcCPN9f2sZGtQb6IdvTnxe98CDptH48FCRNf8CI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T8I4b6ErvUpV1fJcGr95aRhtKGwcAGm33JK8yv3kzyeh2eywbuQary097solhxPqj
	 BWcpYQGvljvKnhl4Q6xilhAsdV1tSoxLZ2a+TMtvFWBIWFrn75NcKX5Mc9XS6lUemG
	 I2XBkoQq/gugRTVC+ZM/NqgH/90a/8Y32UhFy5tuAffFGFkT6IRdH3qN0K4qIChJFi
	 cFUw/tO0HvrF/tp9W3/RjMqQa/ioPw8BeJS2WoTN1MHXP7A1/TvYJvrJkeD6+EDzzf
	 bIrN/gtAm9HJ7bSkZeDAqe29NrUTatOMAPdAIt0Q5Pvqtkna6t2dV6qHkEnU3Szs9O
	 eXRFSuGFBXUQA==
Date: Sat, 25 Jul 2026 10:49:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
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
Message-ID: <20260725174903.GA150173@quark>
References: <0ccda05f-077c-4661-b852-e6bf9bf40be3@gmail.com>
 <20260724180951.GA1572592@google.com>
 <amRntEmCUK-8wXcw@codewreck.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amRntEmCUK-8wXcw@codewreck.org>

On Sat, Jul 25, 2026 at 04:37:24PM +0900, Dominique Martinet wrote:
> Thank you both for your time replying
> 
> Eric Biggers wrote on Fri, Jul 24, 2026 at 06:09:51PM +0000:
> > On Sat, Jul 25, 2026 at 01:32:12AM +0900, Dominique Martinet wrote:
> > > There's not much I can do about the vendor's kernel I'm stuck with, but
> > > that doesn't make having encryption material not accessible to userspace
> > > useless as a concept;
> > > forgetting about the sysctl for now, what are the alternatives API this
> > > kind of implementations could be based on?
> > > 
> > > I guess I should start looking at how tpm backed encryption works,
> > > some other day, it's getting late here...
> > 
> > First, we should remember that implementing hardware-bound keys via a
> > standalone crypto engine is a dated approach.  Inline crypto engines and
> > CPUs, which work much better than and are much easier to use than legacy
> > standalone crypto engines, can support hardware-bound keys as well.  The
> > former is already supported, and is already being widely used, in the
> > kernel via the hardware-wrapped inline crypto keys feature.  For the
> > latter, see e.g. RISC-V High Assurance Cryptography.  In the CPU case no
> > UAPI is even needed; userspace can just use it directly.
> 
> Thank you, this is exactly what I was asking about - my background isn't
> crypto and ultimately whatever direction is implemented will depend on
> $vendor and I'll just be following along, but I'll read up on this.
> 
> "Inline crypto engine" seems to be a qualcomm marketing term, but from
> looking at their doc the API seems to be PKCS#11 smart card?
> Having worked on these for some other hardware I can't say I find it
> easier to use than af alg, but it's definitely something that can be
> worked out.

I guess I should have written "inline encryption hardware", which is the
vendor-independent term we've been using in the kernel, just in case
anyone thinks "inline crypto engine" means the "Qualcomm Inline Crypto
Engine" specifically (but really, IMO they are just descriptive phrases
that mean the same thing).  There are many different hardware vendors
that have inline encryption hardware for UFS and/or eMMC.

Their interface is quite simple and doesn't use PKCS#11 at all.  I don't
know where you're seeing anything about PKCS#11.

See also the documentation in Documentation/block/inline-encryption.rst

> "The CPU case" (looking at the RISC-V High Assurance Cryptography) would
> be some CPU instructions (ISA) reserved for crypto ops?
> That's interesting, I had never seen this but I can see this would
> likely provide the best performance.. And if the ISA gain enough
> traction having them supported out of the box by OpenSSL or whatsnot
> might actually be possible, that'd be a great step forward.

Yes, and similar developments are also occurring on other CPU
architectures, like Intel's Key Locker.

> Right, sorry for asking about an out-of-tree driver, I hadn't realized
> since caam itself has been upstream for a while.
> 
> I was just curious about the double-take approach taken with these two patches:
>  crypto: af_alg - Drop support for off-CPU cryptography (this)
>  crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1 ([4])
> [4] https://lore.kernel.org/linux-crypto/20260622234803.6982-1-ebiggers@kernel.org/T/#u
> 
> I assume part of it was just that the whitelist wasn't ready yet when
> this patch was merged, but as far as I understand if the whitelist
> sysctl is implemented this is basically noop?
> (Well, I guess it'll allow code simplification over time, but these
> hopefully won't be backported to stable kernels too aggressively.. While
> I fully expect to see this "Drop support for off-CPU crypto" patch to
> show up in a couple of weeks in older stable trees; and for practical
> purposes I don't see much way around just reverting it for now)
> 
> Thanks for putting up with me.

Neither of these patches is tagged with 'Cc stable', and I don't expect
them to be backported to stable kernels soon.  That being said, it seems
the people using LLMs to find vulnerabilities haven't focused much on
drivers/crypto/ yet.  Once they do, well, they will of course find
vulnerabilities everywhere (accessible from unprivileged userspace via
AF_ALG), and when that happens there may be little choice.

The addition of the af_alg_restrict sysctl (and the possibility of
userspace explicitly choosing to disable restrictions by setting
af_alg_restrict=0) doesn't necessarily mean that problematic
functionality should be, or should have been, moved under
af_alg_restrict=0 rather than removed outright.  It's just an option
that can be used if needed for compatibility reasons, if actual user
reports come in.  If something is not needed at all it can just be
dropped right away.  This actually happens way more often than people
might think, due to the immense amount of unnecessary functionality that
AF_ALG has: *many* crypto algorithms have been removed from AF_ALG over
the years without any complaints, since they were never used.

I'll also note that hardware crypto "decelerator" driver authors are
actually now *depending* on the drivers no longer being usable from
AF_ALG in mainline in order to argue for more relaxed driver inclusion
criteria.  I don't think they can have it both ways!

- Eric
