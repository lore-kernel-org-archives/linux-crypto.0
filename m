From: Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 02/10] ARM: OMAP3: Fix crypto support for HS devices
Date: Tue, 2 Jun 2015 18:36:30 +0000 (UTC)
Message-ID: <alpine.DEB.2.02.1506021835370.14902@utopia.booyaka.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com> <1424958600-18881-3-git-send-email-pali.rohar@gmail.com> <20150228162436.GB4978@amd> <20150526105415.GB14541@pali>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1596518239-1433270190=:14902"
Cc: =?ISO-8859-15?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>
To: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from utopia.booyaka.com ([74.50.51.50]:41669 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbbFBSgb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2015 14:36:31 -0400
In-Reply-To: <20150526105415.GB14541@pali>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1596518239-1433270190=:14902
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 26 May 2015, Pali Roh=C3=A1r wrote:

> Hi Paul,
>=20
> this patch is also for omap2... Can you review it too?
>=20
> On Saturday 28 February 2015 17:24:36 Pavel Machek wrote:
> > On Thu 2015-02-26 14:49:52, Pali Roh=C3=A1r wrote:
> > > Register crypto hwmod links only if they are not disabled in DT.
> > > If DT information is missing, enable them only for GP devices.
> > >=20
> > > Before this patch crypto hwmod links were always disabled for all HS =
devices
> > > and it was not possible to use omap-aes and omap-sham linux drivers.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >=20
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> >=20

Sent to Tony for v4.2, after tweaking it a bit (below)

- Paul

Subject: [PATCH] ARM: OMAP3: Fix crypto support for HS devices

Register crypto hwmod links only if they are not disabled in DT.
If DT information is missing, enable them only for GP devices.

Before this patch crypto hwmod links were always disabled for all HS
devices and it was not possible to use omap-aes and omap-sham linux
drivers.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
[paul@pwsan.com: move the complex IP-block presence heuristics into their
 own function to simplify the code; fix some checkpatch warnings]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 107 +++++++++++++++++++++++++=
----
 1 file changed, 94 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-oma=
p2/omap_hwmod_3xxx_data.c
index 0ca4d3fb7df6..dc55f8dedf2c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3736,29 +3736,54 @@ static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp=
_ifs[] __initdata =3D {
 /* GP-only hwmod links */
 static struct omap_hwmod_ocp_if *omap34xx_gp_hwmod_ocp_ifs[] __initdata =
=3D {
 =09&omap3xxx_l4_sec__timer12,
-=09&omap3xxx_l4_core__sham,
-=09&omap3xxx_l4_core__aes,
 =09NULL
 };
=20
 static struct omap_hwmod_ocp_if *omap36xx_gp_hwmod_ocp_ifs[] __initdata =
=3D {
 =09&omap3xxx_l4_sec__timer12,
-=09&omap3xxx_l4_core__sham,
-=09&omap3xxx_l4_core__aes,
 =09NULL
 };
=20
 static struct omap_hwmod_ocp_if *am35xx_gp_hwmod_ocp_ifs[] __initdata =3D =
{
 =09&omap3xxx_l4_sec__timer12,
-=09/*
-=09 * Apparently the SHA/MD5 and AES accelerator IP blocks are
-=09 * only present on some AM35xx chips, and no one knows which
-=09 * ones.  See
-=09 * http://www.spinics.net/lists/arm-kernel/msg215466.html So
-=09 * if you need these IP blocks on an AM35xx, try uncommenting
-=09 * the following lines.
-=09 */
+=09NULL
+};
+
+/* crypto hwmod links */
+static struct omap_hwmod_ocp_if *omap34xx_sham_hwmod_ocp_ifs[] __initdata =
=3D {
+=09&omap3xxx_l4_core__sham,
+=09NULL
+};
+
+static struct omap_hwmod_ocp_if *omap34xx_aes_hwmod_ocp_ifs[] __initdata =
=3D {
+=09&omap3xxx_l4_core__aes,
+=09NULL
+};
+
+static struct omap_hwmod_ocp_if *omap36xx_sham_hwmod_ocp_ifs[] __initdata =
=3D {
+=09&omap3xxx_l4_core__sham,
+=09NULL
+};
+
+static struct omap_hwmod_ocp_if *omap36xx_aes_hwmod_ocp_ifs[] __initdata =
=3D {
+=09&omap3xxx_l4_core__aes,
+=09NULL
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
+static struct omap_hwmod_ocp_if *am35xx_sham_hwmod_ocp_ifs[] __initdata =
=3D {
 =09/* &omap3xxx_l4_core__sham, */
+=09NULL
+};
+
+static struct omap_hwmod_ocp_if *am35xx_aes_hwmod_ocp_ifs[] __initdata =3D=
 {
 =09/* &omap3xxx_l4_core__aes, */
 =09NULL
 };
@@ -3860,10 +3885,41 @@ static struct omap_hwmod_ocp_if *omap3xxx_dss_hwmod=
_ocp_ifs[] __initdata =3D {
 =09NULL
 };
=20
+/**
+ * omap3xxx_hwmod_is_hs_ip_block_usable - is a security IP block accessibl=
e?
+ * @bus: struct device_node * for the top-level OMAP DT data
+ * @dev_name: device name used in the DT file
+ *
+ * Determine whether a "secure" IP block @dev_name is usable by Linux.
+ * There doesn't appear to be a 100% reliable way to determine this,
+ * so we rely on heuristics.  If @bus is null, meaning there's no DT
+ * data, then we only assume the IP block is accessible if the OMAP is
+ * fused as a 'general-purpose' SoC.  If however DT data is present,
+ * test to see if the IP block is described in the DT data and set to
+ * 'status =3D "okay"'.  If so then we assume the ODM has configured the
+ * OMAP firewalls to allow access to the IP block.
+ *
+ * Return: 0 if device named @dev_name is not likely to be accessible,
+ * or 1 if it is likely to be accessible.
+ */
+static int __init omap3xxx_hwmod_is_hs_ip_block_usable(struct device_node =
*bus,
+=09=09=09=09=09=09       const char *dev_name)
+{
+=09if (!bus)
+=09=09return (omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) ? 1 : 0;
+
+=09if (of_device_is_available(of_find_node_by_name(bus, dev_name)))
+=09=09return 1;
+
+=09return 0;
+}
+
 int __init omap3xxx_hwmod_init(void)
 {
 =09int r;
-=09struct omap_hwmod_ocp_if **h =3D NULL, **h_gp =3D NULL;
+=09struct omap_hwmod_ocp_if **h =3D NULL, **h_gp =3D NULL, **h_sham =3D NU=
LL;
+=09struct omap_hwmod_ocp_if **h_aes =3D NULL;
+=09struct device_node *bus =3D NULL;
 =09unsigned int rev;
=20
 =09omap_hwmod_init();
@@ -3885,13 +3941,19 @@ int __init omap3xxx_hwmod_init(void)
 =09    rev =3D=3D OMAP3430_REV_ES3_1 || rev =3D=3D OMAP3430_REV_ES3_1_2) {
 =09=09h =3D omap34xx_hwmod_ocp_ifs;
 =09=09h_gp =3D omap34xx_gp_hwmod_ocp_ifs;
+=09=09h_sham =3D omap34xx_sham_hwmod_ocp_ifs;
+=09=09h_aes =3D omap34xx_aes_hwmod_ocp_ifs;
 =09} else if (rev =3D=3D AM35XX_REV_ES1_0 || rev =3D=3D AM35XX_REV_ES1_1) =
{
 =09=09h =3D am35xx_hwmod_ocp_ifs;
 =09=09h_gp =3D am35xx_gp_hwmod_ocp_ifs;
+=09=09h_sham =3D am35xx_sham_hwmod_ocp_ifs;
+=09=09h_aes =3D am35xx_aes_hwmod_ocp_ifs;
 =09} else if (rev =3D=3D OMAP3630_REV_ES1_0 || rev =3D=3D OMAP3630_REV_ES1=
_1 ||
 =09=09   rev =3D=3D OMAP3630_REV_ES1_2) {
 =09=09h =3D omap36xx_hwmod_ocp_ifs;
 =09=09h_gp =3D omap36xx_gp_hwmod_ocp_ifs;
+=09=09h_sham =3D omap36xx_sham_hwmod_ocp_ifs;
+=09=09h_aes =3D omap36xx_aes_hwmod_ocp_ifs;
 =09} else {
 =09=09WARN(1, "OMAP3 hwmod family init: unknown chip type\n");
 =09=09return -EINVAL;
@@ -3908,6 +3970,25 @@ int __init omap3xxx_hwmod_init(void)
 =09=09=09return r;
 =09}
=20
+=09/*
+=09 * Register crypto hwmod links only if they are not disabled in DT.
+=09 * If DT information is missing, enable them only for GP devices.
+=09 */
+
+=09if (of_have_populated_dt())
+=09=09bus =3D of_find_node_by_name(NULL, "ocp");
+
+=09if (h_sham && omap3xxx_hwmod_is_hs_ip_block_usable(bus, "sham")) {
+=09=09r =3D omap_hwmod_register_links(h_sham);
+=09=09if (r < 0)
+=09=09=09return r;
+=09}
+
+=09if (h_aes && omap3xxx_hwmod_is_hs_ip_block_usable(bus, "aes")) {
+=09=09r =3D omap_hwmod_register_links(h_aes);
+=09=09if (r < 0)
+=09=09=09return r;
+=09}
=20
 =09/*
 =09 * Register hwmod links specific to certain ES levels of a
--=20
2.1.4

--843723315-1596518239-1433270190=:14902--
