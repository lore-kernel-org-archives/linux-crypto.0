From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: ixp4xx - Fix error handling path in 'aead_perform()'
Date: Thu, 20 Jul 2017 17:04:28 +0200
Message-ID: <CAK8P3a0kNP9sH68hJ=Mhc1cj1LDwja1qiihdVVrv2gvJ=ZYj-A@mail.gmail.com>
References: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr> <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 20, 2017 at 9:37 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Jul 19, 2017 at 11:47 PM, Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>> In commit 0f987e25cb8a, the source processing has been moved in front of
>> the destination processing, but the error handling path has not been
>> modified accordingly.
>> Free resources in the correct order to avoid some leaks.
>>
>> Fixes: 0f987e25cb8a ("crypto: ixp4xx - Fix false lastlen uninitialised warning")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> Thanks for spotting my mistake!
>
> I've looked at it again and think it's unfortunately still wrong with
> your patch,
> as there is a 'goto free_buf_src' after dma_pool_alloc(), and that now needs
> to jump to free_buf_dst instead. We may also need an extra check to make
> sure we don't free an uninitialized pointer again.
>
> Can you have a look at this version below and send whatever you find
> to be correct in the end?
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Coincidentally, I just came across an older patch of mine that actually
fixes the warning properly, but that for some reason ended up not
getting merged:

https://patchwork.kernel.org/patch/8236811/

How about we just revert my broken 0f987e25cb8a patch, and I apply
the mach-ixp4xx patch instead?

       Arnd
