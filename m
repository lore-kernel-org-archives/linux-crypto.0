Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD2CC43215
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE32421939
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="Ozoz+Mq8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKSGPk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:15:40 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21454 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfKSGPk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 01:15:40 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574144062; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Cg3CzDldMM3vSpNTvV/Bw4bvHdrGnTZExB1H8y5Ue1cXEB96M6Js22VJhV6qLVuH8i3lK1IUaOWEnrO4iVW4lduO+vKhK4nIo19WXxTkrt7Vh/sHpGzh27UHs2+uoIGEaxWmCLbLZg6Q0quyheINHnOZkbIU97t1hY8S0fBbyz8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574144062; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=rnDOXSZ5PSkKW71tjFE4P0SpeDfoougigqcTZkEQtXI=; 
        b=WKf/g6RAa5+Uvh1nUNFJabB2cT4+Kfia9laYizeX8Vbmc3HHq6CoOf0CM102l7BzNVCEF0DeIwiWg/39fVOc1MFNfr8IPF5n4jVjcm/KR031N676YwygLjdKu5rV3IutmnlAaciAcPER1X+QTe4K5TUYQboQjgj6emtyemFUPVg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574144062;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1520; bh=rnDOXSZ5PSkKW71tjFE4P0SpeDfoougigqcTZkEQtXI=;
        b=Ozoz+Mq8lOVWR3d5FFhE8OZ35njUcgsALgaGHA4znPOu+WSteygwcJBi2eRRJ40g
        9ShCnhAFL0baxmU4mE/DJg4Fn6Ka2euFdtgw+DgK8LjWsQ/SsITS+ESWXhdJ9/jCcru
        y76HAkUimlRN+Sd6Na6zh8gPyKKcW/uYtjIZcTR0=
Received: from localhost (195.173.24.136.in-addr.arpa [136.24.173.195]) by mx.zohomail.com
        with SMTPS id 1574144062177961.7340916694379; Mon, 18 Nov 2019 22:14:22 -0800 (PST)
From:   Stephen Brennan <stephen@brennan.io>
To:     stephen@brennan.io
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <wahrenst@gmx.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Message-ID: <20191119061407.69911-3-stephen@brennan.io>
Subject: [PATCH v2 2/3] hwrng: iproc-rng200: Add support for BCM2711
Date:   Mon, 18 Nov 2019 22:14:06 -0800
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119061407.69911-1-stephen@brennan.io>
References: <20191119061407.69911-1-stephen@brennan.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

BCM2711 features a RNG200 hardware random number generator block.
So make the driver available.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
 drivers/char/hw_random/Kconfig        | 2 +-
 drivers/char/hw_random/iproc-rng200.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfi=
g
index 7c7fecfa2fb2..77e848fca531 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -90,7 +90,7 @@ config HW_RANDOM_BCM2835
=20
 config HW_RANDOM_IPROC_RNG200
 =09tristate "Broadcom iProc/STB RNG200 support"
-=09depends on ARCH_BCM_IPROC || ARCH_BRCMSTB
+=09depends on ARCH_BCM_IPROC || ARCH_BCM2835 || ARCH_BRCMSTB
 =09default HW_RANDOM
 =09---help---
 =09  This driver provides kernel-side support for the RNG200
diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random=
/iproc-rng200.c
index 899ff25f4f28..32d9fe61a225 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -213,6 +213,7 @@ static int iproc_rng200_probe(struct platform_device *p=
dev)
 }
=20
 static const struct of_device_id iproc_rng200_of_match[] =3D {
+=09{ .compatible =3D "brcm,bcm2711-rng200", },
 =09{ .compatible =3D "brcm,bcm7211-rng200", },
 =09{ .compatible =3D "brcm,bcm7278-rng200", },
 =09{ .compatible =3D "brcm,iproc-rng200", },
--=20
2.24.0



