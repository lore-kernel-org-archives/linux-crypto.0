From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound
 workqueues
Date: Sun, 24 Mar 2013 11:55:06 -0700
Message-ID: <20130324185506.GA4378@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <20130320185708.GB31256@htj.dyndns.org>
 <CACvQF53=qgUHrr944D_70dZpT-EOMtPcz2+0JPp4kOnGPzAptQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
	fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Lai Jiangshan <eag0628@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:62200 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3CXSzR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Mar 2013 14:55:17 -0400
Content-Disposition: inline
In-Reply-To: <CACvQF53=qgUHrr944D_70dZpT-EOMtPcz2+0JPp4kOnGPzAptQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey, Lai.

On Mon, Mar 25, 2013 at 12:04:19AM +0800, Lai Jiangshan wrote:
> example:
> node0(cpu0,cpu1),node1(cpu2,cpu3),
> wq's cpumask: 1,3
> the pwq of this wq on the node1's cpumask: 3
> current online cpu: 0-2.
> so the cpumask of worker tasks of the pwq on node1 is actually cpu_all_mask.
> so the work scheduled from cpu2 can be executed on cpu0 or cpu2.
> we expect it is executed on cpu1 only.

Ah, right.  I was hoping to avoid doing pwq swaps on CPU hot[un]plugs
doing everything on possible mask.  Looks like we'll need some
massaging after all.

> It can be fixed by swapping pwqs(node's pwq <-> default pwq)
> when cpuhotplug. But could you reschedule this patchset to wq/for-3.11?

We're still only at -rc4 meaning we still have plenty of time to
resolve whatever issues which come up, so I think I'm still gonna
target 3.10.

> the whole patchset is more complicated than my brain.

It isn't that complex, is it?  I mean, the difficult part - using
multiple pwqs on unbound wq - already happened, and even that wasn't
too complex as it in most part synchronized the behaviors between
per-cpu and unbound workqueues.  All that NUMA support is doing is
mapping different pwqs to different issuing CPUs.

Thanks.

-- 
tejun
