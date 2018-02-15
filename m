From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 19:09:02 +0100
Message-ID: <3343102.1189f6ocM2@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <a4a6d87e-4910-1718-a2a4-e7a5a4d12177@chelsio.com> <1855300.7RfVcKporS@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:20133 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163624AbeBOSJH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 13:09:07 -0500
In-Reply-To: <1855300.7RfVcKporS@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Februar 2018, 14:04:53 CET schrieb Stephan Mueller:

Hi Stephan,

> Am Donnerstag, 15. Februar 2018, 13:45:53 CET schrieb Harsh Jain:
> 
> Hi Harsh,
> 
> > > Could you please elaborate what you mean with "partial tag" support?
> > 
> > Here is the catch, Calculation of tag depends on total payload length
> > atleast for shaX, gcm,ccm mode on which I have worked.
> > 
> > If we take an example of shaX. It appends 1 special block at the end of
> > user data which includes total input length in bit. Refer
> > "sha1_base_do_finalize" Suppose we have 32 byte and we break this in 2
> > IOCB
> > of 16 bytes each. Expected result : 32 encrypted bytes + sha auth tag
> > considering length 32 bytes. What we will  get : 16 bytes + sha auth tag
> > considering length 16 bytes + 16 encrypted bytes + another sha tag
> > considering 16 bytes.
> 
> As AF_ALG for AEAD is implemented, there is no stream support where the hash
> is calculated at the end. This is even not supported in the current AEAD
> API of the kernel crypto API as far as I see. The only "stream-like"
> support is that you can invoke multiple separate sendmsg calls to provide
> the input data for the AEAD. But once you call recvmsg, the ciphertext and
> the tag is calculated and thus the recvmsg is akin to a hash_final
> operation.
> 
> Complete parallel execution of multiple independent AEAD cipher operations
> with AIO is possible using the inline IV as suggested in the patch set.
> 
> The locking of the ctx->iv is only there to support a driver not to whack
> the IV buffer. However, if others also agree that the ctx->ivlock should
> not be taken in the AEAD code path because a potential whacking the IV
> buffer by a driver does not need to be prevented, I would change the patch.

I was about to change the implementation. However, I already found an 
implementation where the driver changes the IV of the request buffer: 
crypto_ccm_init_crypt modifies the original buffer of the IV. I expect that 
there are more.

Therefore, I would think that keeping the patch set as it is right now is the 
right thing to do. Thus, we should cover the AEAD ciphers with the lock and 
thus serialize the AEAD request. This guarantees that the IV buffer is at 
least not mangled while the cipher operation is ongoing.

Again, if a particular AEAD driver guarantees the IV is not mangled, it can 
very well set CRYPTO_ALG_SERIALIZES_IV_ACCESS in its flag set. This would 
imply the lock is not set.

Ciao
Stephan
