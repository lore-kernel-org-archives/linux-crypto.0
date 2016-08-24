From: Fabio Estevam <festevam@gmail.com>
Subject: Re: crypto: mxs-dcp: do not call blocking ops when !TASK_RUNNING; state=1
Date: Wed, 24 Aug 2016 19:52:23 -0300
Message-ID: <CAOMZO5DWBoVYfK67faj_i=YVUGE3aODCs0-s3-rbDjy7Y3ckFg@mail.gmail.com>
References: <140047983.403523.225ddbfe-fd96-4f9b-a2b9-e0173af882ba.open-xchange@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:33617 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932337AbcHXWww (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 18:52:52 -0400
Received: by mail-ua0-f180.google.com with SMTP id 74so55058611uau.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 15:52:25 -0700 (PDT)
In-Reply-To: <140047983.403523.225ddbfe-fd96-4f9b-a2b9-e0173af882ba.open-xchange@email.1und1.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stefan,

On Tue, Aug 23, 2016 at 5:38 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> Hi,
>
> i'm using a iMX233-OLinuXino board and i get the following warning during boot
> with 4.8.0-rc2-next-20160819:
>
> [    2.450000] ------------[ cut here ]------------
> [    2.450000] WARNING: CPU: 0 PID: 42 at kernel/sched/core.c:7602
> __might_sleep+0x8c/0xa0
> [    2.470000] do not call blocking ops when !TASK_RUNNING; state=1 set at
> [<c048f730>] dcp_chan_thread_aes+0x24/0x664

Did you select any debug option to observe such messages?

The kernelci boot log does not show this problem on a imx23-olinuxino
running linux-next:
https://storage.kernelci.org/next/next-20160824/arm-mxs_defconfig/lab-pengutronix/boot-imx23-olinuxino.html

We still have the errors below:

[    4.400000] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
[    4.410000] mxs-dcp: probe of 80028000.dcp failed with error -22

,but that's a different issue.

Regards,

Fabio Estevam
