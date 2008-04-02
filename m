From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 2 Apr 2008 09:17:22 +0200
Message-ID: <20080402071722.GF32234@Chamillionaire.breakpoint.cc>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47444 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760849AbYDBHRY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 03:17:24 -0400
Content-Disposition: inline
In-Reply-To: <20080402065015.GA7421@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-04-02 14:50:15 [+0800]:

>On Wed, Apr 02, 2008 at 08:44:19AM +0200, Sebastian Siewior wrote:
>>
>> Herbert: I was going to Cc you and ask if the speed improvements are
>> okey / enough to consider this patch for inclusion but I see now that
>> you found this thread on your own :) Do you want me to form a patch? 
>
>Yes please! BTW, can VIA do SMP? If so then we'll need some code
>to deal with that and if not, we should add a run-time check to
>fail the module insertion if ever such a beast should arise.
I'm not sure if they have SMP or multicore out / plans but I gave a
little thought on this early morning: The only problem is if we get
swapped to another cores before encryption process beginns and after key
reset thing. If the scheduler decides to swap cores than EFLAGS should
be reloaded and wer are fine. The only problem that I see with cpus > 1
is that we might reload the key if it is not required. This could be
solved with old_ctx pointer beeing a percpu. 

>Cheers,
Sebastian
