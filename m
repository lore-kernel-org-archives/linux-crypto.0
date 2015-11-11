From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hardware Crypto Driver
Date: Wed, 11 Nov 2015 23:02:18 +0800
Message-ID: <20151111150218.GA25002@gondor.apana.org.au>
References: <CAG3F19ArjmvN=hEsL67f1vH56nxVfZryV9utNCqosVT9J6FTCQ@mail.gmail.com>
 <20151111042403.GA21253@gondor.apana.org.au>
 <CAG3F19DdmCnWPpuC6w4W8YrYU8+q8BEmgYX0DqrbPRVqC2-16A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Orlando <orlcp440@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35129 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbbKKPCV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 10:02:21 -0500
Content-Disposition: inline
In-Reply-To: <CAG3F19DdmCnWPpuC6w4W8YrYU8+q8BEmgYX0DqrbPRVqC2-16A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 11, 2015 at 09:54:37AM -0500, Orlando wrote:
> I think the main problem might be my lack of understanding how IVs are
> handled by the kernel crypto framework. It seems the omap-aes.c driver
> is indicating to the crypto framework that it wants IV generation to
> be handled automatically by the crypto framework by filling this field
> .geniv = "eseqiv". Is there a way I can tell the kernel crypto
> framework to stop handling IV generation? Even if I remove the .geniv
> field it gets set with a default value by the crypto framework. I have
> tried .geniv = "<built-in>" but then when I make a crypto call it does
> not use the driver anymore. What are the required things I must do if
> I set .geniv = "<built-in>" ?

geniv is completely unrelated to this.  In fact, in the current
kernel geniv is no longer used and I will remove it once the skcipher
conversion is done.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
