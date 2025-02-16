Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49DA1401C;
	Sun, 16 Feb 2025 03:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739676380; cv=none; b=NGghYKv7x6jh8SGUxf4GhCq1wCy8AXEZTQxo4JrG6IqPzhWrdbawqo+eyGnUmay2GCOK5MxWsDRnyaZhY8sR6jUYssaWskp8CfkyigrGFKZjvNmi1hnOqUpIX0Ic3nX5/IAPYbv6oogqd7TOhjAbyNKnJTI5VHKkTELMr3+ch8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739676380; c=relaxed/simple;
	bh=xPxs9EGZOUB8OVEByI5GmnmSdMJ0bdd8pkV5n8kPmQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJzkyFNJuvuGs7kx7+6J4Y62O7QSqzF8HxeWuP+SF170Glfb/huR0clyRUbJlGVXGwDyZA65A6c6dWlTVCn7m78y/Vawnv5jpptjMeHabvxrxTH7vkvEPqOiqQ/wFpqqf1P1hfwMiv/b5BKIvg5bdchMXCU+53OuUu4OCU16VXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHAF/EUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHAF/EUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1771C4CEDD;
	Sun, 16 Feb 2025 03:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739676379;
	bh=xPxs9EGZOUB8OVEByI5GmnmSdMJ0bdd8pkV5n8kPmQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EHAF/EUUukABpePQNqnEyDMKwBXXAkMiwVJkYCnRypfkz5uy5jRqyArIqEStpbsZs
	 qBvytX3fCE61LQzRGMQaw5WPPept3cqmogo9dnft/Jt2dIVgwkTDuOrSU4AR4gaZQJ
	 IO9omqJ4440C0sDWlUazodFN6MQEI8JMNKTV5zvxNWVnbgBdcAcK9pmVV7USfaxfFJ
	 ycqf0eN4p06VKXxPboUct9YcPs3pQ8s+GANnX2NHbaNtWmbr5dZ4Oak321lljY+Zuq
	 Ug1LjL8zI/O0pIsUHjP2Pj/jD/lXksB+ogv62k+b0yuKHm3lDaG1QgiRjnkb3rztHN
	 G3nz+tOmZEagA==
Date: Sat, 15 Feb 2025 19:26:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>, fsverity@lists.linux.dev,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer
 hashing
Message-ID: <20250216032616.GA90952@quark.localdomain>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <20250215090412.46937c11@kernel.org>
 <Z7FM9rhEA7n476EJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7FM9rhEA7n476EJ@gondor.apana.org.au>

On Sun, Feb 16, 2025 at 10:27:02AM +0800, Herbert Xu wrote:
> On Sat, Feb 15, 2025 at 09:04:12AM -0800, Jakub Kicinski wrote:
> >
> > Can confirm, FWIW. I don't know as much about IPsec, but for TLS
> > lightweight SW-only crypto would be ideal.
> 
> Please note that while CPU-only crypto is the best for networking,
> it actually operates in asynchronous mode on x86.  This is because
> RX occurs in softirq context, which may not be able to use SIMD on
> x86.

Well, the async fallback (using cryptd) occurs only when a kernel-mode FPU
section in process context is interrupted by a hardirq and at the end of it a
softirq also tries to use kernel-mode FPU.  It's generally a rare case but also
a terrible implementation that is really bad for performance; this should never
have been implemented this way.  I am planning to fix it so that softirqs on x86
will always be able to use the FPU, like they can on some of the other arches
like arm64 and riscv.

- Eric
