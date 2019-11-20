Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7386C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CBB42240E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="JRrajEjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKTDUc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:20:32 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21473 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKTDUc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 22:20:32 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574219797; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MJqYY4klgG6JsagsSo7sKKSS+LgL644mpWpkTc9t7F6khmj3fD0q95+ydAe51Uip2GaPu2ORppSLonc4rLIXFP4Wg8IDqO/0StvmGVh2Iyk+YZq9ubLosGm37xOZ6cnOUfQbA5ZHzK/UULmRB4aF0Bi22HApVifggoWFCLDCfWo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574219797; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=o3ll4FP6xCHVlz+SirNioLQSMfodSwmxu31hCQHcgJo=; 
        b=gjiSGHFfAgFyo/CvJXgRx9cA1J32I0Y/9RFSY+KhRqYl23tM5s3vAjfMLy5gQA39DfWgIDm1Hf0S0CQQc+m1yId61ZFMKgoWsKFpQQBHQ7fbC0HRCYQojRWhKVCIx0cRZAQfZhV1JCeeAjn3UOAguZYw0fw3+ILWLuGLE3bc4p4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574219797;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=877; bh=o3ll4FP6xCHVlz+SirNioLQSMfodSwmxu31hCQHcgJo=;
        b=JRrajEjDPjquW3CRi7H8oRGyskJ6kSrwYzLA8dXinGI+mnDEqxCWFkJrrwl0UhOO
        Ge3XI5aPwW3SlrKc48Bb1stSjn2ld2RO/VohjcZHUwTkM2FOrosQ01WDub8nrSwQ3pb
        I2b2n8q1o1SUa8Ldigx2owlPVaX1aGibDuEu6T6Y=
Received: from localhost (c-98-207-184-40.hsd1.ca.comcast.net [98.207.184.40]) by mx.zohomail.com
        with SMTPS id 1574219796587191.63371913747665; Tue, 19 Nov 2019 19:16:36 -0800 (PST)
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
Message-ID: <20191120031622.88949-5-stephen@brennan.io>
Subject: [PATCH v3 4/4] ARM: dts: bcm2711: Enable HWRNG support
Date:   Tue, 19 Nov 2019 19:16:22 -0800
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

This enables hardware random number generator support for the BCM2711
on the Raspberry Pi 4 board.

Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
 arch/arm/boot/dts/bcm2711.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dts=
i
index ac83dac2e6ba..ed0877d5a1e9 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -92,10 +92,9 @@ pm: watchdog@7e100000 {
 =09=09};
=20
 =09=09rng@7e104000 {
-=09=09=09interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
-
-=09=09=09/* RNG is incompatible with brcm,bcm2835-rng */
-=09=09=09status =3D "disabled";
+=09=09=09compatible =3D "brcm,bcm2711-rng200";
+=09=09=09reg =3D <0x7e104000 0x28>;
+=09=09=09status =3D "okay";
 =09=09};
=20
 =09=09uart2: serial@7e201400 {
--=20
2.24.0



