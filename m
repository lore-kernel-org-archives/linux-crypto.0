From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 20 Jan 2017 18:07:04 +0100
Message-ID: <2a4fab23-3ea7-a0f7-7c30-55d301f51ec9@atmel.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <1704568.lHqrOxcchT@positron.chronox.de>
 <20170113113324.GA24021@gondor.apana.org.au>
 <2829634.RJknVxGPvY@positron.chronox.de>
 <20170113113906.GA24096@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:39094 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752110AbdATRJM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 12:09:12 -0500
In-Reply-To: <20170113113906.GA24096@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

Le 13/01/2017 à 12:39, Herbert Xu a écrit :
> On Fri, Jan 13, 2017 at 12:36:56PM +0100, Stephan Müller wrote:
>>
>> I thought I understood that you would not want to see it in any 
>> implementation. But, ok, if you want to leave it.
> 
> If you remove it from authenc then authenc will be broken.
> 

Hence if the copy of the associated data is needed in the crypto/authenc.c
driver, then I should also keep this copy in the drivers/crypto/atmel-aes.c
for authenc(hmac(shaX),cbc-aes) algorithms [1], shouldn't I?

If so, should I keep the current not optimized implementation of
atmel_aes_authenc_copy_assoc() or try to use the code extracted by Stephan
from crypto/authenc.c using the null cipher as proposed in this thread?

As said earlier in this thread, copying the associated data is not a so big
deal when compared to the main crypto processing.

For instance, with IPSec ESP with AES in CBC mode, the associated data
layout should be:
Security Parameters Index (SPI): 4 bytes
Sequence Number: 4 bytes
AES IV: 16 bytes

So it's only a 24 byte copy.

I've taken Stephan's other comments into account from his review of the
atmel-authenc driver so I'm preparing a new series but I don't know what to
do for the associated data copy.

Please let me know what you recommend, thanks!

Best regards,

Cyrille


[1] https://lkml.org/lkml/2016/12/22/306
