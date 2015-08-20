From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: un4i-ss-cipher.c warning
Date: Thu, 20 Aug 2015 15:56:39 +0200
Message-ID: <55D5DC97.1040209@gmail.com>
References: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Michal Suchanek <hramrach@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19/08/2015 16:35, Michal Suchanek wrote:
> Hello,
>
> when building a kernel with sunxi crypto driver as merged into the
> sinxi-wip branch I get a compiler warning.
>
> I am not sure this is the latest version of the driver. It does not
> seem to be in mainline yet.
>
> Thanks
>
> Michal
>
> In file included from /scratch/build/linux/include/linux/printk.h:277=
:0,
>                   from /scratch/build/linux/include/linux/kernel.h:13=
,
>                   from /scratch/build/linux/include/linux/clk.h:16,
>                   from
> /scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss.h:15,
>                   from
> /scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:17:
> /scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In
> function =E2=80=98sun4i_ss_cipher_poll=E2=80=99:
> /scratch/build/linux/include/linux/dynamic_debug.h:86:3: warning:
> =E2=80=98todo=E2=80=99 may be used uninitialized in this function
> [-Wmaybe-uninitialized]
>     __dynamic_dev_dbg(&descriptor, dev, fmt, \
>     ^
> /scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:144:15=
:
> note: =E2=80=98todo=E2=80=99 was declared here
>    unsigned int todo;
>

Hello

Thanks for the report, strange that I do not have that warning.
todo is always initialized, since oleft and ileft are always > 0 at sta=
rt.
But setting todo to 0 is a simple fix.
The following patch will suppress the warning.

Regards

-- >8 --
 From 67f2d0749041b08c4c4ad671ab710b3b83f6dfd3 Mon Sep 17 00:00:00 2001
=46rom: LABBE Corentin <clabbe.montjoie@gmail.com>
Date: Thu, 20 Aug 2015 12:18:46 +0200
Subject: [PATCH] crypto: sun4i-ss: suppress the todo uninitialized warn=
ing

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
  drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto=
/sunxi-ss/sun4i-ss-cipher.c
index e070c31..9299914 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -32,7 +32,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_reque=
st *areq)
  	int i, err =3D 0;
  	unsigned int ileft =3D areq->nbytes;
  	unsigned int oleft =3D areq->nbytes;
-	unsigned int todo;
+	unsigned int todo =3D 0;
  	struct sg_mapping_iter mi, mo;
  	unsigned int oi, oo; /* offset for in and out */

@@ -141,7 +141,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_r=
equest *areq)
  	int i, err =3D 0;
  	unsigned int ileft =3D areq->nbytes;
  	unsigned int oleft =3D areq->nbytes;
-	unsigned int todo;
+	unsigned int todo =3D 0;
  	struct sg_mapping_iter mi, mo;
  	unsigned int oi, oo;	/* offset for in and out */
  	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
--=20
2.4.6
