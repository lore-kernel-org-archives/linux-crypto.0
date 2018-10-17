Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43982 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbeJRCUA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 22:20:00 -0400
Received: by mail-yw1-f67.google.com with SMTP id j75-v6so10752060ywj.10
        for <linux-crypto@vger.kernel.org>; Wed, 17 Oct 2018 11:23:06 -0700 (PDT)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id s15-v6sm6400220ywa.62.2018.10.17.11.23.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Oct 2018 11:23:03 -0700 (PDT)
Received: by mail-yw1-f48.google.com with SMTP id d126-v6so10762499ywa.5
        for <linux-crypto@vger.kernel.org>; Wed, 17 Oct 2018 11:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0529a397-f104-5f3a-663e-7ef2d883dcb2@embeddedor.com>
References: <20181008191712.GA12892@embeddedor.com> <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
 <9fa270bc-502d-5ff5-2acb-88ababcc9262@embeddedor.com> <20181017061741.qr23stkwqf36fet6@gondor.apana.org.au>
 <20181017072034.GD28572@kwain> <0529a397-f104-5f3a-663e-7ef2d883dcb2@embeddedor.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Oct 2018 11:23:02 -0700
Message-ID: <CAGXu5jKL07_ofMpTbaH2E=JnWEF8Y=36T+sQ5m-aRke5H=3twA@mail.gmail.com>
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 17, 2018 at 7:41 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
>
> On 10/17/18 9:20 AM, Antoine Tenart wrote:
>> Hi,
>>
>> On Wed, Oct 17, 2018 at 02:17:41PM +0800, Herbert Xu wrote:
>>> On Tue, Oct 16, 2018 at 09:44:02PM +0200, Gustavo A. R. Silva wrote:
>>>> On 10/9/18 12:20 AM, Kees Cook wrote:
>>>>> On Mon, Oct 8, 2018 at 12:17 PM, Gustavo A. R. Silva
>>>>> <gustavo@embeddedor.com> wrote:
>>>>>> The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
>>>>>> *pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
>>>>>> sizeof(*priv->ring[i].rdr_req).
>>>>>>
>>>>>> Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
>>>>>> Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
>>>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>>>
>>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>>
>>>>
>>>>
>>>> Friendly ping. Who can take this?
>>>
>>> Well I tried to take it but it doesn't apply against cryptodev.
>>> So I presume this can go into the tree that carried the change
>>> which it depended on?
>>
>> I would say this should go in cryptodev. The issue is probably because
>> of other changes that got applied in the meantime. Gustavo can probably
>> rebase his patch on top of cryptodev, and re-send it.
>>
>
> cryptodev is missing the previous commit 329e09893909d409039f6a79757d9b80b67efe39
> to which this patch applies.
>
> Kees, did you apply the commit above to your tree?
>
> If so, could you take this patch?

Since this has no functional exposure (the sizes are the same), let's
just wait until after the merge window to get this into crypto-next.

-Kees

-- 
Kees Cook
Pixel Security
