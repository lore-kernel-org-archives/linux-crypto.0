From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 19:56:50 +0800
Message-ID: <20071011115650.GB17801@gondor.apana.org.au>
References: <20071010152146.GA13379@2ka.mipt.ru> <20071011101400.GA17192@gondor.apana.org.au> <20071011104313.GA31211@2ka.mipt.ru> <20071011105202.GA17487@gondor.apana.org.au> <20071011113002.GA20119@2ka.mipt.ru> <20071011114034.GA12869@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4252 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752337AbXJKL4w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 07:56:52 -0400
Content-Disposition: inline
In-Reply-To: <20071011114034.GA12869@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 03:40:36PM +0400, Evgeniy Polyakov wrote:
>
> HIFN driver update to use DES weak key checks (exported in this patch).
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Both patches applied.  Thanks a lot!

BTW I fixed the Kconfig to say CRYPTO_DES instead of DES.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
