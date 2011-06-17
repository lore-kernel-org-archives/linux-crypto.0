From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/5] clocksource: add support for entropy-generation
 function
Date: Fri, 17 Jun 2011 22:52:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.02.1106172247070.11814@ionos>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308002818-27802-3-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:46834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab1FQUwe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2011 16:52:34 -0400
In-Reply-To: <1308002818-27802-3-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 13 Jun 2011, Jarod Wilson wrote:
> Add a new function pointer to struct clocksource that can optionally be
> filled in by clocksources deemed to be high enough resolution to feed
> the random number generator entropy pool.

Uurrg.
 
> + * @entropy:		random entropy pool addition function (optional, and
> + *			requires a fairly high-resolution clocksource)

Why do you want to do that ? Looking at the implementations of TSC and
HPET it's the same code. We really do not want to add that all over
the place. We can make that a property flag and the entropy function
common to the core code.

> +/**
> + * Do we have at least one clocksource that can generate entropy?
> + */
> +bool clocksource_entropy_available(void)
> +{
> +	struct clocksource *src;
> +	bool entropy_possible = false;
> +
> +	mutex_lock(&clocksource_mutex);
> +	list_for_each_entry(src, &clocksource_list, list) {
> +		if (src->entropy) {
> +			entropy_possible = true;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&clocksource_mutex);
> +
> +	return entropy_possible;
> +}
> +EXPORT_SYMBOL(clocksource_entropy_available);

That should be evaluated when clocksources are registered not at some
random point in time, which might return total nonsense as it's not
guaranteed that the clocksource which has the entropy property is
going to end up as the current clocksource.

> +/**
> + * Call the clocksource's entropy-generation function, if set
> + */
> +void clocksource_add_entropy(void)
> +{
> +	if (!curr_clocksource->entropy)
> +		return;

Why restricting it to the current clocksource? We can use the best
registered one for this which has the entropy property set.

> +	curr_clocksource->entropy(curr_clocksource);
> +}
> +EXPORT_SYMBOL(clocksource_add_entropy);
> +
>  #ifdef CONFIG_SYSFS
>  /**
>   * sysfs_show_current_clocksources - sysfs interface for current clocksource
> -- 
> 1.7.1
> 
> 
