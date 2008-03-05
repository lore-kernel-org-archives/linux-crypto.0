From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Wed, 5 Mar 2008 19:52:03 +0800
Message-ID: <20080305115203.GA28021@gondor.apana.org.au>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au> <20080305114652.GA18070@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Stefan Hellermann <stefan@the2masters.de>
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56002 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763518AbYCELwF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 06:52:05 -0500
Content-Disposition: inline
In-Reply-To: <20080305114652.GA18070@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 05, 2008 at 12:46:52PM +0100, Sebastian Siewior wrote:
>
> I'm not sure if we are allowed to modify the IV or if it should
> remain untouched. If it is possible to modify it, I could encrypt it
> inplace and save two memcpy().
> I will check this tonight.

I just had a quick look and it seems that you should be able to
store the result in the IV.

However this won't work for LRW since we need the IV to increment
it.  But then again LRW seems to be fine as it is since its
arguments are already aligned by the blkcipher walker.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
