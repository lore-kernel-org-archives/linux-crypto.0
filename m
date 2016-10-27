From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [ANNOUNCE] libkcapi v0.12.0 released
Date: Thu, 27 Oct 2016 18:53:45 -0400
Message-ID: <CAH8yC8kvADeRgjxkBbdA5aMBDnVVKauTyfS-anaHr+bsF-U1iQ@mail.gmail.com>
References: <2974976.xU0nDqBFOZ@positron.chronox.de> <CAH8yC8n+37D+4i6-WS8yZMLOm-LvMnVV93uWbPcOStwJRWvFWA@mail.gmail.com>
 <10631833.2nPcTagHHZ@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36035 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942888AbcJ0Wxq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 18:53:46 -0400
Received: by mail-oi0-f68.google.com with SMTP id e12so7076829oib.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2016 15:53:46 -0700 (PDT)
In-Reply-To: <10631833.2nPcTagHHZ@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> > The Linux kernel exports a network interface of type AF_ALG to allow user
>> > space to utilize the kernel crypto API. libkcapi uses this network
>> > interface and exports an easy to use API so that a developer does not
>> > need to consider the low-level network interface handling.
...
>> any preprocessor macros to guard code paths in userland? What are the
>
> There are no special guards. If AF_ALG is available, all user space processes
> can use it.
>
>> preprocessor macros we can use to guard it?
>
> I am not entirely sure I understand the question.

See, for example,
https://github.com/openssl/openssl/blob/master/engines/afalg/e_afalg.c

The versions are kind of arbitrary because there's no easy way to tell
when the gear is available. If I recall from researching things, there
were two components needed for afalg, and they were supposedly
available back to later 2.x kernels.

Things should "just work" for 3.x and 4.x kernels. But if "too early"
a kernel is encountered, then users experience the spectrum from
compile problems to unexplained runtime errors.

Jeff
