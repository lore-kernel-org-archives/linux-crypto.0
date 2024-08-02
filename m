Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2267316BE0A
	for <linux-crypto@vger.kernel.org>; Fri,  2 Aug 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722616116; cv=none; b=lKizwT4CIRQN2U8bHP8L8AT1vbmopE+IanzzXL1Mv6ZZjCU688KnwZ9H46JTptR5u/gyyjF7dZDzo76OVvrYQS14wscXJjZNzmt2blE1+aSIejwRQhLyiF1sdMQtkbWCrdliEjCuHJ/hijewOgjby+cdt/y3J0bzKBrwD4+A/Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722616116; c=relaxed/simple;
	bh=fvik2n5/xD8ZSztRsInQiPX0B+88XenNDZ3HLitgs5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=su+7MXNXRAnX1SfM/3oHCgm8XMThMi6nhUwn3B3mYYR8a9nOOfrQWWBolcyQ1ss/bvgspokSlWKjw0dIez6tJ8gV9+kKqmqq8YHZS66HwtITsoUKFmXG2SjkG9Q2quLsOVs4C0UbhV2Z7PD8rkG9JtFCk4CQTektIGXrAezHYto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cE3GVfhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cE3GVfhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68886C32782;
	Fri,  2 Aug 2024 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722616115;
	bh=fvik2n5/xD8ZSztRsInQiPX0B+88XenNDZ3HLitgs5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cE3GVfhv0BHMi3N2kO5MQKIivByXLcW5YQ2GU8yo55EXxNLAOl3FvwdOsBdO8U0mW
	 cPgAuK1HX7E0YSoCGs9GhgYjKHbtiSQQjUWG/yrzOs0hehx/LzrkziI849ubI7u6LP
	 7FH46h7gdWgb0n0GZMeARdMkjrXq4GRWA1rRV2D5KGe2GS0/Tb+mhhRk0scYiyhBWJ
	 4DTcMy5f/4w7KWL0tLLhuIh9e0AfbW6fASx7wOpPh4/AnL6Adl6HhdMwasOR3/mpF8
	 FcRy1iYEqLD/jvUQEFsaKY7K3uCwTaOSzOtcUwN/lblSwkBZM6LalWzrUCf4Uwtmp/
	 Jamcpp5lvr2LA==
Date: Fri, 2 Aug 2024 09:28:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240802162832.GA1809@sol.localdomain>
References: <20240802102333.itejxOsJ@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802102333.itejxOsJ@linutronix.de>

Hi Sebastian,

On Fri, Aug 02, 2024 at 12:23:33PM +0200, Sebastian Andrzej Siewior wrote:
> kernel_fpu_begin() disables preemption. gcm_crypt() has a
> skcipher_walk_done() invocation within a preempt disabled section.
> skcipher_walk_done() can invoke kfree() which requires sleeping locks on
> PREEMPT_RT and must not be invoked with disabled preemption.
> 
> Keep FPU access enabled while skcipher_walk_done() is invoked.
> 
> Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index cd37de5ec4046..be92e4c3f9c7f 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
>  			aes_gcm_update(key, le_ctr, ghash_acc,
>  				       walk.src.virt.addr, walk.dst.virt.addr,
>  				       nbytes, flags);
> +			kernel_fpu_end();
>  			err = skcipher_walk_done(&walk, 0);
> +			kernel_fpu_begin();
>  			/*
>  			 * The low word of the counter isn't used by the
>  			 * finalize, so there's no need to increment it here.

Can you make this conditional on CONFIG_PREEMPT_RT so that it doesn't hurt
performance for everyone else?

Note that kfree() lacks a might_sleep(), and its kerneldoc does not say that it
can sleep.  Have you checked for other instances of this same problem?  It seems
it would be quite common kernel-wide.  Is it really necessary that kfree() takes
a sleepable lock on PREEMPT_RT?

- Eric
