From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: Question about ahash export and import
Date: Tue, 26 Sep 2017 13:34:52 +0300
Message-ID: <CAOtvUMeHF8PZAEaniK+oGYVOF5rbD_kZKuGC3j5XXkF-w2pPDA@mail.gmail.com>
References: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:47734 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965313AbdIZKex (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2017 06:34:53 -0400
Received: by mail-oi0-f45.google.com with SMTP id b1so11213465oih.4
        for <linux-crypto@vger.kernel.org>; Tue, 26 Sep 2017 03:34:53 -0700 (PDT)
In-Reply-To: <0e54df51-7b4c-a01e-2054-3cdf204a429e@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 26, 2017 at 12:36 PM, Christophe LEROY
<christophe.leroy@c-s.fr> wrote:
> Hello,
>
> Today, the talitos driver dma maps/unmaps context and keys at every single
> request.
> I'm looking at doing the dma mapping at hash init and doing unmapping at
> final/finup/digest
>
> However, I'm wondering how to manage hash exports and imports. I was
> initially thinking about doing a dma_sync_for_cpu() before any export and a
> dma_sync_for_device() after any export, but that supposes that the dma area
> is already mapped, which means that we have done the init and not yet done a
> final/finup/digest.
>
> I'm a bit sceptic when reading the following text in include/crypto/hash.h :
>
> @export: Export partial state of the transformation. This function dumps the
>  *          entire state of the ongoing transformation into a provided block
> of
>  *          data so it can be @import 'ed back later on. This is useful in
> case
>  *          you want to save partial result of the transformation after
>  *          processing certain amount of data and reload this partial result
>  *          multiple times later on for multiple re-use
>
>
> Does it mean that import may be called in lieu of hash init, or is hash init
> always called before doing an import ?
>

I believe import is called in lieu of init.

See the example is testmgr.c here:
http://elixir.free-electrons.com/linux/latest/source

import is called on a freshly allocated request (save for set_crypt
and set_callback), followed by
a call to update.

Gilad

> Thanks
> Christophe



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
