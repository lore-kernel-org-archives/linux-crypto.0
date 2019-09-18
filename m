Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B174C4CED0
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 17:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74DB221907
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568827972;
	bh=842m/JSo8zkhqWTjvGIQQMCBzFCNxClDHEXRC5hvQrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ku+8EWAdMXz58TyrD9btkvbZ5PL+iAzEHMHNiNi4Leu1tEcje1DaJSDwpJGnJa52X
	 +LIoUATXzYgtSZ8SlD2YkyzGb9Gc26XVFNOzczCQblA1ZlUYLCjASyjaVeypxXx7TP
	 +hb9la7Nykh6WdP0gwggwnSgZ5pzGcuaVF7is8nA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbfIRRcq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 13:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387871AbfIRRcp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 13:32:45 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7847C208C0;
        Wed, 18 Sep 2019 17:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568827964;
        bh=842m/JSo8zkhqWTjvGIQQMCBzFCNxClDHEXRC5hvQrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imfD8ZeFL3JfbWKLBOl0g4IXKqnOv8ebaSBXNzLB3QMI1t3nujlYdNlQj2AOElGSK
         0sGzh2M1gdLRgj3EtYl3FCRICCDfqgMC9IAmAXXD6Y8ZDjz66yLkYxctPPVkSNPwwe
         djNwKk2ojpcu/k/biiusrFHlZ5VLQm3LpFj3nQDI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-tegra@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-crypto@vger.kernel.org, linux-watchdog@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2 6/8] dt-bindings: watchdog: Add missing clocks requirement in Samsung SoC watchdog
Date:   Wed, 18 Sep 2019 19:31:39 +0200
Message-Id: <20190918173141.4314-6-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918173141.4314-1-krzk@kernel.org>
References: <20190918173141.4314-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Samsung SoC watchdog driver always required providing a clock
(either through platform data or from DT).  However when bindings were
added in commit 9487a9cc7140 ("watchdog: s3c2410: Add support for device
tree based probe"), they missed the requirement of clock.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>

---

Changes since v1:
1. Indent example with four spaces (more readable),
2. Add also missing required entries for clocks.
---
 .../devicetree/bindings/watchdog/samsung-wdt.yaml        | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml b/Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml
index 3ea3c9fe8390..311f9dc83fdb 100644
--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.yaml
@@ -26,6 +26,13 @@ properties:
   reg:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: watchdog
+
   interrupts:
     maxItems: 1
 
@@ -40,6 +47,8 @@ properties:
 
 required:
   - compatible
+  - clocks
+  - clock-names
   - interrupts
   - reg
 
-- 
2.17.1

