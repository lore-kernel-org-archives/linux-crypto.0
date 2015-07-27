From: Oleksij Rempel <linux-YEK0n+YFykbzxQdaRaTXBw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Mon, 27 Jul 2015 12:45:29 +0200
Message-ID: <55B60BC9.8040800@rempel-privat.de>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com> <1436946847-10909-2-git-send-email-miaoqing@qca.qualcomm.com> <55B48F15.9050302@rempel-privat.de> <a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hrvGKHu3ni0Jc9dKv7R3nLUR5GeWhREFT"
Cc: "linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org
To: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
	"linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a8b787bd17d94e8899bf1be6131165b2-Y81KQx/RBXvl7IBs54+zFqRtKmQZhJ7pQQ4Iyu8u01E@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hrvGKHu3ni0Jc9dKv7R3nLUR5GeWhREFT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 27.07.2015 um 08:50 schrieb Pan, Miaoqing:
>  =E2=80=9Cfips_run_rng_test=E2=80=9D  is legacy code, recommend to disa=
ble 'FIPS 140-2' test if to use 'rngd-tools=E2=80=99.

Ok, lets try simple compression. will it find enough pattern to do
compression?
Here what i get on my system:
output from /dev/random
-rw-rw-r-- 1 lex lex 2501678 Jul 27 12:01 random.out
-rw-rw-r-- 1 lex lex 2512892 Jul 27 12:01 random.out.bz2

after compression we got bigger file. i would expect it since we need to
store bzip header somewhere.

output from /dev/hwrng
-rw-rw-r-- 1 lex lex 2564096 Jul 27 11:36 hwrng.out
-rw-rw-r-- 1 lex lex 2468394 Jul 27 11:36 hwrng.out.bz2

Do i understand it correctly, in case of hwrng bzip was able to find
enough pattern to compressed the data? Even with format overhead?

I'm no an expert, help of an expert would be welcome, added some more
people to CC

> -Miaoqing
>=20
> -----Original Message-----
> From: Oleksij Rempel [mailto:linux-YEK0n+YFykbzxQdaRaTXBw@public.gmane.org]=20
> Sent: Sunday, July 26, 2015 3:41 PM
> To: Pan, Miaoqing; linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org
> Cc: linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ath9k-devel
> Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
>=20
> Hi all,
>=20
> i did rngtest on top of this patch. The results are incredibly bad, rig=
ht now it is more a pattern generator not random number generator. Is it =
possible to fix it?
>=20
> /home/lex# cat /dev/hwrng | rngtest -c 1000 rngtest 5 Copyright (c) 200=
4 by Henrique de Moraes Holschuh This is free software; see the source fo=
r copying conditions.  There is NO warranty; not even for MERCHANTABILITY=
 or FITNESS FOR A PARTICULAR PURPOSE.
