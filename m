From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 13/13] crypto: n2 - Replace racy task affinity logic
Date: Thu, 13 Apr 2017 12:56:15 +0800
Message-ID: <20170413045615.GA21693@gondor.apana.org.au>
References: <20170412200726.941336635@linutronix.de>
 <20170412201043.231299672@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-crypto@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:58208 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751577AbdDMFim (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 01:38:42 -0400
Content-Disposition: inline
In-Reply-To: <20170412201043.231299672@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 12, 2017 at 10:07:39PM +0200, Thomas Gleixner wrote:
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
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
