Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B931C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 08:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347994AbiBKIV0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:21:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347989AbiBKIV0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 03:21:26 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4911E43;
        Fri, 11 Feb 2022 00:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644567685; x=1676103685;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1UsTRf6vAc8LZ7TbQ26bS4L3iuvgio5huOsqnR05FIQ=;
  b=HK4/dce2PMKUg/UxiXx6WSCCWEsCsAsNev+rc9jo79ejK/EfsxzoDLxG
   W3nrZPiyn+ymLatnrfo6UEMLOon1fPhGf4ovVKnnesP7rgr3R9ZaY4xT/
   ThUF61k1C11mbRzZ+EXz0lUxVyNM+FDpWoXt/uxW7le6egcKFkFuxtq9T
   wbQ9s1fOR4Z4enUpVJB2EG1+NCoVgPCKf0aO1Bbxj1SCPZ113KNq6CIwm
   KglBq2r4WK/OD+BNYzIE6/Of845swSSNExR3Vl5JtHxzPCZv0m8aYv8AL
   xvyzhywnmdwTlmnrYbc8pKviYKLuyvhUzzRKMiaa9VySdkf/Q9R8oYcni
   w==;
IronPort-SDR: bwmf1RwIFZKooVK5HAVj2uMcrzgwBV1imp6sYYobwCbo6DlxQc6CgeEKFzWG67Spwmcx1j0UsA
 ZAVfrCdrF9ZH5j3cOueG1MBNQeS55SIr6zPlwjJOdxM28wUucCf40igIfiPYamTnrMx+HflDKd
 bLI9alAjzyw9R5UfEjntJJyhuzFGydOwZlkSCNTLdGquxwhLNazujeLYAvFTkhrKcyX/5bvDiX
 4I7qJRq1mrM5KpYI2BmiLp9rQLB26TJn7N82QSFA3Jn5ZJmI/WUn2jgXOSw9ac9Wa3wiedgFwB
 qY4GKw0qTJOXPwt0CHlby8RK
X-IronPort-AV: E=Sophos;i="5.88,360,1635231600"; 
   d="scan'208";a="148383285"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Feb 2022 01:21:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 11 Feb 2022 01:21:18 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 11 Feb 2022 01:21:15 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>, <krzysztof.kozlowski@canonical.com>,
        <robh+dt@kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <alexandre.belloni@bootlin.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kavyasree.kotagiri@microchip.com>,
        <devicetree@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PACTH v3 0/3] dt-bindings: crypto: Convert atmel-crypto to YAML
Date:   Fri, 11 Feb 2022 10:21:11 +0200
Message-ID: <20220211082114.452911-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert Atmel AES, TDES and SHA documentation to yaml format. There is one
binding defined per file. Keeping all bindings under the same yaml does
not make sense, as these are individual IPs. With the conversion the clock
and clock-names properties are made mandatory, to reflect how the drivers
treat them: when these properties are not provided, the drivers return
error.

v3:
- update license to (GPL-2.0-only OR BSD-2-Clause)
- add "Copyright (C) 2022 Microchip Technology, Inc. and its subsidiaries"
- add Krzysztof's R-b tag on patch 3/3. Chose to keep "maxItems: 1" instead
of "items" and "description" because that's what the guide at [1] suggests:
"# Cases that have only a single entry just need to express that with
maxItems"

[1] https://www.kernel.org/doc/html/latest/devicetree/bindings/writing-schema.html#annotated-example-schema

v2:
- use generic "crypto" node name
- drop redundant status = "okay" - it's the default state anyway
- introduce empty line for readability
- be specific and rename the bindings to let room for future possible
  lines of architectures.

Tudor Ambarus (3):
  dt-bindings: crypto: Convert Atmel AES to yaml
  dt-bindings: crypto: Convert Atmel TDES to yaml
  dt-bindings: crypto: Convert Atmel SHA to yaml

 .../crypto/atmel,at91sam9g46-aes.yaml         | 66 ++++++++++++++++++
 .../crypto/atmel,at91sam9g46-sha.yaml         | 60 ++++++++++++++++
 .../crypto/atmel,at91sam9g46-tdes.yaml        | 64 +++++++++++++++++
 .../bindings/crypto/atmel-crypto.txt          | 68 -------------------
 4 files changed, 190 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
 delete mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt

-- 
2.25.1

