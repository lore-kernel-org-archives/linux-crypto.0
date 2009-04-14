From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Tue, 14 Apr 2009 15:05:35 +0200
Message-ID: <20090414130535.GM6791@secunet.com>
References: <20090316114940.GN13998@secunet.com> <20090316115251.GP13998@secunet.com> <20090327083615.GB27903@gondor.apana.org.au> <20090330115415.GC6791@secunet.com> <20090330131955.GA22604@gondor.apana.org.au> <20090408114014.GL6791@secunet.com> <20090409032045.GA2232@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:43909 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZDNNDf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Apr 2009 09:03:35 -0400
Content-Disposition: inline
In-Reply-To: <20090409032045.GA2232@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 09, 2009 at 11:20:45AM +0800, Herbert Xu wrote:
> 
> You can allocate eseqiv(alg), e.g., eseqiv(cbc(aes)).
> 

Ok, that's possible. I missed this possibility, probaply because nobody
is actually doing it this way. Thanks!

Unfortunately eseqiv does not work out of the box if we do synchronous
encryption. 

If crypto_ablkcipher_encrypt() returns synchronous, eseqiv_complete2()
is called even if req->giv is already the pointer to the generated IV.
The generated IV is overwritten with some random data in this case.

I fixed this by calling eseqiv_complete2() just in the case when an
asynchronous algorithm would call eseqiv_complete() as the complete
function. I'll send the patch with an extra mail.

Now pcrypt runs fine together with eseqiv and the throughput
results are very similar to the ones with cpu_chainiv.

Steffen
