From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: algif for compression?
Date: Thu, 8 Dec 2016 01:27:30 +0530
Message-ID: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34506 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753320AbcLGT5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 14:57:51 -0500
Received: by mail-oi0-f41.google.com with SMTP id y198so430236884oia.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2016 11:57:51 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

>> I see the algif_hash and algif_blkcipher implementations to allow
>> userspace AF_ALG socket access to kernel blkcipher and hash
>> algorithms, but has anyone done a algif_compression to allow userspace
>> access to compression algs?  I'm asking specifically wrt the 842
>> crypto module, which uses the hardware compression coprocessors on
>> newer powerpc systems.
>>
>> If not, is there any reason against adding a algif_compression to
>> provide the access?
>
> For a start nx-842 isn't even hooked into the crypto layer so
> there is no chance of exporting it through algif as is.
>
> There is no reason why you couldn't add it of course but that'd
> be a first step.

We are also looking for user-space access to the kernel crypto layer
compression algorithms. I have gone through AF_ALG but couldn=E2=80=99t fin=
d
support for compression ops through it. This is required for our
hardware zip engines whose driver hooks up to the crypto layer.

I was going through the lists and stumbled across this thread. Has
there been  any updates or efforts put up in this direction since this
thread is a few years old. If not, are there any alternate
implementations that allow user-space access to compression? I have
gone through cryptodev and see the same limitation there.

Would appreciate any pointers in this regard.

Thanks,
Abed
(Cavium Inc)
