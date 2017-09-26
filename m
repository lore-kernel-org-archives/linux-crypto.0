From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: Question about ahash export and import
Date: Tue, 26 Sep 2017 13:09:05 +0200
Message-ID: <be29fd42-2e64-5ca8-546c-e7f68a2d0da7@partner.samsung.com>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
        <CGME20170926103514epcas1p4494e6502b2b6835c732201a4aeff60b1@epcas1p4.samsung.com>
        <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41825 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937058AbdIZLJK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 07:09:10 -0400
In-reply-to: <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26.09.2017 12:34, Gilad Ben-Yossef wrote:
> On Tue, Sep 26, 2017 at 12:36 PM, Christophe LEROY
> <christophe.leroy@c-s.fr> wrote:
>> Hello,
>>
>> Today, the talitos driver dma maps/unmaps context and keys at every single
>> request.
>> I'm looking at doing the dma mapping at hash init and doing unmapping at
>> final/finup/digest
>>
>> However, I'm wondering how to manage hash exports and imports. I was
>> initially thinking about doing a dma_sync_for_cpu() before any export and a
>> dma_sync_for_device() after any export, but that supposes that the dma area
>> is already mapped, which means that we have done the init and not yet done a
>> final/finup/digest.
>>
>> I'm a bit sceptic when reading the following text in include/crypto/hash.h :
>>
>> @export: Export partial state of the transformation. This function dumps the
>>  *          entire state of the ongoing transformation into a provided block
>> of
>>  *          data so it can be @import 'ed back later on. This is useful in
>> case
>>  *          you want to save partial result of the transformation after
>>  *          processing certain amount of data and reload this partial result
>>  *          multiple times later on for multiple re-use
>>
>>
>> Does it mean that import may be called in lieu of hash init, or is hash init
>> always called before doing an import ?
>>
> 
> I believe import is called in lieu of init.
> 
> See the example is testmgr.c here:
> http://elixir.free-electrons.com/linux/latest/source
> 
> import is called on a freshly allocated request (save for set_crypt
> and set_callback), followed by
> a call to update.

Both import()/export() are synchronous op, this means they are not allowed
to return -EINPROGRESS nor call complete().

Can import() be called without _any_ init(), for example
after reboot of machine ? Is following scenario valid:

init(), update() 0 or more times, export(),
save exported data to pernament storage
reboot machine
load crypto driver, import() saved state ?

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
