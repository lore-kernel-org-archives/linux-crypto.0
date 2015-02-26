From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 02/10] ARM: OMAP3: Fix crypto support for HS devices
Date: Thu, 26 Feb 2015 14:49:52 +0100
Message-ID: <1424958600-18881-3-git-send-email-pali.rohar@gmail.com>
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

Register crypto hwmod links only if they are not disabled in DT.
If DT information is missing, enable them only for GP devices.

Before this patch crypto hwmod links were always disabled for all HS de=
vices
and it was not possible to use omap-aes and omap-sham linux drivers.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   79 ++++++++++++++++++++=
+++-----
 1 file changed, 66 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach=
-omap2/omap_hwmod_3xxx_data.c
index 4e8e93c..de13a06 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3744,29 +3744,54 @@ static struct omap_hwmod_ocp_if *omap3xxx_hwmod=
_ocp_ifs[] __initdata =3D {
 /* GP-only hwmod links */
 static struct omap_hwmod_ocp_if *omap34xx_gp_hwmod_ocp_ifs[] __initdat=
a =3D {
 	&omap3xxx_l4_sec__timer12,
-	&omap3xxx_l4_core__sham,
-	&omap3xxx_l4_core__aes,
 	NULL
 };
=20
 static struct omap_hwmod_ocp_if *omap36xx_gp_hwmod_ocp_ifs[] __initdat=
a =3D {
 	&omap3xxx_l4_sec__timer12,
-	&omap3xxx_l4_core__sham,
-	&omap3xxx_l4_core__aes,
 	NULL
 };
=20
 static struct omap_hwmod_ocp_if *am35xx_gp_hwmod_ocp_ifs[] __initdata =
=3D {
 	&omap3xxx_l4_sec__timer12,
-	/*
-	 * Apparently the SHA/MD5 and AES accelerator IP blocks are
-	 * only present on some AM35xx chips, and no one knows which
-	 * ones.  See
-	 * http://www.spinics.net/lists/arm-kernel/msg215466.html So
-	 * if you need these IP blocks on an AM35xx, try uncommenting
-	 * the following lines.
-	 */
+	NULL
+};
+
+/* crypto hwmod links */
+static struct omap_hwmod_ocp_if *omap34xx_sham_hwmod_ocp_ifs[] __initd=
ata =3D {
+	&omap3xxx_l4_core__sham,
+	NULL
+};
+
+static struct omap_hwmod_ocp_if *omap34xx_aes_hwmod_ocp_ifs[] __initda=
ta =3D {
+	&omap3xxx_l4_core__aes,
+	NULL
+};
+
+static struct omap_hwmod_ocp_if *omap36xx_sham_hwmod_ocp_ifs[] __initd=
ata =3D {
+	&omap3xxx_l4_core__sham,
+	NULL
+};
+
+static struct omap_hwmod_ocp_if *omap36xx_aes_hwmod_ocp_ifs[] __initda=
ta =3D {
+	&omap3xxx_l4_core__aes,
+	NULL
+};
+
+/*
+ * Apparently the SHA/MD5 and AES accelerator IP blocks are
+ * only present on some AM35xx chips, and no one knows which
+ * ones.  See
+ * http://www.spinics.net/lists/arm-kernel/msg215466.html So
+ * if you need these IP blocks on an AM35xx, try uncommenting
+ * the following lines.
+ */
+static struct omap_hwmod_ocp_if *am35xx_sham_hwmod_ocp_ifs[] __initdat=
a =3D {
 	/* &omap3xxx_l4_core__sham, */
+	NULL
+};
+
+static struct omap_hwmod_ocp_if *am35xx_aes_hwmod_ocp_ifs[] __initdata=
 =3D {
 	/* &omap3xxx_l4_core__aes, */
 	NULL
 };
@@ -3871,7 +3896,8 @@ static struct omap_hwmod_ocp_if *omap3xxx_dss_hwm=
od_ocp_ifs[] __initdata =3D {
 int __init omap3xxx_hwmod_init(void)
 {
 	int r;
-	struct omap_hwmod_ocp_if **h =3D NULL, **h_gp =3D NULL;
+	struct omap_hwmod_ocp_if **h =3D NULL, **h_gp =3D NULL, **h_sham =3D =
NULL, **h_aes =3D NULL;
+	struct device_node *bus =3D NULL;
 	unsigned int rev;
=20
 	omap_hwmod_init();
@@ -3893,13 +3919,19 @@ int __init omap3xxx_hwmod_init(void)
 	    rev =3D=3D OMAP3430_REV_ES3_1 || rev =3D=3D OMAP3430_REV_ES3_1_2)=
 {
 		h =3D omap34xx_hwmod_ocp_ifs;
 		h_gp =3D omap34xx_gp_hwmod_ocp_ifs;
+		h_sham =3D omap34xx_sham_hwmod_ocp_ifs;
+		h_aes =3D omap34xx_aes_hwmod_ocp_ifs;
 	} else if (rev =3D=3D AM35XX_REV_ES1_0 || rev =3D=3D AM35XX_REV_ES1_1=
) {
 		h =3D am35xx_hwmod_ocp_ifs;
 		h_gp =3D am35xx_gp_hwmod_ocp_ifs;
+		h_sham =3D am35xx_sham_hwmod_ocp_ifs;
+		h_aes =3D am35xx_aes_hwmod_ocp_ifs;
 	} else if (rev =3D=3D OMAP3630_REV_ES1_0 || rev =3D=3D OMAP3630_REV_E=
S1_1 ||
 		   rev =3D=3D OMAP3630_REV_ES1_2) {
 		h =3D omap36xx_hwmod_ocp_ifs;
 		h_gp =3D omap36xx_gp_hwmod_ocp_ifs;
+		h_sham =3D omap36xx_sham_hwmod_ocp_ifs;
+		h_aes =3D omap36xx_aes_hwmod_ocp_ifs;
 	} else {
 		WARN(1, "OMAP3 hwmod family init: unknown chip type\n");
 		return -EINVAL;
@@ -3916,6 +3948,27 @@ int __init omap3xxx_hwmod_init(void)
 			return r;
 	}
=20
+	/*
+	 * Register crypto hwmod links only if they are not disabled in DT.
+	 * If DT information is missing, enable them only for GP devices.
+	 */
+
+	if (of_have_populated_dt())
+		bus =3D of_find_node_by_name(NULL, "ocp");
+
+	if (h_sham && ((!bus && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) ||
+	    (bus && of_device_is_available(of_find_node_by_name(bus, "sham"))=
))) {
+		r =3D omap_hwmod_register_links(h_sham);
+		if (r < 0)
+			return r;
+	}
+
+	if (h_aes && ((!bus && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) ||
+	    (bus && of_device_is_available(of_find_node_by_name(bus, "aes")))=
)) {
+		r =3D omap_hwmod_register_links(h_aes);
+		if (r < 0)
+			return r;
+	}
=20
 	/*
 	 * Register hwmod links specific to certain ES levels of a
--=20
1.7.9.5
