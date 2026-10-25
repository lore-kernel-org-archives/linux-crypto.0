Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792970869;
	b=k8lSRiXRg8EQ+nD7l8PkYFdmmgV9sJPANC9SYKGrbys3qIhnQCniI2Hs9rtVJ1HG2N0J
	 SBMcPFxjb4VfTRfURk2dUihP6+WlrZwcehC3JW1WgW67Fl5kp/fN028L2gsQE4XScVLwt
	 K1KbeS+EAL75t2LXXvb2Zi9+AndE96Z2xMPg7dfS6rLWZw43wBuKO1reL9GHRChCsFHlw
	 IShgXtwunyZHAdVLDC773Lr0iSf/87Hal7rfjhKXI9yJsQeVq/lTJeMKXibnsJfr3dVVP
	 /mvwy2Q0dUAOMjYGTIax78JIxqlyC9VMN2bKAYw8UoU07Twtn7Ctq51nksHVnk26iKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792970869;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=749F1kNMvONRb00QECAoqsVJNtCXAyhqfBI03/TRF+Q=;
	b=zDHN7axJXe4HpNdvlmf+PX0mN0fUo/bApr9+RwLJQ9AFK+mtRhXg9KXW6kl2dlQKlqz2
	 wAxdHSsa5WYWQWwLv4PU29OqqI8e/0VJiI4IWxwuzPTfGnRjWktGzblGfG0qFsmVgYs52
	 V5enuH0O8eRAInEyRL9UhkzKs6hEN/J+UJd/Vq1xNR3Nrx32e/TRTeasYBUi//O4rKsAU
	 PRYSJ10ibcfvA3CWfYsq+g2sP1Qa3n3tEH2+Ti48nIGaQctd/vIGW5IGv/Xlc9aspoG46
	 /cO2UMqLIFs/gCPspoQVd/DfrCPXaB7As5Q0v2VZKzKR3AD+HdPymiwDW+vc+RaFTIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jZaigJSZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74C606A31A;
	Sun, 25 Oct 2026 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jZaigJSZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C081F01825;
	Sun, 25 Oct 2026 23:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792970868;
	bh=749F1kNMvONRb00QECAoqsVJNtCXAyhqfBI03/TRF+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jZaigJSZwL7yGLaLiqgMfXUpeXaWekbhNHRqoHeQY4Vp0sG8lH8VJwO4QCsu/bV39
	 MevoG+esrRiIHwiwRVoQeDX08/+NmXYcQxoSnck04aKhAAx8W7Q4I4pD+Rs0nsnxgl
	 rm5a4H18XiVBmnFE+RSQJEKeHf/esvQ0bxW9KjWOaSK+ifut5acrNlxY9mR2pM2+4F
	 LTYl4z7NsoMV7XpdOpNfxXZBI1AlhKWyJQzpqtm+BgenDyQjzkt9Yo/jZQZTrCKEXy
	 rZ8I54cmR+/cjCIdK0s3yi8v/v4RuMM1wEB744OlcJCGaAyF8viaYaJck2b2mhgKxx
	 O3VJfq8NeiuPA==
Date: Sun, 25 Oct 2026 16:27:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
	Yuqi Xu <xuyuqiabc@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] wifi: mac80211: Fix cryptographic MAC comparison
 to be constant-time
Message-ID: <20261025232746.GB148998@quark>
References: <20261025210032.134911-1-ebiggers@kernel.org>
 <676effaff715929da980158820833c18a3a2845c.camel@sipsolutions.net>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <676effaff715929da980158820833c18a3a2845c.camel@sipsolutions.net>

On Sun, Oct 25, 2026 at 10:37:47PM +0100, Johannes Berg wrote:
> On Sun, 2026-10-25 at 14:00 -0700, Eric Biggers wrote:
> > To prevent timing attacks, the comparison of cryptographic message
> > authentication codes (MACs) needs to have data-independent timing.
> > Replace the memcmp() with the correct function, crypto_memneq().
> > 
> > Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
> > Cc: stable@vger.kernel.org
> > 
> 
> I'll apply this if you either come up with an actual attack, or stop
> pretending it's a bug.

I don't have time to set up a system using IEEE 802.11ai and try to
exploit this to forge a frame, sorry.  Especially when we fix timing
bugs like this all the time.  Realistically, these types of bugs are
usually hard to exploit (e.g., involving sending a lot of packets and
doing statistical analysis) and can be the topic of a research paper.
But that doesn't mean they don't exist or aren't obvious bugs.

You can find more details about such bugs at external sources such as
https://blog.canutethegreat.com/index.php/2026/10/04/timing-side-channels-constant-time-comparison/
A memcmp of HMAC values (16 bytes, which coincidentally is the same
length here) was also exploited in the Xbox 360 to install arbitrary
code.  That example is covered in cryptography textbooks.

The use of AES-SIV here does seem to remove some flexibility for the
attacker over a MAC by itself, due to the synthetic IV.  But that gets
defeated by frames with zero-length ciphertexts, as far as I can tell,
which can still include arbitrary IEs as associated data in addr[4].

Understood that you don't want to fix this bug now, though you've
accepted similar fixes in the past such as 98c67d187db7.  It will still
need to be fixed at some point anyway unless this code is dropped.
Perhaps you could consider at least applying it without the tags for
now, and we can consider the stable backport separately later.

- Eric
