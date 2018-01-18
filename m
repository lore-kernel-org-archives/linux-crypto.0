From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] crypto: ux500/hash: Add empty export and import
Date: Thu, 18 Jan 2018 11:06:46 +0100
Message-ID: <CACRpkdYLxALiKfaPe5rQwDTWj3y5tV3-491s=wJVa15qs0Z27A@mail.gmail.com>
References: <CGME20180116163219eucas1p132fafc2db8cb9b3af1a1f22d8bf2fdaf@eucas1p1.samsung.com>
 <a83d9022-b8bc-ea50-0707-5812f2306b8e@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joakim Bech <joakim.bech@linaro.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a83d9022-b8bc-ea50-0707-5812f2306b8e@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 16, 2018 at 5:32 PM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:

> Crypto framework will require async hash export/import, so add empty
> functions to prevent OOPS.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

But why isn't the framework code just checking the vtable for NULL?

if (foo->fp)
    foo->fp(bar);

Yours,
Linus Walleij
