From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 19:05:48 +0200
Message-ID: <1535446.zHpTqe8jba@positron.chronox.de>
References: <20170325162654.3827-1-krzk@kernel.org> <20170326160126.nwboar7mwztwxtgp@kozik-lap> <CANc+2y4xkDs2kQGXKP=8i_v9oYw4dPKTjWs0xFnvOcwDbar47g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <CANc+2y4xkDs2kQGXKP=8i_v9oYw4dPKTjWs0xFnvOcwDbar47g@mail.gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 26. März 2017, 18:46:02 CEST schrieb PrasannaKumar Muralidharan:

Hi 	Krzysztof,

> >> > +       if (slen < EXYNOS_RNG_SEED_SIZE) {
> >> > +               dev_warn(rng->dev, "Seed too short (only %u bytes)\n",
> >> > slen); +               return -EINVAL;
> >> > +       }
> >> 
> >> Will it be helpful to print the required seed size?
> > 
> > It is in /proc/crypto... It is not a problem to print it but isn't that
> > redundant?
> 
> Not necessary if it is already available.

Maybe the dev_warn should be removed. Note, unprivileged user space can 
trigger this warning by simply invoking the seeding operation over and over 
again with an insufficient seed size. This would clutter the log.

Ciao
Stephan
