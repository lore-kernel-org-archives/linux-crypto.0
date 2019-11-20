Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A11DC43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E63E42245F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 03:17:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=brennan.io header.i=stephen@brennan.io header.b="WN8HwTFg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfKTDRT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:17:19 -0500
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21432 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfKTDRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 22:17:19 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574219791; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=eFoKa9qXy1tgn9/SUB+A/HnLyFMrVY7caqc9mj56iP/ZNPuNaRAbXAXthYqfMLSXXHKMG3ljKA8TtpLretv/n0gia4vsWqp0iijXN8RBrt9XGsbWMAggM9Q+u7HKjsT1xOns9v4gb3AY5lEs85fTQR0jYXOfTk+hiQpfE6WC7qA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574219791; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cfu4tgSh/ZEFa8HY5V7AvfFEMPP8yuNAhIRi2KmoYKY=; 
        b=KJvZ+Zc6yLN+/HgpZn3e+Wm+6nozQD1EqqPXoeSL2NAcx19lKiuitkW/p3EjK2VOYvKSEsbEGvl51HI53S4mu+wByeP0PivZFqZPTuOUry9aJfZXWsZG8Xdj/r3Xnuy2U29evBkEgjKbozztqAPAoVAA7wbvBYDrGin1m3ItIYo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=brennan.io;
        spf=pass  smtp.mailfrom=stephen@brennan.io;
        dmarc=pass header.from=<stephen@brennan.io> header.from=<stephen@brennan.io>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1574219791;
        s=selector01; d=brennan.io; i=stephen@brennan.io;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=881; bh=cfu4tgSh/ZEFa8HY5V7AvfFEMPP8yuNAhIRi2KmoYKY=;
        b=WN8HwTFgQirOnyQsKTh3e72cq43UUGVZTzZEQn6LdO04Pwd+LBN0iKETukWu5wqt
        4l19Aj8kskfypoU9JvrDbSna8DuyPgxt+9q/LpoRmbwEAU3KglEdyHP1rGvd/eDvZEA
        qjoVHtHaVEPUqKX7nEWoqT18HE/j78sKMfDrUdL0=
Received: from localhost (c-98-207-184-40.hsd1.ca.comcast.net [98.207.184.40]) by mx.zohomail.com
        with SMTPS id 1574219790523910.6750032020789; Tue, 19 Nov 2019 19:16:30 -0800 (PST)
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
Message-ID: <20191120031622.88949-2-stephen@brennan.io>
Subject: [PATCH v3 1/4] dt-bindings: rng: add BCM2711 RNG compatible
Date:   Tue, 19 Nov 2019 19:16:19 -0800
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



