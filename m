From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 03/10] crypto: omap-sham: Add support for omap3 devices
Date: Thu, 26 Feb 2015 14:49:53 +0100
Message-ID: <1424958600-18881-4-git-send-email-pali.rohar@gmail.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

omap3 support is same as omap2, just with different IO address (specifi=
ed in DT)

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 drivers/crypto/omap-sham.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 3c76696..b20e374 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1792,6 +1792,10 @@ static const struct of_device_id omap_sham_of_ma=
tch[] =3D {
 		.data		=3D &omap_sham_pdata_omap2,
 	},
 	{
+		.compatible	=3D "ti,omap3-sham",
+		.data		=3D &omap_sham_pdata_omap2,
+	},
+	{
 		.compatible	=3D "ti,omap4-sham",
 		.data		=3D &omap_sham_pdata_omap4,
 	},
--=20
1.7.9.5
