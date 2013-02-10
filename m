From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Sun, 10 Feb 2013 20:32:37 +0100
Message-ID: <5117F5D5.8040709@chronox.de>
References: <51157686.9000404@chronox.de> <20130209180629.GD8091@thunk.org> <20130210015751.GA13690@unpythonic.net> <5117969A.1080909@chronox.de> <20130210185002.GA10801@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Jeff Epler <jepler@unpythonic.net>,
	linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:40895 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761058Ab3BJTcl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Feb 2013 14:32:41 -0500
In-Reply-To: <20130210185002.GA10801@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10.02.2013 19:50:02, +0100, Theodore Ts'o <tytso@mit.edu> wrote:

Hi Ted,
> On Sun, Feb 10, 2013 at 01:46:18PM +0100, Stephan Mueller wrote:
>> However, the CPU has timing jitter in the execution of instruction. And
>> I try to harvest that jitter. The good thing is that this jitter is
>> always present and can be harvested on demand.
> How do you know, though, that this is what you are harvesting?


...

Given all your doubts on the high-precision timer, how can you
reasonably state that the Linux kernel RNG is good then?

The data from add_timer_randomness the kernel feeds into the input_pool
is a concatenation of the event value, the jiffies and the get_cycles()
value. The events hardly contains any entropy, the jiffies a little bit
due to the coarse resolution of 250 or 1000 Hz. Only the processor
cycles value provides real entropy.

Now you start doubting that with arguments that the resolution of that
processor cycle timer is very coarse. If this is the case, why shall I
trust random.c, especially considering the measurements observable
events like key strokes, mouse movements, interrupts (network cards).
Only if you have a high-precision time stamp, entropy can be derived
from these events.

Moreover, I cannot understand your comments on VMs -- on x86, the timer
depends on the rdtsc instruction which should be available on current
CPUs and is callable from user space. Hence, there should be no obstacle
to use this instruction within a VM and get a good reading.

Note, I will make measurements about the distribution of the timer
values and will come back to you.

Thanks
Stephan

-- 
| Cui bono? |
