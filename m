From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu
 where applicable
Date: Thu, 12 Jul 2012 10:06:18 -0700
Message-ID: <20120712170618.GB20167@google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-4-git-send-email-tj@kernel.org>
 <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
	vgoyal@redhat.com, vwadekar@nvidia.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
	elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
	gustavo@padovan.org, johan.hedberg@gmail.com,
	linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
To: Tony Luck <tony.luck@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50580 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2GLRGY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jul 2012 13:06:24 -0400
Content-Disposition: inline
In-Reply-To: <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, Tony.

On Tue, Jul 10, 2012 at 04:30:36PM -0700, Tony Luck wrote:
> On Mon, Jul 9, 2012 at 11:41 AM, Tejun Heo <tj@kernel.org> wrote:
> > @@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
> >          */
> >         WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
> >                      pool->nr_workers == pool->nr_idle &&
> > -                    atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> > +                    atomic_read(get_pool_nr_running(pool)));
> >  }
> 
> Just had this WARN_ON_ONCE trigger on ia64 booting next-20120710. I
> haven't bisected ... just noticed  that two patches in this series tinker
> with lines in this check. next-20120706 didn't generate the WARN.

Sorry about the delay.  The warning is spurious.  As now there are
multiple pools, nr_running check should be done before
pool->nr_workers check.  Will post fix soon.

Thank you.

-- 
tejun
