From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/9] Convert padlock sha to shash
Date: Thu, 16 Jul 2009 10:16:01 +0800
Message-ID: <20090716021601.GA28776@gondor.apana.org.au>
References: <20090711101958.GA14642@gondor.apana.org.au> <20090714202615.GA21476@Chamillionaire.breakpoint.cc> <20090715004847.GA17017@gondor.apana.org.au> <20090715220606.GA30627@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39851 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757077AbZGPCQE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 22:16:04 -0400
Content-Disposition: inline
In-Reply-To: <20090715220606.GA30627@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 16, 2009 at 12:06:06AM +0200, Sebastian Andrzej Siewior wrote:
> * Herbert Xu | 2009-07-15 08:48:47 [+0800]:
> 
> >Yes, that should be enough.  You don't even ipsec-tools, just
> >a manual SA setup with ip xfrm should be good enough.
> 
> I did not get that far:
> 
> |alg: hash: Chunking test 1 failed for sha1-padlock
> |00000000: e9 95 22 0c 1b d1 0f 5f f1 fa ee 74 7d 27 cd b2
> |00000010: 99 f2 ad 73
> |alg: hash: Chunking test 1 failed for sha256-padlock
> |00000000: 9e 49 25 fa b3 a8 45 de 53 e9 9f d0 e8 7d 2c 33
> |00000010: 09 51 6b 33 15 cb e0 4e 22 c0 04 1b 1e 25 ad c9
> |padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
> 
> Do you think that it is something obvious or should I dig into it?

Can you please pull my tree again? There were quite a few bugs
that I fixed last night.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
