Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B27F4409
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723271135; cv=none; b=t4M74Jrc41skAHzpCW2XxfG6Cq1PPSjljDbt2U0PcQytZ42eQs+C0398FEnRO3KwvY1PhcXVsaHQRrWJsYoZsyMULBg3qlyf0a7IuSCG8vVG7E249jmAopskCKXSZZRfZx10xQwW4ZjppPjUHBEkO4ayfKr8owdMN8vQifVSzWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723271135; c=relaxed/simple;
	bh=PwmieYPqlbqLH2s9iYCDezUramuuC7MKpbaR1UwFKx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCLY8uSvtSFDpBzxl3/qnwb4XkoCCBBvQLjAXV4iZSZbxW//FrEh98jbnExDWZz77jf0a20j7JDswOoobfikarIqH1aHrKuJikLzynYmmqfBgRkApNmbDt/XQbKBl6B7Swk2AafBqSvuwk6N7QDh2DK+6e/rszEY77QVoPYlSzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfPB-003is2-1Z;
	Sat, 10 Aug 2024 14:25:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:25:30 +0800
Date: Sat, 10 Aug 2024 14:25:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm - fix PREEMPT_RT issue in gcm_crypt()
Message-ID: <ZrcH2vEzP2EGytEp@gondor.apana.org.au>
References: <20240805182713.161198-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805182713.161198-1-ebiggers@kernel.org>

On Mon, Aug 05, 2024 at 11:27:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On PREEMPT_RT, kfree() takes sleeping locks and must not be called with
> preemption disabled.  Therefore, on PREEMPT_RT skcipher_walk_done() must
> not be called from within a kernel_fpu_{begin,end}() pair, even when
> it's the last call which is guaranteed to not allocate memory.
> 
> Therefore, move the last skcipher_walk_done() in gcm_crypt() to the end
> of the function so that it goes after the kernel_fpu_end().  To make
> this work cleanly, rework the data processing loop to handle only
> non-last data segments.
> 
> Fixes: b06affb1cb58 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Closes: https://lore.kernel.org/linux-crypto/20240802102333.itejxOsJ@linutronix.de
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 59 ++++++++++++++----------------
>  1 file changed, 28 insertions(+), 31 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
