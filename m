Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953D6474275;
	Wed,  5 Aug 2026 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785938032; cv=none; b=QV+iEy6x1SyQKjEI8LmRPPjeaQazuncqeHQBeYYIul9fHwzad+AwDBDai6l5GGLfdxVAmW8BBax1xzPZicjoflaSxrEFqv2yOLPLTE9NUJCphlI3Cf5srPsQI/AJJ95VbbcwVsd1OYRhMDesd4Alf0Rn1jIcv1gcTsSP1iWW+Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785938032; c=relaxed/simple;
	bh=EWBq/GNSoHrAzZlloleNbRp4/QLqwvYk+ctxWRG1edY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pv/KU+TlvjFbvpAz1TXU2y1yYdv0aAIyA8wa6JVUeZg1JJ+6W9CB83+mNjUKMHBbQCsRfYhf3qhrcW7rt3E1l1xHsMCBV8f4dO4wMcDVeD7haTW6GblXAvqNj9LV4ETx6+xziWoaX/hN6dc5AJCvhTH142oCJXivjqYUy0FywrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 41FE51EA8AF; Wed,  5 Aug 2026 21:53:42 +0800 (AWST)
X-Spam-Level: 
Received: from [IPV6:2001:8003:8802:7000::41b] (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 74AC81EA5E6;
	Wed,  5 Aug 2026 21:53:40 +0800 (AWST)
Message-ID: <ed14ca37-c2e0-485f-9c3f-2038b59bfa60@davidgow.net>
Date: Wed, 5 Aug 2026 21:53:37 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kunit: irq: Continue increasing hrtimer interval for
 longer
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>,
 stable@vger.kernel.org
References: <20260803181842.44648-1-ebiggers@kernel.org>
Content-Language: en-US
From: David Gow <david@davidgow.net>
In-Reply-To: <20260803181842.44648-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 04/08/2026 à 02:18, Eric Biggers a écrit :
> Currently, kunit_irq_test_timer_func() stops increasing the hrtimer
> interval as soon as some forward progress is made in each of softirq and
> task context.  Update it to use a more aggressive strategy: increase the
> interval as long as the hrtimer is running significantly faster than
> either context.
> 
> This resolves an occasional hang in the CRC and crypto library tests
> under qemu-system-s390x.  It was exposed by the change in the default
> preemption model on s390 from NONE to LAZY.  That seems to have exposed
> the issue by allowing some forward progress to be made while the actual
> system timer tick is still starved, preventing jiffies from increasing
> or the task context from making much progress towards max_iterations.
> 
> Fixes: 201ceb94aa1d ("kunit: irq: Ensure timer doesn't fire too frequently")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next
> 

Thanks. Nothing else is touching this, so taking it through 
libcrypto-next is fine.

Reviewed-by: David Gow <david@davidgow.net>

Cheers,
-- David

>   include/kunit/run-in-irq-context.h | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
> index bfe60d6cf28d..3802b6fb218e 100644
> --- a/include/kunit/run-in-irq-context.h
> +++ b/include/kunit/run-in-irq-context.h
> @@ -38,11 +38,13 @@ static enum hrtimer_restart kunit_irq_test_timer_func(struct hrtimer *timer)
>   	softirq_calls = atomic_read(&state->softirq_func_calls);
>   
>   	/*
> -	 * If the timer is firing too often for the softirq or task to ever have
> -	 * a chance to run, increase the timer interval.  This is needed on very
> -	 * slow systems.
> +	 * If the hrtimer is running much faster than the bh_work or the task,
> +	 * then it is firing too fast and might be starving those contexts as
> +	 * well as the actual system timer tick.  Increase the interval.
>   	 */
> -	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
> +	if (hardirq_calls >= 20 &&
> +	    (hardirq_calls / 2 > softirq_calls ||
> +	     hardirq_calls / 2 > task_calls))
>   		state->interval = ktime_add_ns(state->interval, 250);
>   
>   	if (!state->func(state->test_specific_state))
> 
> base-commit: 6d22ec26295c1412d765e3d687e46224fc332928

