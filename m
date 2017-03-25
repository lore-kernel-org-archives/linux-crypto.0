From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sat, 25 Mar 2017 13:48:35 +0100
Message-ID: <2198038.IahjPeE5Ux@positron.chronox.de>
References: <20170324182606.23339-1-krzk@kernel.org>
 <4248691.8fGIDmasva@tauon.atsec.com>
 <20170325073648.cbphcouvi6trmhcj@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Arnd Bergmann <arnd@arndb.de>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 linux-kernel@vger.kernel.org,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170325073648.cbphcouvi6trmhcj@kozik-lap>
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

Am Samstag, 25. M=E4rz 2017, 08:36:48 CET schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> On Fri, Mar 24, 2017 at 09:41:59PM +0100, Stephan M=FCller wrote:
> > Am Freitag, 24. M=E4rz 2017, 19:26:04 CET schrieb Krzysztof Kozlowski:
> > =

> > Hi Krzysztof,
> > =

> > > +static unsigned int exynos_rng_copy_random(struct exynos_rng_dev *rn=
g,
> > > +					   u8 *dst, unsigned int dlen)
> > > +{
> > > +	unsigned int cnt =3D 0;
> > > +	int i, j;
> > > +	u32 val;
> > > +
> > > +	for (j =3D 0; j < EXYNOS_RNG_SEED_REGS; j++) {
> > > +		val =3D exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
> > > +
> > > +		for (i =3D 0; i < 4; i++) {
> > > +			dst[cnt] =3D val & 0xff;
> > > +			val >>=3D 8;
> > > +			if (++cnt >=3D dlen)
> > > +				return cnt;
> > > +		}
> > > +		rng->seed_save[j] =3D val;
> > =

> > Just to clarify: is this call right? Shouldn't that be removed? Any RNG
> > that is given to a caller is tainted and should not serve as seed.
> =

> In that case I could either re-use RNGs not passed to the caller (like
> in the block quoted below) or generate another round of them just for
> purpose of next seeding.
> =

> With the first approach the problem is that I might wait for such unused
> numbers pretty long. If user is requesting large amount of data, then I
> will always give him all five output numbers. I will not have unused
> numbers.
> =

> The second approach seems safe, but requires additional engine run which
> will slow down some of the generate() calls.

Random numbers should never be used twice.
> =

> > > +	}
> > > +
> > > +	/*
> > > +	 * Engine filled all output registers, so read the remaining regist=
ers
> > > +	 * for storing data as future seed.
> > > +	 */
> > > +	for (; j < EXYNOS_RNG_SEED_REGS; j++)
> > > +		rng->seed_save[j] =3D exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
> > =

> > With this call, I guess the questioned line above could go away, right?
> =

> This is used in combination with the previous line so I will get five
> seeds (for five registers).
> =

> Best regards,
> Krzysztof


Ciao
Stephan
