Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3CAC432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3D721850
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 06:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="Vop6KDuk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfKSGPL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:15:11 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21471 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfKSGPK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 01:15:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574144061; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Le7sfsCod1Xd41l4GEpIO/K40w93kGGzj4EHMqIMWnYLTivT3RoNuBmTZXhSNFvXBKcOrdZglWpgR7r+FRrf45hSWX4ixfTqggyxmVD51p2IOTe0D+DzT+tWbaxjLSKWhCCpnYAw/n2kQEF7nHoKs9bwwBGNsOSFRbvUKJclHhc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574144061; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cfu4tgSh/ZEFa8HY5V7AvfFEMPP8yuNAhIRi2KmoYKY=; 
        b=b1uVCdTMCVnceWNS8pXlJHRxz/uApiMuSJlkYqQ3UBTcBOIyQ4oqgwG2jL7U88tsnrhtp8ZNypmgYqyAyoGmeSEnWXHakFAyOPA3jsj3P9lmQBMwJK8TDPGJONBtlOk5M2DdjTja3zpxI8uM6/sOvZEJvzui0p6r/dUyUsjLK6Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574144061;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=881; bh=cfu4tgSh/ZEFa8HY5V7AvfFEMPP8yuNAhIRi2KmoYKY=;
        b=Vop6KDukXrIFvhSNE5ePAzF/2JlEgb3AECzMYGkaJ22HP+C+4uQQ6JkUG1IqRKKS
        kQnzWoLyL4BEKA05Rw76GfYByZSk6hsHms2Sb33n42Z74R5KY9z/aOBzRPLph3P8A1y
        BdvCETNpGbRnl5NWoK/Maz4L2Erdr1W2gCRCDqsY=
Received: from localhost (195.173.24.136.in-addr.arpa [136.24.173.195]) by mx.zohomail.com
        with SMTPS id 1574144060211715.8784521890552; Mon, 18 Nov 2019 22:14:20 -0800 (PST)
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
Message-ID: <20191119061407.69911-2-stephen@brennan.io>
Subject: [PATCH v2 1/3] dt-bindings: rng: add BCM2711 RNG compatible
Date:   Mon, 18 Nov 2019 22:14:05 -0800
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

The BCM2711 has a RNG200 block, so document its compatible string.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
 Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt b/=
Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
index c223e54452da..802523196ee5 100644
--- a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
+++ b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
@@ -2,6 +2,7 @@ HWRNG support for the iproc-rng200 driver
=20
 Required properties:
 - compatible : Must be one of:
+=09       "brcm,bcm2711-rng200"
 =09       "brcm,bcm7211-rng200"
 =09       "brcm,bcm7278-rng200"
 =09       "brcm,iproc-rng200"
--=20
2.24.0



