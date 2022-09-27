Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC37EC07E9D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 03:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiI0DN2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 23:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiI0DMc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 23:12:32 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50CF5F9BC
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 20:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1664248224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPxt7D78MSmCkt3QR+zGnR1lJY4CjBW9vU4txUhA/m0=;
        b=iZko2+MjNCNxdnkJG3JMGVDG4PozHA4WEu7vakXpQLF9sCbS9QEKvY38TEU+s5dj9OkFp+
        z18TpN1Ss6vY1jfjBfWInff5d56oQv1c0yAcatxcAavQM3nglUes7ANDEzJTANlwqh7Dbb
        GtVuCaI17C+/Fby/JhbqfojidPc+V5ZooViIsjrq+fS9ZMYDvL07ltiXrNPuPALnhoqqW9
        eVo0aYNwSlyPlxjKVGA6DX2Ucv6n0ZpELRnIQYRpGHKLe10g4Ac1RCzpzYpb6Kg6aYBPaB
        7nFdRHTjR79loyz7ZoIr/PDin+SO5yR1LwfxUB3JSX5KNxBhwiSOF7n0B/aGdA==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-642-qcODJMh8MD2pJryJkWBGJg-1; Mon, 26 Sep 2022 23:10:24 -0400
X-MC-Unique: qcODJMh8MD2pJryJkWBGJg-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 26 Sep 2022 20:10:20 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        <pvanleeuwen@rambus.com>, Peter Harliman Liem <pliem@maxlinear.com>
Subject: [PATCH v2 3/3] crypto: inside-secure - Add MaxLinear platform
Date:   Tue, 27 Sep 2022 11:10:10 +0800
Message-ID: <006744b6ac881824ecf0019d4de1e3c01509b308.1664247167.git.pliem@maxlinear.com>
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

This is to add MaxLinear platform into compatible id.
Firmware endianness option is added since MaxLinear
firmware is in little endian format.

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
 drivers/crypto/inside-secure/safexcel.c | 11 +++++++++++
 drivers/crypto/inside-secure/safexcel.h |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/insid=
e-secure/safexcel.c
index 4d6d64ff9a0f..ae6110376e21 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -421,6 +421,8 @@ static int eip197_load_firmwares(struct safexcel_crypto=
_priv *priv)
 =09else if (priv->data->version =3D=3D EIP197B_MRVL ||
 =09=09 priv->data->version =3D=3D EIP197_DEVBRD)
 =09=09dir =3D "eip197b";
+=09else if (priv->data->version =3D=3D EIP197C_MXL)
+=09=09dir =3D "eip197c";
 =09else
 =09=09return -ENODEV;
=20
@@ -1828,6 +1830,11 @@ static const struct safexcel_priv_data eip197_devbrd=
_data =3D {
 =09.version =3D EIP197_DEVBRD,
 };
=20
+static const struct safexcel_priv_data eip197c_mxl_data =3D {
+=09.version =3D EIP197C_MXL,
+=09.fw_little_endian =3D true,
+};
+
 static const struct of_device_id safexcel_of_match_table[] =3D {
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip97ies",
@@ -1841,6 +1848,10 @@ static const struct of_device_id safexcel_of_match_t=
able[] =3D {
 =09=09.compatible =3D "inside-secure,safexcel-eip197d",
 =09=09.data =3D &eip197d_mrvl_data,
 =09},
+=09{
+=09=09.compatible =3D "inside-secure,safexcel-eip197c-mxl",
+=09=09.data =3D &eip197c_mxl_data,
+=09},
 =09/* For backward compatibility and intended for generic use */
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip97",
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/insid=
e-secure/safexcel.h
index f049293870b4..6c2fc662f64f 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -730,7 +730,8 @@ enum safexcel_eip_version {
 =09EIP97IES_MRVL,
 =09EIP197B_MRVL,
 =09EIP197D_MRVL,
-=09EIP197_DEVBRD
+=09EIP197_DEVBRD,
+=09EIP197C_MXL,
 };
=20
 struct safexcel_priv_data {
--=20
2.17.1

