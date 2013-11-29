From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Fri, 29 Nov 2013 09:50:23 +0800
Message-ID: <20131129015023.GA5381@gondor.apana.org.au>
References: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
 <1384856532-17247-2-git-send-email-freude@linux.vnet.ibm.com>
 <20131128140045.GA32124@gondor.apana.org.au>
 <1385653183.3131.14.camel@myubuntu10>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Harald Freudenberger <hfreude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46225 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3K2BvJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 20:51:09 -0500
Content-Disposition: inline
In-Reply-To: <1385653183.3131.14.camel@myubuntu10>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 28, 2013 at 04:39:43PM +0100, Harald Freudenberger wrote:
>
> > You can't use mutex_lock because you may be in a non-sleepable
> > context.  Perhaps just fall back to doing it block-by-block, like
> > we do in aesni-intel on x86?
> 
> The first attempt to lock the mutex is done with mutex_trylock() which
> should be safe for non-sleepable context. If this fails, an attempt is
> made to allocate a fresh page __get_free_page(GFP_ATOMIC). If this also
> fails, well what could be done then ? I think, it is valid to wait for
> the preallocated page to get released with an mutex_lock(). Should I
> really add code here for handling the 3rd level of the exceptional
> path ?

If it's wrong per se, how does hiding it behind two if's make it
OK?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
