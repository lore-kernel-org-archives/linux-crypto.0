From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 2 Apr 2008 14:50:15 +0800
Message-ID: <20080402065015.GA7421@gondor.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stefan Hellermann <stefan@the2masters.de>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43065 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759306AbYDBGuX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:50:23 -0400
Content-Disposition: inline
In-Reply-To: <20080402064419.GC32234@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 02, 2008 at 08:44:19AM +0200, Sebastian Siewior wrote:
>
> Herbert: I was going to Cc you and ask if the speed improvements are
> okey / enough to consider this patch for inclusion but I see now that
> you found this thread on your own :) Do you want me to form a patch? 

Yes please! BTW, can VIA do SMP? If so then we'll need some code
to deal with that and if not, we should add a run-time check to
fail the module insertion if ever such a beast should arise.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
