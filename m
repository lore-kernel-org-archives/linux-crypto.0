From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] crypto: ixp4xx - Fix error handling path in 'aead_perform()'
Date: Wed, 2 Aug 2017 12:59:07 +0200
Message-ID: <CAK8P3a0Rx75vugf0o=ifi5TXR_UTxJJXSG-bZdfHuFc3OyWv=Q@mail.gmail.com>
References: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr>
 <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com> <20170802084046.GA6740@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35256 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752657AbdHBK7J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Aug 2017 06:59:09 -0400
In-Reply-To: <20170802084046.GA6740@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 2, 2017 at 10:40 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 20, 2017 at 09:37:10AM +0200, Arnd Bergmann wrote:
>
> Oops, looks like I introduced the bug.  Anyway, such is the danger
> of fixing compiler warnings in rarely used code.
>
> For some reason your patch is corrupted in patchwork.  Also we don't
> need to check crypt->dst as free_buf_chain is a no-op if we didn't do
> the allocation at all.  So how about this patch?

Looks good to me.

> ---8<---
> In commit 0f987e25cb8a, the source processing has been moved in front of
> the destination processing, but the error handling path has not been
> modified accordingly.
> Free resources in the correct order to avoid some leaks.
>
> Fixes: 0f987e25cb8a ("crypto: ixp4xx - Fix false lastlen uninitialised warning")
> Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
