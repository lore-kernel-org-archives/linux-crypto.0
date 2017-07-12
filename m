From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Decreasing time for `rsa_init`
Date: Wed, 12 Jul 2017 19:28:11 +0200
Message-ID: <3649766.4rHtxdK8Pi@tauon.chronox.de>
References: <4ec5a3f5-9605-cdcd-23cf-1df7b3af211c@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60490 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753913AbdGLR2X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 13:28:23 -0400
In-Reply-To: <4ec5a3f5-9605-cdcd-23cf-1df7b3af211c@molgen.mpg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 12. Juli 2017, 12:59:58 CEST schrieb Paul Menzel:

Hi Paul,

> Dear Linux crypto folks,
> 
> 
> Building CRYPTO_RSA not as module, but into the Linux kernel,
> `rsa_init()` takes 130 ms on an ASRock E350M1.
> 
> (Timings are shown by adding `initcall_debug` to Linux command line [1].
> The times are visualized by `analyze_boot.py` from pm-graph [2] or
> `systemd-bootchart`.)
> 
> This is quite a lot of time compared to other modules, and I wonder if
> there are ways to decrease that time other than building it as a module,
> and not signing modules?

Is the testmgr compiled? If yes, the self test may take that time.
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> [1] http://elinux.org/Initcall_Debug
> [2] https://github.com/01org/pm-graph



Ciao
Stephan
