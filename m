From: Stephan Mueller <smueller@chronox.de>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Mon, 08 Jun 2015 14:44:47 +0200
Message-ID: <179222904.HonSY4bzy7@tachyon.chronox.de>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <20150608122502.GA29454@gondor.apana.org.au> <1433766990.1495.39.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Waiman Long <Waiman.Long@hp.com>,
	Ingo Molnar <mingo@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, fengguang.wu@intel.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46116 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbFHMsA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 08:48:00 -0400
In-Reply-To: <1433766990.1495.39.camel@twins>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 8. Juni 2015, 14:36:30 schrieb Peter Zijlstra:

Hi Peter,

> Adding Stephan to Cc.
> 
> On Mon, 2015-06-08 at 20:25 +0800, Herbert Xu wrote:
> > On Mon, Jun 08, 2015 at 03:21:09PM +0300, Andy Shevchenko wrote:
> > > On Fri, May 29, 2015 at 10:14 PM, Jim Davis <jim.epost@gmail.com> wrote:
> > > > Building with the attached random configuration file,
> > > 
> > > Hit the very same error against next-20150605.
> > > 
> > > The issue with that file we have no compiler optimization enabled. So,
> > > guys, how you would recommend to fix it?
> > 
> > Stephan, can we get rid of the no optimisation requirement?
> 
> Would something like
> 
> #pragma GCC push_options
> #pragma GCC optimize ("-O0")
> static __u64 jent_fold_time(struct rand_data *ec, __u64 time,
> 			    __u64 *folded, __u64 loop_cnt)
> {
> 	...
> }
> #pragma GCC pop_options
> 
> Be an option to allow the file to be compiled with regular optimizations
> enabled?

Yes, that is also possible. I was not aware of the fact that the optimization 
is the problem. I got another report fom Fengguang Wu about a compile issue on 
AVR32 which I found out relates to the same issue.

I will prepare a patch shortly.

-- 
Ciao
Stephan
