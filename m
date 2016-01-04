From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 2/5] crypto: sunxi-ss: fix min3() call to match types
Date: Mon, 4 Jan 2016 15:20:01 +0100
Message-ID: <20160104142001.GB28361@pengutronix.de>
References: <1450787267-26836-1-git-send-email-andre.przywara@arm.com>
 <1450787267-26836-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, arnd@arndb.de,
	Herbert Xu <herbert@gondor.apana.org.au>, marc.zyngier@arm.com,
	catalin.marinas@arm.com, will.deacon@arm.com,
	linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
To: Andre Przywara <andre.przywara@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46881 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbcADOUR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jan 2016 09:20:17 -0500
Content-Disposition: inline
In-Reply-To: <1450787267-26836-3-git-send-email-andre.przywara@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 22, 2015 at 12:27:44PM +0000, Andre Przywara wrote:
> The min3() macro expects all arguments to be of the same type (or
> size at least). While two arguments are ints or u32s, one is size_t,
> which does not match on 64-bit architectures.
> Cast the size_t to u32 to make min3() happy. In this context here the
> length should never exceed 32 bits anyway.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 12 ++++++------
>  drivers/crypto/sunxi-ss/sun4i-ss-hash.c   |  8 ++++----
>  2 files changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/cryp=
to/sunxi-ss/sun4i-ss-cipher.c
> index a19ee12..b3bc7bd 100644
> --- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
> @@ -79,7 +79,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_req=
uest *areq)
>  	oi =3D 0;
>  	oo =3D 0;
>  	do {
> -		todo =3D min3(rx_cnt, ileft, (mi.length - oi) / 4);
> +		todo =3D min3(rx_cnt, ileft, (u32)(mi.length - oi) / 4);

=46or this case the min function has a min_t variant to specify the
argument. What about introducing min3_t?

BTW, I don't understand why min3(x, y, z) isn't just defined as

	#define min3(x, y, z) min(min(x, y), z)

but instead as:

	#define min3(x, y, z) min((typeof(x))min(x, y), z)

=2E I thought min(x, y) has the same type as x anyhow?

Best regards
Uwe


--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
