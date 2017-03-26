From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 18:05:55 +0200
Message-ID: <6597290.C3JGqjKOeS@positron.chronox.de>
References: <20170325162654.3827-1-krzk@kernel.org>
 <CANc+2y4+1-oH50Y1tmTtOJ11snvi=FwNkjUbOE5ANPyNuzXOqg@mail.gmail.com>
 <20170326160126.nwboar7mwztwxtgp@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170326160126.nwboar7mwztwxtgp@kozik-lap>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 26. M=E4rz 2017, 18:01:26 CEST schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> > > +       if (slen < EXYNOS_RNG_SEED_SIZE) {
> > > +               dev_warn(rng->dev, "Seed too short (only %u bytes)\n",
> > > slen); +               return -EINVAL;
> > > +       }
> > =

> > Will it be helpful to print the required seed size?
> =

> It is in /proc/crypto... It is not a problem to print it but isn't that
> redundant?

You also get the information from crypto_user.

See [1] for a user space API.

[1] https://github.com/smuellerDD/libkcapi/commit/
f856e8c655b7e5c53f59ef8c5754ad59b196df08


Ciao
Stephan
