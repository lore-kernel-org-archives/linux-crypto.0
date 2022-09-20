Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6896BC6FA92
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 08:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiITIDV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiITIBy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 04:01:54 -0400
Received: from us-smtp-delivery-115.mimecast.com (us-smtp-delivery-115.mimecast.com [170.10.129.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D68A642C8
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 01:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1663660910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ouPEC3kvQ0ao0uh8YN4F3GFPf1No8spzAha5/ht5RO0=;
        b=HGTNXCJK11DAo+e0DUnVri9yf1s6tjip0JyFT7ezYNqkCfQsr9P1hmsmJ119soMBDi7NQU
        kbeFulUmlS5ZQqMKQNcLl0rxzfcvFC//Ld3iUh0nPFFa58kKitIOr6M4Rc+O922yq2sV0a
        noa0EeV3F548Zytt1Ux+PCeahc5lx5DGWc7vqTgXbaHJ2EzVxg2fn/T6rxMVCIbQhzBAR2
        8fPlYMLFqEzhe0byacCXeSqR/B1ObK+woQdgQqHcjZt8Fe6YaPkvb6vlXn+94HnHb8UJNm
        uvryYkSDEknLgv1Bx5Fnw1srKfCJnOGSoMriKWbrqbICcRbrfsm/XKaKp9LmXA==
Received: from mail.maxlinear.com (174-47-1-84.static.ctl.one [174.47.1.84])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 us-mta-235-qkySXk_lNHylBziHljehCg-4; Tue, 20 Sep 2022 04:01:49 -0400
X-MC-Unique: qkySXk_lNHylBziHljehCg-4
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.119) with Microsoft SMTP Server id 15.1.2375.24;
 Tue, 20 Sep 2022 01:01:45 -0700
From:   Peter Harliman Liem <pliem@maxlinear.com>
To:     <atenart@kernel.org>, <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-lgm-soc@maxlinear.com>,
        "Peter Harliman Liem" <pliem@maxlinear.com>
Subject: [PATCH 3/3] crypto: inside-secure - Add MaxLinear platform
Date:   Tue, 20 Sep 2022 16:01:39 +0800
Message-ID: <ffd4efd6eb8bedd28908e6c123f66f6f0c3890ae.1663660578.git.pliem@maxlinear.com>
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

This is to add MaxLinear platform into compatible id.
Firmware endianness option is added since MaxLinear
firmware is in little endian format.

Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>
---
 drivers/crypto/inside-secure/safexcel.c | 9 +++++++++
 drivers/crypto/inside-secure/safexcel.h | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/insid=
e-secure/safexcel.c
index 955170d2dd7c..4b7c18db290c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1830,6 +1830,11 @@ static const struct safexcel_of_data eip197d_mrvl_da=
ta =3D {
 =09.version =3D EIP197D_MRVL,
 };
=20
+static const struct safexcel_of_data eip197_mxl_data =3D {
+=09.version =3D EIP197_MXL,
+=09.fw_little_endian =3D true,
+};
+
 static const struct of_device_id safexcel_of_match_table[] =3D {
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip97ies",
@@ -1843,6 +1848,10 @@ static const struct of_device_id safexcel_of_match_t=
able[] =3D {
 =09=09.compatible =3D "inside-secure,safexcel-eip197d",
 =09=09.data =3D &eip197d_mrvl_data,
 =09},
+=09{
+=09=09.compatible =3D "inside-secure,safexcel-eip197-mxl",
+=09=09.data =3D &eip197_mxl_data,
+=09},
 =09/* For backward compatibility and intended for generic use */
 =09{
 =09=09.compatible =3D "inside-secure,safexcel-eip97",
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/insid=
e-secure/safexcel.h
index a89dd8dc1ddd..078dbfb2b094 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -730,7 +730,8 @@ enum safexcel_eip_version {
 =09EIP97IES_MRVL,
 =09EIP197B_MRVL,
 =09EIP197D_MRVL,
-=09EIP197_DEVBRD
+=09EIP197_DEVBRD,
+=09EIP197_MXL,
 };
=20
 struct safexcel_of_data {
--=20
2.17.1

