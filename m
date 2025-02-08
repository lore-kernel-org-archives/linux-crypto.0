Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DFC148304;
	Sat,  8 Feb 2025 03:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738984343; cv=none; b=AGHAJHn+no3qBClXH7Utd1HZhSyKsFaY1Rpu+pacq7iFu6fM35+EHA/eX1incxCB9fu1WJGVjYhDnkEqylnzmkAMBn4WVqR+XYGjEFDQ4XVJe/ywQB5fnDqRD8bj+VVvGBbRhysLx6lJ84cAWhD6a6pPHWVxMkrGh7z0acqcjqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738984343; c=relaxed/simple;
	bh=HyTLh1jVA4aRn6uJ7/f/aV00X3lPFEEUTsnuihvyh9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeb/QEYNrc1Vv1CHV3v2acETZWmIB3xWskGfZ8v+YzclLS2psIk5TuV0LTZflPR6EjXso/SFfL8IgzKYWyBBurzqFCTmzOzYLICDHTLs0pSE+Cdy4TzASRSfrxv/ja+r5eaMoaWdWagPEx+oz2nlS+y1Fw1berCuF4wZKnQkKlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rS918Dwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rS918Dwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9C3C4CED1;
	Sat,  8 Feb 2025 03:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738984343;
	bh=HyTLh1jVA4aRn6uJ7/f/aV00X3lPFEEUTsnuihvyh9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rS918DwcNPRJ2UiuFsEoQh9WHChUOoay4mOO4XVUDDxa34tPrimlCmy2k+36WS6gM
	 GZZ9LJlV8sRR7MZU4rnFk/p7bYJJ1vVACmmynennY8KKoaonYEjGZX+jV3Tq0tRcKq
	 vu/soOLuvhkFZhz+kubakbLbFYlTZh8os3j3lK4+i4JIhMszrsDCZ3fYjrafphkqFJ
	 /4N5zdrL6WYuB7WdPh08y79tE0M8CuT5A03b2IuBb9HsE1J0xrLmQeDHQLwJEC0xsT
	 H7kxsWOsBDx7JJJXBFBoCTiQwUPeCNv/raMUjHEm1Da0shqA5FjhjLdWuxmxrCHcwe
	 XlIi9M/ElTSPw==
Date: Fri, 7 Feb 2025 19:12:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: x86/aes-ctr - remove non-AVX implementation
 of AES-CTR
Message-ID: <20250208031221.GA2552@sol.localdomain>
References: <20250205035026.116976-1-ebiggers@kernel.org>
 <20250205035026.116976-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205035026.116976-3-ebiggers@kernel.org>

On Tue, Feb 04, 2025 at 07:50:26PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Nearly all x86_64 CPUs with AES-NI also support AVX.  The exceptions are
> Intel Westmere from 2010, and the low-power Intel CPU microarchitectures
> Silvermont, Goldmont, and Tremont from 2013 through 2020.  Tremont's
> successor, Gracemont (launched in 2021), supports AVX.  It is unlikely
> that any more non-AVX-capable x86_64 CPUs will be released.
> 
> Supporting non-AVX x86_64 SIMD assembly code is a major burden, given
> the differences between VEX and non-VEX code.  It is probably still
> worth doing for the most common algorithms like xts(aes) and gcm(aes).
> ctr(aes) seems unlikely to be one of these; it can be used in IPsec
> together with a standalone MAC if the better option of gcm(aes) is not
> being used, but it is not useful for much else in the kernel.
> 
> Therefore, let's drop the non-AVX implementation of ctr(aes).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

It was brought to my attention that the above does not list all the Intel CPUs
that have AES-NI without AVX.  The Pentiums and Celerons based on the Skylake,
Kaby Lake, Coffee Lake, and Comet Lake microarchitectures have AVX fused off.

I'm leaning towards dropping this patch, and keeping the AES-NI only AES-CTR
around for a couple years longer just in case.  This patch would just be
184 deletions, so not a huge amount anyway, and I think we do need to keep some
of the other modes in aesni-intel_asm.S like XTS anyway.

- Eric
