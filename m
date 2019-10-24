Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44DECA9EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 17:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9514C21906
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 17:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410149AbfJXRFW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 13:05:22 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:15918 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410113AbfJXRFV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 13:05:21 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: sDuzIKqKF2WoEdz+uGasTVOVvMm1648yY9+1myKia5vT3IOofPzBelK9wDcm8eqODPKUMYBsUO
 +H+5YxuTOb/ZEyoImoURrgH6mJU8ZuMSE4mbBWi83PCyUmfh2AH/nsYEnMCe/RIuTIEB9WH2K5
 5MieozXW211RLZt6ktQt2hPv/ACKZ+txINGN+7LN2T+THB7gvX63HBh3z5QpXzpkSPXk75FCl0
 DPtU7O94lm7cEmwBoc8oEN8A6Kn9JzFO0xNJFH1iv6ySTe/ajLS+QTsUAEn/Mg0puP9vay04v2
 zrY=
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="53974558"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2019 10:05:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Oct 2019 10:05:18 -0700
Received: from rob-ult-m19940.microchip.com (10.10.85.251) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 24 Oct 2019 10:05:16 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <arnd@arndb.de>,
        <Tudor.Ambarus@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH 1/2] dt-bindings: rng: atmel-trng: add new compatible
Date:   Thu, 24 Oct 2019 20:04:51 +0300
Message-ID: <20191024170452.2145-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add compatible for new IP found on sam9x60 SoC.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 Documentation/devicetree/bindings/rng/atmel-trng.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/atmel-trng.txt b/Documentation/devicetree/bindings/rng/atmel-trng.txt
index 4ac5aaa2d024..3900ee4f3532 100644
--- a/Documentation/devicetree/bindings/rng/atmel-trng.txt
+++ b/Documentation/devicetree/bindings/rng/atmel-trng.txt
@@ -1,7 +1,7 @@
 Atmel TRNG (True Random Number Generator) block
 
 Required properties:
-- compatible : Should be "atmel,at91sam9g45-trng"
+- compatible : Should be "atmel,at91sam9g45-trng" or "microchip,sam9x60-trng"
 - reg : Offset and length of the register set of this block
 - interrupts : the interrupt number for the TRNG block
 - clocks: should contain the TRNG clk source
-- 
2.20.1

