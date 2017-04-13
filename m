From: David Miller <davem@davemloft.net>
Subject: Re: [patch V2 13/13] crypto: n2 - Replace racy task affinity logic
Date: Thu, 13 Apr 2017 10:51:03 -0400 (EDT)
Message-ID: <20170413.105103.1861501727952285713.davem@davemloft.net>
References: <20170412200726.941336635@linutronix.de>
        <20170412201043.231299672@linutronix.de>
        <alpine.DEB.2.20.1704131019420.2408@nanos>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@kernel.org, bigeasy@linutronix.de, benh@kernel.crashing.org,
        fenghua.yu@intel.com, herbert@gondor.apana.org.au,
        jiangshanlai@gmail.com, lenb@kernel.org, mpe@ellerman.id.au,
        rjw@rjwysocki.net, tj@kernel.org, tony.luck@intel.com,
        viresh.kumar@linaro.org, linux-crypto@vger.kernel.org
To: tglx@linutronix.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1704131019420.2408@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 13 Apr 2017 10:20:23 +0200 (CEST)

> spu_queue_register() needs to invoke setup functions on a particular
> CPU. This is achieved by temporarily setting the affinity of the
> calling user space thread to the requested CPU and reset it to the original
> affinity afterwards.
> 
> That's racy vs. CPU hotplug and concurrent affinity settings for that
> thread resulting in code executing on the wrong CPU and overwriting the
> new affinity setting.
> 
> Replace it by using work_on_cpu_safe() which guarantees to run the code on
> the requested CPU or to fail in case the CPU is offline.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
