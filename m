From: Paolo Bonzini <pbonzini@redhat.com>
Subject: single_task_running() vs. preemption warnings (was Re: [PATCH] kvm:
 fix preemption warnings in kvm_vcpu_block)
Date: Thu, 17 Sep 2015 18:45:00 +0200
Message-ID: <55FAEE0C.60904@redhat.com>
References: <1442507270-67227-1-git-send-email-dingel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	herbert@gondor.apana.org.au, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-crypto@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442507270-67227-1-git-send-email-dingel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 17/09/2015 18:27, Dominik Dingel wrote:
> +			preempt_disable();
> +			solo = single_task_running();
> +			preempt_enable();
> +
>  			cur = ktime_get();
> -		} while (single_task_running() && ktime_before(cur, stop));

That's the obvious way to fix it, but the TOCTTOU problem (which was in
the buggy code too) is obvious too. :)  And the only other user of
single_task_running() in drivers/crypto/mcryptd.c has the same issue.

In fact, because of the way the function is used ("maybe I can do a
little bit of work before going to sleep") it will likely be called many
times in a loop.  This in turn means that:

- any wrong result due to a concurrent process migration would be
rectified very soon

- preempt_disable()/preempt_enable() can actually be just as expensive
or more expensive than single_task_running() itself.

Therefore, I wonder if single_task_running() should just use
raw_smp_processor_id().  At least the TOCTTOU issue can be clearly
documented in the function comment, instead of being hidden behind each
of the callers.

Thanks,

Paolo
