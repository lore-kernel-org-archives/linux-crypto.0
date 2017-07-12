From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Decreasing time for `rsa_init`
Date: Wed, 12 Jul 2017 12:59:58 +0200
Message-ID: <4ec5a3f5-9605-cdcd-23cf-1df7b3af211c@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50000 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756559AbdGLLAB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 07:00:01 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Linux crypto folks,


Building CRYPTO_RSA not as module, but into the Linux kernel, 
`rsa_init()` takes 130 ms on an ASRock E350M1.

(Timings are shown by adding `initcall_debug` to Linux command line [1]. 
The times are visualized by `analyze_boot.py` from pm-graph [2] or 
`systemd-bootchart`.)

This is quite a lot of time compared to other modules, and I wonder if 
there are ways to decrease that time other than building it as a module, 
and not signing modules?


Kind regards,

Paul


[1] http://elinux.org/Initcall_Debug
[2] https://github.com/01org/pm-graph
