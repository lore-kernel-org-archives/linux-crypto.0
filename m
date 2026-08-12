Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B755F374187;
	Wed, 12 Aug 2026 20:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565118; cv=none; b=hrnYanXShcFPl/KmFhNgGpoVTv9RSLdVCoB1/loL9MJoIQJcZexz9X6deC6LAaT8ilXfoZD3bHORFYf1u+QRo+m/Q/xN0+HEsLkYFb7BdgDSJrygR8aqDqzAZQx99ttWDtXfaPxMg+ZNc/xndHWJNyMaKdpiBwg3e+qvVedNqns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565118; c=relaxed/simple;
	bh=4vhTRc1/dX1D34Vcc2xvEiUy1eUBo/ZiHS7drQU0aoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvKBSPsYwmbdwloHij4q0cdMYWvFqCRMKsIyA03RPH5D1OiIsiWuX8f87Snv7NBHlHnF4pElptTcWdzlOfND21L5GdGbVRkl6Zs53YuZ4RH5K0IlXHl48ZrNBA2ZqHTv5Q+dRtjzFbQnIme9+ZSFAW3ArFzN2lYlIxlJVXoWFnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fk9bQ2GF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fk9bQ2GF"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7926B40E019E;
	Wed, 12 Aug 2026 20:05:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9NTlaYtYKV85; Wed, 12 Aug 2026 20:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786565103; bh=6dBQkg+AiyaWmAjZedH4XYQHET6jIziOv8yV3K7UfrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fk9bQ2GFg0WBzx1knvI7zfntSMNhLYqZLQEOY6NMnq4GdSpAhHnEjaoqhLr+XzkeL
	 tSkRf8BTrFumNd5LJwzwyONszFhqBVt/yvTPQVT6jRSFgWfH/6jG3t2XGasNX/4uW/
	 bvG+ufYtZe8UK4YLGXxnGOYMws1Q/vqFBXP7fIoHCvHjkA1ohrKeFgZ98uOnSeE+cN
	 djrO0d7cDTyLpWZ96j2wOg2crbfXpDasUrJ77KstV6OtvrJ1uJP891HMcIpHROiV7F
	 G8dy1tLNskNHyE7xtkfb1YCcuOG/iUPZ3zheo8ICTsHrI+/TwpO4GGcR5QNz6TL1wW
	 Qv9q9HP9tBgiQxk6ABjIzJXevfgrb0H11ItKIY8ltUgFvaUhfhrvrG+FyNKw9GlHea
	 b0kjcMfw5az+bwmHa5OET2dxiZCXYJXW4MTDpB5dPem2RHyRoOrmCEja86Rsdz9w2w
	 A3mUrD756oreZCqVd+nDTePWhAfZ7ZvEWSmRItUUmuqaQOmRkh24m6zvShmo860G12
	 T4V/V6ayvwjxj4l07TZCjl++DcJmQ6Hxqn2i22MYisa/53ICRAWmI5YxX2e617+ZSa
	 GNPvh+SdOi0cEa/UExeMlQ3DpdebFQFfngOXaww3BdIcd70w/jFxrxh5Nibl8wGIPr
	 EmSOCXEAD7Kk/j5eydk2G2kI=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D7F2F40E019C;
	Wed, 12 Aug 2026 20:04:54 +0000 (UTC)
Date: Wed, 12 Aug 2026 13:04:51 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260812200451.GCanzR41yxY2n_62fs@fat_crate.local>
References: <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
 <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
 <20260728183447.GB3355536@google.com>
 <20260728225936.GBamk0WK38PByPFkxz@fat_crate.local>
 <20260728233430.GA3277@quark>
 <20260728234726.GCamk_jnl3LtfGbxoC@fat_crate.local>
 <20260812174826.GAanyx6vUWv5GLX2AZ@fat_crate.local>
 <20260812194011.GA3734410@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260812194011.GA3734410@google.com>

On Wed, Aug 12, 2026 at 07:40:11PM +0000, Eric Biggers wrote:
> Interesting, so the !boot_cpu_has(X86_FEATURE_FPU) check is dead code
> since ab05214025ee ("x86/fpu: Remove MATH_EMULATION and related glue
> code").  Sure, there's no need to add anything to there then, though we
> should do a separate patch that removes it.

Sure.

> Sure, that works.  I'm not sure it's actually easier to understand than
> what I proposed; it's kind of contradictory to call
> "setup_clear_cpu_cap(X86_FEATURE_XSAVE)" when we just verified it is
> clear.  But the comment mentioning that it's actually for clearing
> dependent flags helps.  If you prefer this way, let's do this.

Yes please, that's why I added the comment. And we have this machinery in
do_clear_cpu_cap() so let's use it.

> It's functionally equivalent, but yes we can write it this way if you
> prefer.  Is it okay if I fold your diff (minus the pr_info()) into this
> patch?  (I'll also add FW_BUG to the error messages as Thomas
> requested.)

Yap, that's perfectly fine.

Thanks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
