From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: Tree for Oct 26 (crypto/acompress.ko)
Date: Wed, 26 Oct 2016 19:54:00 -0400
Message-ID: <CAP=VYLq=Zgaf5uhWVG68Hyha=gJ923ZkW+v7UsfsOJE53YxR0w@mail.gmail.com>
References: <20161026135133.65edfd22@canb.auug.org.au> <052d917e-0442-0bbf-5b22-6506f832e30e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <052d917e-0442-0bbf-5b22-6506f832e30e@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 26, 2016 at 10:48 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 10/25/16 19:51, Stephen Rothwell wrote:
>> Hi all,
>>
>> There will probably be no linux-next releases next week while I attend
>> the Kernel Summit.
>>
>> Changes since 20161025:
>>
>
> on x864_64:
>
> ERROR: "crypto_acomp_scomp_alloc_ctx" [crypto/acompress.ko] undefined!
> ERROR: "crypto_acomp_scomp_free_ctx" [crypto/acompress.ko] undefined!
> ERROR: "crypto_init_scomp_ops_async" [crypto/acompress.ko] undefined!
>
>
> Full randconfig file is attached.

crypto/acompress.o ----> crypto/Makefile:obj-$(CONFIG_CRYPTO_ACOMP2)
+= acompress.o

crypto/Kconfig:config CRYPTO_ACOMP2
crypto/Kconfig: tristate

paul@builder:~/git/linux-head$ git grep crypto_acomp_scomp_alloc_ctx
crypto/acompress.c:             return crypto_acomp_scomp_alloc_ctx(req);
crypto/scompress.c:struct acomp_req
*crypto_acomp_scomp_alloc_ctx(struct acomp_req *req)
include/crypto/internal/scompress.h:struct acomp_req
*crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
paul@builder:~/git/linux-head$

So, no EXPORT_SYMBOL, and any .config which has ACOMP2=m will fail.

Paul.
--





>
> --
> ~Randy
