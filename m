From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 01/10] ARM: OMAP2+: Return correct error values from device and hwmod
Date: Thu, 26 Feb 2015 14:49:51 +0100
Message-ID: <1424958600-18881-2-git-send-email-pali.rohar@gmail.com>
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

Without this patch function pm_runtime_get_sync() returns 0 even when s=
ome
omap subfunction fails. This patch properly propagate error codes from =
omap
functions back to caller.

This patch fix problem, when loading omap-aes driver in qemu cause kern=
el oops.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/omap_device.c |   30 +++++++++++++++++------------=
-
 arch/arm/mach-omap2/omap_hwmod.c  |   10 ++++++----
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/om=
ap_device.c
index be9541e..9fd47a9 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -224,13 +224,13 @@ static int _omap_device_notifier_call(struct noti=
fier_block *nb,
  */
 static int _omap_device_enable_hwmods(struct omap_device *od)
 {
+	int ret =3D 0;
 	int i;
=20
 	for (i =3D 0; i < od->hwmods_cnt; i++)
-		omap_hwmod_enable(od->hwmods[i]);
+		ret |=3D omap_hwmod_enable(od->hwmods[i]);
=20
-	/* XXX pass along return value here? */
-	return 0;
+	return ret;
 }
=20
 /**
@@ -241,13 +241,13 @@ static int _omap_device_enable_hwmods(struct omap=
_device *od)
  */
 static int _omap_device_idle_hwmods(struct omap_device *od)
 {
+	int ret =3D 0;
 	int i;
=20
 	for (i =3D 0; i < od->hwmods_cnt; i++)
-		omap_hwmod_idle(od->hwmods[i]);
+		ret |=3D omap_hwmod_idle(od->hwmods[i]);
=20
-	/* XXX pass along return value here? */
-	return 0;
+	return ret;
 }
=20
 /* Public functions for use by core code */
@@ -595,18 +595,20 @@ static int _od_runtime_suspend(struct device *dev=
)
 	int ret;
=20
 	ret =3D pm_generic_runtime_suspend(dev);
+	if (ret)
+		return ret;
=20
-	if (!ret)
-		omap_device_idle(pdev);
-
-	return ret;
+	return omap_device_idle(pdev);
 }
=20
 static int _od_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev =3D to_platform_device(dev);
+	int ret;
=20
-	omap_device_enable(pdev);
+	ret =3D omap_device_enable(pdev);
+	if (ret)
+		return ret;
=20
 	return pm_generic_runtime_resume(dev);
 }
@@ -740,7 +742,8 @@ int omap_device_enable(struct platform_device *pdev=
)
=20
 	ret =3D _omap_device_enable_hwmods(od);
=20
-	od->_state =3D OMAP_DEVICE_STATE_ENABLED;
+	if (ret =3D=3D 0)
+		od->_state =3D OMAP_DEVICE_STATE_ENABLED;
=20
 	return ret;
 }
@@ -770,7 +773,8 @@ int omap_device_idle(struct platform_device *pdev)
=20
 	ret =3D _omap_device_idle_hwmods(od);
=20
-	od->_state =3D OMAP_DEVICE_STATE_IDLE;
+	if (ret =3D=3D 0)
+		od->_state =3D OMAP_DEVICE_STATE_IDLE;
=20
 	return ret;
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/oma=
p_hwmod.c
index 92afb72..870e984 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3350,16 +3350,17 @@ int omap_hwmod_enable(struct omap_hwmod *oh)
  */
 int omap_hwmod_idle(struct omap_hwmod *oh)
 {
+	int r;
 	unsigned long flags;
=20
 	if (!oh)
 		return -EINVAL;
=20
 	spin_lock_irqsave(&oh->_lock, flags);
-	_idle(oh);
+	r =3D _idle(oh);
 	spin_unlock_irqrestore(&oh->_lock, flags);
=20
-	return 0;
+	return r;
 }
=20
 /**
@@ -3372,16 +3373,17 @@ int omap_hwmod_idle(struct omap_hwmod *oh)
  */
 int omap_hwmod_shutdown(struct omap_hwmod *oh)
 {
+	int r;
 	unsigned long flags;
=20
 	if (!oh)
 		return -EINVAL;
=20
 	spin_lock_irqsave(&oh->_lock, flags);
-	_shutdown(oh);
+	r =3D _shutdown(oh);
 	spin_unlock_irqrestore(&oh->_lock, flags);
=20
-	return 0;
+	return r;
 }
=20
 /*
--=20
1.7.9.5
