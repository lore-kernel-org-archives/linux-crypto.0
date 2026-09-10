Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C7149BD74;
	Thu, 10 Sep 2026 14:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050212; cv=none; b=XjlI6Ew1ZckaHU+uMRa4B39ori134ROXnE69XvvTXRdNmM7a4DndUkGNk+dMu6CBAfv0LvHmioq4cNW5DrJWxYjtBaVSR3ErEWOsRONlcoc9VVMoXFQZR5KVKKHx2FRLY+Pq9tLyi7w5218lVEo8IdrBrTzsTtg0ESXPc5AOspw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050212; c=relaxed/simple;
	bh=oQLfe0josw0afgf5qbypjfJkfaRgUMkwMRxthXux920=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOgLqTAVkn1YkUS/ednn6pYe4iUQ/udGHmJV9uQkB/Z4dOYeOmrckf+l6cjHb+CGudBrjp9K1r8POi2kXCmtkBHg+b+njxf3BLBd3Rcqz0gdNox2hgkxQPrTMAI32i4O/t8DfmNhq2aOSXuHuMv94MDDdmrC9Azp+DP6h2OE3p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D1meaicj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D1meaicj"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 60AA540E01DD;
	Thu, 10 Sep 2026 14:23:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JlEgMq8cfcwl; Thu, 10 Sep 2026 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789050195; bh=oazBnerJKBXfynp5uGUgQGCP5CJIKWsROgSUMUbl4yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D1meaicjse+es/+8OSM9lXaQVJ22Ma8RICYFH+AKCVCVtmrIEV50ALRE1EIaKXaaO
	 zUz983449jzmJzwfllrEDiPSDk+NDzDt+n1J1sBFavIj4kDdN+zE1YnIgBs7H2P9d9
	 mcpPTfbPDTeZhklPoT7pWxFmOlGoT2vOzbv3eajeBP9g5rNGK7Fi7UKYqB5a1Dqps4
	 TJfhj9EJoZj0FXuAyFeuAW+NCHjPB+CS3YcAOkioiBkz2YiABsTfCueSf+mW+SXIRx
	 qd3em2EQ7l9u8pSKrzT5Bqv2ho1agTxx1RoeUrWB2BV2RUMg0ebjNa17HUu3ON6e7d
	 nVQ02h/1AaLAfriIgs+TNjHxHc+VY+GYOnoJlk9GHbPu7kJ9EIo9C9aXnVgb6PMn5I
	 TKLe8CXssgvuYzAeUvwc7XpkVWQhlNr6WtXZQ6zPvxC3czTysE75mmR9JgLSludc01
	 1jfcf4ruW7Sj6u1EXYE6F7d6I/nXg2uAX21EqH7q/0TjlUrFh9mNPOlWGo2XQaEgBf
	 VVRYB/lMQNCa0cxitws60mOodDHxp3zYn2kXrIdPVxWA9YtML9eXV8QLl0rAjh0pOi
	 Nix2IeAnQJxv2yvHcIHqSV6yddrGQEXRc186uIkRWFaEwGdEqRt8KtrIDHxe1wse9W
	 jiiPVvzzi4wMbo+xQmcAma3s=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C01DB40E00E8;
	Thu, 10 Sep 2026 14:23:05 +0000 (UTC)
Date: Thu, 10 Sep 2026 07:23:01 -0700
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
	linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 6/8] x86/fpu: Remove cpu_has_xfeatures()
Message-ID: <20260910142301.GAaqK9RVdjjmpwX876@fat_crate.local>
References: <20260901145740.42337-1-ebiggers@kernel.org>
 <20260901145740.42337-7-ebiggers@kernel.org>
 <20260910083801.GU4121339@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910083801.GU4121339@noisy.programming.kicks-ass.net>

On Thu, Sep 10, 2026 at 10:38:01AM +0200, Peter Zijlstra wrote:
> Boris, can you have a look? For now I'm reverting this patch locally.

Yeah, I'll zap it from the x86/fpu lineup and then we can see how to fix up
everything later.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
