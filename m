Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C33C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A1DE2240E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="UWPcAzhZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfKTDRp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:17:45 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21465 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKTDRp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 22:17:45 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574219793; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=RSpCohzv+f9T1VYLNuM8wp6pAQvrLm2bKPIikd/UwZECpWbbBVVVhp69Cvkpk7/gGbh6uRsH1moDUiysa+RhfWfZ+Ba32Z7pf+t9nkel2v664fc1y9pUnZUqnS3rckmCMh0Qd8rP67n72+osy8VGAlgZcYX/jNYSyLujz0U6MhA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574219793; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Efwht2VhX2X3iX4OfpDosxQefq6lHG/BFamPUzKTwA4=; 
        b=Rbp24i5z1RYEkQYC8Z1NQ6DyJodMQSQtP7W2lRO7GYMKztZgjHS5U2vWWYPWmAiNYgJZMyl4+NfKedGPSCi6w2WmP6w4JfCUi3Sokr05dza6XEBDxXQYw7x0xSGnhGylqlT+smki0HlqY3qw7+IA6oQja2mkoH16agHSRm0c1M0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574219793;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1571; bh=Efwht2VhX2X3iX4OfpDosxQefq6lHG/BFamPUzKTwA4=;
        b=UWPcAzhZF95UNB/VBCiQqqO3KguKbaI74BeISboBhYdO8f5QKIgVvoUMQtr/PRhX
        MTjevbThZ4/+9GKNQbVjFpiM/saGGh27+zxzoHJ7fNOb0qbEjEHGrBvKK6Ws0RIz+jj
        RxrDLhzmSKr9sNU3oVSI5YzvO9HennBi+bFgW6uc=
Received: from localhost (c-98-207-184-40.hsd1.ca.comcast.net [98.207.184.40]) by mx.zohomail.com
        with SMTPS id 1574219792572634.0146447404323; Tue, 19 Nov 2019 19:16:32 -0800 (PST)
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
        linux-rpi-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
Message-ID: <20191120031622.88949-3-stephen@brennan.io>
Subject: [PATCH v3 2/4] hwrng: iproc-rng200: Add support for BCM2711
Date:   Tue, 19 Nov 2019 19:16:20 -0800
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

From: Stefan Wahren <wahrenst@gmx.net>

BCM2711 features a RNG200 hardware random number generator block.
So make the driver available.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Brennan <stephen@brennan.io>
Reviewed-by: Matthias Brugger <mbrugger@suse.com>
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



