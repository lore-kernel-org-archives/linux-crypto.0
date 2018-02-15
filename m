From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 08:26:35 -0500
Message-ID: <CAH8yC8kbjv8cjAHCiQf6jdKcPsii9-Fqu1hUXViMVkCBHn+vGw@mail.gmail.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1927702.eDKbX5ILji@tauon.chronox.de>
 <a4a6d87e-4910-1718-a2a4-e7a5a4d12177@chelsio.com> <1855300.7RfVcKporS@tauon.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:41277 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031273AbeBON0g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 08:26:36 -0500
Received: by mail-ot0-f194.google.com with SMTP id w38so5294889ota.8
        for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2018 05:26:36 -0800 (PST)
In-Reply-To: <1855300.7RfVcKporS@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 15, 2018 at 8:04 AM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 15. Februar 2018, 13:45:53 CET schrieb Harsh Jain:
>
>> > Could you please elaborate what you mean with "partial tag" support?
>>
>> Here is the catch, Calculation of tag depends on total payload length
>> atleast for shaX, gcm,ccm mode on which I have worked.
>>
>> If we take an example of shaX. It appends 1 special block at the end of user
>> data which includes total input length in bit. Refer
>> "sha1_base_do_finalize" Suppose we have 32 byte and we break this in 2 IOCB
>> of 16 bytes each. Expected result : 32 encrypted bytes + sha auth tag
>> considering length 32 bytes. What we will  get : 16 bytes + sha auth tag
>> considering length 16 bytes + 16 encrypted bytes + another sha tag
>> considering 16 bytes.
>
> As AF_ALG for AEAD is implemented, there is no stream support where the hash
> is calculated at the end. This is even not supported in the current AEAD API
> of the kernel crypto API as far as I see. The only "stream-like" support is
> that you can invoke multiple separate sendmsg calls to provide the input data
> for the AEAD. But once you call recvmsg, the ciphertext and the tag is
> calculated and thus the recvmsg is akin to a hash_final operation.

If you follow Bernstein's protocol design philosophy, then messages
should be no larger than about 4K in size. From
https://nacl.cr.yp.to/valid.html:

    This is one of several reasons [1] that callers should (1) split
    all data into packets sent through the network; (2) put a
    small global limit on packet length; and (3) separately
    encrypt and authenticate each packet.

With the [1] link being
https://groups.google.com/forum/#!original/boring-crypto/BpUmNMXKMYQ/EEwAIeQdjacJ

Jeff
