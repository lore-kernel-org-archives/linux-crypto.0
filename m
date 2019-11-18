Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F330BC432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 08:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC32C20740
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 08:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="anV7HRl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKRIAG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 03:00:06 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21416 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfKRIAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 03:00:06 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574063917; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=YE3ZdikWrz4vU1wnKMshg3aH2E9+RlQgSCVV+br1F91F1PuwLieEtIvZvoKrgjOwY04gbq6CseB7hmzWfRWHRw7w+XXHWD74F4gYyBf1qGBToBah6MhfA9nYZ7uZBml+5d6589ujXt5UPlJWxuIBND3tX5RAkSLVkeuoI6mevfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574063917; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=SqUaBIpR2mccPD6jr20GE5M0X9vjxDDNdgLp2NxZva8=; 
        b=VbjBKVhlbPDXrHTk9ZxSJ/Mbtm6iuhEV80+RtOhFRgX6rOH8Uh3qhgcWlh9Nvob6E/XVwozQHv0aXQPaL8pZqYz+3Xm0ccbemPFpvRrtMLEx13KyloMw5Kt8NI3NvfjgV2MANyy1Gc/+u0c4BM75lrwXbNcSFRndAnQR6Pt+Rzw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574063917;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=928; bh=SqUaBIpR2mccPD6jr20GE5M0X9vjxDDNdgLp2NxZva8=;
        b=anV7HRl7bKqk4mHo2jeLLWqW3ZBdNO6/iS8FDjt7rIsjIXtvSDQHIA07RUh0kNm/
        ynOfFc0UVtWYGRrWy6/YaGFfPU5v/P2jpMLVN5DYd5zYfV+Gmbbqos0UQrF4uQfHbM+
        YoXP6BNOK8ivrGQ3+nUcWLaQOmJ98s3VCV5PZkqg=
Received: from localhost (195.173.24.136.in-addr.arpa [136.24.173.195]) by mx.zohomail.com
        with SMTPS id 1574063915435914.3658986565996; Sun, 17 Nov 2019 23:58:35 -0800 (PST)
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
Message-ID: <20191118075807.165126-4-stephen@brennan.io>
Subject: [PATCH 3/3] ARM: dts: bcm2711: Enable HWRNG support
Date:   Sun, 17 Nov 2019 23:58:07 -0800
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191118075807.165126-1-stephen@brennan.io>
References: <20191118075807.165126-1-stephen@brennan.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

This enables hardware random number generator support for the BCM2711
on the Raspberry Pi 4 board.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
 arch/arm/boot/dts/bcm2711.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dts=
i
index ac83dac2e6ba..2c19e5de284a 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -92,10 +92,9 @@ pm: watchdog@7e100000 {
 =09=09};
=20
 =09=09rng@7e104000 {
+=09=09=09compatible =3D "brcm,bcm2711-rng200";
 =09=09=09interrupts =3D <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>;
-
-=09=09=09/* RNG is incompatible with brcm,bcm2835-rng */
-=09=09=09status =3D "disabled";
+=09=09=09status =3D "okay";
 =09=09};
=20
 =09=09uart2: serial@7e201400 {
--=20
2.24.0



