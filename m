Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558649;
	b=0kwSOa2HimkPXvdUBVSv0NT4ndBfLMhbh5tSadDbbUBGXnIrmv1Ke6XsVd7gm8BYTR8V
	 iWP7OFVHjnvZlqWn50RX3rmZOHHIyzef4oy9tZpJ7mKoCPs1kbPjxXtYciyc3z340tRg9
	 JhVW6UfmaJl7e/OGc+XSbFwXYCHU1kL5ioYS8l+C7aT+KG8N4SJJJrfxbhSvAyg382Ewd
	 9x1xXwibK+PZXHZHBxrOXbSUo4sHg5ymb3Bg8AZcJrvZWrM+jY6tFHQqYwkVrQ5McTZcl
	 QahcpLisFr6RoFcguXRUFLwUVSQn+Su7KAFqwun7vwSl7CknUjM86Qn1YKLBwUfj/rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558649;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=uosHZwAVA/Wj59OFYqGYVPsgMvJJ0rwUoHUhYed4Ebc=;
	b=DBgNEKZtVZtSI6QJx5wEwZcNYAgc+HjcnPE+HTPpeQ1G/4k0RFvWIdFkCXS9HbfZkgRS
	 9i0BenKgS2zvVV41XVjPRz/+G8LEmbA3Rzz7BzlZ6lmXRXCwKO543NUn2nRSkbmneSdkq
	 6qo1wgyPDIz7kklfCJdFCX88cGVNsN6+UHLe6uEahK/JCk+Tr6MRo5gCinJz+rbM826CE
	 QZsyZb5YMgbE03YaTRH5iADbIgsQ4oCs+DAPLIlISzL06a2FhqrYA0fD8Ui0uzcO4prSX
	 nw5cQTX+72f577Aa9lmmE6xpXhpHumdTi8aCUkLz9soFKnedlIiXIb/m7EhQmlvE8PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKJLWuTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F0606A33D
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKJLWuTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70071F000C6
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558649;
	bh=uosHZwAVA/Wj59OFYqGYVPsgMvJJ0rwUoHUhYed4Ebc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mKJLWuTSKosZUh3n6wFviDVGdHu3RNOuRghsUk9e4mA4ZBqVPJnRm1+CNpUTjosI5
	 wf5GhEMeficF6mpXQKbNaGagiok1oMAHoUdpgBuFWi/qRJczJ8N5TLJN2/7v9Ic/LD
	 D3OAjc2Cw/hi3iGhzvpUQ0avw0qisvOBNiTBs/ka8LlxNFpiTXqC1eTk8KkTd/ZreS
	 PgWef4sTDyKRvXHKGruOyYaRb5JsZRmX5RHBcTzJ98+xApDpOFyWwg5jrwJEpFk1cg
	 orHYVuoepu4zbiQevS+vHEv59Jm6Dy71bNVJZoCP7uTzzB3BYpp5F06gySPw8Lhk8K
	 Vl1WkUwyLz2HQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id F323C1980058;
	Fri, 13 Nov 2026 03:30:46 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:30:46 -0500
X-ME-Sender: <xms:tcr2aglHvimQkHYm0o7isuMa6NAdPEn1relgfK0T3RmlQqR-2bl_MA>
    <xme:tcr2aqoosd9PWhDsvSA_RLL0JoaKelEM4WQe2x5qT-eXFoVghglJFw1BlGivgbiIc
    ZXgWVfr4OEZUkIqT6vitXajFW9uSX4diVJB4V3WLo6UtxbCtapEJnAf>
X-ME-Proxy-Cause: dmFkZTEgPMbuUIHK5w0w0TDINr6ulglGA6dQWqvb+vs6ifcfd4CN+oy/iWgWujgVAKq415
    SksEHV17HXaqGPfSA6AIOM7Gibh3Wi3b/fyY3YN6cIzWzHyF6AyPwhVOi+ca389EJXg/aH
    zmAn5vsvU+HBB6a6K82C0t8PLYoR4H4Cq4CfZq1yqY9DlV4gsMEHe1kl/7ABGSYIb2jlYa
    as82+EO2g+n/Wa3hwelc4R62hAuGixNxZ0f+GoJefBa4fzaM/Lb/nFGciirpaGyp63m+qh
    ENJ/PBVGRyHjz+11VnmPu4qm641nXWluojSCTHsS/2IsQg/tSt8Gkm5lA3o+pVGafk8OTz
    ZH9s4kCKMSx5wiqzWlLJ992knwjKWtNvZ7bzGr+7O8/hWvcIlSJbiixbS6obcY0fVbvOep
    BffHtfFgX+vi9Q2X1L1apLajjPQ5q9LelVms5uVr9Bfy11KQFSDUM2AkT/L7hevJhGfGD6
    Tf9hHOY/EIhZqQBBaKCDi/BmPNQafe6IfvCjvpotZ3Q6bK+Ho37WfVHKEld2n7aPgsF0pP
    2YZxhTk5iJbrSGCUf8ac1q6KPqE3ID+KdXxRsvM52OteI/ZzRCsf2kB84g123nRsrdbwvq
    IPbLm466Fq8PtGxbc/P9dIO9qUgcjDWmIx5oLmkm8q64MCeTA4WYSEqMoFUA
X-ME-Proxy: <xmx:tsr2al7Gslix6gImY68akQPTlYjVl8eBGtxpCLBE8noCqoOUwRgCXQ>
    <xmx:tsr2amkrcLwGujJ-xLJK5InXw_cZZqksjDjCTLRZziJhECHI6Itn8A>
    <xmx:tsr2amQsUl6q9bJDK6BtHN3HJEebnCsBm-thVEDWQJkPo9pv8xOzGA>
    <xmx:tsr2alEu_IRdjvo-F2zhGQuMTYC8IEaLfX_TPJYKwW0mMDOc0jz4vw>
    <xmx:tsr2arFNHogyW1-a7nb6uxTlLHvDyI51ZXFlBH0RUAfaopBZsNN9y5nA>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 95FBFF8008E; Fri, 13 Nov 2026 03:30:45 -0500 (EST)
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
X-ThreadId: ArPqs3zlMT6s
Date: Fri, 13 Nov 2026 09:30:24 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org
Message-Id: <6f5f6852-5cc5-401b-8a85-d5e863f9da3c@app.fastmail.com>
In-Reply-To: <20261111201436.39855-1-ebiggers@kernel.org>
References: <20261111201436.39855-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: x86/blake2s: Drop redundant checks for AVX and AVX512F
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 11 Nov 2026, at 21:14, Eric Biggers wrote:
> X86_FEATURE_AVX2 implies X86_FEATURE_AVX.  Similarly,
> X86_FEATURE_AVX512VL implies X86_FEATURE_AVX512F (and X86_FEATURE_AVX).
>
> Simplify blake2s_mod_init_arch() accordingly.  Also nest these checks
> under the block that sets the static key for blake2s_use_ssse3,
> mirroring the code that uses these static keys.
>
> (Note: as usual, arch/x86/kernel/cpu/cpuid-deps.c is non-enforcing: if a
> dependency isn't met, it warns and doesn't prevent booting.  However,
> that case doesn't occur in real CPUs and is unsupported.)
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/blake2s.h | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
