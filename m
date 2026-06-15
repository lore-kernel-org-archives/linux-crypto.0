Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E03911CA;
	Mon, 15 Jun 2026 21:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781558244; cv=none; b=FuQ79qhTm/fiAcXtRwhhRzsyw/x+jaMe89P7ZDNmS9Ero2FSskFo7rtK+68tRsqREOZdo6O+HF7Da08Th97LZLrrSWXlcM0AKUfXtwUSCFlkuAySJS9FcvRZo2MvcOVE7PgtE0u5i1HFiyoGzw9nXFMswKSglZHgDPvfx/8nEDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781558244; c=relaxed/simple;
	bh=q4pUUCKGzahPcFx2bdr90hQWoOMtRr7Cg7dbll2HD1Q=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=axZTy3B5+XxHXfAdZ4xTsTeWkAvChjdp66Yl9M5pTIj+LAsurWAQPyxAAOd0OqVm8QqhNF1Ntj6exHnKXNKNBygunxFlOKZD2FF3wzCcAUu8mr4z/9J9lTh69jlgogdz1YlD2q21jg1f/vaibJ9YhLr3uFDaNssLML2HcWcV0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZZ/8E7x9; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZZ/8E7x9"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3B37640E01B4;
	Mon, 15 Jun 2026 21:17:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id X38PDWbl-Y-v; Mon, 15 Jun 2026 21:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781558230; bh=cX9p7efhFe8c45IXIwsevPcp+JvdUpUWzONDHj8uRVU=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=ZZ/8E7x9t6IHdYWKr95+cs3W8Fy0clhB40/6+W0QXnZEdiHssRRgoBFOcgX1bAxmY
	 dCT6zlWauEhd9vSQBeyMwgWnYGdruMCcSMtif0b3++dNRD47m06pkK5+CUzWNkqTZO
	 E2kXSRqfJH624gV8NOUkBANhIl53Ran7ybwAQewoSyQdDvjZIi4n9JCG+1o6aKuNys
	 mtiUG2zGqmRNlCkr6l75btoAFslNUIgf1hFkxXEaW3GQD4s6qWOlgIrND/VHK6ypx3
	 DRZGZ2Qx0yOAO7C4DnIxLLv29qD8EmXPhtwkDJ38Jcxm5+3Lv7jp/dRo979MeUisxW
	 jo3It11O6ppmHT2W9EnNZKMZGibmndiBVll6NeIm9DG7bsStm3NiiHTdai1dP/f6T0
	 lgM17slo8uVNGsUhoIFYh3oAWU7aEn1h7V4q5Dr/VzAPDyADRtVWcfdAhsm7u0Ogvv
	 ZwNz8LNM0QsfnKvOvqRJ+vnSciQ0GgpCFpoMq1Yqf60xc1yp4GjFEn6f5h6mTSietW
	 sMHvJj2GMTzWIMUpp+YO4YLIG36d1YrubqWce/upqkQW1yjG1uno5pwc2JA8PSw/5o
	 pNbaQF/83zv5jSSGUk8AUwe75kq2nJIBwm21jnGgySafIr0GjaGuKDkoc79tjNTwPh
	 eVfF1QJ1CJr+o9W/zfaDvsF4=
Received: from ehlo.thunderbird.net (mobile-166-177-248-195.mycingular.net [166.177.248.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 85B2E40E00B8;
	Mon, 15 Jun 2026 21:17:01 +0000 (UTC)
Date: Mon, 15 Jun 2026 21:16:55 +0000
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org
CC: Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
 David Laight <david.laight.linux@gmail.com>, linux-raid@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
User-Agent: K-9 Mail for Android
In-Reply-To: <20260615201050.GB1764@quark>
References: <20260615190338.26581-1-ebiggers@kernel.org> <20260615201050.GB1764@quark>
Message-ID: <255CAE3E-7FD3-4DC2-B3DE-46BE67EF22A8@alien8.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 15, 2026 8:10:50 PM UTC, Eric Biggers <ebiggers@kernel=2Eorg> wrote=
:
>
>But I wanted to ask: do we really care about the case where features are
>"supported" but their XCR0 bits aren't set?  Perhaps the kernel just
>doesn't/shouldn't support weird cases like "-cpu max,xsave=3Doff"?
>

Yes, our aim is to support only configurations which are actually present =
in real hardware and not a "oh, it would be good if it did that, just becau=
se=2E=2E=2E"

>If this case indeed needs to be handled, could we make things easier for
>the kernel's AVX and AVX-512 optimized code?  Currently AVX-512 needs:
>
>        if (boot_cpu_has(X86_FEATURE_AVX512F) &&
>            cpu_has_xfeatures(XFEATURE_MASK_FP | XFEATURE_MASK_SSE |
>                              XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, N=
ULL))
>
>How about we make X86_FEATURE_AVX512F depend on XCR0=3D111xx111, and
>X86_FEATURE_AVX depend on XCR0=3Dxxxxx111?  Then the cpu_has_xfeatures()
>check wouldn't be needed=2E  Is there any reason not to do that?

 How do you want to accomplish that? Very early during boot on the BSP you=
 sanity-check XCR0 and clear feature flags if components are not set?=20

Thx=2E

--=20
Small device=2E Typos and formatting crap
