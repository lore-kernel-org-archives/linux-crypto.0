From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [QUESTION] hash import and request initialization
Date: Wed, 27 Dec 2017 08:27:53 +0200
Message-ID: <CAOtvUMc-_bi5ZFm9r-5E=hdPh8h3rFzAWzNGY3SdCR=wyzp4jw@mail.gmail.com>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com>
 <20171226030751.GA11758@gondor.apana.org.au> <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com>
 <20171226104010.GA28275@gondor.apana.org.au> <CAOtvUMeEw88mYVjb7bDLwGb67aXi2p5e-uRXn0XrDe0uddyT6g@mail.gmail.com>
 <20171227033500.GA32764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:37542 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdL0G1y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Dec 2017 01:27:54 -0500
Received: by mail-ot0-f179.google.com with SMTP id p31so25969446ota.4
        for <linux-crypto@vger.kernel.org>; Tue, 26 Dec 2017 22:27:54 -0800 (PST)
In-Reply-To: <20171227033500.GA32764@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 27, 2017 at 5:35 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Dec 26, 2017 at 02:21:53PM +0200, Gilad Ben-Yossef wrote:
>>
>> See how SKCIPHER_REQUEST_ON_STACK is being used with an asymmetric skcipher
>> in drivers/md/dm-integrity.c
>
> That's just broken.  SKCIPHER_REQUEST_ON_STACK is only meant for
> sync algorithms and this code needs to be changed to either do the
> proper request allocation or switch over to allocating sync
> algorithms.

OK, great. Thanks for clearing that up.

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
