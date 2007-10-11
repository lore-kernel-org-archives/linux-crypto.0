From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 18:52:02 +0800
Message-ID: <20071011105202.GA17487@gondor.apana.org.au>
References: <20071010152146.GA13379@2ka.mipt.ru> <20071011101400.GA17192@gondor.apana.org.au> <20071011104313.GA31211@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3719 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754912AbXJKKwH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 06:52:07 -0400
Content-Disposition: inline
In-Reply-To: <20071011104313.GA31211@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 02:43:14PM +0400, Evgeniy Polyakov wrote:
> 
> Attached patch fixes that with following tcrypt output:

That was quick :)

Unfortunately it doesn't apply because des.c has been renamed
to des_generic.c in cryptodev-2.6.  Could you please fix that
up and also move the prototype into a header file, say
include/crypto/des.h?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
