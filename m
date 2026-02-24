Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4644C190462;
	Tue, 24 Feb 2026 09:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771923696; cv=none; b=OkbzoE60Qp/hjh8PGoiWuz6Sl/vCfA/87jCE8QiWvMaEZHKGJ6w9uRu6XmSQ/Tk4Fy+7ojYluZbCJVBzTqqgWnDYixgcbQBzO/MS869FTtR/xONip58LTTyVCkshXoqDOu21MdPZbcfLjMBpkGnCGuI3GyeIna9IebkhPwan+fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771923696; c=relaxed/simple;
	bh=pty0p3EkgQsMv5GqCnhpOyx0EMZJ0zKmu+67M/tExE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CDlJJYTaDItA184u9wd5m0pAwhgy+JFCQ4EFFpm7Ky05l9qmYz8c1eXlntvRn35CD/HZPPHCAf1uvrjbu+Dbxyj6VXNgbQgrJkGhFdigXftgk27mwnSxhomzLdnBP1eCT9tWF2k5KPkihFqHrMQpK++QmL85u/hiJoCzB2PJk1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b=lRgv4bTZ; dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b=fNwipv6W; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b="lRgv4bTZ";
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b="fNwipv6W"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1771923692;
	bh=pty0p3EkgQsMv5GqCnhpOyx0EMZJ0zKmu+67M/tExE8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lRgv4bTZvMupZejdLNOAfeW0fBmESQk+nEFcPSNeLSrRdXJhrQXjA8Xs+lSQ2VkDO
	 3MfmZeOSHAiHHg873mXQxwuB341Wbi+vjyCyWNi4//fE0ProOs1OGqfZxxKvqDPlTn
	 IYZLWjNBW21Xik23q8sKK8757dwyO746aCN/2MTDs23GD2SB9EzWURpjLdz8kQBkFw
	 47chRRLeW7g8HpRJVJYr7mnHWBAHfn25JznTiRPwpXjrUvmkzjtlyX/XTja8nKTXxJ
	 UeXXEKd2bCL9W59TZJ1OtAUjU48PcciruooIGABirXMURFFI1NONFzOHIPYoBZudT7
	 pYIVsFU+8a5scBsIxbNbSOHM5Q1R8L8BSY48plYUZIHBuMUZRV2qngODj23YiTns1V
	 PWHLsLfpjAolh7puAFpgwKVZ73Viu5LHYU+aDEeO3kIX95Ca1iSKOwRfm2DlorC5v8
	 0GbzveJhMS7Kmqw4yEoZK46/gia173kivtwPQhyQEafO3EnuQcJ2vK5cf7IO7w7m9+
	 dHxI64KttFO+oq8IDufh2r+qcd6I5vRTCM2N8vRAJ9hPvmuBfWOBLrk8obx2seO1hz
	 6W+IQtBlJj26600g3UzUgmwGOeu6CWjtLQXz2/3vWiLMIsK+JDbQJkQiw/VNHdkbW0
	 44YjVbXjg42Z5xikNo5sdPuo=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id E5AD41E78B6; Tue, 24 Feb 2026 17:01:32 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1771923691;
	bh=pty0p3EkgQsMv5GqCnhpOyx0EMZJ0zKmu+67M/tExE8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fNwipv6WKQoKAH3qAW1VgWlotPhOh0t6cMqzyD6DoT501nVeQXwe6ZgiE63OwBoUK
	 xcyncTsZ51ymNreqaqMczKtuCSC9+AhWdsp0ql+nwu54HvG9ekv5pzpmI0SGTkqtvZ
	 YcJJJUq420QzdXewAGcnBRUng+3+I4ytWTWZLHeJQnA8Xj3XC3GVU1hKPr/sDgbJbe
	 ls07JJ9kfex+fBI4YK8wUI4gn7A+ACpEWhlRdyYuUSxNeTVvADd1iRM7BOgRxQ1QXC
	 zQ0vv9/tpnMwEJ3x8RS+zm5L4FaYEA/wqQZ8WQvMx7yk9s2Gwf0M9/UpF5QwXNE68t
	 TY0Pq9PnWobllMdGbUZCxVh88INHi+YBFUsJubwP6+MKVznfLUXPYMQHOEcBMhRZuQ
	 MUlWbT/PC/F2R0o1hq9enC31RzqqoJRuEpFCxaacQb8zFHqCPPCQuyJVaruCalQmS6
	 zVTmspdVK7gmVee9/uEiCn6Odd93EDHiIDy/TA2twKzZdatQ02HXUyszaYKIKT4XzA
	 ZN1A/XcOjeYunz8im7COIJOdF9UtunKQc5xIEjUgJQscQvrwwAm4qGGibEdHoS4inM
	 +PUr0BWha5zOnRCdtgJYulUjX58Wr1PLJ1MqFSbPQ2ldfi/gQdnuk0tvW7tdAw1rT6
	 7TBIwPRifKCJkZgvOvXUz/uI=
