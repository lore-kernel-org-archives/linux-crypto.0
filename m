From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] padata: avoid race in reordering
Date: Tue, 4 Apr 2017 20:26:12 +0200
Message-ID: <20170404182612.GA3419@kroah.com>
References: <20170323112443.30843-1-Jason@zx2c4.com>
 <20170324141608.GA15370@gondor.apana.org.au>
 <CAHmME9radQrAeyWmwapLGg1RYD0wVz3ysAT_p19KD0fi4q=anQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41364 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752518AbdDDS0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2017 14:26:25 -0400
Content-Disposition: inline
In-Reply-To: <CAHmME9radQrAeyWmwapLGg1RYD0wVz3ysAT_p19KD0fi4q=anQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 04, 2017 at 01:53:15PM +0200, Jason A. Donenfeld wrote:
> Herbert applied this to his tree. It's probably a good stable
> candidate, since it's a two line change to fix a race condition.
> 
> On Fri, Mar 24, 2017 at 3:16 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >> Under extremely heavy uses of padata, crashes occur, and with list
> >> debugging turned on, this happens instead:
> >>
> >> [87487.298728] WARNING: CPU: 1 PID: 882 at lib/list_debug.c:33
> >> __list_add+0xae/0x130
> >> [87487.301868] list_add corruption. prev->next should be next
> >> (ffffb17abfc043d0), but was ffff8dba70872c80. (prev=ffff8dba70872b00).
> >> [87487.339011]  [<ffffffff9a53d075>] dump_stack+0x68/0xa3
> >> [87487.342198]  [<ffffffff99e119a1>] ? console_unlock+0x281/0x6d0
> >> [87487.345364]  [<ffffffff99d6b91f>] __warn+0xff/0x140
> >> [87487.348513]  [<ffffffff99d6b9aa>] warn_slowpath_fmt+0x4a/0x50
> >> [87487.351659]  [<ffffffff9a58b5de>] __list_add+0xae/0x130
> >> [87487.354772]  [<ffffffff9add5094>] ? _raw_spin_lock+0x64/0x70
> >> [87487.357915]  [<ffffffff99eefd66>] padata_reorder+0x1e6/0x420
> >> [87487.361084]  [<ffffffff99ef0055>] padata_do_serial+0xa5/0x120
> >>
> >> padata_reorder calls list_add_tail with the list to which its adding
> >> locked, which seems correct:
> >>
> >> spin_lock(&squeue->serial.lock);
> >> list_add_tail(&padata->list, &squeue->serial.list);
> >> spin_unlock(&squeue->serial.lock);
> >>
> >> This therefore leaves only place where such inconsistency could occur:
> >> if padata->list is added at the same time on two different threads.
> >> This pdata pointer comes from the function call to
> >> padata_get_next(pd), which has in it the following block:
> >>
> >> next_queue = per_cpu_ptr(pd->pqueue, cpu);
> >> padata = NULL;
> >> reorder = &next_queue->reorder;
> >> if (!list_empty(&reorder->list)) {
> >>       padata = list_entry(reorder->list.next,
> >>                           struct padata_priv, list);
> >>       spin_lock(&reorder->lock);
> >>       list_del_init(&padata->list);
> >>       atomic_dec(&pd->reorder_objects);
> >>       spin_unlock(&reorder->lock);
> >>
> >>       pd->processed++;
> >>
> >>       goto out;
> >> }
> >> out:
> >> return padata;
> >>
> >> I strongly suspect that the problem here is that two threads can race
> >> on reorder list. Even though the deletion is locked, call to
> >> list_entry is not locked, which means it's feasible that two threads
> >> pick up the same padata object and subsequently call list_add_tail on
> >> them at the same time. The fix is thus be hoist that lock outside of
> >> that block.
> >>
> >> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> > Patch applied.  Thanks.

Any clue as to what the git commit id is?

thanks,

greg k-h
