From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: mxs-dcp: do not call blocking ops when !TASK_RUNNING;
 state=1
Date: Thu, 25 Aug 2016 17:02:30 +0800
Message-ID: <20160825090230.GA11590@gondor.apana.org.au>
References: <140047983.403523.225ddbfe-fd96-4f9b-a2b9-e0173af882ba.open-xchange@email.1und1.de>
 <CAOMZO5DWBoVYfK67faj_i=YVUGE3aODCs0-s3-rbDjy7Y3ckFg@mail.gmail.com>
 <539610224.17415.b37ed0be-b9b4-4de6-871e-3fc62b44240e.open-xchange@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <festevam@gmail.com>, linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43092 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757887AbcHYJCj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 05:02:39 -0400
Content-Disposition: inline
In-Reply-To: <539610224.17415.b37ed0be-b9b4-4de6-871e-3fc62b44240e.open-xchange@email.1und1.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 25, 2016 at 06:44:25AM +0200, Stefan Wahren wrote:
> Hi Fabio,
> 
> > Fabio Estevam <festevam@gmail.com> hat am 25. August 2016 um 00:52
> > geschrieben:
> > 
> > 
> > Hi Stefan,
> > 
> > On Tue, Aug 23, 2016 at 5:38 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> > > Hi,
> > >
> > > i'm using a iMX233-OLinuXino board and i get the following warning during
> > > boot
> > > with 4.8.0-rc2-next-20160819:
> > >
> > > [    2.450000] ------------[ cut here ]------------
> > > [    2.450000] WARNING: CPU: 0 PID: 42 at kernel/sched/core.c:7602
> > > __might_sleep+0x8c/0xa0
> > > [    2.470000] do not call blocking ops when !TASK_RUNNING; state=1 set at
> > > [<c048f730>] dcp_chan_thread_aes+0x24/0x664
> > 
> > Did you select any debug option to observe such messages?
> 
> yes, it's CONFIG_DEBUG_ATOMIC_SLEEP. After a short web search i found this lwn
> article [1].
> I will try the suggested solution.

The problem is that the driver is setting the task state too early.
In fact, there is no reason why it should be using a kthread at all.
Someone should convert this over to a work queue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
