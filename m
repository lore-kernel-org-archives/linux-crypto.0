From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: Crypto patches
Date: Sat, 20 Oct 2007 05:57:16 +0100
Message-ID: <200710200557.17091.vda.linux@googlemail.com>
References: <200710181228.13569.vda.linux@googlemail.com> <20071018191940.GA11001@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:26454 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXJTE52 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2007 00:57:28 -0400
Received: by ug-out-1314.google.com with SMTP id z38so707424ugc
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2007 21:57:26 -0700 (PDT)
In-Reply-To: <20071018191940.GA11001@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 18 October 2007 20:19, Sebastian Siewior wrote:
> * Denys Vlasenko | 2007-10-18 12:28:13 [+0100]:
> 
> >I want to rediff and resend it. I also want to send patches
> >for other modules (e.g. camellia, aes).
> I'm going to unify the aes key setup on i386/x86_64/generic code on aes.
> It should work from what I thing but I am not sure :) Are planning/doing
> the same thing on aes?

I was thinking about measuring whether 64bit aes is really faster
than i386 one. i386 code seems to be already maxed out (at the first
glance), apart from using stack for temp storage. I wonder why
64bit one is completely different, and it worth testing -
maybe i386 code (only with saves to REX registers instead of stack)
will actually work faster in 64bit too.

But twofish and camellia are higher on my TODO list.
--
vda