>=20
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 0
> rngtest: FIPS 140-2 failures: 1000
> rngtest: FIPS 140-2(2001-10-10) Monobit: 27
> rngtest: FIPS 140-2(2001-10-10) Poker: 1000
> rngtest: FIPS 140-2(2001-10-10) Runs: 1000
> rngtest: FIPS 140-2(2001-10-10) Long run: 2
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D1.879; avg=3D871.897; max=3D195312=
50.000)Kibits/s
> rngtest: FIPS tests speed: (min=3D19.443; avg=3D48.374; max=3D70.123)Mi=
bits/s
> rngtest: Program run time: 23423736 microseconds
>=20
>=20
>=20
> Am 15.07.2015 um 09:54 schrieb miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org:
>> From: Miaoqing Pan <miaoqing-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>
>>
>> We measured the FFT-based entropy in 3 ways, Shannon entropy,=20
>> collision entropy, and directly measured min-entropy. Just to be=20
>> conservative, we recommend the estimated min-Entropy to be
>> 10 bits per 16-bit value.
>>
>> Analysis was done by Jacobson,David(djacobso-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org).
>>
>> Signed-off-by: Miaoqing Pan <miaoqing-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>
>> ---
>>  drivers/net/wireless/ath/ath9k/Kconfig  |  7 +++ =20
>> drivers/net/wireless/ath/ath9k/Makefile |  1 + =20
>> drivers/net/wireless/ath/ath9k/ath9k.h  | 23 ++++++++++
>>  drivers/net/wireless/ath/ath9k/main.c   |  4 ++
>>  drivers/net/wireless/ath/ath9k/rng.c    | 75 ++++++++++++++++++++++++=
+++++++++
>>  5 files changed, 110 insertions(+)
>>  create mode 100644 drivers/net/wireless/ath/ath9k/rng.c
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig=20
>> b/drivers/net/wireless/ath/ath9k/Kconfig
>> index fee0cad..bde62ec9 100644
>> --- a/drivers/net/wireless/ath/ath9k/Kconfig
>> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
>> @@ -176,3 +176,10 @@ config ATH9K_HTC_DEBUGFS
>>  	depends on ATH9K_HTC && DEBUG_FS
>>  	---help---
>>  	  Say Y, if you need access to ath9k_htc's statistics.
>> +
>> +config ATH9K_HWRNG
>> +	bool "Random number generator support"
>> +	depends on ATH9K && (HW_RANDOM =3D y || HW_RANDOM =3D ATH9K)
>> +	default y
>> +	---help---
>> +	  Provides a hardware random number generator to the kernel.
>> diff --git a/drivers/net/wireless/ath/ath9k/Makefile=20
>> b/drivers/net/wireless/ath/ath9k/Makefile
>> index ecda613..76f9dc3 100644
>> --- a/drivers/net/wireless/ath/ath9k/Makefile
>> +++ b/drivers/net/wireless/ath/ath9k/Makefile
>> @@ -15,6 +15,7 @@ ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) +=3D dfs_debug.o
>>  ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) +=3D dfs.o
>>  ath9k-$(CONFIG_ATH9K_TX99) +=3D tx99.o
>>  ath9k-$(CONFIG_ATH9K_WOW) +=3D wow.o
>> +ath9k-$(CONFIG_ATH9K_HWRNG) +=3D rng.o
>> =20
>>  ath9k-$(CONFIG_ATH9K_DEBUGFS) +=3D debug.o
>> =20
>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h=20
>> b/drivers/net/wireless/ath/ath9k/ath9k.h
>> index a7a81b3..45596e5 100644
>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> @@ -23,6 +23,7 @@
>>  #include <linux/leds.h>
>>  #include <linux/completion.h>
>>  #include <linux/time.h>
>> +#include <linux/hw_random.h>
>> =20
>>  #include "common.h"
>>  #include "debug.h"
>> @@ -1041,6 +1042,12 @@ struct ath_softc {
>>  	u32 wow_intr_before_sleep;
>>  	bool force_wow;
>>  #endif
>> +
>> +#ifdef CONFIG_ATH9K_HWRNG
>> +	struct hwrng rng;
>> +	bool rng_initialized;
>> +	u32 rng_last;
>> +#endif
>>  };
>> =20
>>  /********/
>> @@ -1063,6 +1070,22 @@ static inline int ath9k_tx99_send(struct=20
>> ath_softc *sc,  }  #endif /* CONFIG_ATH9K_TX99 */
>> =20
>> +/***************************/
>> +/* Random Number Generator */
>> +/***************************/
>> +#ifdef CONFIG_ATH9K_HWRNG
>> +void ath9k_rng_register(struct ath_softc *sc); void=20
>> +ath9k_rng_unregister(struct ath_softc *sc); #else static inline void =

