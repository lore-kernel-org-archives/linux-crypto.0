From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] check for s390 crypto facility availablility
Date: Fri, 11 Jul 2008 20:29:38 +0800
Message-ID: <20080711122938.GA4140@gondor.apana.org.au>
References: <1215702043.12011.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37340 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbYGKM3l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2008 08:29:41 -0400
Content-Disposition: inline
In-Reply-To: <1215702043.12011.6.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 10, 2008 at 03:00:43PM +0000, Jan Glauber wrote:
> 
> here is a small patch for the s390 crypto detection.
> 
> [PATCH] respect STFL bit for s390 crypto
> 
> From: <jang@linux.vnet.ibm.com>
> 
> For all s390 in-kernel crypto algorithms we check at module
> load time whether the CPACF facility bit is on. If the facility
> is not enabled we bail out.
> 
> Signed-off-by: <jang@linux.vnet.ibm.com>

Thanks Jan, the patch looks harmless enough.

> --- ./arch/s390/crypto/crypt_s390.h.stfle
> +++ ./arch/s390/crypto/crypt_s390.h
> @@ -294,6 +294,10 @@ static inline int crypt_s390_func_availa
>  	unsigned char status[16];
>  	int ret;
>  
> +	/* check if CPACF facility (bit 17) is available */
> +	if (!(stfl() & 1ULL << (31 - 17)))
> +		return 0;

However, the patch description doesn't exactly tell me what
happens without this check.  I mean, does the machine go up
in flames if the check would have bailed :)

That leads to my next question, is this something that must
go into 2.6.26 or can it wait?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
