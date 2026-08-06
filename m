Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D33E46E003;
	Thu,  6 Aug 2026 11:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786016203; cv=none; b=enWTpS7KjRXNsuv+d6e3zVRN9o3YcJ/8XLFyw3PE8OTCTaKLYq4888oyGm+3uPDW5IvXJWrDr1TVnZEubXX6mimG1uwnQw+U/h1oT3FjoswlBL2gOp/WV+0b+/xfmoiex8qNBjngJLgPhSXHEN4wn4nOj5nxfmupdrLFGTXmatg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786016203; c=relaxed/simple;
	bh=uiRFkOUABBUWYfxWQL6aj/dfNx0mDkmt3C6LzWKGEY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubolyY1F3YoWDaCLpHDH0DkAeXiOa70jUlLK+KtEoYf5lYjQRoJtPPVhdEqqVBPGYLOBVptiOZP6Il5Dq+Ld0H5jef/NB2yuqGrNtHFTYl4HJtwL9UurJ8a+bEqih6NI6OZa7Bvo+32poj/6KF7gPEtr0lOB3JAGL1vaWHMxcZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 787531EA9BD; Thu,  6 Aug 2026 19:36:34 +0800 (AWST)
X-Spam-Level: 
Received: from [IPV6:2001:8003:8802:7000::9c4] (unknown [IPv6:2001:8003:8802:7000::9c4])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id E9FD61EA9B6;
	Thu,  6 Aug 2026 19:36:31 +0800 (AWST)
Message-ID: <dae41fe0-60ff-4fa7-a7dc-2a3947aa08bb@davidgow.net>
Date: Thu, 6 Aug 2026 19:36:30 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kunit: irq: Unregister on-stack timer and work from
 debugobjects
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>
References: <20260806053804.106724-1-ebiggers@kernel.org>
From: David Gow <david@davidgow.net>
Content-Language: fr
In-Reply-To: <20260806053804.106724-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 06/08/2026 à 1:38 PM, Eric Biggers a écrit :
> In kunit_run_irq_test(), call destroy_hrtimer_on_stack() and
> destroy_work_on_stack() to unregister the hrtimer and work from the
> debugobjects infrastructure (when CONFIG_DEBUG_OBJECTS_TIMERS=y and
> CONFIG_DEBUG_OBJECTS_WORK=y) before the function returns.
> 
> Found via code review; the lack of the unregistrations didn't actually
> cause a warning, since the objects are inactive upon return anyway.  But
> they should be there, otherwise debugobjects keeps tracking the objects.
> 
> Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Nice catch, thanks!

Reviewed-by: David Gow <david@davidgow.net>

Cheers,
-- David

> 
>  include/kunit/run-in-irq-context.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
> index 3802b6fb218ed..b46fa1696360c 100644
> --- a/include/kunit/run-in-irq-context.h
> +++ b/include/kunit/run-in-irq-context.h
> @@ -137,6 +137,8 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
>  	/* Cancel the timer and work. */
>  	hrtimer_cancel(&state.timer);
>  	flush_work(&state.bh_work);
> +	destroy_hrtimer_on_stack(&state.timer);
> +	destroy_work_on_stack(&state.bh_work);
>  
>  	/* Sanity check: the timer and BH functions should have been run. */
>  	KUNIT_EXPECT_GT_MSG(test, atomic_read(&state.hardirq_func_calls), 0,
> 
> base-commit: 4bceb5614e0fc0338d6787f39df5472bfd72eaab

