From: Sebastian Siewior <bigeasy@breakpoint.cc>
Subject: Re: [PATCH] an XTS blockcipher mode implementation without partial
	blocks
Date: Fri, 7 Sep 2007 20:38:32 +0200
Message-ID: <20070907183832.GA23067@Chamillionaire.breakpoint.cc>
References: <11888559161619-git-send-email-rsnel@cube.dyndns.org> <20070905002906.GA6930@Chamillionaire.breakpoint.cc> <20070906145726.GA30421@cube.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, christoph.sievers@gmail.com,
	herbert@gondor.apana.org.au
To: rsnel@cube.dyndns.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35194 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758114AbXIGSii (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Sep 2007 14:38:38 -0400
Content-Disposition: inline
In-Reply-To: <20070906145726.GA30421@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* rsnel@cube.dyndns.org | 2007-09-06 16:57:26 [+0200]:

>> The compiler should generate similar code.
>
>I'd rather tell the compiler what I want than to introduce a new local
>variable and a conditional branch in the hope that the compiler will
>optimize it away, just to avoid a goto.
>
>If you insist on getting rid of the goto, I could unroll the first
>iteration of the loop by hand. (when is submitted lrw.c it had the first
>iteration unrolled; Herbert replaced it with this goto)

I didn't know that Herbert did it the same way. In that case you are
fine :)

>Christoph encountered a deadlock after a few hours and 16GB of data (on
>an aes-xts-plain partition). Assuming there is an error in xts.c, is
>there an obvious way of finding it?

Haven't seen any locks in your code, so your part may be fine. How do I
use this? 

cryptsetup -c aes-xts 

or?

>Greetings,
>
>Rik.

Sebastian
