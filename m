From: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: n2 RNG driver bogus cast removal
Date: Mon, 9 Aug 2010 23:32:46 +0400
Message-ID: <20100809193246.GA11374@albatros>
References: <20100809.004514.73697921.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100809.004514.73697921.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 09, 2010 at 00:45 -0700, David Miller wrote:
>=20
> Kulikov, can you at least build test your patches?  Casts are not
> always incorrect, particularly when private cookies are "unsigned
> long" as is the case here:
>=20
> drivers/char/hw_random/n2-drv.c: In function =E2=80=98n2rng_data_read=
=E2=80=99:
> drivers/char/hw_random/n2-drv.c:390: warning: initialization makes po=
inter from integer without a cast
Ahh, shame on me... I'd compiled this on x86 and looked through error
log, I wrongly pointed out that there is no error at this line. As I se=
e
now, this tactic is incorrect. I'd not do this any more, sorry for
this...

>=20
> Herbert, please revert this change, thanks.  And I suspect there
> might be more of these hwrng driver duds that went into the tree,
> it's worth checking out. :-)
>=20
> Thanks.
>=20
> commit 8b9cfdca9c52f7d39c3ccfac1668e31c20c9f42e
> Author: Kulikov Vasiliy <segooon@gmail.com>
> Date:   Mon Jul 5 21:25:06 2010 +0800
>=20
>     hwrng: n2-drv - remove casts from void*
>    =20
>     Remove unnesessary casts from void*.
>    =20
>     Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
