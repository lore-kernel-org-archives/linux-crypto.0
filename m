From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [ANNOUNCE] libkcapi v0.12.0 released
Date: Fri, 28 Oct 2016 01:04:30 +0200
Message-ID: <2286347.nnOjI5TozX@tauon.atsec.com>
References: <2974976.xU0nDqBFOZ@positron.chronox.de> <10631833.2nPcTagHHZ@positron.chronox.de> <CAH8yC8kvADeRgjxkBbdA5aMBDnVVKauTyfS-anaHr+bsF-U1iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47044 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933403AbcJ0XEf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 19:04:35 -0400
In-Reply-To: <CAH8yC8kvADeRgjxkBbdA5aMBDnVVKauTyfS-anaHr+bsF-U1iQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 27. Oktober 2016, 18:53:45 CEST schrieb Jeffrey Walton:

Hi Jeffrey,


> >> preprocessor macros we can use to guard it?
> > 
> > I am not entirely sure I understand the question.
> 
> See, for example,
> https://github.com/openssl/openssl/blob/master/engines/afalg/e_afalg.c
> 
> The versions are kind of arbitrary because there's no easy way to tell
> when the gear is available. If I recall from researching things, there
> were two components needed for afalg, and they were supposedly
> available back to later 2.x kernels.
> 
> Things should "just work" for 3.x and 4.x kernels. But if "too early"
> a kernel is encountered, then users experience the spectrum from
> compile problems to unexplained runtime errors.

I see. There are guards around zerocopy.

AF_ALG appeared with 2.6.38 / 3.0 which already had zerocopy.

I will try a 3.0 kernel with my current lib to see whether it works out of the 
box and apply fixes and guards if it does not.

But I am not sure whether I should guard anything for 2.x kernels where we 
know that some folks simply backported the AF_ALG interface.


Thanks a lot for the reminder.

Ciao
Stephan
