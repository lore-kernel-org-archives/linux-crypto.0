From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] crypto: caam/qi - simplify CGR allocation, freeing
Date: Tue, 9 Oct 2018 19:11:01 +0200
Message-ID: <20181009171101.jk6lgdx4g5rnq7cm@linutronix.de>
References: <20181005125443.dfhd2asqktm22ney@linutronix.de>
 <20181008110937.29198-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181008110937.29198-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2018-10-08 14:09:37 [+0300], Horia Geantă wrote:
> CGRs (Congestion Groups) have to be freed by the same CPU that
> initialized them.
> This is why currently the driver takes special measures; however, using
> set_cpus_allowed_ptr() is incorrect - as reported by Sebastian.
> 
> Instead of the generic solution of replacing set_cpus_allowed_ptr() with
> work_on_cpu_safe(), we use the qman_delete_cgr_safe() QBMan API instead
> of qman_delete_cgr() - which internally takes care of proper CGR
> deletion.
> 
> Link: https://lkml.kernel.org/r/20181005125443.dfhd2asqktm22ney@linutronix.de
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Oh. No more usage of set_cpus_allowed_ptr(). Wonderful. Thank you.
 Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
for that.

Now that you shifted my attention to qman_delete_cgr_safe().
Could you please use work_on_cpu_safe() here instead
smp_call_function_single() with preempt_disable() around it?

Now, what is the problem with the CPU limitation? Is this a HW
limitation that you can access the registers from a certain CPU?

This still fails (silently) if the CPU is missing, right? If you can't
get around it, you could block the CPU from going offline. You could
register a HP notifier
	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, …

and the function would return -EINVAL if this is the special CPU. The
other thing would be forbid rmmod. This *could* work but if I remember
correctly, an explicit unbind can't be stopped.

Sebastian
