From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Date: Tue, 15 Jul 2014 11:21:49 -0400
Message-ID: <20140715152149.GC19570@htj.dyndns.org>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
 <20140715133627.GS3588@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Ingo Molnar <mingo@kernel.org>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:57303 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGOPVx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2014 11:21:53 -0400
Content-Disposition: inline
In-Reply-To: <20140715133627.GS3588@twins.programming.kicks-ass.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 15, 2014 at 03:36:27PM +0200, Peter Zijlstra wrote:
> So, just to expand on this, we're already getting 'bug' reports because
> worker threads are not cgroup aware. If work gets generated inside some
> cgroup, the worker doesn't care and runs the worker thread wherever
> (typically the root cgroup).
> 
> This means that the 'work' escapes the cgroup confines and creates
> resource inversion etc. The same is of course true for nice and RT
> priorities.
> 
> TJ, are you aware of this and/or given it any throught?

Yeap, I'm aware of the issue but haven't read any actual bug reports
yet.  Can you point me to the reports?

Given that worker pool management is dynamic, spawning separate pools
for individual cgroups on-demand should be doable.  Haven't been able
to decide how much we should be willing to pay in terms of complexity
yet.

Thanks.

-- 
tejun
