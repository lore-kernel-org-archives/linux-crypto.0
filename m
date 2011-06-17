From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 2/5] clocksource: add support for entropy-generation function
Date: Fri, 17 Jun 2011 17:19:37 -0400
Message-ID: <4DFBC4E9.902@redhat.com>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com> <1308002818-27802-3-git-send-email-jarod@redhat.com> <alpine.LFD.2.02.1106172247070.11814@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab1FQVUQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2011 17:20:16 -0400
In-Reply-To: <alpine.LFD.2.02.1106172247070.11814@ionos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thomas Gleixner wrote:
> On Mon, 13 Jun 2011, Jarod Wilson wrote:
>> Add a new function pointer to struct clocksource that can optionally be
>> filled in by clocksources deemed to be high enough resolution to feed
>> the random number generator entropy pool.
>
> Uurrg.
>
>> + * @entropy:		random entropy pool addition function (optional, and
>> + *			requires a fairly high-resolution clocksource)
>
> Why do you want to do that ? Looking at the implementations of TSC and
> HPET it's the same code. We really do not want to add that all over
> the place. We can make that a property flag and the entropy function
> common to the core code.
>
>> +/**
>> + * Do we have at least one clocksource that can generate entropy?
>> + */
>> +bool clocksource_entropy_available(void)
>> +{
>> +	struct clocksource *src;
>> +	bool entropy_possible = false;
>> +
>> +	mutex_lock(&clocksource_mutex);
>> +	list_for_each_entry(src,&clocksource_list, list) {
>> +		if (src->entropy) {
>> +			entropy_possible = true;
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&clocksource_mutex);
>> +
>> +	return entropy_possible;
>> +}
>> +EXPORT_SYMBOL(clocksource_entropy_available);
>
> That should be evaluated when clocksources are registered not at some
> random point in time, which might return total nonsense as it's not
> guaranteed that the clocksource which has the entropy property is
> going to end up as the current clocksource.
>
>> +/**
>> + * Call the clocksource's entropy-generation function, if set
>> + */
>> +void clocksource_add_entropy(void)
>> +{
>> +	if (!curr_clocksource->entropy)
>> +		return;
>
> Why restricting it to the current clocksource? We can use the best
> registered one for this which has the entropy property set.

Yeah, John had some similar suggestions, and locally, I've got a 
modified version that instead of adding entropy functions for each 
clocksource, adds an entropy rating, then the highest rated entropy 
clocksource gets used, but a common clocksource entropy function that 
calls the chosen clocksource's read function. The entropy clocksource 
function gets picked by way of another function similar to 
clocksource_select, called in all the same places.

However, since none of this is going to be viable until the random code 
is significantly restructured, I haven't bothered with posting any of 
the updates I've made. I can toss the delta out there if anyone really 
wants to take a look at it, but otherwise, I'll just sit on it until 
said restructuring happens.

-- 
Jarod Wilson
jarod@redhat.com
