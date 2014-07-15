From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Date: Tue, 15 Jul 2014 11:40:58 -0700
Message-ID: <1405449658.2970.797.camel@schen9-DESK>
References: <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
	 <1405364908.2970.729.camel@schen9-DESK>
	 <20140714191504.GO9918@twins.programming.kicks-ass.net>
	 <1405367450.2970.750.camel@schen9-DESK>
	 <20140715095045.GV9918@twins.programming.kicks-ass.net>
	 <20140715120728.GR3588@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
Received: from mga02.intel.com ([134.134.136.20]:44620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093AbaGOSl2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2014 14:41:28 -0400
In-Reply-To: <20140715120728.GR3588@twins.programming.kicks-ass.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2014-07-15 at 14:07 +0200, Peter Zijlstra wrote:
> On Tue, Jul 15, 2014 at 11:50:45AM +0200, Peter Zijlstra wrote:
> > So you already have an idle notifier (which is x86 only, we should fix
> > that I suppose), and you then double check there really isn't anything
> > else running.
> 
> Note that we've already done a large part of the expense of going idle
> by the time we call that idle notifier -- in specific, we've
> reprogrammed the clock to stop the tick.
> 
> Its really wasteful to then generate work again, which means we have to
> again reprogram the clock etc.

Will try another version of the patch without using the idle notifier.

Tim
