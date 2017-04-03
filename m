From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: algif for compression?
Date: Mon, 3 Apr 2017 14:11:45 +0530
Message-ID: <CACVarETH7y0GAvDZT_cR=z4Zz-2jVW2-HCzEAb97RaQaSRDr8Q@mail.gmail.com>
References: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com>
 <20161210081014.GA32746@gondor.apana.org.au> <CACVarEQ14ZF9LGDkaNYtX3GRD5GOH62NBiPtC4z=i6RY4MtFDA@mail.gmail.com>
 <12030384.uXSX3S3VSk@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:33706 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdDCImH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 04:42:07 -0400
Received: by mail-wr0-f171.google.com with SMTP id w43so158419242wrb.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Apr 2017 01:42:06 -0700 (PDT)
In-Reply-To: <12030384.uXSX3S3VSk@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephen,

> If you follow the AF_ALG implementations that are currently in the kernel=
, a
> calling application receives two file descriptors. The first file descrip=
tor
> is the reference to a tfm, the second is the reference to a particular
> request.
>
> Wouldn't those file descriptors be the reference you are looking for?

Those descriptors are sufficient to pass data from userspace
applications to the algif interface.
However the issue is passing those from the interface to the driver
using the current acomp API's.
This is the currently exposed interface to the comp framework. Am I
missing something here?

int (*compress)(struct acomp_req *req);
int (*decompress)(struct acomp_req *req);

struct acomp_req {
        struct crypto_async_request base;
        struct scatterlist *src;
        struct scatterlist *dst;
        unsigned int slen;
        unsigned int dlen;
        u32 flags;
        void *__ctx[] CRYPTO_MINALIGN_ATTR;
};


Thanks
Abed



On Mon, Apr 3, 2017 at 12:56 PM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> Am Montag, 3. April 2017, 08:10:19 CEST schrieb abed mohammad kamaluddin:
>
> Hi abed,
>
>> Hi Herbert,
>>
>> We have implemented algif acomp interface for user space applications
>> to utilize the kernel compression framework and the hardware drivers
>> using it and have been testing it using userspace zlib library.
>>
>> However, what we find lacking in the existing acomp implementation is
>> the ability to pass context data between the applications and the
>> drivers using the acomp interface. Currently the interface only allows
>> src/dest data  and a flag argument with each request. There are two
>> context pointers, one in acomp_req and another in crypto_tfm but they
>> are for internal use and not available to applications through the
>> api's. Would it be acceptable to add fields that need to be
>> communicated b/w the driver and applications like history,
>> csum/adler32, EOF, stream ctx  to acomp_req.
>>
>> Or is there any other way, which I may have missed, through which we
>> can pass ctx data between applications and drivers while using the
>> kernel compression framework?
>
> If you follow the AF_ALG implementations that are currently in the kernel=
, a
> calling application receives two file descriptors. The first file descrip=
tor
> is the reference to a tfm, the second is the reference to a particular
> request.
>
> Wouldn't those file descriptors be the reference you are looking for?
>
> Ciao
> Stephan