Received: from [IPV6:2001:8003:8824:9e00::744] (unknown [IPv6:2001:8003:8824:9e00::744])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id ABF171E778A;
	Tue, 24 Feb 2026 17:01:30 +0800 (AWST)
Message-ID: <75ea0056-605d-4f1c-ac49-76fb094744d1@davidgow.net>
Date: Tue, 24 Feb 2026 17:01:27 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kunit: irq: Ensure timer doesn't fire too frequently
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 Brendan Higgins <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>,
 stable@vger.kernel.org
References: <20260224033751.97615-1-ebiggers@kernel.org>
Content-Language: en-US
From: David Gow <david@davidgow.net>
In-Reply-To: <20260224033751.97615-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 24/02/2026 à 11:37, 'Eric Biggers' via KUnit Development a écrit :
> Fix a bug where kunit_run_irq_test() could hang if the system is too
> slow.  This was noticed with the crypto library tests in certain VMs.
> 
> Specifically, if kunit_irq_test_timer_func() and the associated hrtimer
> code took over 5us to run, then the CPU would spend all its time
> executing that code in hardirq context.  As a result, the task executing
> kunit_run_irq_test() never had a chance to run, exit the loop, and
> cancel the timer.
> 
> To fix it, make kunit_irq_test_timer_func() increase the timer interval
> when the other contexts aren't having a chance to run.
> 
> Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Looks good to me, thanks!

Reviewed-by: David Gow <david@davidgow.net>

Cheers,
-- David

