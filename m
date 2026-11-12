Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794515011;
	b=3fCAM2mQBLXvAKmGgyjw0ZFWOxmxZLs/yfa151JAujj7qC534td54Ezrnn0O4JenHpxt
	 +WUYZxrDHOpbC7xPUYHGxrJSgCSgGnJb54CSM8MttH/YI8zzNBpoXN+wCo6ahab0uFtlw
	 2TJ8+tboA/e62+mNb3WXkWKppKuXa4jNu4avwYNB9L28dYNrlX9V6UrHj27oU4I6LIm81
	 CgLPg3Ry7YHR6eeTIDRlvWl4udncJyeZ79ToNn4nd7UJ8VwW8/jRY1QZrgK4KEm/X+k7J
	 kioRrm8LHpOXiXNNOJAE6ktz/YjnjqL7pJWkClYwZsN2yKzyHPvTWE0jfsp5G/LPd/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794515011;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=echnUtSfnLWGNHxFYZIBhHwmjWZfhLaMzo8MtinsitI=;
	b=lHYeDjT9RlICAboDdd9fQkuCdvEgmukfUqaoNY7PpXVfa3bNlfpZtWqPkt6uMSxsTdQo
	 T5z38h2iDuEaKjr4GrJNlNI1vGe14gMwKkFAcTIJsQFWq64DlaEJEQ31UDTWVA5oCoA+/
	 yuUvAirEK4tNuA6pofqVdUvYWGda1Qp2qeaHf66Jx3UaVkPCoHUoSSHDiSii1fdbnT6Jx
	 LnlD0LHOND8KCJhjqLKxP+TCjg2KNJHpYJjPow1Txee+pL3D0ya8dA77B0z0M14h2MMSU
	 uL3zp4eNecaySjgFFM4n5489bnO5YOOQVB46WsbEeLrtS2H8khnq5tKpPa0sMrKDB4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyqRXX2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB2606A894;
	Thu, 12 Nov 2026 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyqRXX2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2F61F00923;
	Thu, 12 Nov 2026 20:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794515011;
	bh=echnUtSfnLWGNHxFYZIBhHwmjWZfhLaMzo8MtinsitI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iyqRXX2Q1vidatqj5X/VnXgVAF8Kq4shBpenzEnPfmNDdpD4wFamZlQC781jKlpnn
	 l6/ZpuvednzgPd0EdeCEDPmcgOMtaBq0ndLpDfwzbSZ1oUIqXNVeVs0yw5+tlVU/dD
	 Y3+SYgw2pbFnEPOxt5qLy4tM/Dzdy/7JEjJU+kUKIZPCPnulFhDogOzmDWhXAXemxm
	 avt0apaGSSlVVY5pAidwqSSo0RWCxbZrBSvm7lf1OuUbllnzo7eZ4R63ashPNSwr86
	 4XHTpMytCDkZRTEPozJ9U6iRhAHhQkYs6t79JPWzw+sQB0q3Nb1v10Dxss4pWEaq64
	 q06uhG/rDQpAg==
Date: Thu, 12 Nov 2026 20:23:29 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	dm-devel@lists.linux.dev, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 1/2] crypto: x86 - remove aegis128 support
Message-ID: <20261112202329.GA815040@google.com>
References: <20261112164419.1769428-4-ardb+git@google.com>
 <20261112164419.1769428-5-ardb+git@google.com>
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
In-Reply-To: <20261112164419.1769428-5-ardb+git@google.com>

On Thu, Nov 12, 2026 at 05:44:17PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Even the people that are invested in Aegis appear to have lost interest
> in aegis128: it did win the CAESAR competition but is no longer covered
> by RFC 10032, which does list some other variants that competed as well.
> 
> So let's delete it.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

AEGIS-128 might be used by dm-crypt, e.g. if anyone passed
'-c aegis128-random' to cryptsetup.  I added dm-devel and Milan Broz to
Cc to comment on the feasibility of removing it.

But clearly AEGIS-128 is a mistake.  It has a hardcoded amount of
parallelism that is much too small for current CPUs.  That was very
clear when I looked into optimizing it with AVX-512: it just does not
work, and it uses only a quarter of the CPU's resources.

That's resulted in AES-GCM now being much faster, as well as the people
promoting AEGIS having abandoned AEGIS-128 and now advocating entirely
for other variants like AEGIS-128X4 instead (despite that unfortunately
still having a hardcoded amount of parallelism).

AEGIS-128 doesn't fare super well on the nonce front either, with it not
being nonce-misuse-resistant, and its 128-bit nonce being only an
incremental upgrade over AES-GCM's 96-bit nonce.  (Compare to
XChaCha20Poly1305's or XAES-256-GCM's 192-bit nonce, or to AES-GCM-SIV
which is nonce-misuse-resistant.)

So yes, this seems to have become yet another odd legacy thing that
doesn't really make sense to use.  If anyone does use it, it is likely
mainly because the kernel's existing, already-highly-optimized
XChaCha20Poly1305 code hasn't yet been wired up to dm-crypt, or because
they relied on outdated information about AEGIS-128's performance.

- Eric
