Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E88DC6FA86
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 03:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiI0DN1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 23:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiI0DM3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 23:12:29 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682BE5F9AD
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 20:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1664248224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qp7Q/cZpWTdbRZcRxFCCzx1As5bjEYcZEfztwq3ge3w=;
        b=DMXEJDNKU0pfmGEwDs1aTD28ZlcE0DRgqPRx/o/HthjGcl+sP0TAOaktvlKJnje9hy+GAR
        d7KzGMxqoKQpkQTmbFKB2zMYxuojq2hkxlwizeAvgqZ87u0yrwfPgKUErq0G0MWedJxo0b
        BvqLqzHhCOC6BlIyut8Pv1ouz+4rwIB9679ytvVT7GZB6WfrzRYgqqS4WXwjhz+KgFeCkF
        Y8zPvQYcifqbYcNNWyfw3ppGqTWOiQvoyB/cmkxEc+mZmYloN53Sotg+9eYfOXBoP+YQ51
        J2qFs/Q4qcKvQl2vOrhApIychvalo6hsTZ+OoJICp7FoN6dEsdxQmL8t3MRWzw==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-496-szsk-4ugP_2fmOU81S5dNg-1; Mon, 26 Sep 2022 23:10:20 -0400
X-MC-Unique: szsk-4ugP_2fmOU81S5dNg-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 26 Sep 2022 20:10:17 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        <pvanleeuwen@rambus.com>, Peter Harliman Liem <pliem@maxlinear.com>
Subject: [PATCH v2 1/3] crypto: inside-secure - Expand soc data structure
Date:   Tue, 27 Sep 2022 11:10:08 +0800
Message-ID: <c458de8b2c3fa72be0196c71c6277470ad0c477b.1664247167.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1664247167.git.pliem@maxlinear.com>
References: <cover.1664247167.git.pliem@maxlinear.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently platform data is assigned directly to
version string(instead of struct). To make it more
scalable, we move it to use data struct instead.
This allows customization for individual platforms other
than version string.

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
 drivers/crypto/inside-secure/safexcel.c | 44 +++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h |  6 +++-
 2 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/insid=
e-secure/safexcel.c
index ad0d8c4a71ac..8f4872470529 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -410,10 +410,10 @@ static int eip197_load_firmwares(struct safexcel_cryp=
to_priv *priv)
 =09int i, j, ret =3D 0, pe;
 =09int ipuesz, ifppsz, minifw =3D 0;
=20
-=09if (priv->version =3D=3D EIP197D_MRVL)
+=09if (priv->data->version =3D=3D EIP197D_MRVL)
 =09=09dir =3D "eip197d";
-=09else if (priv->version =3D=3D EIP197B_MRVL ||
-=09=09 priv->version =3D=3D EIP197_DEVBRD)
+=09else if (priv->data->version =3D=3D EIP197B_MRVL ||
+=09=09 priv->data->version =3D=3D EIP197_DEVBRD)
 =09=09dir =3D "eip197b";
 =09else
 =09=09return -ENODEV;
