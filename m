From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 02 Apr 2008 17:48:33 +0200
Message-ID: <47F3AAD1.90406@the2masters.de>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:34475 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbYDBPt0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 11:49:26 -0400
In-Reply-To: <20080402065015.GA7421@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu schrieb:
> On Wed, Apr 02, 2008 at 08:44:19AM +0200, Sebastian Siewior wrote:
>> Herbert: I was going to Cc you and ask if the speed improvements are
>> okey / enough to consider this patch for inclusion but I see now that
>> you found this thread on your own :) Do you want me to form a patch? 
> 
> Yes please! BTW, can VIA do SMP? If so then we'll need some code
> to deal with that and if not, we should add a run-time check to
> fail the module insertion if ever such a beast should arise.

Till now VIA has no SMP and nothing planed (as far as I know, I'm not a VIA guy). There
next gen processors will be called isaiah, without smp but with 64bit and lots of other
features ( http://www.via.com.tw/en/products/processors/isaiah-arch/ )

Cheers
Stefan

> 
> Cheers,
