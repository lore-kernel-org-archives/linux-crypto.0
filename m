From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 2 Apr 2008 08:44:19 +0200
Message-ID: <20080402064419.GC32234@Chamillionaire.breakpoint.cc>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45381 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729AbYDBGoV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:44:21 -0400
Content-Disposition: inline
In-Reply-To: <47F28136.3080502@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-04-01 20:38:46 [+0200]:

>Now I have more numbers :)
>read from a device through dm-crypt with aes-cts-plain, 256-bit mode (512bit keysize for
>cryptsetup)
>without this patch: 54MB/s with plain dd(blocksize 512b), 51MB/s with dd and a blocksize
>of 512kib (Yes, it's slower with a larger blocksize!)
>with this patch: 63MB/s with dd and a blocksize of 512b, 64MB/s with a blocksize of 512k
>(This time the larger blocksize was a little bit faster in each test)
>I did 5 tests for each combination, top shows everytime ~90% user and ~0% wait
Thank you for you excellent work.

Herbert: I was going to Cc you and ask if the speed improvements are
okey / enough to consider this patch for inclusion but I see now that
you found this thread on your own :) Do you want me to form a patch? 

>
>Stefan

Sebastian
