From: Martin Willi <martin@strongswan.org>
Subject: Re: HMAC regression
Date: Sun, 31 May 2009 15:01:19 +0200
Message-ID: <1243774879.25453.25.camel@martin.hsr.ch>
References: <1243523348.30487.89.camel@martin.hsr.ch>
	 <20090529061931.GA10003@gondor.apana.org.au>
	 <1243591472.7473.169.camel@martin.hsr.ch>
	 <20090530011222.GA19425@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zaes.ch ([213.133.111.41]:47325 "EHLO zaes.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZEaNB0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 31 May 2009 09:01:26 -0400
In-Reply-To: <20090530011222.GA19425@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> You must getting an sg entry that crosses a page boundary, rather than
> two sg entries that both stay within a page.

Yes.

> These things are very rare, and usually occurs as
> a result of SLAB debugging causing kmalloc to return memory that
> crosses page boundaries.

Indeed, SLAB_DEBUG was enabled in my config. Disabling it resolves this
issue.

> Can you see if this patch fixes the problem?

Yes, it fixes HMAC calculation with enabled SLAB debugging.

Thanks for your help!

