Return-Path: <SRS0=aDvo=PQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314C9C43387
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jan 2019 08:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3872070B
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jan 2019 08:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfAHItW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Jan 2019 03:49:22 -0500
Received: from ozlabs.org ([203.11.71.1]:56843 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbfAHItW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jan 2019 03:49:22 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 43YmCK6zqpz9sMQ;
        Tue,  8 Jan 2019 19:49:17 +1100 (AEDT)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto\@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "iommu\@lists.linux-foundation.org" 
        <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v3] crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK
In-Reply-To: <d609078d-b432-0fba-8a48-4224e62b46a9@c-s.fr>
References: <ae7b64e9415874060977e32ed48b62f1f6148084.1545346337.git.christophe.leroy@c-s.fr> <VI1PR0402MB3485FC2A3758BCEAC05BF3A2988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com> <VI1PR0402MB34853754B8F90F5904710526988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com> <d609078d-b432-0fba-8a48-4224e62b46a9@c-s.fr>
Date:   Tue, 08 Jan 2019 19:49:14 +1100
Message-ID: <87muobttyt.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190108084914.IiWeWTXhrn2rfZTaW4XOi5X6wc6sQZzlHgitp5xz2uk@z>

Christophe Leroy <christophe.leroy@c-s.fr> writes:
> Le 04/01/2019 à 16:24, Horia Geanta a écrit :
>> On 1/4/2019 5:17 PM, Horia Geanta wrote:
>>> On 12/21/2018 10:07 AM, Christophe Leroy wrote:
>>> [snip]
>>>> IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stack
>>>> cannot be DMA mapped anymore.
>>>> This looks better, thanks.
>>>
>>>> This patch copies the IV into the extended descriptor when iv is not
>>>> a valid linear address.
>>>>
>>> Though I am not sure the checks in place are enough.
>>>
>>>> Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>> ---
>>>>   v3: Using struct edesc buffer.
>>>>
>>>>   v2: Using per-request context.
>>> [snip]
>>>> +	if (ivsize && !virt_addr_valid(iv))
>>>> +		alloc_len += ivsize;
>>> [snip]
>>>>   
>>>> +	if (ivsize && !virt_addr_valid(iv))
>>> A more precise condition would be (!is_vmalloc_addr || is_vmalloc_addr(iv))
>>>
>> Sorry for the typo, I meant:
>> (!virt_addr_valid(iv) || is_vmalloc_addr(iv))
>
> As far as I know, virt_addr_valid() means the address is in the linear 
> memory space. So it cannot be a vmalloc_addr if it is a linear space 
> addr, can it ?

That matches my understanding.

This is one of those historical macros that has no documentation and its
behaviour is only defined in terms of other things, so it's kind of hard
to track down.

In commit e41e53cd4fe3 ("powerpc/mm: Fix virt_addr_valid() etc. on
64-bit hash")

https://git.kernel.org/torvalds/c/e41e53cd4fe3

I said:

  virt_addr_valid() is supposed to tell you if it's OK to call virt_to_page() on
  an address. What this means in practice is that it should only return true for
  addresses in the linear mapping which are backed by a valid PFN.


Each arch can define virt_to_page(), so presumably you *could* set
things up such that virt_to_page() worked on vmalloc addresses.

Originally virt_to_page() would basically just mask and right shift the
address and then use that as an array index to get the page. Things are
more complicated now that we have SPARSEMEM etc. but it still only works
for linear mapping addresses.

Hopefully someone who knows mm stuff can chime in and tell us if we're
missing anything :)

cheers