@@ -423,7 +423,7 @@ static int eip197_load_firmwares(struct safexcel_crypto=
_priv *priv)
 =09=09snprintf(fw_path, 37, "inside-secure/%s/%s", dir, fw_name[i]);
 =09=09ret =3D firmware_request_nowarn(&fw[i], fw_path, priv->dev);
 =09=09if (ret) {
-=09=09=09if (minifw || priv->version !=3D EIP197B_MRVL)
+=09=09=09if (minifw || priv->data->version !=3D EIP197B_MRVL)
 =09=09=09=09goto release_fw;
=20
 =09=09=09/* Fallback to the old firmware location for the
@@ -1597,7 +1597,7 @@ static int safexcel_probe_generic(void *pdev,
=20
 =09safexcel_configure(priv);
=20
-=09if (IS_ENABLED(CONFIG_PCI) && priv->version =3D=3D EIP197_DEVBRD) {
+=09if (IS_ENABLED(CONFIG_PCI) && priv->data->version =3D=3D EIP197_DEVBRD)=
 {
 =09=09/*
 =09=09 * Request MSI vectors for global + 1 per ring -
 =09=09 * or just 1 for older dev images
@@ -1731,7 +1731,7 @@ static int safexcel_probe(struct platform_device *pde=
v)
 =09=09return -ENOMEM;
=20
 =09priv->dev =3D dev;
-=09priv->version =3D (enum safexcel_eip_version)of_device_get_match_data(d=
ev);
+=09priv->data =3D (struct safexcel_priv_data *)of_device_get_match_data(de=
v);
=20
 =09platform_set_drvdata(pdev, priv);
=20
@@ -1806,27 +1806,43 @@ static int safexcel_remove(struct platform_device *=
pdev)
 =09return 0;
 }
=20
+static const struct safexcel_priv_data eip97ies_mrvl_data =3D {
+=09.version =3D EIP97IES_MRVL,
+};
+
+static const struct safexcel_priv_data eip197b_mrvl_data =3D {
+=09.version =3D EIP197B_MRVL,
+};
+
+static const struct safexcel_priv_data eip197d_mrvl_data =3D {
+=09.version =3D EIP197D_MRVL,
+};
+
+static const struct safexcel_priv_data eip197_devbrd_data =3D {
+=09.version =3D EIP197_DEVBRD,
+};
+
 static const struct of_device_id safexcel_of_match_table[] =3D {
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip97ies",
-=09=09.data =3D (void *)EIP97IES_MRVL,
+=09=09.data =3D &eip97ies_mrvl_data,
 =09},
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip197b",
-=09=09.data =3D (void *)EIP197B_MRVL,
+=09=09.data =3D &eip197b_mrvl_data,
 =09},
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip197d",
-=09=09.data =3D (void *)EIP197D_MRVL,
+=09=09.data =3D &eip197d_mrvl_data,
 =09},
 =09/* For backward compatibility and intended for generic use */
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip97",
-=09=09.data =3D (void *)EIP97IES_MRVL,
+=09=09.data =3D &eip97ies_mrvl_data,
 =09},
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip197",
-=09=09.data =3D (void *)EIP197B_MRVL,
+=09=09.data =3D &eip197b_mrvl_data,
 =09},
 =09{},
 };
@@ -1862,7 +1878,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 =09=09return -ENOMEM;
=20
 =09priv->dev =3D dev;
-=09priv->version =3D (enum safexcel_eip_version)ent->driver_data;
+=09priv->data =3D (struct safexcel_priv_data *)ent->driver_data;
=20
 =09pci_set_drvdata(pdev, priv);
=20
@@ -1881,7 +1897,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 =09}
 =09priv->base =3D pcim_iomap_table(pdev)[0];
=20
-=09if (priv->version =3D=3D EIP197_DEVBRD) {
+=09if (priv->data->version =3D=3D EIP197_DEVBRD) {
 =09=09dev_dbg(dev, "Device identified as FPGA based development board - ap=
plying HW reset\n");
=20
 =09=09rc =3D pcim_iomap_regions(pdev, 4, "crypto_safexcel");
@@ -1949,7 +1965,7 @@ static const struct pci_device_id safexcel_pci_ids[] =
=3D {
 =09{
 =09=09PCI_DEVICE_SUB(PCI_VENDOR_ID_XILINX, 0x9038,
 =09=09=09       0x16ae, 0xc522),
-=09=09.driver_data =3D EIP197_DEVBRD,
+=09=09.driver_data =3D (kernel_ulong_t)&eip197_devbrd_data,
 =09},
 =09{},
 };
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/insid=
e-secure/safexcel.h
index 797ff91512e0..e8da8b30a392 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -733,6 +733,10 @@ enum safexcel_eip_version {
 =09EIP197_DEVBRD
 };
=20
+struct safexcel_priv_data {
+=09enum safexcel_eip_version version;
+};
+
 /* Priority we use for advertising our algorithms */
 #define SAFEXCEL_CRA_PRIORITY=09=09300
=20
@@ -815,7 +819,7 @@ struct safexcel_crypto_priv {
 =09struct clk *reg_clk;
 =09struct safexcel_config config;
=20
-=09enum safexcel_eip_version version;
+=09struct safexcel_priv_data *data;
 =09struct safexcel_register_offsets offsets;
 =09struct safexcel_hwconfig hwconfig;
 =09u32 flags;
--=20
2.17.1

