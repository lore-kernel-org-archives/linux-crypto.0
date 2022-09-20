Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991A1ECAAD8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 08:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiITIDR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiITIBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 04:01:51 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9112642C4
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 01:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663660909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZCOZe3LJQX2wc3TOLjSwHgnPXH4/Vrg5ziu0+q0SZU=;
        b=lrH4gH5pHYEjlWISbas+8NCpezL+henDSbdSEdHE3BhjlBErgSz3ZvEopXgvOwHVVjpVF0
        cKtCu2/WMf+HoOqs5qcYC+JwPv7urpqMgMM3TJq8vT4xawwdSm0Dl1PiXoa3sPUqoaAZi/
        t8EVodx9oKvEV8oSgqDgQeVv/wSkC2iZ5GOIW8RIX+2T5BoOUYb3stjGXvnUyYqyRU8JUp
        1Z9CLHqBuvINgs4IupbWxLwlBm6hT4mGY65MUZqlU6x4fd0VQHyQ0diJdHC6cR6Gv1hJ/F
        n4jAZTiXb00i/F35AVLDuXrksD+s3sKOJZFiBa7N+J8pnuchR2xZBzNx76HAjg==
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-235-INmaW5GAOMSQsX9AhldYzA-2; Tue, 20 Sep 2022 04:01:47 -0400
X-MC-Unique: INmaW5GAOMSQsX9AhldYzA-2
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 20 Sep 2022 01:01:42 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH 1/3] crypto: inside-secure - Expand soc data structure
Date:   Tue, 20 Sep 2022 16:01:37 +0800
Message-ID: <131f0d802d4e251dd8f98672260a04c2f649440c.1663660578.git.pliem@maxlinear.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1663660578.git.pliem@maxlinear.com>
References: <cover.1663660578.git.pliem@maxlinear.com>
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
 drivers/crypto/inside-secure/safexcel.c | 49 +++++++++++++++++--------
 drivers/crypto/inside-secure/safexcel.h |  6 ++-
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/insid=
e-secure/safexcel.c
index ad0d8c4a71ac..02c103da09a9 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -410,20 +410,25 @@ static int eip197_load_firmwares(struct safexcel_cryp=
to_priv *priv)
 =09int i, j, ret =3D 0, pe;
 =09int ipuesz, ifppsz, minifw =3D 0;
=20
-=09if (priv->version =3D=3D EIP197D_MRVL)
-=09=09dir =3D "eip197d";
-=09else if (priv->version =3D=3D EIP197B_MRVL ||
-=09=09 priv->version =3D=3D EIP197_DEVBRD)
+=09switch (priv->data->version) {
+=09case EIP197_DEVBRD:
+=09case EIP197B_MRVL:
 =09=09dir =3D "eip197b";
-=09else
-=09=09return -ENODEV;
+=09=09break;
+=09case EIP197D_MRVL:
+=09=09dir =3D "eip197d";
+=09=09break;
+=09default:
+=09=09/* generic case */
+=09=09dir =3D "";
+=09}
=20
 retry_fw:
 =09for (i =3D 0; i < FW_NB; i++) {
 =09=09snprintf(fw_path, 37, "inside-secure/%s/%s", dir, fw_name[i]);
 =09=09ret =3D firmware_request_nowarn(&fw[i], fw_path, priv->dev);
 =09=09if (ret) {
-=09=09=09if (minifw || priv->version !=3D EIP197B_MRVL)
+=09=09=09if (minifw || priv->data->version !=3D EIP197B_MRVL)
 =09=09=09=09goto release_fw;
=20
 =09=09=09/* Fallback to the old firmware location for the
@@ -1597,7 +1602,7 @@ static int safexcel_probe_generic(void *pdev,
=20
 =09safexcel_configure(priv);
=20
-=09if (IS_ENABLED(CONFIG_PCI) && priv->version =3D=3D EIP197_DEVBRD) {
+=09if (IS_ENABLED(CONFIG_PCI) && priv->data->version =3D=3D EIP197_DEVBRD)=
 {
 =09=09/*
 =09=09 * Request MSI vectors for global + 1 per ring -
 =09=09 * or just 1 for older dev images
@@ -1731,7 +1736,7 @@ static int safexcel_probe(struct platform_device *pde=
v)
 =09=09return -ENOMEM;
=20
 =09priv->dev =3D dev;
-=09priv->version =3D (enum safexcel_eip_version)of_device_get_match_data(d=
ev);
+=09priv->data =3D (struct safexcel_of_data *)of_device_get_match_data(dev)=
;
=20
 =09platform_set_drvdata(pdev, priv);
=20
@@ -1806,27 +1811,39 @@ static int safexcel_remove(struct platform_device *=
pdev)
 =09return 0;
 }
=20
+static const struct safexcel_of_data eip97ies_mrvl_data =3D {
+=09.version =3D EIP97IES_MRVL,
+};
+
+static const struct safexcel_of_data eip197b_mrvl_data =3D {
+=09.version =3D EIP197B_MRVL,
+};
+
+static const struct safexcel_of_data eip197d_mrvl_data =3D {
+=09.version =3D EIP197D_MRVL,
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
@@ -1862,7 +1879,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 =09=09return -ENOMEM;
=20
 =09priv->dev =3D dev;
-=09priv->version =3D (enum safexcel_eip_version)ent->driver_data;
+=09priv->data =3D (struct safexcel_of_data *)ent->driver_data;
=20
 =09pci_set_drvdata(pdev, priv);
=20
@@ -1881,7 +1898,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 =09}
 =09priv->base =3D pcim_iomap_table(pdev)[0];
=20
-=09if (priv->version =3D=3D EIP197_DEVBRD) {
+=09if (priv->data->version =3D=3D EIP197_DEVBRD) {
 =09=09dev_dbg(dev, "Device identified as FPGA based development board - ap=
plying HW reset\n");
=20
 =09=09rc =3D pcim_iomap_regions(pdev, 4, "crypto_safexcel");
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/insid=
e-secure/safexcel.h
index 797ff91512e0..1b8ccb33202b 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -733,6 +733,10 @@ enum safexcel_eip_version {
 =09EIP197_DEVBRD
 };
=20
+struct safexcel_of_data {
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
+=09struct safexcel_of_data *data;
 =09struct safexcel_register_offsets offsets;
 =09struct safexcel_hwconfig hwconfig;
 =09u32 flags;
--=20
2.17.1

