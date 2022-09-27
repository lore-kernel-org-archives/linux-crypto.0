Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21C6C07E9D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 03:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiI0DN0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 23:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiI0DM2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 23:12:28 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.133.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6811C5D118
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 20:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1664248223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5KqD4AXNLeulyrOVo52Gu9w6zx7SQ1kM2L3Wg2nWcE=;
        b=ZU88/6CEFHYRdM7CgaMERfYhvY97KHXQUtdg6CrZPTZhPO4jR1OYv+Gub9gfM13VibLecc
        YJvJJqh3cQT0Jjg4o13fn6GcaSm/cEh0Rg83KcPHjyuxGBhX9GIhMDUU+J7W8GTHVacC66
        MPgzphkbhHWglOxSFqU3DekXqMchq1ypmhmmg9CcgIqeKdrfN2hXAKqGdYKFY5y6xTULxl
        szJU5oCKtBhIPWCrHJluGWxJjHr39T/rgEJOHCbH7ysKFivG61v1r5IK3nGAMtjj68gCSs
        jf7gzm5pA5TrWO3ZI2q9xiSXZG+qD/jzLTv7ekFzVWAuh0T7Zf7E6sTl4wcRvg==
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-496-jwznOG5TO563IXWtGdT8-g-2; Mon, 26 Sep 2022 23:10:21 -0400
X-MC-Unique: jwznOG5TO563IXWtGdT8-g-2
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2375.24;
 Mon, 26 Sep 2022 20:10:19 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        <pvanleeuwen@rambus.com>, Peter Harliman Liem <pliem@maxlinear.com>
Subject: [PATCH v2 2/3] crypto: inside-secure - Add fw_little_endian option
Date:   Tue, 27 Sep 2022 11:10:09 +0800
Message-ID: <d9d673107f08be9abbbf31a199d4ca26bf985283.1664247167.git.pliem@maxlinear.com>
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

This is to add fw_little_endian option, which can
be used for platform which firmware is using little-endian
(instead of big-endian).

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
 drivers/crypto/inside-secure/safexcel.c | 14 ++++++++++----
 drivers/crypto/inside-secure/safexcel.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/insid=
e-secure/safexcel.c
index 8f4872470529..4d6d64ff9a0f 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -316,14 +316,20 @@ static void eip197_init_firmware(struct safexcel_cryp=
to_priv *priv)
 static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
 =09=09=09=09  const struct firmware *fw)
 {
-=09const __be32 *data =3D (const __be32 *)fw->data;
+=09u32 val;
 =09int i;
=20
 =09/* Write the firmware */
-=09for (i =3D 0; i < fw->size / sizeof(u32); i++)
-=09=09writel(be32_to_cpu(data[i]),
+=09for (i =3D 0; i < fw->size / sizeof(u32); i++) {
+=09=09if (priv->data->fw_little_endian)
+=09=09=09val =3D le32_to_cpu(((const __le32 *)fw->data)[i]);
+=09=09else
+=09=09=09val =3D be32_to_cpu(((const __be32 *)fw->data)[i]);
+
+=09=09writel(val,
 =09=09       priv->base + EIP197_CLASSIFICATION_RAMS +
-=09=09       i * sizeof(__be32));
+=09=09       i * sizeof(val));
+=09}
=20
 =09/* Exclude final 2 NOPs from size */
 =09return i - EIP197_FW_TERMINAL_NOPS;
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/insid=
e-secure/safexcel.h
index e8da8b30a392..f049293870b4 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -735,6 +735,7 @@ enum safexcel_eip_version {
=20
 struct safexcel_priv_data {
 =09enum safexcel_eip_version version;
+=09bool fw_little_endian;
 };
=20
 /* Priority we use for advertising our algorithms */
--=20
2.17.1

