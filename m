From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: Decreasing time for `rsa_init`
Date: Thu, 13 Jul 2017 20:20:41 +0200
Message-ID: <1499970041.1134.1.camel@molgen.mpg.de>
References: <4ec5a3f5-9605-cdcd-23cf-1df7b3af211c@molgen.mpg.de>
         <3649766.4rHtxdK8Pi@tauon.chronox.de>
         <8d89fefa-b27d-ba32-e7b2-75312549ee90@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:59832 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751017AbdGMSUo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 14:20:44 -0400
In-Reply-To: <8d89fefa-b27d-ba32-e7b2-75312549ee90@molgen.mpg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Stephan,


Am Mittwoch, den 12.07.2017, 19:38 +0200 schrieb Paul Menzel:

> On 07/12/17 19:28, Stephan Müller wrote:
> > Am Mittwoch, 12. Juli 2017, 12:59:58 CEST schrieb Paul Menzel:
> > > Building CRYPTO_RSA not as module, but into the Linux kernel,
> > > `rsa_init()` takes 130 ms on an ASRock E350M1.
> > > 
> > > (Timings are shown by adding `initcall_debug` to Linux command
> > > line [1].
> > > The times are visualized by `analyze_boot.py` from pm-graph [2]
> > > or `systemd-bootchart`.)
> > > 
> > > This is quite a lot of time compared to other modules, and I
> > > wonder if
> > > there are ways to decrease that time other than building it as a
> > > module,
> > > and not signing modules?
> > 
> > Is the testmgr compiled? If yes, the self test may take that time.
> 
> It looks like it is, as the tests are not disabled.
> 
> ```
> $ grep MANAGER_DISABLE_TESTS .config
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> ```
> 
> I’ll try an image without the tests, and will report back.

Thank you. That was it. Disabling the tests reduces the time to 51 μs.

```
kernel: calling  rsa_init+0x0/0x40 @ 1
kernel: initcall rsa_init+0x0/0x40 returned 0 after 51 usecs
```

It’d be nice to be able to disable the testmgr during run-time by
adding an option to the Linux Kernel command line for example.


Kind regards,

Paul


> > > [1] http://elinux.org/Initcall_Debug
> > > [2] https://github.com/01org/pm-graph
