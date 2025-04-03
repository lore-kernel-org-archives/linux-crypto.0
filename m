Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06DE2581;
	Thu,  3 Apr 2025 03:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743652776; cv=none; b=ZXcQ//wCu85a3kpGoXSH/2DFpF6aAlGhhzvfTKwIjCp2TX65o7t7+R6N5DpxikOmAhCQ1qwWibS5nT7Tcdyyg0ofxC6bs92/Bw2hJdx6mqv6JIPBgSNP+4SZoI/jYH2jRsq+/NaWE1PYL+Xx2WRNRx7E2OhBynpURr3mpBDY3lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743652776; c=relaxed/simple;
	bh=RE63XWPcYVjkIJVfd4rvnqu5gjt/U5Kzw79QJ0K1F/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7ws1Gi4SKeuKE6pweM3vbz+GGUHE/dnaaIeBczqUm0IJVo0Qp+LpnP4L+uivZBHqesGcK+7UjAPmq5MUYVTyyxGdEEx0Gh53p8F84PvriFCol8vOhoL7gUBasiGhmz5ijutjigcHzu8iqRI9GQg4d6EmFrwr1FGPelFPZTZU98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esKLdExk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esKLdExk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016ECC4CEE3;
	Thu,  3 Apr 2025 03:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743652776;
	bh=RE63XWPcYVjkIJVfd4rvnqu5gjt/U5Kzw79QJ0K1F/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=esKLdExk9Jk2zueFh+VKoVMh9S1UVSqbI45ipgmTzP24WXGSvjYNqOTEIQUfOwxZ9
	 QLpRqWOTyvvww5ttciS9SH5jJOz+e5KVmSJaV0EEXAIW7ehvrrnDoH2akixY/yFgPy
	 TNSS56AT9dawrAMaR55Q6+FdjuZZGyctiH1ErcpKZRqJir0xrw9P6FaizWEJzIEdxS
	 /vamlqP3q6q8n7LeN1HQ2T1yPUQwFEe3c5Dn6tev57yp8ljxwI7cuxbnrsSAAZF+ts
	 BPGezgSCISD8AlLMWrAnXBcQX5k2lJ5CwEf56SnO3WOw3w1i0pqjaL3HG4TLE2tZdJ
	 zspnmrK2FbANQ==
Date: Wed, 2 Apr 2025 20:59:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Banning crypto in hardirq context (was: [PATCH v2 0/9] crypto:
 x86 - stop using the SIMD helper)
Message-ID: <20250403035934.GB129577@sol.localdomain>
References: <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
 <20250402171930.GD1235@sol.localdomain>
 <Z-3jkYNtZpTDtKGf@gondor.apana.org.au>
 <20250403021453.GA2872965@google.com>
 <Z-344xAsx1uTE9OK@gondor.apana.org.au>
 <20250403032008.GA129577@sol.localdomain>
 <Z-4DqsRApwQi6Xju@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-4DqsRApwQi6Xju@gondor.apana.org.au>

On Thu, Apr 03, 2025 at 11:42:34AM +0800, Herbert Xu wrote:
> On Wed, Apr 02, 2025 at 08:20:08PM -0700, Eric Biggers wrote:
> >
> > Also, riscv has scalar AES instructions.  (They aren't used by the kernel yet,
> > but they could be.  The CRC code already uses scalar carryless multiplication.)
> 
> It still doesn't mean that it's a good idea to use AES in a
> hard IRQ handler, especially if the code is meant to be portable.
> 
> > Also, as I said already, x86 does support SIMD instructions in hardirq context
> > in some cases.  Whether anyone actually uses that, I don't know, but it is
> > explicitly supported.  Check out irq_fpu_usable().
> 
> This is more of an accident than some deliberate strategy of
> supporting FPU usage in hard IRQs.  This test was initially
> added for aesni:
> 
> commit 54b6a1bd5364aca95cd6ffae00f2b64c6511122c
> Author: Ying Huang <huang.ying.caritas@gmail.com>
> Date:   Sun Jan 18 16:28:34 2009 +1100
> 
>     crypto: aes-ni - Add support to Intel AES-NI instructions for x86_64 platform
> 
> It was then improved by:
> 
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Feb 13 13:56:14 2012 -0800
> 
>     i387: make irq_fpu_usable() tests more robust
>     
>     Some code - especially the crypto layer - wants to use the x86
>     FP/MMX/AVX register set in what may be interrupt (typically softirq)
>     context.
> 
> At no point was there any intention of using this in a hardirq
> context.
> 
> Until such a time when you have a valid application for using
> lib/crypto code in a hardirq context, I don't think we should
> be supporting that at the expense of real users who are in
> process/softirq context only.

Whatever.  We agree that "crypto in hardirq" is not a good idea in general.  I'm
just pointing out that there are certain cases, like SipHash used in a hash
table, where it easily could happen and would be fine.  And all the shash and
crypto library functions currently work in any context, unlike e.g. skcipher and
aead which do not.  You seem to be trying to claim that it was never supported,
but that is incorrect.  Making it unsupported would be a change that needs to be
properly documented (the functions would no longer be simply "Any context")
*and* have proper debug assertions added to enforce it and prevent usage errors.
But in a lot of cases there is also no reason to even add that restriction.  I'm
not sure why you're so eager to make the library functions harder to use.

- Eric
