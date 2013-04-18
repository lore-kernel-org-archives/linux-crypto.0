From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/9] crypto: ux500/cryp - Fix compile error
Date: Thu, 18 Apr 2013 11:27:01 +0100
Message-ID: <1366280825-31136-6-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	Lee Jones <lee.jones@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Clearly this driver hasn't been tested, or even enabled in a while.

drivers/crypto/ux500/cryp/cryp_core.c:1771:3:
	error: request for member =E2=80=98pm=E2=80=99 in something not a stru=
cture or union

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux5=
00/cryp/cryp_core.c
index a56cbc4..444deaf 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1750,7 +1750,7 @@ static struct platform_driver cryp_driver =3D {
 	.shutdown =3D ux500_cryp_shutdown,
 	.driver =3D {
 		.owner =3D THIS_MODULE,
-		.name  =3D "cryp1"
+		.name  =3D "cryp1",
 		.pm    =3D &ux500_cryp_pm,
 	}
 };
--=20
1.7.10.4
