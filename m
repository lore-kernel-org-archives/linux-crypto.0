Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D842C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 08:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiITIDQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiITIBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 04:01:51 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7146642C2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 01:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663660909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBElztSxJ1rdBS50z2Hh+xljndSP253b3OPRrTnscxQ=;
        b=ByzcBrxRaf8bYEPI7zE7VITvzf/7AzLipeLGJfeP8P56neBdKN3xd38PtTRGqm6I/lBOuA
        GHNvkGmgmm11Yc2gvvYDskTs1m+J2f0/FxgWt4EutXOznSD/XcN9vC95cMj8cO2u1r6vKD
        bf5akZXfPfmksV0VFimHSiYQNHrXvthbcFnooEc/eGsPKW1AOWzKcJTFo3IVWyw0gg/NnD
        9lMkdpLkJgvMglYCeG+PhIohgg0FTNZ4aWMf+nUk0453Hh1BSbWun4Dg3j+f4+n8X3x5o6
        FcLfk+/J4Qpung2wifqhe3xBcaU69OUeqvnVI7FWx3T2kT4ovKI4BgtxBa987w==
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-235-nEWdcjjDOR-NiH6cM9J8hQ-3; Tue, 20 Sep 2022 04:01:48 -0400
X-MC-Unique: nEWdcjjDOR-NiH6cM9J8hQ-3
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 20 Sep 2022 01:01:44 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH 2/3] crypto: inside-secure - Add fw_little_endian option
Date:   Tue, 20 Sep 2022 16:01:38 +0800
Message-ID: <29cf210c9adce088bc50248ad46255d883bd5edc.1663660578.git.pliem@maxlinear.com>
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

This is to add fw_little_endian option, which can
be used for platform which firmware is using little-endian
(instead of big-endian).

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
 drivers/crypto/inside-secure/safexcel.c | 15 +++++++++++----
 drivers/crypto/inside-secure/safexcel.h |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/insid=
e-secure/safexcel.c
index 02c103da09a9..955170d2dd7c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -316,14 +316,21 @@ static void eip197_init_firmware(struct safexcel_cryp=
to_priv *priv)
 static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
 =09=09=09=09  const struct firmware *fw)
 {
-=09const __be32 *data =3D (const __be32 *)fw->data;
+=09const u32 *data =3D (const u32 *)fw->data;
+=09u32 val;
 =09int i;
=20
 =09/* Write the firmware */
-=09for (i =3D 0; i < fw->size / sizeof(u32); i++)
-=09=09writel(be32_to_cpu(data[i]),
+=09for (i =3D 0; i < fw->size / sizeof(u32); i++) {
+=09=09if (priv->data->fw_little_endian)
+=09=09=09val =3D le32_to_cpu(data[i]);
+=09=09else
+=09=09=09val =3D be32_to_cpu(data[i]);
+
+=09=09writel(val,
 =09=09       priv->base + EIP197_CLASSIFICATION_RAMS +
-=09=09       i * sizeof(__be32));
+=09=09       i * sizeof(*data));
+=09}
=20
 =09/* Exclude final 2 NOPs from size */
 =09return i - EIP197_FW_TERMINAL_NOPS;
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/insid=
e-secure/safexcel.h
index 1b8ccb33202b..a89dd8dc1ddd 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -735,6 +735,7 @@ enum safexcel_eip_version {
=20
 struct safexcel_of_data {
 =09enum safexcel_eip_version version;
+=09bool fw_little_endian;
 };
=20
 /* Priority we use for advertising our algorithms */
--=20
2.17.1

