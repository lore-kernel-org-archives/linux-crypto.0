Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558622;
	b=GViUIkOHvd23gV0DukPndXe6CTkhfDKgZ9A/hNuCzC6v+h/vLDzv85xs247auqtQl3BA
	 t+aXRtkEuLQD7q3VO3CPig4cYzcYpWoXS88FefuraN9OIfSkReB9ej/TolIOOEqudROm1
	 K2k9muuDA+wLse156HY5YmDg4+fVfnZTkvVoQhNTSYZsZPuYDE0R94fVJfeknQqDd/SK9
	 jobgNUHWY6/m8YZIUk9uY7aAAqs2DYgX95TRyMkUB/jckvJUwJGwTr1CtvSRuRaPDmhty
	 GKapuk+MfcW4w4H5Q+6xwp3gv+yCn96zTren3Fvkla8vwedehTN4iuPldsCW7IJuoEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558622;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=iX13ARQTEy2hudyOA7XybZNggDkpdP2KjEJecd5fksQ=;
	b=SsKsHcjR7lOiH1nDL1XiNJaMEF/YCIHm2za35X/itDw93qzwUSltcfg37P19Pi4s4MDz
	 sDZnhgNw7FA4+AuUrmO1Nk3J69yutmnNHHDQQnMWenOzqcfhF5CFzYPSjK8e+14Tmm1bf
	 I3Pj6dHPxEfzNnkVyvNf1c79dCd0tCzESqE+fGK1vBCa73RImKvk9yGDhrc3gBYXe7/sE
	 PnwKY7voVGZyoyuUKD2RrECSfKOZnDxjbwkzzTX9WmF96hTEjWrDKW2s+C+vxXf83GWk8
	 jsnWpHHXw3FNUnOGFquYUXeu+zouaZIm5ZSJrXT9sspZt4/aamDoZieqtzWtGArPKAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLzrHnNM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BBF606A33D
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLzrHnNM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5B1F000C4;
	Fri, 13 Nov 2026 08:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558622;
	bh=iX13ARQTEy2hudyOA7XybZNggDkpdP2KjEJecd5fksQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RLzrHnNM7b9G8hsIRSV7/nsD5teP/49mt3cvO0qjLktynBCYyJO6zN5PzS49srAQn
	 REXc11HLDonFNG28087LCPAO8F8Bxgu6p59JAYj15TMhV1R2/J67RNPa7Q67r2LgKP
	 mntdmTLPKcjLeX9abpYW9StnSW0NgrWq1bg9EsnnRKTJi9z1QTZ0c1apO8En3MO6CB
	 nVxOWsv0jlqBPYAcxhKgaFH4020rRQSAYuVs0efkiFClvfmm76nTSpQlkIEeo5q6nE
	 XPDSZIupU9UzAHW/VOCWqLY3SeshBSXVMvhh3nKITLDZN07e4oTYXi3WtnRZz68I6/
	 oaxzaFHQkxC0w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9DC8D1980058;
	Fri, 13 Nov 2026 03:30:20 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:30:20 -0500
X-ME-Sender: <xms:m8r2agNsl_uia519MCkxwK1heAAo15PRLeBevQJiuCbwJSjmDGJiPw>
    <xme:m8r2ahyD1jLWM6Bo4RrB-uU7prvOIR2mno56rALtSjj0XSlmEBZOUdRJ4uzFl1WpI
    PDuSs0YrATdUZ_ABPyMbmmZ76Hr05DxlOPl5fRl-YFACF-ZyMRw0xo>
X-ME-Proxy-Cause: dmFkZTGTjuiFI02bcru1Um3mj0IH5u6WRaa5J3FsCN3wkflYKwkhz1hDbt2mh9Z/c3xBg2
    uRWW2TguS8jPs+EGvIWNV6zjVW11uojOc6A0BjfNFF3GoCReAte9nkOCmWGg24v7qiPvWC
    EVwkNYc6+H42ubzZHqOKKpikTQj2xnW+KGPh2F6ZcxW/q8dVJW98R1lo7+bY0jZEVOQXku
    CgLQQ7wH2hSS2/+ydAjxjuu/EwHbw4gcJa/yPkix4THBIVgE6P0dovLb2Z27LTZGbctLji
    gbJ0T6YPt9XP1BXtgix/hRpILs8Per0ZU5Hr5zJScJz70fq+cdT6XavMii+yO1xvyPFRBo
    1YECbbYR11ykIHBcMimthDznHLFvOunVsLg4Tq6ocC/dGpDQX1qWm9jQcinIAyKjOjBj5e
    ADO1W5vokgv0o28LXq5jtiZvrsH55dJbnlVQUzt46ZIrZIoTpcdEthLaRbVxKok/9dhkC3
    Pg+hvmW2AmxaolWvmK6snLOiPtcNc12a4Nt2883xzDrXPMaRscjvSYhAzl96IGAiZU7KeO
    yLHVj7Qm8VL0Olu4/PQAdyBOGcSTmTLmttAxA3p89mwFgGkNyQTscrkLTLsUJ/2qSXTF5O
    o4OdclMa5rNb3Oy5svrKDYnx6MidGayijFgn6Bub86ojQyoWEeH5KVHSoXiw
X-ME-Proxy: <xmx:nMr2aoiwQFkDn4yuyOGEtlZY4oBP47MFf2XvtRfxeRvohDZ9a7hYDQ>
    <xmx:nMr2akub9sPcGOE0eQ18j6VEUjn57sQB3GW0MkeHpj9QDzzPJFERbQ>
    <xmx:nMr2ap7bbHtbWXeua2b2pBf5rgJSKfjEIBbIxkeL18QwD9RLqD9XHA>
    <xmx:nMr2agPmPriXeWCExLJ4qxhTE-gIZYL0iI6q-wJjpYFZrv6dIHS7UA>
    <xmx:nMr2antwqADE7TduMlXh5EbQrITdtwV0JBqxrtFd2pKouxlYtNgB0SoP>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 41822F80093; Fri, 13 Nov 2026 03:30:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AQWzzjFngA27
Date: Fri, 13 Nov 2026 09:29:59 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <9f210f72-5d8d-4a12-a4d1-b0dfc2d08142@app.fastmail.com>
In-Reply-To: <20261111201517.39989-1-ebiggers@kernel.org>
References: <20261111201517.39989-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Drop redundant check for AVX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 11 Nov 2026, at 21:15, Eric Biggers wrote:
> X86_FEATURE_AVX2 implies X86_FEATURE_AVX.  Simplify
> chacha_mod_init_arch() accordingly.
>
> (Note: as usual, arch/x86/kernel/cpu/cpuid-deps.c is non-enforcing: if a
> dependency isn't met, it warns and doesn't prevent booting.  However,
> that case doesn't occur in real CPUs and is unsupported.)
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
