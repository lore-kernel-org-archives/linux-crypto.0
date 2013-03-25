From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET wq/for-3.10] workqueue: NUMA affinity for unbound
 workqueues
Date: Mon, 25 Mar 2013 13:48:07 -0700
Message-ID: <20130325204807.GA26033@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <20130320185708.GB31256@htj.dyndns.org>
 <CACvQF53=qgUHrr944D_70dZpT-EOMtPcz2+0JPp4kOnGPzAptQ@mail.gmail.com>
 <20130324185506.GA4378@htj.dyndns.org>
 <20130325191500.GA12767@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
	fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Lai Jiangshan <eag0628@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64510 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3CYUsP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Mar 2013 16:48:15 -0400
Content-Disposition: inline
In-Reply-To: <20130325191500.GA12767@htj.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 25, 2013 at 12:15:00PM -0700, Tejun Heo wrote:
> On Sun, Mar 24, 2013 at 11:55:06AM -0700, Tejun Heo wrote:
> > > the whole patchset is more complicated than my brain.
> > 
> > It isn't that complex, is it?  I mean, the difficult part - using
> > multiple pwqs on unbound wq - already happened, and even that wasn't
> > too complex as it in most part synchronized the behaviors between
> > per-cpu and unbound workqueues.  All that NUMA support is doing is
> > mapping different pwqs to different issuing CPUs.
> 
> Oh, BTW, please feel free to rebase your patchset on top of the
> current wq/for-3.10.  I'll take care of the conflicts with the numa
> one, if there are any.

Sorry, never mind.  I'm cherry picking wq->mutex patches.  Will apply
the rebased versions in a couple hours.  Let's base everything else on
top of those.

Thanks.

-- 
tejun
