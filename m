Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.5]:24061 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbeJQXB6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 19:01:58 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 44B1C161AED
        for <linux-crypto@vger.kernel.org>; Wed, 17 Oct 2018 09:41:46 -0500 (CDT)
To: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20181008191712.GA12892@embeddedor.com>
 <CAGXu5j+a=81mGFrF5igMXe46mv_PsqzUKCzLWj0oCEMk1PY62g@mail.gmail.com>
 <9fa270bc-502d-5ff5-2acb-88ababcc9262@embeddedor.com>
 <20181017061741.qr23stkwqf36fet6@gondor.apana.org.au>
 <20181017072034.GD28572@kwain>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
Message-ID: <0529a397-f104-5f3a-663e-7ef2d883dcb2@embeddedor.com>
Date: Wed, 17 Oct 2018 16:41:23 +0200
MIME-Version: 1.0
In-Reply-To: <20181017072034.GD28572@kwain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/17/18 9:20 AM, Antoine Tenart wrote:
> Hi,
> 
> On Wed, Oct 17, 2018 at 02:17:41PM +0800, Herbert Xu wrote:
>> On Tue, Oct 16, 2018 at 09:44:02PM +0200, Gustavo A. R. Silva wrote:
>>> On 10/9/18 12:20 AM, Kees Cook wrote:
>>>> On Mon, Oct 8, 2018 at 12:17 PM, Gustavo A. R. Silva
>>>> <gustavo@embeddedor.com> wrote:
>>>>> The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
>>>>> *pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
>>>>> sizeof(*priv->ring[i].rdr_req).
>>>>>
>>>>> Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
>>>>> Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
>>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>
>>>
>>>
>>> Friendly ping. Who can take this?
>>
>> Well I tried to take it but it doesn't apply against cryptodev.
>> So I presume this can go into the tree that carried the change
>> which it depended on?
> 
> I would say this should go in cryptodev. The issue is probably because
> of other changes that got applied in the meantime. Gustavo can probably
> rebase his patch on top of cryptodev, and re-send it.
> 

cryptodev is missing the previous commit 329e09893909d409039f6a79757d9b80b67efe39
to which this patch applies.

Kees, did you apply the commit above to your tree?

If so, could you take this patch?

Thanks
--
Gustavo
