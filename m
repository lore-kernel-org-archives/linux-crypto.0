From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Wed, 18 Jan 2017 15:57:49 +0100
Message-ID: <e9e14b17-e313-b14d-d8e3-bf2f18532114@atmel.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:37858 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751316AbdARO5w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 09:57:52 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

this series of patches sounds like a good idea. I haven't tested it with
the Atmel AES hardware yet but I have many dummy questions:

Looking at some driver patches in the series, it seems you only add a call
to crypto_aead_copy_ad() but I don't see any removal of the previous driver
specific implementation to perform that copy.

I take the Atmel gcm(aes) driver case aside since looking at the current
code, it seems that I've forgotten to copy that assoc data from req->src
into req->dst scatter list. Then I assume that I was lucky so when I tested
with the test manager or IPSec connections, I always fell in the case where
req->src == req->dst. I thought the test manager also covered the case
req->src != req->dst but I don't remember very well and I haven't checked
recently, sorry!

Then I now look at the default drivers/gcm.c driver and, if I understand
this driver correctly, it doesn't copy the associated data from req->src
into req->dst when req->src != req->dst...
What does it mean? Did I misunderstand the gmc.c driver or is it a bug? Is
that copy the associated data needed after all?
Also looking at the drivers/authenc.c driver, this one does copy the
associated data.
So now I understand why I didn't make the copy for gcm(aes) but did it for
authenc(hmac(shaX),cbc(aes)) in atmel-aes.c: when I add new crypto
algorithms support in the Atmel drivers, I always take the crypto/*.c
drivers as reference.

So finally, what shall we do? copy or not copy? That is my question!

One last question: why do we copy those associated data only for encrypting
requests but not for decrypting requests?

The associated data might still be needed in the req->dst scatter list even
when it only refers to plain data so no other crypto operation is needed
after. However, let's take the example of an IPSec connection with ESP: the
first 8 bytes of the ESP header (4-byte SPI + 4-byte sequence number) are
used as associated data. They must be authenticated but they cannot be
ciphered as we need the plain SPI value to attach some IP packet to the
relevant IPSec session hence knowing the crypto algorithms to be used to
process the network packet.
However, once the received IPSec packet has been decrypted and
authenticated, the sequence number part the the ESP header might still be
needed in req->dst if for some reason the req->src is no longer available
when performing the anti-replay check.
Maybe the issue simply never occurs because req->src is always == req->dst
or maybe because the anti-replay check is always performed before the
crypto stuff. I dunno!

So why not copying the associated data also when processing decrypt
requests too?

Sorry for those newbie questions! I try to improve my understanding and
knowledge of the crypto subsystem and its interaction with the network
subsystem without digging too much in the source code :p

Best regards,

Cyrille

Le 10/01/2017 à 02:36, Stephan Müller a écrit :
> Hi,
> 
> to all driver maintainers: the patches I added are compile tested, but
> I do not have the hardware to verify the code. May I ask the respective
> hardware maintainers to verify that the code is appropriate and works
> as intended? Thanks a lot.
> 
> Herbert, this is my proprosal for our discussion around copying the
> AAD for algif_aead. Instead of adding the code to algif_aead and wait
> until it transpires to all cipher implementations, I thought it would
> be more helpful to fix all cipher implementations.
> 
> To do so, the AAD copy function found in authenc is extracted to a global
> service function. Furthermore, the generic AEAD TFM initialization code
> now allocates the null cipher too. This allows us now to only invoke
> the AAD copy function in the various implementations without any additional
> allocation logic.
> 
> The code for x86 and the generic code was tested with libkcapi.
> 
> The code for the drivers is compile tested for drivers applicable to
> x86 only. All others are neither compile tested nor functionally tested.
> 
> Stephan Mueller (13):
>   crypto: service function to copy AAD from src to dst
>   crypto: gcm_generic - copy AAD during encryption
>   crypto: ccm_generic - copy AAD during encryption
>   crypto: rfc4106-gcm-aesni - copy AAD during encryption
>   crypto: ccm-aes-ce - copy AAD during encryption
>   crypto: talitos - copy AAD during encryption
>   crypto: picoxcell - copy AAD during encryption
>   crypto: ixp4xx - copy AAD during encryption
>   crypto: atmel - copy AAD during encryption
>   crypto: caam - copy AAD during encryption
>   crypto: chelsio - copy AAD during encryption
>   crypto: nx - copy AAD during encryption
>   crypto: qat - copy AAD during encryption
> 
>  arch/arm64/crypto/aes-ce-ccm-glue.c      |  4 ++++
>  arch/x86/crypto/aesni-intel_glue.c       |  5 +++++
>  crypto/Kconfig                           |  4 ++--
>  crypto/aead.c                            | 36 ++++++++++++++++++++++++++++++--
>  crypto/authenc.c                         | 36 ++++----------------------------
>  crypto/ccm.c                             | 10 +++++++++
>  crypto/gcm.c                             | 17 +++++++++++++++
>  drivers/crypto/atmel-aes.c               |  6 ++++++
>  drivers/crypto/caam/caamalg.c            |  8 +++++++
>  drivers/crypto/chelsio/chcr_algo.c       |  5 +++++
>  drivers/crypto/ixp4xx_crypto.c           |  6 ++++++
>  drivers/crypto/nx/nx-aes-ccm.c           |  4 ++++
>  drivers/crypto/nx/nx-aes-gcm.c           | 10 +++++++++
>  drivers/crypto/picoxcell_crypto.c        |  5 +++++
>  drivers/crypto/qat/qat_common/qat_algs.c |  4 ++++
>  drivers/crypto/talitos.c                 |  5 +++++
>  include/crypto/aead.h                    |  2 ++
>  include/crypto/internal/aead.h           | 12 +++++++++++
>  18 files changed, 143 insertions(+), 36 deletions(-)
> 
