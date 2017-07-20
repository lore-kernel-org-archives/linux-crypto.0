From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: ixp4xx - Fix error handling path in 'aead_perform()'
Date: Thu, 20 Jul 2017 17:16:57 +0200
Message-ID: <CAK8P3a2Kd5_EdHeCXki-2sLN2BxNZwW6aQm0RJX6J-S2jxFt5Q@mail.gmail.com>
References: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr>
 <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com> <CAK8P3a0kNP9sH68hJ=Mhc1cj1LDwja1qiihdVVrv2gvJ=ZYj-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0kNP9sH68hJ=Mhc1cj1LDwja1qiihdVVrv2gvJ=ZYj-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 20, 2017 at 5:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Coincidentally, I just came across an older patch of mine that actually
> fixes the warning properly, but that for some reason ended up not
> getting merged:
>
> https://patchwork.kernel.org/patch/8236811/
>
> How about we just revert my broken 0f987e25cb8a patch, and I apply
> the mach-ixp4xx patch instead?

Nevermind that, I just tried it and the warning is back after reverting my
0f987e25cb8a patch, regardless of the indirect-io patch.

         Arnd
