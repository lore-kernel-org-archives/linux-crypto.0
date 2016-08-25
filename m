From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: crypto: mxs-dcp: do not call blocking ops when !TASK_RUNNING;
 state=1
Date: Thu, 25 Aug 2016 06:44:25 +0200 (CEST)
Message-ID: <539610224.17415.b37ed0be-b9b4-4de6-871e-3fc62b44240e.open-xchange@email.1und1.de>
References: <140047983.403523.225ddbfe-fd96-4f9b-a2b9-e0173af882ba.open-xchange@email.1und1.de>
 <CAOMZO5DWBoVYfK67faj_i=YVUGE3aODCs0-s3-rbDjy7Y3ckFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        =?UTF-8?Q?Marek_Va=C5=A1ut?= <marex@denx.de>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:61849 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752541AbcHYEvS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2016 00:51:18 -0400
In-Reply-To: <CAOMZO5DWBoVYfK67faj_i=YVUGE3aODCs0-s3-rbDjy7Y3ckFg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Fabio,

> Fabio Estevam <festevam@gmail.com> hat am 25. August 2016 um 00:52
> geschrieben:
> 
> 
> Hi Stefan,
> 
> On Tue, Aug 23, 2016 at 5:38 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> > Hi,
> >
> > i'm using a iMX233-OLinuXino board and i get the following warning during
> > boot
> > with 4.8.0-rc2-next-20160819:
> >
> > [    2.450000] ------------[ cut here ]------------
> > [    2.450000] WARNING: CPU: 0 PID: 42 at kernel/sched/core.c:7602
> > __might_sleep+0x8c/0xa0
> > [    2.470000] do not call blocking ops when !TASK_RUNNING; state=1 set at
> > [<c048f730>] dcp_chan_thread_aes+0x24/0x664
> 
> Did you select any debug option to observe such messages?

yes, it's CONFIG_DEBUG_ATOMIC_SLEEP. After a short web search i found this lwn
article [1].
I will try the suggested solution.

Regards
Stefan

[1] - https://lwn.net/Articles/628628/

> 
> The kernelci boot log does not show this problem on a imx23-olinuxino
> running linux-next:
> https://storage.kernelci.org/next/next-20160824/arm-mxs_defconfig/lab-pengutronix/boot-imx23-olinuxino.html
> 
> We still have the errors below:
> 
> [    4.400000] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
> [    4.410000] mxs-dcp: probe of 80028000.dcp failed with error -22
> 
> ,but that's a different issue.
> 
> Regards,
> 
> Fabio Estevam
