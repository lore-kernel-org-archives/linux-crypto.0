Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794252056;
	b=FS1WODdbPl2Ud14ns6YNqTK+DZaDNxpSsXALGRp1SddcTNaF9rFwqH60mPLuHFMg3UY8
	 SuN73NUK3MhznrGPmSbh1O3yR73UK6qsfvVD2xr2Rth9nCXAnRMmP7VucqSmSF/9OCU5l
	 UkV4lzIIE0eFQDGu5Tyo266CdRLgzwVsmJy18dWZVTTFYGXCYWwB2EjwUL60xsz2DgeQF
	 43+iiysFKOKkQEL5PYB/ly/XrSB0KHs8v2LfC1ddF3o0PuMaaRkEA2XLZ7JY68wnk6GFl
	 HQC6qdtJa+exIOrIPlgOW/vjClh6wD2r0tGrxnfYZmITjmaDo+z2mV5DoOmN1ZqmqtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794252056;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sYZrTSymVbGr+J5tx9WqmyGxsTySgpEc5GVqzxAxWWE=;
	b=JUL0f3TE/5EA5I4ZPft0eBvoRzeS71kO/YiN7Xiq/qKn4HoqDvreaWECHxG9moXUpntF
	 PupAAE+9ppLN0vLcEx/oD7tN24Hbufv2w3PmIZ5mAiumtyJoQCRJ1xP1t1E64ZMh4EZzN
	 PKXTYY8ORXeeDMTpNQ+IdpSZ+VWO7UZ0Ieh/8ygr8j8jbBxG6eNqD0uPfSO6HYn11ENyd
	 GBNn4LzjsN5BdPyDiSgYSDYp1MkzGfS27XXfFaecmOhr5PuedVs78QFq0YlPAHAu7qn74
	 aN5xPe4cIANWe9pzUWPSYsISRDmcm8umm2GPy24zu7A197WCRbmXB+xdnBprCbv8h2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtS20Lwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0E606A33C
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 19:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gtS20Lwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD731F008A4;
	Mon,  9 Nov 2026 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794252055;
	bh=sYZrTSymVbGr+J5tx9WqmyGxsTySgpEc5GVqzxAxWWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gtS20LweN0QSN1Ihxss/vJRFWtxuhebLjzeu5/79URneQ1I6YK3Sl+hqz3EBjJ/uH
	 3YHoVAdvk4y4TLPWHi/fCW6KuNiRqrFhDITyfMn4VHUCnMFzHc9nj1TNqIL32Ef1ig
	 q6FgAUlntqjfEptahf+L+YW+WpB7B/1y5Rx29ZThMELaZdCEQRtEhIDVUg0a+oaLBH
	 1bD+NRbyQU+VCQZV9KHBmkksDlJ5Pn86MAVr0Q4pmz80aCg97vx/Y8hTUtqk4MT74W
	 TOaqg6c0lhn9SWWM3WUnMZsy30S2HjwcZtLwmbcXZVIZDoq2DcluFoQMzg7ErJJdXA
	 E0G03M90J94Rw==
Date: Mon, 9 Nov 2026 19:20:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: lib/crypto: AES-GCM x86 arch hooks: any plan?
Message-ID: <20261109192053.GA57100@google.com>
References: <6ce2344c-f6b5-4051-87b0-88a1c258a6d3@mandelbit.com>
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
In-Reply-To: <6ce2344c-f6b5-4051-87b0-88a1c258a6d3@mandelbit.com>

On Mon, Nov 09, 2026 at 04:47:05PM +0100, Antonio Quartulli wrote:
> Since the commit adding GCM to the library says the arch-optimized code
> will be migrated into it, do you already have work in progress for x86?
> 
> If not, we'd be happy to help there, or to test yours on Zen 5 with ovpn
> as a user.
> 
> One design question I have though: the VAES code needs the hash key
> powers H^16..H^1 (and H^8..H^1 for VAES-AVX2 / AES-NI), while the x86
> ghash_key only holds the PCLMUL state.
> 
> Would you rather extend struct ghash_key on x86, or have an
> arch-specific part in struct aes_gcm_key that aes_gcm_preparekey()
> fills when the arch code is usable?

I'm planning it.  I've just been trying to get other things out of the
way first.  If you're interested you can try to do it; just keep in mind
it will be quite a bit of work to do properly.

The tentative plan is to implement the GHASH and AES-GCM arch hooks that
lib/crypto/aes.c already has in place.  And yes, that would mean that
the x86 AES-GCM code would have to be reorganized to operate on struct
ghash_key (expanded to hold up to 16 key powers) and struct aes_enckey
rather than a combined struct.

That by itself may result in performance regressions on short messages,
though, as each AES-GCM operation would be broken up into multiple calls
to the arch code.  There likely will also need to be new hooks for
one-shot AES-GCM operations to handle them efficiently.

- Eric
