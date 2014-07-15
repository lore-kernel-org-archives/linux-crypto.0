From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Date: Tue, 15 Jul 2014 22:46:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407152244310.24854@nanos>
References: <1405110784.2970.655.camel@schen9-DESK>  <20140714101611.GS9918@twins.programming.kicks-ass.net>  <1405354214.2970.663.camel@schen9-DESK>  <20140714161432.GC9918@twins.programming.kicks-ass.net>  <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>  <1405364908.2970.729.camel@schen9-DESK>  <20140714191504.GO9918@twins.programming.kicks-ass.net>  <1405367450.2970.750.camel@schen9-DESK>  <20140715095045.GV9918@twins.programming.kicks-ass.net>
 <20140715120728.GR3588@twins.programming.kicks-ass.net>  <alpine.DEB.2.10.1407151452370.24854@nanos> <1405449665.2970.798.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
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
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:51197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963AbaGOUrU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jul 2014 16:47:20 -0400
In-Reply-To: <1405449665.2970.798.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 15 Jul 2014, Tim Chen wrote:
> On Tue, 2014-07-15 at 14:59 +0200, Thomas Gleixner wrote:
> > On Tue, 15 Jul 2014, Peter Zijlstra wrote:
> > 
> > > On Tue, Jul 15, 2014 at 11:50:45AM +0200, Peter Zijlstra wrote:
> > > > So you already have an idle notifier (which is x86 only, we should fix
> > > > that I suppose), and you then double check there really isn't anything
> > > > else running.
> > > 
> > > Note that we've already done a large part of the expense of going idle
> > > by the time we call that idle notifier -- in specific, we've
> > > reprogrammed the clock to stop the tick.
> > > 
> > > Its really wasteful to then generate work again, which means we have to
> > > again reprogram the clock etc.
> > 
> > Doing anything which is not related to idle itself in the idle
> > notifier is just plain wrong.
> 
> I don't like the kicking the multi-buffer job flush using idle_notifier
> path either.  I'll try another version of the patch by doing this in the
> multi-buffer job handler path.
>  
> > 
> > If that stuff wants to utilize idle slots, we really need to come up
> > with a generic and general solution. Otherwise we'll grow those warts
> > all over the architecture space, with slightly different ways of
> > wreckaging the world an some more.
> > 
> > This whole attidute of people thinking that they need their own
> > specialized scheduling around the real scheduler is a PITA. All this
> > stuff is just damanging any sensible approach of power saving, load
> > balancing, etc.
> > 
> > What we really want is infrastructure, which allows the scheduler to
> > actively query the async work situation and based on the results
> > actively decide when to process it and where.
> 
> I agree with you.  It will be great if we have such infrastructure. 

You are heartly invited to come up with that. :)
