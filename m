From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 2 Apr 2008 14:31:52 +0800
Message-ID: <20080402063152.GA7258@gondor.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <E1Jgw4g-0008Uc-00@gondolin.me.apana.org.au> <20080402062659.GA32234@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stefan@the2masters.de, linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59220 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752925AbYDBGb7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:31:59 -0400
Content-Disposition: inline
In-Reply-To: <20080402062659.GA32234@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 02, 2008 at 08:26:59AM +0200, Sebastian Siewior wrote:
>
> In that case we are safe aren't we? If we get preempted and user
> space is invoked (or any other kernel thread) then the EFLAGS of the
> task are restored what sets EFLAGS:30 to zero. Or did I misinterprete
> it?

Good point.  It should be fine then.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
