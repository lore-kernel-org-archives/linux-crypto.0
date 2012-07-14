From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and for_each_worker_pool()
Date: Fri, 13 Jul 2012 21:27:03 -0700
Message-ID: <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-6-git-send-email-tj@kernel.org> <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, joshhunt00@gmail.com,
	axboe@kernel.dk, rni@google.com, vgoyal@redhat.com,
	vwadekar@nvidia.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	swhiteho@redhat.com, bpm@sgi.com, elder@kernel.org,
	xfs@oss.sgi.com, marcel@holtmann.org, gustavo@padovan.org,
	johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
	martin.petersen@oracle.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34782 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2GNE1Z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Jul 2012 00:27:25 -0400
In-Reply-To: <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Seeing code like this

+       return &(*nr_running)[0];

just makes me go "WTF?"

Why are you taking the address of something you just dereferenced (the
"& [0]" part).

And you actually do that *twice*, except the inner one is more
complicated. When you assign nr_runing, you take the address of it, so
the "*nr_running" is actually just the same kind of odd thing (except
in reverse - you take dereference something you just took the
address-of).

Seriously, this to me is a sign of *deeply* confused code. And the
fact that your first version of that code was buggy *EXACTLY* due to
this confusion should have made you take a step back.

As far as I can tell, what you actually want that function to do is:

  static atomic_t *get_pool_nr_running(struct worker_pool *pool)
  {
    int cpu = pool->gcwq->cpu;

    if (cpu != WORK_CPU_UNBOUND)
        return per_cpu(pool_nr_running, cpu);

    return unbound_pool_nr_running;
  }

Notice how there isn't an 'address-of' operator anywhere in sight
there. Those things are arrays, they get turned into "atomic_t *"
automatically. And there isn't a single dereference (not a '*', and
not a "[0]" - they are the exact same thing, btw) in sight either.

What am I missing? Are there some new drugs that all the cool kids
chew that I should be trying? Because I really don't think the kinds
of insane "take the address of a dereference" games are a good idea.
They really look to me like somebody is having a really bad drug
experience.

I didn't test the code, btw. I just looked at the patch and went WTF.

                Linus