> 
> This patch applies to v7.0-rc1 and is targeting libcrypto-fixes
> 
>   include/kunit/run-in-irq-context.h | 44 +++++++++++++++++++-----------
>   1 file changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/include/kunit/run-in-irq-context.h b/include/kunit/run-in-irq-context.h
> index c89b1b1b12dd5..bfe60d6cf28d8 100644
> --- a/include/kunit/run-in-irq-context.h
> +++ b/include/kunit/run-in-irq-context.h
> @@ -10,36 +10,47 @@
>   #include <kunit/test.h>
>   #include <linux/timekeeping.h>
>   #include <linux/hrtimer.h>
>   #include <linux/workqueue.h>
>   
> -#define KUNIT_IRQ_TEST_HRTIMER_INTERVAL us_to_ktime(5)
> -
>   struct kunit_irq_test_state {
>   	bool (*func)(void *test_specific_state);
>   	void *test_specific_state;
>   	bool task_func_reported_failure;
>   	bool hardirq_func_reported_failure;
>   	bool softirq_func_reported_failure;
> +	atomic_t task_func_calls;
>   	atomic_t hardirq_func_calls;
>   	atomic_t softirq_func_calls;
> +	ktime_t interval;
>   	struct hrtimer timer;
>   	struct work_struct bh_work;
>   };
>   
>   static enum hrtimer_restart kunit_irq_test_timer_func(struct hrtimer *timer)
>   {
>   	struct kunit_irq_test_state *state =
>   		container_of(timer, typeof(*state), timer);
> +	int task_calls, hardirq_calls, softirq_calls;
>   
>   	WARN_ON_ONCE(!in_hardirq());
> -	atomic_inc(&state->hardirq_func_calls);
> +	task_calls = atomic_read(&state->task_func_calls);
> +	hardirq_calls = atomic_inc_return(&state->hardirq_func_calls);
> +	softirq_calls = atomic_read(&state->softirq_func_calls);
> +
> +	/*
> +	 * If the timer is firing too often for the softirq or task to ever have
> +	 * a chance to run, increase the timer interval.  This is needed on very
> +	 * slow systems.
> +	 */
> +	if (hardirq_calls >= 20 && (softirq_calls == 0 || task_calls == 0))
> +		state->interval = ktime_add_ns(state->interval, 250);
>   
>   	if (!state->func(state->test_specific_state))
>   		state->hardirq_func_reported_failure = true;
>   
> -	hrtimer_forward_now(&state->timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL);
> +	hrtimer_forward_now(&state->timer, state->interval);
>   	queue_work(system_bh_wq, &state->bh_work);
>   	return HRTIMER_RESTART;
>   }
>   
>   static void kunit_irq_test_bh_work_func(struct work_struct *work)
> @@ -84,14 +95,18 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
>   				      void *test_specific_state)
>   {
>   	struct kunit_irq_test_state state = {
>   		.func = func,
>   		.test_specific_state = test_specific_state,
> +		/*
> +		 * Start with a 5us timer interval.  If the system can't keep
> +		 * up, kunit_irq_test_timer_func() will increase it.
> +		 */
> +		.interval = us_to_ktime(5),
>   	};
>   	unsigned long end_jiffies;
> -	int hardirq_calls, softirq_calls;
> -	bool allctx = false;
> +	int task_calls, hardirq_calls, softirq_calls;
>   
>   	/*
>   	 * Set up a hrtimer (the way we access hardirq context) and a work
>   	 * struct for the BH workqueue (the way we access softirq context).
>   	 */
> @@ -102,25 +117,22 @@ static inline void kunit_run_irq_test(struct kunit *test, bool (*func)(void *),
>   	/*
>   	 * Run for up to max_iterations (including at least one task, softirq,
>   	 * and hardirq), or 1 second, whichever comes first.
>   	 */
>   	end_jiffies = jiffies + HZ;
> -	hrtimer_start(&state.timer, KUNIT_IRQ_TEST_HRTIMER_INTERVAL,
> -		      HRTIMER_MODE_REL_HARD);
> -	for (int task_calls = 0, calls = 0;
> -	     ((calls < max_iterations) || !allctx) &&
> -	     !time_after(jiffies, end_jiffies);
> -	     task_calls++) {
> +	hrtimer_start(&state.timer, state.interval, HRTIMER_MODE_REL_HARD);
> +	do {
>   		if (!func(test_specific_state))
>   			state.task_func_reported_failure = true;
>   
> +		task_calls = atomic_inc_return(&state.task_func_calls);
>   		hardirq_calls = atomic_read(&state.hardirq_func_calls);
>   		softirq_calls = atomic_read(&state.softirq_func_calls);
> -		calls = task_calls + hardirq_calls + softirq_calls;
> -		allctx = (task_calls > 0) && (hardirq_calls > 0) &&
> -			 (softirq_calls > 0);
> -	}
> +	} while ((task_calls + hardirq_calls + softirq_calls < max_iterations ||
> +		  (task_calls == 0 || hardirq_calls == 0 ||
> +		   softirq_calls == 0)) &&
> +		 !time_after(jiffies, end_jiffies));
>   
>   	/* Cancel the timer and work. */
>   	hrtimer_cancel(&state.timer);
>   	flush_work(&state.bh_work);
>   
> 
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f

