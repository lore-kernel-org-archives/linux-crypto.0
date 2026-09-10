Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492824A68B9;
	Thu, 10 Sep 2026 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789055074; cv=none; b=sQbf8bky5WWbd2OScr9PwDDAevS4tdhGeNAy2chrdLjWEOURME+xSW0KzBBeCB96eBv+tXbl8tMtK/JJkVGJJChtVT7W2TPThcaYSlfEuaZ0rtvLIP4o7s6TkCq4l8vwqha5JJAm0+cmtHFJ/IUrj3rpx54DOtJosYtEu/g7fpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789055074; c=relaxed/simple;
	bh=coc1EG/HQWXGMlOEl8xXjnMBy4TsNq0wc5rlF709jtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0UXHleoilTK7LRONkJ1Glz1i0NlYwSi+4Wot9sSMMLRQU9FLyn+hlQ0iT1/kKT3wLrakxDCaN8+PXn31QWu1g8cdRFlQIeW30WCW3civ0mdBT8Dc3D1nje+XTCvEbb0hsX6goeUk+fipi8zZopPu0ljipBCiIqOIVGS36Hes3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EYrhsW+V; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EYrhsW+V"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9045740E01ED;
	Thu, 10 Sep 2026 15:44:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xWqO-b47gyZP; Thu, 10 Sep 2026 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789055059; bh=ggfuCidWjl1FJRJIK2RNc9iSgXfrieeLUmrFlZQVRGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EYrhsW+Vi/NIPYQqx0qONq+iIuEX1lJtruEq7JxSA2YCeB6ozvDHXvYkoY+GrBdQA
	 lARnF+s90K1pIyh65RE1e01bQnOeUoY6uivpIVlsKFCuiTu/fl6QYJMZi0SdMWirss
	 AXbaSlcQcwz0u8sfgZWAyW7sQ+gey3jH01HcuAJ9ZjioBI4DQhlCdZgnsYd4Ou+JXV
	 6jUxXT0Y9fVLhurzXO+g3Tlu302nelO3m9/sSI5Njnf0hL4FpfZVUqLvfajxNd1Fh6
	 I89cHkFTEF88MDtwMhc7yaY5E49CvoiybRH5gzxsr+t6YOtVvssfs6AQ5y3V3XKwAs
	 gIxw1YVxf2dPZJDpXN3r3Hh+VWV0+WnIvpI+0a6lruy4Hf60POSqBxY/mbQhphASe+
	 Sxs46vpaGhix0/Xkebkb3p+cxrBmUDR9vuDbTgDLQHCMgZbxhVLM3va9toRgW4K0Yp
	 6W8ftcKQ2ft22iBR5eANBxMW480rfMe47RJFkKV7YogKYJxfhpa4xOp8d07UOhHucq
	 pWkep1KiQMiiF4AVNsWMSHFZHsEwQuk30j/u4xl+BJtQcHtm8DnbJdG1TiA+N74miw
	 QxVvkW0sPt/WD9fYWXwORoZI7FrmiOcQH/EGtf4HH7DLCAfofBF4Cd1K24acHdLVGi
	 gaWvW79roKfWgc4UwzrfG09A=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1EF8240E01DD;
	Thu, 10 Sep 2026 15:44:09 +0000 (UTC)
Date: Thu, 10 Sep 2026 08:44:07 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
	linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 6/8] x86/fpu: Remove cpu_has_xfeatures()
Message-ID: <20260910154407.GCaqLQR1uy639wTGAx@fat_crate.local>
References: <20260901145740.42337-1-ebiggers@kernel.org>
 <20260901145740.42337-7-ebiggers@kernel.org>
 <20260910083801.GU4121339@noisy.programming.kicks-ass.net>
 <20260910142301.GAaqK9RVdjjmpwX876@fat_crate.local>
 <20260910145933.GB5719@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910145933.GB5719@quark>

On Thu, Sep 10, 2026 at 09:59:33AM -0500, Eric Biggers wrote:
> How about just applying patches 1-5 and 7-8, and deferring the actual
> removal of cpu_has_xfeatures() to the next cycle?

Yeah, just did that, will push out tip/master after some testing.

> XFEATURE_MASK_OPMASK is just part of the AVX-512 state and it will be
> implied by X86_FEATURE_AVX512F.

Right, I wouldn't mind if we zap those cpu_has_xfeatures() in perf/core now
but then it'll need to merge x86/fpu... so perhaps waiting for the next cycle
is better.

I'm putting it on my todo, unless you wanna do it. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
