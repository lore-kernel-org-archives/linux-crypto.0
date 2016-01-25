From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] hw_random: bcm63xx-rng: remove unused variables
Date: Mon, 25 Jan 2016 22:49:03 +0800
Message-ID: <20160125144903.GI8840@gondor.apana.org.au>
References: <1453021437-12531-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, f.fainelli@gmail.com, jogo@openwrt.org,
	cernekee@gmail.com
To: =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453021437-12531-1-git-send-email-noltari@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jan 17, 2016 at 10:03:54AM +0100, =C1lvaro Fern=E1ndez Rojas wr=
ote:
> These variables where left as unused in commit 6229c16060fe
> ("hwrng: bcm63xx - make use of devm_hwrng_register")
>=20
> Fixes the following warning:
> drivers/char/hw_random/bcm63xx-rng.c: In function 'bcm63xx_rng_probe'=
:
> drivers/char/hw_random/bcm63xx-rng.c:85:16: warning: unused variable =
'rng'
> [-Wunused-variable]
>   struct hwrng *rng;
>                 ^
> drivers/char/hw_random/bcm63xx-rng.c:82:14: warning: unused variable =
'clk'
> [-Wunused-variable]
>   struct clk *clk;
>=20
> Signed-off-by: =C1lvaro Fern=E1ndez Rojas <noltari@gmail.com>

All applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
