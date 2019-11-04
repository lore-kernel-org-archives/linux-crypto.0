Return-Path: <SRS0=nD+4=Y4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAE9CA9ECF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 12:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E067E21D7D
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 12:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKDM4M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:56:12 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62902 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfKDM4M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Nov 2019 07:56:12 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Cx8jqRkQ5JRUGczCabc5Cy/BRBSb8Uq4WJB6eYbrLof3PBI+Jxu9MocMtJ4NAPFsmVRtRcpAzy
 vzdaAL+Wfw0X+pomuOWmFoYluVN36VFfXl8PJ7wtv6NksBdiyAGl5XlnYR8NY/pGMoxS7jgRni
 KWO5TYLKI4p9vAHuz/0TWLc1Pq5dZigOKpExLxy2K6hdzELhO+HGZ24O1HKTCKYaYcQXDO2BRy
 RYaiUwVOyddp9Kjdul0HcvI8KSHRU+ALqYSqab3HqZ3/NJpihOMtEczoVYckZCJlmAbdMRAawG
 KiM=
X-IronPort-AV: E=Sophos;i="5.68,267,1569308400"; 
   d="scan'208";a="56900562"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2019 05:56:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Nov 2019 05:56:11 -0700
Received: from rob-ult-m19940.corp.atmel.com (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 4 Nov 2019 05:56:08 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <arnd@arndb.de>,
        <Tudor.Ambarus@microchip.com>, <Claudiu.Beznea@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: rng: atmel-trng: add new compatible
Date:   Mon, 4 Nov 2019 13:54:56 +0200
Message-ID: <20191104115457.2681-1-codrin.ciubotariu@microchip.com>
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
Acked-by: Rob Herring <robh@kernel.org>
---

Changes in v2:
 - added 'Acked-by' from Rob;

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

