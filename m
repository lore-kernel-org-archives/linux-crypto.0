From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Date: Mon, 14 Jul 2014 10:51:31 -0700
Message-ID: <1405360291.2970.702.camel@schen9-DESK>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
	 <1405110784.2970.655.camel@schen9-DESK>  <53C0FF16.40902@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: tkhai@yandex.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbaGNRwA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Jul 2014 13:52:00 -0400
In-Reply-To: <53C0FF16.40902@yandex.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2014-07-12 at 13:25 +0400, Kirill Tkhai wrote:

> >  
> > +unsigned long nr_running_cpu(int cpu)
> > +{
> > +	if (cpumask_test_cpu(cpu, cpu_online_mask))
> > +		return cpu_rq(cpu)->nr_running;
> > +	else
> > +		return 0;
> > +}
> > +
> 
> Offline cpu should have nr_running equal to 0. We park last
> enqueued thread (migration_thread) at the end of take_cpu_down().
> 
> So, it's enough to return cpu_rq(cpu)->nr_running.

Thanks.  This seems reasonable.

Tim
