From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Thu, 4 Oct 2007 16:48:18 +0800
Message-ID: <20071004084818.GB23890@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2129 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754003AbXJDIsZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 04:48:25 -0400
Content-Disposition: inline
In-Reply-To: <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 04, 2007 at 10:35:12AM +0200, Sebastian Siewior wrote:
>
> Two last questions:
> - What about the i386 assembly vs generic implementation? Do you prefer
>   the patch that I have send earlier (choose the assembly by default
>   making the generic optional) or do you want both of them loaded at
>   the same time.

I'd prefer both to be built by default so that if something
does go wrong we can ask people to check by using aes-generic.

> - What might be the best fallback strategy for the s390 + geode aes
>   driver? 

I've been trying to avoid this :)

Yes your proposal is definitely on the right track.

My original plan is to have a template like keylen(aes,16) that
only supports key length 16.  So perhaps you can take a look at
doing that or come up with a different solution.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
