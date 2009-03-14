From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: enable padlock on x86_64
Date: Sat, 14 Mar 2009 12:53:07 +0100
Message-ID: <20090314115307.GA28235@Chamillionaire.breakpoint.cc>
References: <49B83002.9040705@tobiasvolk.de> <1237029843-28076-1-git-send-email-sebastian@breakpoint.cc> <20090314114732.GB3805@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, mail@tobiasvolk.de
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47543 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbZCNLxK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Mar 2009 07:53:10 -0400
Content-Disposition: inline
In-Reply-To: <20090314114732.GB3805@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Ingo Molnar | 2009-03-14 12:47:32 [+0100]:

>thanks, looks good. We can apply #1 to -tip just fine - but a 
>drivers/crypto/ change should go via the crypto tree. Can the 
>crypto tree apply #2 without having #1 right away? [i.e. will it 
>still build and boot fine - even though the padlock 
>functionality might not be fully present on 32-bit? ]

Yep, it is fine.
#1 in, #2 not will not result in any difference to what we have now.
#2 in, #1 not will result in "padlock not detected" while loading the
module and -ENODEV.

>Then in 2.6.30 once both the x86 tree and the crypto tree are 
>merged we'll have both changes combined.
>
>Does that sound good?
I'm fine with this, but last word is Herbert's :)

>	Ingo

Sebastian
