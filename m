From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
 for_each_worker_pool()
Date: Fri, 13 Jul 2012 22:07:41 -0700
Message-ID: <20120714050741.GB7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-6-git-send-email-tj@kernel.org>
 <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
 <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, joshhunt00@gmail.com,
	axboe@kernel.dk, rni@google.com, vgoyal@redhat.com,
	vwadekar@nvidia.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	swhiteho@redhat.com, bpm@sgi.com, elder@kernel.org,
	xfs@oss.sgi.com, marcel@holtmann.org, gustavo@padovan.org,
	johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
	martin.petersen@oracle.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49402 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2GNFHu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Jul 2012 01:07:50 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey, Linus.

On Fri, Jul 13, 2012 at 10:00:10PM -0700, Linus Torvalds wrote:
> On Fri, Jul 13, 2012 at 9:44 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
> > array part, it's just returning the address of N'th element of the
> > array.  ARRAY + N == &ARRAY[N].
> 
> None of this matters one whit.
> 
> You did "&(x)[0]".
> 
> That's insane. It's crazy. It doesn't even matter what "x" is in
> between, it's crazy regardless.

Eh, from my previous reply.

| Ah okay, you're looking at the fifth patch in isolation.  Upto this
| point, the index is always 0.  I'm puttin it in as a placeholder for
| the next patch which makes use of non-zero index.  This patch is
| supposed to prepare everything for multiple pools and thus non-zero
| index.

The patch is about converting stuff to handle size-1 array without
introducing any actual behavior change so that the next patch can bump
the array size and just change the index.

Thanks.

-- 
tejun
