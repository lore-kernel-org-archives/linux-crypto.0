From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
 parallel.
Date: Fri, 11 Jan 2013 10:24:51 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B941514BF@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1357123173-32534-1-git-send-email-vakul@freescale.com>
	<20130105182556.87853b23jydihzk0@www.dalek.fi>
	<065BBB7616BCE543832A2EF096986B9414EFE5@039-SN2MPN1-011.039d.mgd.msft.net>
	<20130109154552.4163137574bb7de915017e21@freescale.com>
	<065BBB7616BCE543832A2EF096986B94150EC2@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130110095043.c609644407b8ebaa945db405@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:13575
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab3AKKY6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2013 05:24:58 -0500
In-Reply-To: <20130110095043.c609644407b8ebaa945db405@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Thursday, January 10, 2013 9:21 PM
> To: Garg Vakul-B16394
> Cc: Jussi Kivilinna; linux-crypto@vger.kernel.org
> Subject: Re: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in
> parallel.
> 
> On Thu, 10 Jan 2013 00:49:23 -0600
> Garg Vakul-B16394 <B16394@freescale.com> wrote:
> 
> > > From: Phillips Kim-R1AAHA
> > > Sent: Thursday, January 10, 2013 3:16 AM On Sat, 5 Jan 2013 17:14:13
> > > +0000 Garg Vakul-B16394 <B16394@freescale.com> wrote:
> > > > > From: Jussi Kivilinna [mailto:jussi.kivilinna@mbnet.fi]
> > > > > Sent: Saturday, January 05, 2013 9:56 PM
> > > > >
> > > > > Quoting Vakul Garg <vakul@freescale.com>:
> > > > >
> > > > > > This allows to test & run multiple parallel crypto ahash
> contexts.
> > > > > > Each of the test vector under the ahash speed test template is
> > > > > > started under a separate kthread.
> > > > >
> > > > > Why you want to do this?
> > > >
> > > > In its current form, we cannot test multiple simultaneous crypto
> > > sessions with tcrypt.
> > > > Crypto offload hardware accelerators are usually capable of
> > > > handling
> > > multiple session in parallel.
> > > > This patch allows to load such hardware.
> > >
> > > tcrypt can currently test offload engines with multiple
> > > single-session async requests.  So to test multiple _session_
> > > requests, why isn't the change to tcrypt simply to alternate keys in
> > > the request loop, as opposed to what this patch does, i.e.
> > > adding separate kthreads?  The number of sessions/keys to alternate
> > > can be added as a module parameter.
> > >
> > > > Even if offload accelerators are not present, multiple crypto
> > > > sessions
> > > can execute in parallel on Multicore.
> > >
> > > I think that's more in the area of PCRYPT.
> > >
> >
> >
> > > > > Does not this change make tcrypt give inconsistent results?
> > > > >
> > > >
> > > > Based on kernel scheduling of threads, this change can make tcrypt
> > > > give
> > > varying results in different runs.
> > > > For consistent results, we can use existing synchronous mode
> > > > crypto
> > > sessions.
> > >
> > > see above.  I'm not sure, but I think multithreading tcrypt should
> > > be left to the parallel crypto engine (PCRYPT) and Software async
> > > crypto daemon (CRYPTD).
> > [VG] IIUC, PCRYPT and CRYPTD provides infrastructure to execute crypto
> contexts under threads to achieve different things.
> > PCRYPT allows multiple crypto requests from a transform to execute in
> parallel.
> >
> > CRYPTD provides a daemon which executes crypto requests.
> > It is more like crypto hardware accelerator running in software (e.g.
> on a certain core of Multicore processor).
> >
> > My proposal is to add capability in tcrypt to launch multiple parallel
> crypto transforms.
> 
> but you can do that in a single thread - it's up to the algorithm
> implementation (be it a driver, pcrypt, sync s/w, etc.) to parallelize
> the requests appropriately for the underlying h/w.
> 
> > Currently, only one transform is active at any point of time.
> 
> so allocate multiple transforms at startup and round-robin through them
> in the single-threaded test loop?

Current tcrypt structure waits for a crypto job to complete before sending next one.
Even if I create multiple transforms at startup, they would still run serially if 
I use single thread. And if I do not wait for a response to previous job before 
sending next job (belonging to different transform), I have to do all the housekeeping
in same thread for co-relating responses to requests. Having multiple kthreads is a
convenient way to achieve the above as each kthread is responsible for only one
transform. Also multiple kthreads running on multiple cores may easily stress SEC
without single core becoming bottleneck.
 

> 
> btw, tcrypt's existing async cipher implementation (commit 3f3baf3
> "crypto: tcrypt - add test_acipher_speed") waits for request completion
> prior to submitting a new request - not good for h/w with parallel cipher
> capabilities.  Here's a version that suits the SEC4
> better:
> 
> http://marc.info/?l=linux-crypto-vger&m=128179098817896&w=2

Thanks. I will check this.
 

> 
> Kim
