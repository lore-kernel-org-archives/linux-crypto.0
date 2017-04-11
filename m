From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v4 2/2] crypto: hw_random - Add new Exynos RNG driver
Date: Tue, 11 Apr 2017 10:09:50 +0200
Message-ID: <CAJKOXPe4gDFWqNwa1WqADTv2Zv_wu3pVpEaefPz5POk8mVeaqQ@mail.gmail.com>
References: <20170408133245.30147-1-krzk@kernel.org> <20170408133245.30147-3-krzk@kernel.org>
 <20170410105547.GA8615@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: James Hogan <james.hogan@imgtec.com>,
        Matt Mackall <mpm@selenic.com>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Bernie Thompson <bernie@plugable.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-kernel@vger.kernel.org, linux-metag@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170410105547.GA8615@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 10, 2017 at 12:55 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Sat, Apr 08, 2017 at 03:32:45PM +0200, Krzysztof Kozlowski wrote:
>>
>> +static struct rng_alg exynos_rng_alg = {
>> +     .generate               = exynos_rng_generate,
>> +     .seed                   = exynos_rng_seed,
>> +     .seedsize               = EXYNOS_RNG_SEED_SIZE,
>> +     .base                   = {
>> +             .cra_name               = "exynos_rng",
>
> Please use stdrng.  Or is there a reason why this can't be used
> by the crypto layer itself?

I think there is no reason against, I'll fix it.

Best regards,
Krzysztof
