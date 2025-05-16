Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F192C278E49;
	Fri, 16 May 2025 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747419231; cv=none; b=JbnEnoBScUULYCM0MBVxLJvzGfK/7SWblRG+zM9WuwLpoKpIg5fjdtH46UylPGoqq+FKv+ILUPCdxK2doriPyg0QzzdL6+eBt9RqtesneSxmBBtvGq0NIq36GgCnVHsTJZ5ekw54KKoIzvR5YM2AG2Lvl5XfiV0d9O68sYJJpu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747419231; c=relaxed/simple;
	bh=nk9hWC8USjjsnXE7l0I3tf5QzbuBujjdLKLOeQj64UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsfzzUHE8gbrMIAHVuHuxNjAjCJyADkZ1Qk/NwUTgS9k1/C5lg/TGrV32/16lW2Wa1W7xf8wDPKe4j09BhjwQAIh2MU4KfkXrqAu3n7Qs1D9YRfSJ2aDMUAmZjb+SYg9DR0yWLhglJJP69A7vb/k0LK4Cq0pzs67uz9sqPQDz8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JHfXhgCg; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JHfXhgCg"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E155940E0239;
	Fri, 16 May 2025 18:13:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sbE7yB2ZThj3; Fri, 16 May 2025 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1747419216; bh=KMY5vheIjhkx9qYtvgFR5OOu6wfNTli4ajAeliw3Xw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JHfXhgCgNzW/qOjuoJpwcya5E/wXO92fMPMmHqvlE+G+rau7CzWhNG7+N8k55TnC8
	 r6uVZ5MRyg2IlT9jDmr7zxa1xgoMrbhqB2P6EiX1HjwsCqBXTke+UoLLO0OuWKoTr+
	 /QA55EIjjpaMuTfM4QcGEifilNTdcgxQiGxxCGLuEgoB3IOJbCHxkfLKg+UPf8fBJd
	 nzeBE3DuCwDlfHWzXcbebmqtDSc0HfwufwoFxMd17mK4P+oQF6fwK4xQeAGwfHZzor
	 SKwMdPsss1w9jqqYDJZ/XiYbKZ9FEpmDTuyhL62tibVmT7oTMsKK3MLCdfpkAlRP6v
	 rejFpEWK2HksThVj+67mzBafIt8wf3zcDN/JTpE3RYyFANdT2QBiK1QdEy2VHnheb4
	 W4Sz9EiP0Z8WC/jOf811auLchzZJNv4X/9QwFzQupgSnAyqnMN848Qy6ZkPSEtmCz1
	 LW5kqfM7T8KWukvtx+wScud6iS8S4cmTRQTroTqiyfz2ZtrYeCvtEjDPdLlfM2JZwo
	 DVpYTnOhgWKnufBXLBls+nY+TopeqvqBeigywtLGiEHHHT7EMXraVYiDwlZDcxQYoI
	 YErEYNcyH/4xHiwZU24syv1qZz7PvsBvHwo2JtfUAoeiUY5dFgI5VHwYC9DEBg3g6f
	 +qBqyfssIE22gV3ERqupwDD0=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ACADB40E0196;
	Fri, 16 May 2025 18:13:28 +0000 (UTC)
Date: Fri, 16 May 2025 20:13:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jain@formenos.rohan.me.apana.org.au, Ayush <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/sha256 - Disable SIMD
Message-ID: <20250516181322.GGaCeAQjnIVQx_tX_R@fat_crate.local>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
 <aCcirrsFFrrRqf5A@gondor.apana.org.au>
 <aCcmJGuCnuyHmHbx@gondor.apana.org.au>
 <20250516170316.GD1241@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250516170316.GD1241@sol>

On Fri, May 16, 2025 at 10:03:16AM -0700, Eric Biggers wrote:
> That's silly.  We should just fix x86's irq_fpu_usable() to return false
> before the CPU is properly initialized. It already checks a per-cpu bool, so
> it shouldn't be too hard to fit that in.

Probably.

There's a fpu__init_cpu() call almost right after load_ucode_ap() which causes
this thing.

I'm not sure how much initialized stuff you need for SHA256 SIMD... perhaps
swap fpu__init_cpu() and load_ucode_ap() calls after proper code audit whether
that's ok.

Or add a "is the FPU initialized" check, as you propose, which is probably
easier.

As always, the x86 CPU init path is nasty and needs careful auditing.

> Using the generic SHA-256 code explicitly is also an option,

Or that.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
