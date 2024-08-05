Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD4915382E
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722850466; cv=none; b=nusRTgqPo8TezUQfW+wPcfhxiKC4AIenV+5Z2er74NIDKl9gBihrWjZBAX5u3dLzmF1S7/hVxESE1DnOOIe2v4yXNtqBqvZgnKjvuhWIjd0Wq0xOL/yZTN19sOH9pTgcQ7GcFNpxMEdrN0RUCMZokMiAlCEkCYGtulmWmBxV8dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722850466; c=relaxed/simple;
	bh=w57TnR4ptMXUBp1wfScfm94bi5pNPi6ESOb3YcY3KYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzhK+Emw6nYuFdxeFqYxWo7ko2qA9jERnaCmioewcDg65gFExT5Xhq/vd7GW1SXnI+BCipkxMLQCWvr+JKjG5H2ZWonrEK+UF7M5f/LA86mvq7xBieM9PFFEQv+309QyaIiccCc7WSLyK6tdfFDeLtoUVlwOOmImZcozSx0L+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MklitRRb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VtIixYwD; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MklitRRb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VtIixYwD"
Date: Mon, 5 Aug 2024 11:34:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722850462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWNIz3IptDUR2+BfS00wCKZwWZ1Torsxtz6K0R0Eb4=;
	b=MklitRRbAFLxQFjYXbNenT0TYM7VrYzJFym6mnB26DqCn05HFxzAEsWwKvy2zW3WuESW8j
	3l8TFb5p2koRny2se9kLYtPO0edIquEmCZOxjyQ53ayG412ZfWuWI5Dpprkk+E+UWWRZIs
	S20x1qXDNodwPzr5ZlWOoNLTi9aKf+gwLPiUTwS0IlLPjMKG4PDpto1k2hwyvsYA9m44u4
	4VWbX8wjvouysiFhDTG+x1UjhP2hBowO6JxNPd1alDmnYxDAhGx6diNMa0okRHMH2no3on
	dApDSRXghxp7E/iH5iLaPSh4mLp4+wofn11D+yE8kBlcnrAMqRk0a74ePm6I5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722850462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JzWNIz3IptDUR2+BfS00wCKZwWZ1Torsxtz6K0R0Eb4=;
	b=VtIixYwDwLhQ7nxqIdxhwG+Dgso02j64ACEVN7FwGTFbG0ctiFtJh0M1j45mH/ktP+RfKL
	rxsWBxxKHForbUBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240805093420.wMcRg2tb@linutronix.de>
References: <20240802102333.itejxOsJ@linutronix.de>
 <Zq17sZgSGueOsGiO@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zq17sZgSGueOsGiO@gondor.apana.org.au>

On 2024-08-03 08:37:05 [+0800], Herbert Xu wrote:
> On Fri, Aug 02, 2024 at 12:23:33PM +0200, Sebastian Andrzej Siewior wrote:
> > kernel_fpu_begin() disables preemption. gcm_crypt() has a
> > skcipher_walk_done() invocation within a preempt disabled section.
> > skcipher_walk_done() can invoke kfree() which requires sleeping locks on
> > PREEMPT_RT and must not be invoked with disabled preemption.
> > 
> > Keep FPU access enabled while skcipher_walk_done() is invoked.
> > 
> > Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index cd37de5ec4046..be92e4c3f9c7f 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
> >  			aes_gcm_update(key, le_ctr, ghash_acc,
> >  				       walk.src.virt.addr, walk.dst.virt.addr,
> >  				       nbytes, flags);
> > +			kernel_fpu_end();
> >  			err = skcipher_walk_done(&walk, 0);
> > +			kernel_fpu_begin();
> 
> What if the user already did a preempt_disable()? This would still
> be buggy, right?

Yes if it has been done explicitly by preempt_disable(). And I am
looking into explicit case of disabling preemption and trying to get rid
of it if I stumble upon one. This one just popped up on one of my boxes.

> The Crypto API allows this to be called with preemption disabled.
> 
> Cheers,

Sebastian
