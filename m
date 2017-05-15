From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v11 4/5] LRNG - enable compile (fwd)
Date: Mon, 15 May 2017 13:03:16 +0200
Message-ID: <2851091.MrAN01rSas@tauon.chronox.de>
References: <alpine.DEB.2.20.1705151852591.4315@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, kbuild-all@01.org
To: Julia Lawall <julia.lawall@lip6.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59604 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933701AbdEOLDU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2017 07:03:20 -0400
In-Reply-To: <alpine.DEB.2.20.1705151852591.4315@hadrien>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Mai 2017, 12:54:38 CEST schrieb Julia Lawall:

Hi Julia,

> Hello,
> 
> I received the following report from kbuild about some coccinelle detected
> errors.  I wasn't sure what to look at at the URL to check them.  I
> already forwarded the patch for the last case.
> 
> julia
> 
> ---------- Forwarded message ----------
> Date: Mon, 15 May 2017 14:09:39 +0800
> From: kbuild test robot <fengguang.wu@intel.com>
> To: kbuild@01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: Re: [PATCH v11 4/5] LRNG - enable compile
> 
> CC: kbuild-all@01.org
> In-Reply-To: <2619717.M11260EEPi@positron.chronox.de>
> TO: "Stephan Müller" <smueller@chronox.de>
> CC: linux-kernel@vger.kernel.org
> CC: linux-crypto@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
> 
> Hi Stephan,
> 
> [auto build test WARNING on char-misc/char-misc-testing]
> [also build test WARNING on v4.12-rc1 next-20170512]
> [if your patch is applied to the wrong git tree, please drop us a note to
> help improve the system]
> 
> url:   
> https://github.com/0day-ci/linux/commits/Stephan-M-ller/dev-random-a-new-ap
> proach/20170514-223633
> :::::: branch date: 16 hours ago
> :::::: commit date: 16 hours ago
> >> 
> >> drivers/char/lrng_base.c:2243:5-25: duplicated argument to && or ||

I am not sure about this one: I think the code is clean and this hint is not 
applicable here. Both arguments to the || condition are different as they are 
function calls.
> 
> --
> 
> >> drivers/char/lrng_base.c:1245:7-11: ERROR: iterator variable bound on
> >> line 1236 cannot be NULL

Fixed.
> --
> 
> >> drivers/char/lrng_base.c:1509:19-24: ERROR: reference preceded by free on
> >> line 1453

Fixed, pdrbg set to NULL after free.
> --
> 
> >> drivers/char/lrng_base.c:1461:1-11: alloc with no test, possible model on
> >> line 1466

I think the code is clean because kcalloc was invoked with GFP_NOFAIL. Thus, 
if the code returns we know we have allocated memory.
> --
> 
> >> drivers/char/lrng_base.c:1526:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Please review and possibly fold the followup patch.

This is already fixed as mentioned in other email.

Thanks a lot for the help.

Ciao
Stephan
