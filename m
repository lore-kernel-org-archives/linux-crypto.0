From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Thu, 21 Feb 2013 15:17:06 +0100
Message-ID: <51262C62.4040707@chronox.de>
References: <20130221140712.GA11550@fatphil.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Phil Carmody <pc+lkml@asdf.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130221140712.GA11550@fatphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 21.02.2013 15:07:12, +0100, Phil Carmody <pc+lkml@asdf.org> wrote:

Hi Phil,
> Apologies if this is misthreaded, I had to hand-craft the headers.
>
>> The patch offers an entropy generator based on CPU timing jitter. The 
>> entropy collector has the following properties:
>>
>> * it does not maintain any state and therefore does not need any seed
> What is this "pool" if it's not "state"?

There is no state between calls. Of course, you need a scratchpad to do
calculations.
>
>> /* Entropy pool of the RNG which is filled upon each request for entropy */
>> struct rand_data
> And, from looking at jitterentropy_entropy_calc(), it seems to think that
> the [source producing the] following sequence of timestamps:
>
> 1000, 1010, 1030, 1050, 1060, 1080, 1090, 1110, 1120, ...
> i.e. with absolutely metronomic deltas of 10, 20, 10, 20, 10, 20, ...
>
> has 4 bit of entropy per reading. I hope I don't have to explicitly say
> that it clearly it has 0 bits of entropy.

I can always hand-craft some deltas that the entropy heuristics come up
with a positive value although there is none. You can make the same
statement for the entropy calculation of random.c. So, that example is
not applicable. I am working on showing that the jitter has entropy. I
will come back.
>
> Entropy harvesting is quite hard - entropy estimation is unimaginably harder.

This is a statement that does not make sense. You CANNOT per definition
calculate entropy! The entropy calculation shall ensure that the
collector in the worst case is called as often to make sure that there
is enough entropy. In other circumstances, it shall just save time!

Ciao
Stephan

> Phil

-- 
| Cui bono? |
