From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Subject: [PATCH] crypto: make Open Firmware device id constant
Date: Tue, 12 Jan 2010 09:01:45 +0100
Message-ID: <4B4C2C69.9000804@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, cocci@diku.dk,
	LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <cocci-bounces@diku.dk>
List-Unsubscribe: <http://lists.diku.dk/mailman/listinfo/cocci>,
	<mailto:cocci-request@diku.dk?subject=unsubscribe>
List-Archive: <http://lists.diku.dk/pipermail/cocci>
List-Post: <mailto:cocci@diku.dk>
List-Help: <mailto:cocci-request@diku.dk?subject=help>
List-Subscribe: <http://lists.diku.dk/mailman/listinfo/cocci>,
	<mailto:cocci-request@diku.dk?subject=subscribe>
Sender: cocci-bounces@diku.dk
Errors-To: cocci-bounces@diku.dk
List-Id: linux-crypto.vger.kernel.org

From: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>

The match_table field of the struct of_device_id is constant in <linux/of=
_platform.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y =3D {
	  .x =3D E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] =3D ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] =3D ...;
// </smpl>

Signed-off-by: M=C3=A1rton N=C3=A9meth <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
--- a/drivers/crypto/talitos.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/crypto/talitos.c 2010-01-08 14:16:24.000000000 +0100
@@ -1958,7 +1958,7 @@ err_out:
 	return err;
 }

-static struct of_device_id talitos_match[] =3D {
+static const struct of_device_id talitos_match[] =3D {
 	{
 		.compatible =3D "fsl,sec2.0",
 	},
diff -u -p a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/c=
rypto4xx_core.c
--- a/drivers/crypto/amcc/crypto4xx_core.c 2009-12-03 04:51:21.000000000 =
+0100
+++ b/drivers/crypto/amcc/crypto4xx_core.c 2010-01-08 14:16:45.000000000 =
+0100
@@ -1274,7 +1274,7 @@ static int __exit crypto4xx_remove(struc
 	return 0;
 }

-static struct of_device_id crypto4xx_match[] =3D {
+static const struct of_device_id crypto4xx_match[] =3D {
 	{ .compatible      =3D "amcc,ppc4xx-crypto",},
 	{ },
 };
_______________________________________________
Cocci mailing list
Cocci@diku.dk
http://lists.diku.dk/mailman/listinfo/cocci
(Web access from inside DIKUs LAN only)
