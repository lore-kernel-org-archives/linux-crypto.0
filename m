From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2] crypto: omap-sham: Check for return value from pm_runtime_get_sync
Date: Sun,  8 Mar 2015 11:01:01 +0100
Message-ID: <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
References: <1424958600-18881-5-git-send-email-pali.rohar@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39490 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbbCHKBQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Mar 2015 06:01:16 -0400
In-Reply-To: <1424958600-18881-5-git-send-email-pali.rohar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46unction pm_runtime_get_sync could fail and we need to check return
value to prevent kernel crash.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
v2: Check return value for all pm_runtime_get_sync() calls
---
 drivers/crypto/omap-sham.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b20e374..c5df53d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -362,7 +362,13 @@ static void omap_sham_copy_ready_hash(struct ahash=
_request *req)
=20
 static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
-	pm_runtime_get_sync(dd->dev);
+	int err;
+
+	err =3D pm_runtime_get_sync(dd->dev);
+	if (err < 0) {
+		dev_err(dd->dev, "failed to get sync: %d\n", err);
+		return err;
+	}
=20
 	if (!test_bit(FLAGS_INIT, &dd->flags)) {
 		set_bit(FLAGS_INIT, &dd->flags);
@@ -1949,7 +1955,13 @@ static int omap_sham_probe(struct platform_devic=
e *pdev)
 	dd->flags |=3D dd->pdata->flags;
=20
 	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
+
+	err =3D pm_runtime_get_sync(dev);
+	if (err < 0) {
+		dev_err(dev, "failed to get sync: %d\n", err);
+		goto err_pm;
+	}
+
 	rev =3D omap_sham_read(dd, SHA_REG_REV(dd));
 	pm_runtime_put_sync(&pdev->dev);
=20
@@ -1979,6 +1991,7 @@ err_algs:
 		for (j =3D dd->pdata->algs_info[i].registered - 1; j >=3D 0; j--)
 			crypto_unregister_ahash(
 					&dd->pdata->algs_info[i].algs_list[j]);
+err_pm:
 	pm_runtime_disable(dev);
 	if (dd->dma_lch)
 		dma_release_channel(dd->dma_lch);
@@ -2021,7 +2034,11 @@ static int omap_sham_suspend(struct device *dev)
=20
 static int omap_sham_resume(struct device *dev)
 {
-	pm_runtime_get_sync(dev);
+	int err =3D pm_runtime_get_sync(dev);
+	if (err < 0) {
+		dev_err(dev, "failed to get sync: %d\n", err);
+		return err;
+	}
 	return 0;
 }
 #endif
--=20
1.7.9.5
