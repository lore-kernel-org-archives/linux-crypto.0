From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] s390/crypto: fix aes ctr concurrency issue
Date: Thu, 28 Nov 2013 22:00:46 +0800
Message-ID: <20131128140045.GA32124@gondor.apana.org.au>
References: <1384856532-17247-1-git-send-email-freude@linux.vnet.ibm.com>
 <1384856532-17247-2-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:44391 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3K1OAy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 09:00:54 -0500
Content-Disposition: inline
In-Reply-To: <1384856532-17247-2-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 19, 2013 at 11:22:12AM +0100, Harald Freudenberger wrote:
> The aes-ctr mode used one preallocated page without any concurrency
> protection. When multiple threads run aes-ctr encryption or decryption
> this could lead to data corruption.
> 
> The patch introduces locking for the preallocated page and alternatively
> allocating and freeing of an temp page in concurrency situations.

You can't use mutex_lock because you may be in a non-sleepable
context.  Perhaps just fall back to doing it block-by-block, like
we do in aesni-intel on x86?

I have to say that your hardware has a funny way of doing CTR.
Somebody was generalising out of their backside :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
