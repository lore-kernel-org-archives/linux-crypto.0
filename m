From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 14:04:53 +0100
Message-ID: <1855300.7RfVcKporS@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1927702.eDKbX5ILji@tauon.chronox.de> <a4a6d87e-4910-1718-a2a4-e7a5a4d12177@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:28123 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030561AbeBONE7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 08:04:59 -0500
In-Reply-To: <a4a6d87e-4910-1718-a2a4-e7a5a4d12177@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Februar 2018, 13:45:53 CET schrieb Harsh Jain:

Hi Harsh,

> > Could you please elaborate what you mean with "partial tag" support?
> 
> Here is the catch, Calculation of tag depends on total payload length
> atleast for shaX, gcm,ccm mode on which I have worked.
> 
> If we take an example of shaX. It appends 1 special block at the end of user
> data which includes total input length in bit. Refer
> "sha1_base_do_finalize" Suppose we have 32 byte and we break this in 2 IOCB
> of 16 bytes each. Expected result : 32 encrypted bytes + sha auth tag
> considering length 32 bytes. What we will  get : 16 bytes + sha auth tag
> considering length 16 bytes + 16 encrypted bytes + another sha tag
> considering 16 bytes.

As AF_ALG for AEAD is implemented, there is no stream support where the hash 
is calculated at the end. This is even not supported in the current AEAD API 
of the kernel crypto API as far as I see. The only "stream-like" support is 
that you can invoke multiple separate sendmsg calls to provide the input data 
for the AEAD. But once you call recvmsg, the ciphertext and the tag is 
calculated and thus the recvmsg is akin to a hash_final operation.

Complete parallel execution of multiple independent AEAD cipher operations 
with AIO is possible using the inline IV as suggested in the patch set.

The locking of the ctx->iv is only there to support a driver not to whack the 
IV buffer. However, if others also agree that the ctx->ivlock should not be 
taken in the AEAD code path because a potential whacking the IV buffer by a 
driver does not need to be prevented, I would change the patch.

Ciao
Stephan
