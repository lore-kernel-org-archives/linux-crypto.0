From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 13/14] workqueue: implement NUMA affinity for unbound
 workqueues
Date: Sun, 31 Mar 2013 12:06:33 -0700
Message-ID: <20130331190633.GC7533@htj.dyndns.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
 <1364453020-2829-14-git-send-email-tj@kernel.org>
 <20130329224434.GC9862@htj.dyndns.org>
 <CACvQF50c3m3eMiGKctagoOe6s3uhehfFy733imBfnLKTXSqZ4A@mail.gmail.com>
 <CAOS58YOgwB4s4-2e528T6SV36pDxLS3Zx+b5eR0L2kQjiZBEnw@mail.gmail.com>
 <51571FA2.2050804@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lai Jiangshan <eag0628@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Jan Kara <jack@suse.cz>, fengguang.wu@intel.com,
	jmoyer@redhat.com, zab@redhat.com,
	LKML <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48101 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3CaTGi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 Mar 2013 15:06:38 -0400
Content-Disposition: inline
In-Reply-To: <51571FA2.2050804@cn.fujitsu.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello, Lai.

On Sun, Mar 31, 2013 at 01:23:46AM +0800, Lai Jiangshan wrote:
> But for unbound wq when cpuhotplug
> w/o NUMA affinity, works are    always   in the cpus  if   there is online cpu in wq's cpumask
> w/ NUMA affinity, .........   NOT always ........     even ....................................

Yeah, this is rather unfortunate but cpumask for unbound workqueue is
a completely new thing anyway and I think providing a similar
guarantee as per-cpu should be enough.  Things are much simpler that
way and requiring users which depend on hard affinity to take care of
flushing is reasonable enough and in line with how workqueue has
traditionally been working.

> > Workqueue's affinity guarantee is very specific - the work item owner is
> > responsible for flushing the work item during CPU DOWN if it wants
> > to guarantee affinity over full execution. 
> 
> Could you add the comments and add Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> for the patchset?

Sure thing.

Thanks.

-- 
tejun
