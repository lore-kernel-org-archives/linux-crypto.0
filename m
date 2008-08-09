From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Sat, 9 Aug 2008 13:20:13 +0200
Message-ID: <20080809112013.GA7914@Chamillionaire.breakpoint.cc>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au> <20080402071722.GF32234@Chamillionaire.breakpoint.cc> <20080402072258.GA7720@gondor.apana.org.au> <20080807145312.GA11073@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47970 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYHILUR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Aug 2008 07:20:17 -0400
Content-Disposition: inline
In-Reply-To: <20080807145312.GA11073@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-08-07 22:53:12 [+0800]:

>I've coded this up with the per-cpu structure and it seems to work.
yup, excellent. Thanks for finishing this. I had the following comment
above my DEFINE_PER_CPU definition (I replaced my definition with
last_cword):
|/*
| * PER-CPU last_cword is here to make this code SMP / future safe and works as
| * follows: After every crypt operation, the CPU sets EFLAGS:30 to indicate
| * that the key is already in the CPU and catch-the-key-from-memory operation
| * can be saved. This bit needs to be cleared if we change the key. This bit is
| * auto-cleared by the CPU on every context switch (and can not be set by the
| * kernel). We don't lock our self to one CPU during the crypt process because
| * it isn't required: If we get scheduled to another CPU after the var check
| * and before the crypt operation than the CPU clears the EFLAGS:30 bit and the
| * CPU reloads the key anyway. The same things happens if we get scheduled to
| * another CPU after the crypt operation but before we set last_cword.
| */

I had a few missing pieces and was never was in the mode to finish it.

>It doesn't make much of a difference for ECB/CBC but with LRW/XTS
>it gives a huge boost.
Well, the spec says the key reload takes a lot of time so it should give
a big boost to everything what isn't supported directly in HW.
The padlock supports a few other modes like OFB but I doubt they are
required since they aren't even implemented in SW.

>Cheers,

Sebastian
