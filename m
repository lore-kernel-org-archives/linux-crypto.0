Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD91C77B7C
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Apr 2023 09:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDNJUq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Apr 2023 05:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDNJUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2023 05:20:45 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541475BB0;
        Fri, 14 Apr 2023 02:20:44 -0700 (PDT)
Received: from stefanw-SCHENKER ([37.4.248.58]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N4Q8u-1qX8jH2Txu-011RQg; Fri, 14 Apr 2023 11:20:09 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     kernel@pengutronix.de, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH V3 0/6] ARM: dts: imx6ull: Fix dtbs_check warnings
Date:   Fri, 14 Apr 2023 11:19:41 +0200
Message-Id: <20230414091947.7831-1-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:hZO7aSeh19CFSzyt1wn7DMqe5u+cJwhytrJylrSjOxbVjlxhFzV
 la9Z3fIgiDi3HXXewf+iWVDf4Pz851OnoCQEvSb5U1Z6T/JbnJtn6509JsU9bXk4E2f73Ef
 idkUHyq/4w34eR6PgnFQW5/bKeNKaATggNeKkNp0hsQiQC9YVUxFvLYH4hX7ufHVEWZCc7f
 ImlrB1EGBnn1B6UTtL4Dg==
UI-OutboundReport: notjunk:1;M01:P0:T4Ry70SW50U=;1kp/ghpYCyKpzAyHh/WjkyYii9z
 MdWawSyhF1XQp+hbp4dviq+AgQQSQcHMmidH8MYlIYxNpJ5Hfy8nnzfQbMC/Rc67v5PAUxD+3
 mz0mekv+1dw5uO/6dg23sxLuxOwYbt91EZhE3u4H+7sPWHGsc4xsuZSEFtc3e67h4HRFVYZJj
 gmUmb3QkIarRFcKpGoSJ2/9k3ODxKIM5MJrTQkUrKllA/Wf6sCb+W3m7nS6xvFeyy9v3ZTROO
 uBGJokHgL0baX01rquISsU8CXJIYWiPK0TlkI584uCP/AFx1pWwHeoNJ8DI0ooq4yJ173xKcM
 lEbDKocv9JydyPVw/7+c/1PT+CyhF/VMQZtg+0JKC1mcVhElXZ6oOKjHxqBLpepSv146pwlML
 KmvYDCVMnvLl1C45h7PCCdXMaFnEIlLDG91aq1ThdAb+kHATQBCMa5ncEhs1kFQpBiU1wD4hm
 2oUVIdXYJJzAZ37wcW+jiU6lXZw1WKpeX1tw0GCUorGkSWs5KZcGPsOSHX1vrCjvWemW8/Q9a
 QtDpB1dgpQBiXl2YxjhTPGExek9qVOoYOrJ+T1e2+lAu9314F3egz1HZLWjj9jEOjH0oNc9ZG
 7kBAyiwnDQd4aMfe0oVrLU6NwUuUdPHyvTsZO86Gotf8wL48Y4DI7TuwchKcEI4qvzAvRKB4h
 OKluAaiyw87XBKviGquCA1c988CSwh/+38QWukzfvw==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series tries to address some dtbs_check warnings on i.MX6ULL.

Changes in V3:
- add Krzysztof's Reviewed-Bys
- fix indentation in Patch 6 found by Krzysztof Kozlowski

Changes in V2:
- new patch to fix fsl-imx-uart warnings 
- fixed GPC typo found by Fabio Estevam
- keep enum in bindings as suggested by Krzysztof Kozlowski
- make imx6ul GPT compatible to imx6sx

Stefan Wahren (6):
  dt-bindings: serial: fsl-imx-uart: add missing properties
  dt-bindings: crypto: fsl-dcp: add imx6sl and imx6ull compatible
  dt-bindings: imx-thermal: add imx6sll and imx6ul compatible
  dt-bindings: imxgpt: add imx6ul compatible
  ARM: dts: imx: Adjust dma-apbh node name
  ARM: dts: imx6ul: Add clock and PGC node to GPC

 .../devicetree/bindings/crypto/fsl-dcp.yaml   | 12 ++++++---
 .../bindings/serial/fsl-imx-uart.yaml         | 25 +++++++++++++++++++
 .../bindings/thermal/imx-thermal.yaml         | 14 ++++++++---
 .../devicetree/bindings/timer/fsl,imxgpt.yaml |  3 +++
 arch/arm/boot/dts/imx23.dtsi                  |  2 +-
 arch/arm/boot/dts/imx28.dtsi                  |  2 +-
 arch/arm/boot/dts/imx6qdl.dtsi                |  2 +-
 arch/arm/boot/dts/imx6sx.dtsi                 |  2 +-
 arch/arm/boot/dts/imx6ul.dtsi                 | 14 ++++++++++-
 arch/arm/boot/dts/imx7s.dtsi                  |  2 +-
 10 files changed, 65 insertions(+), 13 deletions(-)

-- 
2.34.1

