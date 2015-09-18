From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: single_task_running() vs. preemption warnings (was Re: [PATCH]
 kvm: fix preemption warnings in kvm_vcpu_block)
Date: Fri, 18 Sep 2015 09:52:15 +0200
Message-ID: <20150918075215.GR3816@twins.programming.kicks-ass.net>
References: <1442507270-67227-1-git-send-email-dingel@linux.vnet.ibm.com>
 <55FAEE0C.60904@redhat.com>
 <20150917190752.27396fdb@BR9TG4T3.de.ibm.com>
 <1442521975.6240.13.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	herbert@gondor.apana.org.au, Ingo Molnar <mingo@redhat.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442521975.6240.13.camel@schen9-desk2.jf.intel.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 17, 2015 at 01:32:55PM -0700, Tim Chen wrote:
> I have no objection to change single_task_running to use
> raw_smp_processor_id.  The worker in mcryptd is bound to
> the cpu so it has no migration/preemption issue.  So it shouldn't care
> which smp_processor_id version is being used.  Yes, please add a comment
> to alert the user of this caveat should you change single_task_running.


We actually have raw_rq() for that, and the whole if thing looks rather
superfluous. So something like the below, except with a suitable comment
on and tested etc.. ;-)

---
 kernel/sched/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6ab415aa15c4..f39c0498e284 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2666,10 +2666,7 @@ unsigned long nr_running(void)
  */
 bool single_task_running(void)
 {
-	if (cpu_rq(smp_processor_id())->nr_running == 1)
-		return true;
-	else
-		return false;
+	return raw_rq()->nr_running == 1;
 }
 EXPORT_SYMBOL(single_task_running);
 