>> +ath9k_rng_register(struct ath_softc *sc) { }
>> +
>> +static inline void ath9k_rng_unregister(struct ath_softc *sc) { }=20
>> +#endif
>> +
>>  static inline void ath_read_cachesize(struct ath_common *common, int =

>> *csz)  {
>>  	common->bus_ops->read_cachesize(common, csz); diff --git=20
>> a/drivers/net/wireless/ath/ath9k/main.c=20
>> b/drivers/net/wireless/ath/ath9k/main.c
>> index cfd45cb..5916ab2 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -739,6 +739,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
>> =20
>>  	ath9k_ps_restore(sc);
>> =20
>> +	ath9k_rng_register(sc);
>> +
>>  	return 0;
>>  }
>> =20
>> @@ -828,6 +830,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>> =20
>>  	ath9k_deinit_channel_context(sc);
>> =20
>> +	ath9k_rng_unregister(sc);
>> +
>>  	mutex_lock(&sc->mutex);
>> =20
>>  	ath_cancel_work(sc);
>> diff --git a/drivers/net/wireless/ath/ath9k/rng.c=20
>> b/drivers/net/wireless/ath/ath9k/rng.c
>> new file mode 100644
>> index 0000000..d8fa7a5
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath9k/rng.c
>> @@ -0,0 +1,75 @@
>> +/*
>> + * Copyright (c) 2015 Qualcomm Atheros, Inc.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software=20
>> +for any
>> + * purpose with or without fee is hereby granted, provided that the=20
>> +above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL=20
>> +WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE=20
>> +LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY=20
>> +DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN=
=20
>> +AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING=20
>> +OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>> +
>> +#include "ath9k.h"
>> +#include "hw.h"
>> +#include "ar9003_phy.h"
>> +
>> +static int ath9k_rng_data_read(struct hwrng *rng, u32 *data) {
>> +	u32 v1, v2;
>> +	struct ath_softc *sc =3D (struct ath_softc *)rng->priv;
>> +	struct ath_hw *ah =3D sc->sc_ah;
>> +
>> +	ath9k_ps_wakeup(sc);
>> +
>> +	REG_RMW_FIELD(ah, AR_PHY_TEST, AR_PHY_TEST_BBB_OBS_SEL, 5);
>> +	REG_CLR_BIT(ah, AR_PHY_TEST, AR_PHY_TEST_RX_OBS_SEL_BIT5);
>> +	REG_RMW_FIELD(ah, AR_PHY_TEST_CTL_STATUS,=20
>> +AR_PHY_TEST_CTL_RX_OBS_SEL, 0);
>> +
>> +	v1 =3D REG_READ(ah, AR_PHY_TST_ADC);
>> +	v2 =3D REG_READ(ah, AR_PHY_TST_ADC);
>> +
>> +	ath9k_ps_restore(sc);
>> +
>> +	/* wait for data ready */
>> +	if (v1 && v2 && sc->rng_last !=3D v1 && v1 !=3D v2) {
>> +		*data =3D (v1 & 0xffff) | (v2 << 16);
>> +		sc->rng_last =3D v2;
>> +
>> +		return sizeof(u32);
>> +	}
>> +
>> +	sc->rng_last =3D v2;
>> +
>> +	return 0;
>> +}
>> +
>> +void ath9k_rng_register(struct ath_softc *sc) {
>> +	struct ath_hw *ah =3D sc->sc_ah;
>> +
>> +	if (WARN_ON(sc->rng_initialized))
>> +		return;
>> +
>> +	if (!AR_SREV_9300_20_OR_LATER(ah))
>> +		return;
>> +
>> +	sc->rng.name =3D "ath9k";
>> +	sc->rng.data_read =3D ath9k_rng_data_read;
>> +	sc->rng.priv =3D (unsigned long)sc;
>> +
>> +	if (!hwrng_register(&sc->rng))
>> +		sc->rng_initialized =3D true;
>> +}
>> +
>> +void ath9k_rng_unregister(struct ath_softc *sc) {
>> +	if (sc->rng_initialized) {
>> +		hwrng_unregister(&sc->rng);
>> +		sc->rng_initialized =3D false;
>> +	}
>> +}
>>
>=20
>=20
> --
> Regards,
> Oleksij
>=20


--=20
Regards,
Oleksij


--hrvGKHu3ni0Jc9dKv7R3nLUR5GeWhREFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlW2C80ACgkQHwImuRkmbWn3ugD9EqM5immmhajVCi6RKMNSOHol
n3ll3gN9jB7LTDaz6pIA/jeV4wc+Qp0TiFlarSx0wkDmIG3RkEGETF/4E8H26Qu5
=jc++
-----END PGP SIGNATURE-----

--hrvGKHu3ni0Jc9dKv7R3nLUR5GeWhREFT--
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
