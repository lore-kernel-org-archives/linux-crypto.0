Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7FA15A85A;
	Fri, 14 Aug 2026 00:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786667745; cv=none; b=HOq6/O18vPU7R51PLYwnB72FEZaVQAKjbSKHABQdJwIGiLwS2V4n/wVXx4aAt3UQTOMz2jCmZElOrFg7H/JwQUii54QT1Znx9IVYqOGMhNefeaIkbpwQqhLX6G4nSYoZJKNvrzWPY3dp4knJ0cmlfZ499hYPF1DG+hl+9Pl/0x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786667745; c=relaxed/simple;
	bh=60jlxKkV5uBLZyY4tOmtsm8Mqz6Bj0s6eY82iXIEHhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPKOAebSPwvP2xImslp7lYf2fA7zFnjbWBQ/NctCPP00G/We7kYtFP6bE1TOGR9T7OnaCF6LwE+Ch5W4CIRmitBYWxmP6+d0XvFjoOL3k2swkIh4iwqiUr3k1E58yo8sY89olPva4GS8RjlEwLFHEDc4oiAExPu5nfOClY+16hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Xt98E0gb; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Xt98E0gb"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E94C640E0031;
	Fri, 14 Aug 2026 00:35:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NvIvzpUUnXDM; Fri, 14 Aug 2026 00:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786667729; bh=s4whABqcvLZBqYt2AF3I5iHUkpSSVuAbE9B4+2NQSuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xt98E0gbcBvul2ZQZcLWwQ5acfXZXvWs4JojSzhUpv84WHQZqehIWYwBzvoCt+XhF
	 x8rv+eKtKf3PGy4bVy8gCblj6e9fbBZKBmJ7zYB4SwG+U0rXHcA8nHLHhgjOr/qkGl
	 O+Aa8rpN1H2eG6qYtF4ywR5A9yVeo+j1pXjhC192VHXwRwiRuTpvFwjJg/58v8tBlO
	 iDzULM6jjUiWjmqa6dHqLR6/2dx2ilDiIjEsuruPmkNtqG1gIaisUDbIK96zi9jk18
	 6Mvv2UZ9s+6EdFrxElmNWJxkDeo7Ahy9rscBF4pLiAJB3T/9+egdKY2WwE4/Pmkv9x
	 g6zEOPF8k4M3PxpKUkUytIMkHaTelhUQvuLUJk2sx3bVt6gT6RN/bB5nabISpvOjNP
	 A2GrB5ovG8wjRDcvx6CyZr9hhRJHTipVAT/PH7nulS2Jrf9WMsKscR5vD5ZuMUGxqE
	 AuRuBOgfVCo2s0zNKGAB1l7FC5yFjJ27C+dhsxuVpnPkS5dAHf+/Mg308F12aiuU9E
	 rKnP0uVpPoczg4NGe7NYhF38m3y/pD23F+RClGJTFdkAOEpkuUGGBO2x3jvvFiVjoj
	 RSIfYTqmyPvSc1lBXYCRjN1wZAaTs+CFuy+Icdi1onJug24Tf7p+2ORCGVHsw4+mak
	 we45huGjhTdaTDIzcdWWUfFI=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 44B5440E0171;
	Fri, 14 Aug 2026 00:35:21 +0000 (UTC)
Date: Thu, 13 Aug 2026 17:35:17 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512
 xor_gen()
Message-ID: <20260814003517.GBan5ixaTArd0Sf6X3@fat_crate.local>
References: <20260813021506.55129-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260813021506.55129-1-ebiggers@kernel.org>

On Wed, Aug 12, 2026 at 07:14:58PM -0700, Eric Biggers wrote:
> This series consolidates and cleans up how the kernel handles CPU
> feature flags for AVX and AVX-512 when the underlying OS or hypervisor
> (if any) doesn't enable the required xstate features in XCR0.
> 
> Specifically, it makes the checks for xstate features be done in a
> single place at boot time for both UML and native x86, instead of
> everywhere kernel code wants to check for AVX or AVX-512 support.
> 
> Patch 8 then adds an AVX-512 optimized implementation of xor_gen() for
> RAID, which had been blocked on confusion around cpu_has_xfeatures() and
> its lack of implementation on UML.

Sashiko complains about a missing VZEROUPPER there in patch 8:

https://sashiko.dev/#/patchset/20260813021506.55129-1-ebiggers%40kernel.org

Otherwise, LGTM.

I can queue them all into tip after the merge window opens.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
