Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36787C43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C0C622464
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="NUsCEu3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfKTDUK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:20:10 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21440 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfKTDUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 22:20:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574219795; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=BpjWrV94yGBTXFWbbdxFHjxmAm8D9PMwse96A0QAyOXhcxoCS3EFHC4RLDkzT5fjVgWGzQS+89EO/XqkqV3Zf7w4OLJUJXoCJr4EzdSsrAyvwobPdFkN/w0G9lDz9Gh4PyIQ2RS544KQt15d9Z9ZajPfhOmgrTfEt2mXxi527fg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574219795; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hUM9b+dswT9UPWGlwBwCNyrp4zRDfMTZRh5LuHt9eB0=; 
        b=RJpQYP6XmffOYPpCLiiielT1JXzEKudU4xMENecGYWvMEqZx64IlLXKZgvqPb4er8fpHQ2AZ64n0Pkd+mU2ObizN3THucxM0vqNekNOoa17BmmS6Ak4rO8XcAQPYG0AMQCex77fYTFjqeg92KOyrSAuT3DvQbnC0/FLm07QWYFs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574219795;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1694; bh=hUM9b+dswT9UPWGlwBwCNyrp4zRDfMTZRh5LuHt9eB0=;
        b=NUsCEu3m2VD2aRVon4jt5dm6oAxDZHk9Yjr2uODkCgJ38hUoqLq7v9i1MR6rYBLe
        zGMHybZ9vSep+yuuiAi4yHQsgocHApFByNyDEEJHOBlcpIW/8A1w5xrzYJAuY6CA1o5
        S+fAHdgKU/WF2QpeN5CyjogDciPe8iMPJ5kIRwwo=
Received: from localhost (c-98-207-184-40.hsd1.ca.comcast.net [98.207.184.40]) by mx.zohomail.com
        with SMTPS id 1574219794570904.3468110611888; Tue, 19 Nov 2019 19:16:34 -0800 (PST)
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
Message-ID: <20191120031622.88949-4-stephen@brennan.io>
Subject: [PATCH v3 3/4] ARM: dts: bcm2835: Move rng definition to common location
Date:   Tue, 19 Nov 2019 19:16:21 -0800
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120031622.88949-1-stephen@brennan.io>
References: <20191120031622.88949-1-stephen@brennan.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM2711 inherits from BCM283X, but has an incompatible HWRNG. Move this
node to bcm2835-common.dtsi, so that BCM2711 can define its own.

Signed-off-by: Stephen Brennan <stephen@brennan.io>
---

Changes in v3:
- moved the bcm2835 rng into bcm2835-common.dtsi rather than a new file
- split out enabling rng on bcm2711 into its own patch

 arch/arm/boot/dts/bcm2835-common.dtsi | 6 ++++++
 arch/arm/boot/dts/bcm283x.dtsi        | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835-common.dtsi b/arch/arm/boot/dts/bcm2=
835-common.dtsi
index fe1ab40c7f22..2b1d9d4c0cde 100644
--- a/arch/arm/boot/dts/bcm2835-common.dtsi
+++ b/arch/arm/boot/dts/bcm2835-common.dtsi
@@ -70,6 +70,12 @@ pm: watchdog@7e100000 {
 =09=09=09system-power-controller;
 =09=09};
=20
+=09=09rng@7e104000 {
+=09=09=09compatible =3D "brcm,bcm2835-rng";
+=09=09=09reg =3D <0x7e104000 0x10>;
+=09=09=09interrupts =3D <2 29>;
+=09=09};
+
 =09=09pixelvalve@7e206000 {
 =09=09=09compatible =3D "brcm,bcm2835-pixelvalve0";
 =09=09=09reg =3D <0x7e206000 0x100>;
diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dts=
i
index 3caaa57eb6c8..5219339fc27c 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -84,12 +84,6 @@ clocks: cprman@7e101000 {
 =09=09=09=09<&dsi1 0>, <&dsi1 1>, <&dsi1 2>;
 =09=09};
=20
-=09=09rng@7e104000 {
-=09=09=09compatible =3D "brcm,bcm2835-rng";
-=09=09=09reg =3D <0x7e104000 0x10>;
-=09=09=09interrupts =3D <2 29>;
-=09=09};
-
 =09=09mailbox: mailbox@7e00b880 {
 =09=09=09compatible =3D "brcm,bcm2835-mbox";
 =09=09=09reg =3D <0x7e00b880 0x40>;
--=20
2.24.0



