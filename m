Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8C630EF86
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 16:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758213232; cv=none; b=csWGiI/bx1s1kyx7mdblffKNRG5HVbtqMQWstAu0JLKWgUthLImEr/75iDA4jfZjbkpMqptmK2JR/kFg8LGdEp3cMHzlgtzhq3PU93KrwicuWoe6jB2uyTjyclRqmEd/D+Y6dF0fs4vEvOIc5NqL4m5CJ1xmWVeJ2MKtmOjxmQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758213232; c=relaxed/simple;
	bh=Jni++KkmKwf5EgI46WwltbKBUwJsnOHzljdkCqyTw5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgdHAs5yclFUCPfTLj3uNLAubMpg6cSXIUcuKA7oBNhQo3JXt+qHd7OOLrOGkkSjva9v4fNbBQi0Y64RdqsZXAZjbc2YpKhCvqpuG/vsXcLpsdzWavpv1Qvy7hbAw72Yt6aZryfOfeJ5Csn6cUlegLrDy+giP9LsfzsyGJKu+i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pVoz1uF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pVoz1uF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFE5C4CEE7;
	Thu, 18 Sep 2025 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758213232;
	bh=Jni++KkmKwf5EgI46WwltbKBUwJsnOHzljdkCqyTw5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pVoz1uF3AsvSVt9u+Vk8IUDI7jkCgxM/l69Y1Tg3C2bftcFYXUuWEKQ8Y8JAyepFe
	 aNmI9qfrd+fVcdNW8QxsPHtmaZlMbEPW1qr68cJ8SpJ7fXIPpcLzrXeVR+mH40899y
	 ToQ/1gPi1VvjlkiV0Zxp+w2fVNmkUse4Zh/0Leti7yOz95Fug2vHulLDE44I+HMJ1N
	 01/UMAQWI0Vcp92HIHVukCyQdeKgKYa7ljZi5cpdjrfpJcEUR0HrrjaUrIzSFzOX6Y
	 im5KY17OoIBmiHKJs+Ads75UXLGffG4q9cEnObqxvujpgJExUIbBVO8N+WMyhvRaNT
	 b94xP1JWbWI4w==
Date: Thu, 18 Sep 2025 11:33:47 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, simo@redhat.com
Subject: Re: FIPS requirements in lib/crypto/ APIs
Message-ID: <20250918163347.GB1422@quark>
References: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>

On Thu, Sep 18, 2025 at 11:00:45AM -0500, Joachim Vandersmissen wrote:
> Hi Eric,
> 
> I'm starting a new thread since I don't want to push the SHAKE256 thread
> off-topic too much.
> 
> One simple example of a FIPS requirement that I currently don't see in
> lib/crypto/ is that HMAC keys must be at least 112 bits in length. If the
> lib/crypto/ HMAC API wants to be FIPS compliant, it must enforce that (i.e.,
> disallow HMAC computations using those small keys). It's trivial to add a
> check to __hmac_sha1_preparekey or hmac_sha1_preparekey or
> hmac_sha1_init_usingrawkey, but the API functions don't return an error
> code. How would the caller know anything is wrong? Maybe there needs to be a
> mechanism in place first to let callers know about these kinds of checks?
> 
> It would be great to have your guidance since you've done so much work on
> the lib/crypto/ APIs, you obviously know the design very well.

That's misleading.  First, in the approach to FIPS certification that is
currently (sort of) supported by the upstream kernel, the FIPS module
contains the entire kernel.  lib/crypto/ contains kernel-internal
functions, which are *not* part of the interface of the FIPS module.
So, lib/crypto/ does *not* need to have a "FIPS compliant API".

Second, according to the document "Implementation Guidance for FIPS
140-3 and the Cryptographic Module Validation Program", HMAC with keys
shorter than 112 bits is still approved for legacy use in verifying
existing messages.

Third, HMAC is sometimes used with HKDF, where the input keying material
is passed as the *data*.  The HMAC key length would be the wrong length
to check in this case.

Fourth, not every user of HMAC is the kernel is necessarily for a
"security function" of the FIPS module.  Non-security functions can use
non-FIPS-approved algorithms.

Point is: lib/crypto/ is correct in allowing HMAC keys shorter than 112
bits.  (And this is a lot like how lib/ also has entirely
non-FIPS-approved algorithms, like ChaCha20...)  It's up to callers of
the hmac_*() functions, who have more information about the purpose for
which HMAC is actually being used, to do the check *if* they need it.

- Eric
