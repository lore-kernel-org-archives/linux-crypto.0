From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 17 Nov 2016 09:05:16 +0100
Message-ID: <20161117080516.GA25394@Red>
References: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com>
 <CANc+2y63p1b5ATDY0oU4nLckk9CJhSs3CXGHy=NwoXn_awP9aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y63p1b5ATDY0oU4nLckk9CJhSs3CXGHy=NwoXn_awP9aA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 18, 2016 at 09:39:17PM +0530, PrasannaKumar Muralidharan wrote:
> Hi Corentin,
> 
> I have a few minor comments.
> 
> On 18 October 2016 at 18:04, Corentin Labbe <clabbe.montjoie@gmail.com> wrote:
> > From: LABBE Corentin <clabbe.montjoie@gmail.com>
> >
> > The Security System have a PRNG.
> > This patch add support for it as an hwrng.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  drivers/crypto/Kconfig                   |  8 ++++
> >  drivers/crypto/sunxi-ss/Makefile         |  1 +
> >  drivers/crypto/sunxi-ss/sun4i-ss-core.c  | 14 +++++++
> >  drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c | 70 ++++++++++++++++++++++++++++++++
> >  drivers/crypto/sunxi-ss/sun4i-ss.h       |  8 ++++
> >  5 files changed, 101 insertions(+)
> >  create mode 100644 drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c
> >
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index 4d2b81f..38f7aca 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -538,6 +538,14 @@ config CRYPTO_DEV_SUN4I_SS
> >           To compile this driver as a module, choose M here: the module
> >           will be called sun4i-ss.
> >
> > +config CRYPTO_DEV_SUN4I_SS_PRNG
> > +       bool "Support for Allwinner Security System PRNG"
> > +       depends on CRYPTO_DEV_SUN4I_SS
> > +       select HW_RANDOM
> > +       help
> > +         This driver provides kernel-side support for the Pseudo-Random
> > +         Number Generator found in the Security System.
> > +
> >  config CRYPTO_DEV_ROCKCHIP
> >         tristate "Rockchip's Cryptographic Engine driver"
> >         depends on OF && ARCH_ROCKCHIP
> > diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/Makefile
> > index 8f4c7a2..ca049ee 100644
> > --- a/drivers/crypto/sunxi-ss/Makefile
> > +++ b/drivers/crypto/sunxi-ss/Makefile
> > @@ -1,2 +1,3 @@
> >  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sun4i-ss.o
> >  sun4i-ss-y += sun4i-ss-core.o sun4i-ss-hash.o sun4i-ss-cipher.o
> > +sun4i-ss-$(CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG) += sun4i-ss-hwrng.o
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > index 3ac6c6c..fa739de 100644
> > --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> > @@ -359,6 +359,16 @@ static int sun4i_ss_probe(struct platform_device *pdev)
> >                 }
> >         }
> >         platform_set_drvdata(pdev, ss);
> > +
> > +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
> > +       /* Voluntarily made the PRNG optional */
> > +       err = sun4i_ss_hwrng_register(&ss->hwrng);
> > +       if (!err)
> > +               dev_info(ss->dev, "sun4i-ss PRNG loaded");
> > +       else
> > +               dev_err(ss->dev, "sun4i-ss PRNG failed");
> > +#endif
> > +
> >         return 0;
> >  error_alg:
> >         i--;
> > @@ -386,6 +396,10 @@ static int sun4i_ss_remove(struct platform_device *pdev)
> >         int i;
> >         struct sun4i_ss_ctx *ss = platform_get_drvdata(pdev);
> >
> > +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
> > +       sun4i_ss_hwrng_remove(&ss->hwrng);
> > +#endif
> > +
> >         for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
> >                 switch (ss_algs[i].type) {
> >                 case CRYPTO_ALG_TYPE_ABLKCIPHER:
> > diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c b/drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c
> > new file mode 100644
> > index 0000000..95fadb7
> > --- /dev/null
> > +++ b/drivers/crypto/sunxi-ss/sun4i-ss-hwrng.c
> > @@ -0,0 +1,70 @@
> > +#include "sun4i-ss.h"
> > +
> > +static int sun4i_ss_hwrng_init(struct hwrng *hwrng)
> > +{
> > +       struct sun4i_ss_ctx *ss;
> > +
> > +       ss = container_of(hwrng, struct sun4i_ss_ctx, hwrng);
> > +       get_random_bytes(ss->seed, SS_SEED_LEN);
> > +
> > +       return 0;
> > +}
> > +
> > +static int sun4i_ss_hwrng_read(struct hwrng *hwrng, void *buf,
> > +                              size_t max, bool wait)
> > +{
> > +       int i;
> > +       u32 v;
> > +       u32 *data = buf;
> > +       const u32 mode = SS_OP_PRNG | SS_PRNG_CONTINUE | SS_ENABLED;
> > +       size_t len;
> > +       struct sun4i_ss_ctx *ss;
> > +
> > +       ss = container_of(hwrng, struct sun4i_ss_ctx, hwrng);
> > +       len = min_t(size_t, SS_DATA_LEN, max);
> > +
> > +       spin_lock_bh(&ss->slock);
> 
> Is spin_lock_bh really required here? I could see it is being used in
> sun4i-ss-hash.c but could not find any comment/info about the need.
> 

No for sun4i-ss-hwrng it seems not required and work perfecly without _bh

> > +       writel(mode, ss->base + SS_CTL);
> > +
> > +       /* write the seed */
> > +       for (i = 0; i < SS_SEED_LEN / 4; i++)
> > +               writel(ss->seed[i], ss->base + SS_KEY0 + i * 4);
> > +       writel(mode | SS_PRNG_START, ss->base + SS_CTL);
> > +
> > +       /* Read the random data */
> > +       readsl(ss->base + SS_TXFIFO, data, len / 4);
> > +
> > +       if (len % 4 > 0) {
> > +               v = readl(ss->base + SS_TXFIFO);
> > +               memcpy(data + len / 4, &v, len % 4);
> > +       }
> 
> hwrng core asks for "rng_buffer_size()" of data which is a multiple of
> 4. So len % 4 will be 0. I think the above check is not required. Feel
> free to correct if I am wrong.
> 

Agree, I removed that in v2

Thanks

Corentin Labbe
