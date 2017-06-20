From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Tue, 20 Jun 2017 11:59:47 +0200
Message-ID: <20170620095947.i3r3iym2cxz5jciw@flea.lan>
References: <20170620085819.20114-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="t4jystnua5fvpthq"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170620085819.20114-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--t4jystnua5fvpthq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 20, 2017 at 10:58:19AM +0200, Corentin Labbe wrote:
> The Security System have a PRNG, this patch add support for it via
> crypto_rng.

This might be a dumb question, but is the CRYPTO_RNG code really
supposed to be used with PRNG?

> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/Kconfig                  |  8 +++++
>  drivers/crypto/sunxi-ss/Makefile        |  1 +
>  drivers/crypto/sunxi-ss/sun4i-ss-core.c | 30 ++++++++++++++++++
>  drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 56 +++++++++++++++++++++++++++=
++++++
>  drivers/crypto/sunxi-ss/sun4i-ss.h      |  9 ++++++
>  5 files changed, 104 insertions(+)
>  create mode 100644 drivers/crypto/sunxi-ss/sun4i-ss-prng.c
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index ab82536d64e2..bde0b102eb70 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -618,6 +618,14 @@ config CRYPTO_DEV_SUN4I_SS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called sun4i-ss.
> =20
> +config CRYPTO_DEV_SUN4I_SS_PRNG
> +	bool "Support for Allwinner Security System PRNG"
> +	depends on CRYPTO_DEV_SUN4I_SS
> +	select CRYPTO_RNG
> +	help
> +	  Select this option if you to provides kernel-side support for
> +	  the Pseudo-Random Number Generator found in the Security System.
> +
>  config CRYPTO_DEV_ROCKCHIP
>  	tristate "Rockchip's Cryptographic Engine driver"
>  	depends on OF && ARCH_ROCKCHIP
> diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/M=
akefile
> index 8f4c7a273141..ccb893219079 100644
> --- a/drivers/crypto/sunxi-ss/Makefile
> +++ b/drivers/crypto/sunxi-ss/Makefile
> @@ -1,2 +1,3 @@
>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) +=3D sun4i-ss.o
>  sun4i-ss-y +=3D sun4i-ss-core.o sun4i-ss-hash.o sun4i-ss-cipher.o
> +sun4i-ss-$(CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG) +=3D sun4i-ss-prng.o
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sun=
xi-ss/sun4i-ss-core.c
> index 02ad8256e900..d6bb2991c000 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
> @@ -213,6 +213,23 @@ static struct sun4i_ss_alg_template ss_algs[] =3D {
>  		}
>  	}
>  },
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
> +{
> +	.type =3D CRYPTO_ALG_TYPE_RNG,
> +	.alg.rng =3D {
> +		.base =3D {
> +			.cra_name		=3D "stdrng",
> +			.cra_driver_name	=3D "sun4i_ss_rng",
> +			.cra_priority		=3D 300,
> +			.cra_ctxsize		=3D 0,
> +			.cra_module		=3D THIS_MODULE,
> +		},
> +		.generate               =3D sun4i_ss_prng_generate,
> +		.seed                   =3D sun4i_ss_prng_seed,
> +		.seedsize               =3D SS_SEED_LEN,
> +	}
> +},
> +#endif
>  };
> =20
>  static int sun4i_ss_probe(struct platform_device *pdev)
> @@ -355,6 +372,13 @@ static int sun4i_ss_probe(struct platform_device *pd=
ev)
>  				goto error_alg;
>  			}
>  			break;
> +		case CRYPTO_ALG_TYPE_RNG:
> +			err =3D crypto_register_rng(&ss_algs[i].alg.rng);
> +			if (err) {
> +				dev_err(ss->dev, "Fail to register %s\n",
> +					ss_algs[i].alg.rng.base.cra_name);
> +			}
> +			break;
>  		}
>  	}
>  	platform_set_drvdata(pdev, ss);
> @@ -369,6 +393,9 @@ static int sun4i_ss_probe(struct platform_device *pde=
v)
>  		case CRYPTO_ALG_TYPE_AHASH:
>  			crypto_unregister_ahash(&ss_algs[i].alg.hash);
>  			break;
> +		case CRYPTO_ALG_TYPE_RNG:
> +			crypto_unregister_rng(&ss_algs[i].alg.rng);
> +			break;
>  		}
>  	}
>  	if (ss->reset)
> @@ -393,6 +420,9 @@ static int sun4i_ss_remove(struct platform_device *pd=
ev)
>  		case CRYPTO_ALG_TYPE_AHASH:
>  			crypto_unregister_ahash(&ss_algs[i].alg.hash);
>  			break;
> +		case CRYPTO_ALG_TYPE_RNG:
> +			crypto_unregister_rng(&ss_algs[i].alg.rng);
> +			break;
>  		}
>  	}
> =20
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-prng.c b/drivers/crypto/sun=
xi-ss/sun4i-ss-prng.c
> new file mode 100644
> index 000000000000..3941587def6b
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-prng.c
> @@ -0,0 +1,56 @@
> +#include "sun4i-ss.h"
> +
> +int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
> +		       unsigned int slen)
> +{
> +	struct sun4i_ss_alg_template *algt;
> +	struct rng_alg *alg =3D crypto_rng_alg(tfm);
> +
> +	algt =3D container_of(alg, struct sun4i_ss_alg_template, alg.rng);
> +	memcpy(algt->ss->seed, seed, slen);
> +
> +	return 0;
> +}
> +
> +int sun4i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
> +			   unsigned int slen, u8 *dst, unsigned int dlen)
> +{
> +	struct sun4i_ss_alg_template *algt;
> +	struct rng_alg *alg =3D crypto_rng_alg(tfm);
> +	int i;
> +	u32 v;
> +	u32 *data =3D (u32 *)dst;
> +	const u32 mode =3D SS_OP_PRNG | SS_PRNG_CONTINUE | SS_ENABLED;
> +	size_t len;
> +	struct sun4i_ss_ctx *ss;
> +	unsigned int todo =3D (dlen / 4) * 4;
> +
> +	algt =3D container_of(alg, struct sun4i_ss_alg_template, alg.rng);
> +	ss =3D algt->ss;
> +
> +	spin_lock(&ss->slock);
> +
> +	writel(mode, ss->base + SS_CTL);
> +
> +	while (todo > 0) {
> +		/* write the seed */
> +		for (i =3D 0; i < SS_SEED_LEN / 4; i++)
> +			writel(ss->seed[i], ss->base + SS_KEY0 + i * 4);
> +
> +		/* Read the random data */
> +		len =3D min_t(size_t, SS_DATA_LEN, todo);
> +		readsl(ss->base + SS_TXFIFO, data, len / 4);
> +		data +=3D len / 4;
> +		todo -=3D len;
> +
> +		/* Update the seed */
> +		for (i =3D 0; i < SS_SEED_LEN / 4; i++) {
> +			v =3D readl(ss->base + SS_KEY0 + i * 4);
> +			ss->seed[i] =3D v;
> +		}
> +	}
> +
> +	writel(0, ss->base + SS_CTL);
> +	spin_unlock(&ss->slock);
> +	return dlen;
> +}
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss=
/sun4i-ss.h
> index a0e1efc1cb2a..293632b1cf27 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss.h
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
> @@ -32,6 +32,7 @@
>  #include <crypto/aes.h>
>  #include <crypto/des.h>
>  #include <crypto/internal/rng.h>
> +#include <crypto/rng.h>
> =20
>  #define SS_CTL            0x00
>  #define SS_KEY0           0x04
> @@ -127,6 +128,9 @@
>  #define SS_RXFIFO_EMP_INT_ENABLE	(1 << 2)
>  #define SS_TXFIFO_AVA_INT_ENABLE	(1 << 0)
> =20
> +#define SS_SEED_LEN (192 / 8)
> +#define SS_DATA_LEN (160 / 8)
> +
>  struct sun4i_ss_ctx {
>  	void __iomem *base;
>  	int irq;
> @@ -136,6 +140,7 @@ struct sun4i_ss_ctx {
>  	struct device *dev;
>  	struct resource *res;
>  	spinlock_t slock; /* control the use of the device */
> +	u32 seed[SS_SEED_LEN / 4];

Shouldn't you define SS_SEED_LEN in bits, and then use either
BITS_PER_BYTE and BITS_PER_LONG so that it's obvious what you're doing
?

And you could also make that variable defined based on the option,
otherwise you'll always allocate that array, even if you're not using
it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--t4jystnua5fvpthq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZSPITAAoJEBx+YmzsjxAgkxMP/283sritjSLdCgDXWwipPgC2
eGFw32S09HjbiKATgFu6SiXvG2f+Up//X5TFSW/Gaq6ROgTjoMtLV7Lkzxf+ftSb
bl/bnGUKoFDi70acQ/4iFoFK3RDkwljH/PS9LIaPlzMmsTLqIH/A7R3SsoTiePCn
CFiWnnFDUT5atyNNSVQtvN8ncbDSGFZ8TA9YXDOkvk9vnc/llAnZzFDT7fzIYnNS
Gbg6V3BDflA1NMTHc7aqW0s/foUQ4SfaqBZ/i4yuUAbBow9vUIKNKbraqOdjGK+t
eUjcK3a5PF2kSvMp1Am0TOPD5fQr6ws0tk+vgZZmPinFjxnxJz8YBAwr210VYstc
+cw9lHWuQE+htH3WU6vpfv6SLE4Gn43bfF3fDy893pi5lGQEi63p7UMhXcznC3cJ
588xekaATNWWupTgpizmxAdQxYJPq0Lx1Fatyc53iORoyWPmFuykwekZMr0+0YWx
igo6Zy0tKm6YI3BhglQsqYzJum/pgk4ioaZL6rX4loh9nVqtMipJip+Rps8eyWy+
hnOICwXdc833LsyoJebwFKxvDXXPB3C6G4xGaIDLLaa+zmF+BbXZm5olYBn65kk6
Bp7RcLtVinov+LrW25GcVNL+jaYyLkYCJbs5zg234yOWljjiSkr79im2NPNyTu2+
/GtV4YUXyvpVGIMmjCE1
=WJp7
-----END PGP SIGNATURE-----

--t4jystnua5fvpthq--
