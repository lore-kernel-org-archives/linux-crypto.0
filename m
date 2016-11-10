From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Wed, 9 Nov 2016 16:26:50 -0800 (PST)
Message-ID: <alpine.OSX.2.20.1611091555190.69058@mjmartin-mac01.wa.intel.com>
References: <4006219.iWaCqWYv1B@positron.chronox.de> <2822295.gL4fqFHz8h@positron.chronox.de> <alpine.OSX.2.20.1610311456250.4111@mjmartin-mac01.local> <13567923.CP2Rp1drvf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17787 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751582AbcKJA0v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 19:26:51 -0500
In-Reply-To: <13567923.CP2Rp1drvf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Stephan,

On Wed, 9 Nov 2016, Stephan Mueller wrote:

> Am Montag, 31. Oktober 2016, 16:18:32 CET schrieb Mat Martineau:
>
> Hi Mat,
>>
>> My main concern is getting the semantics correct and consistent in a
>> single patch series. It would be a big problem to explain that AF_ALG AEAD
>> read and write works one way in 4.x, another way in 4.y, and some
>> different way in 4.z.
>
> I do have a patch now available that exactly does what you suggest. See the
> patch attached. It works with the following exception.
>
> In the case of sendpage and using an in-place cipher operation, the patch
> breaks as follows. When the caller sends the same buffer for a sendpage
> operation, the cipher operation now will write the ciphertext to the beginning
> of the buffer where the AAD used to be. The subsequent tag calculation will
> now use the data it finds where the AAD is expected. As the cipher operation
> has already replaced the AAD with the ciphertext, the tag calculation will
> take the ciphertext as AAD and thus calculate a wrong tag.
>
> Thus, the only way to avoid that would be to duplicate the AAD into an
> internal buffer. But that would defeat the entire purpose of sendpage.

The use case for an "in place" operation would be to have the ciphertext 
overwrite the plaintext, correct? If the src and dst overlap, does it make 
sense to require the plaintext and ciphertext to be in exactly the same 
location?

> The patch, however, works with sendmsg as well as sendpage when the src and
> dst buffers are different.

Thanks - I tested your patch and found that it works as expected with 
sendmsg.


Regards,

--
Mat Martineau
Intel OTC
