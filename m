Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08A4C678DB
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Mar 2023 23:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjCEXFB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Mar 2023 18:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCEXFA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2023 18:05:00 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D25510A9E;
        Sun,  5 Mar 2023 15:04:59 -0800 (PST)
Received: from stefanw-SCHENKER ([37.4.248.41]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MiakT-1qBqJG1Owp-00fkew; Sun, 05 Mar 2023 23:59:33 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Cc:     linux-imx@nxp.com, Marek Vasut <marex@denx.de>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 2/6] dt-bindings: imx-thermal: add imx6sll and imx6ul compatible
Date:   Sun,  5 Mar 2023 23:58:56 +0100
Message-Id: <20230305225901.7119-3-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230305225901.7119-1-stefan.wahren@i2se.com>
References: <20230305225901.7119-1-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:LdkJIDMurn45BWkJDT8GjmvZOHqCuFwYE3c40poDEbgFl1hLAai
 VnpbdQ9+AcVlza7RRLsnv4zWpRz20lcVMY1p8dsP1reQrXo/km+i+DVrxmkkXxrGblWY2mP
 qCLroqJ54TAS82MZenlXCngD6Umi/3UEQ9Ljpn9ILclxq028VAaK8YBgETQF4DexxcwzYQZ
 wciU4MESNx1HbcHBpyadA==
UI-OutboundReport: notjunk:1;M01:P0:ByKym6MCWmQ=;5vkKvvntfHM3zPp6qaFNx1Tx74c
 xiKUNZjIwt47MP1HEqxbyqK92RlFFadJXXhzBIVpBhIGHvEji9QSyQ8AAEgDAsYQAp+R+JXTE
 q+76ompcW6IJfr7Q7pWv5OKrABt87ILTZGm9yz4Elem2Npyy/CgyaOrmgQCX0sJFihfRMYD4T
 sfRyQ6WvUs9nubMqA9Te1jgMHYIuHYTV2v10BI3XGCC2lhdos9EMIreabmlBwtrLhaJclspPi
 NAlZJ3SVB7Qn8YG5b3TXJq5jsifVyWNvfpWcubK72fezvs1jWmean+02rG2ZIcOcwaIJHUWyr
 hAkrhmrUYsJyU28j/6g+M3bYJNGZMaZRPmyYNkDBthu16lwPAGRamFFrPKVHQEqR+5pgOFRjM
 Z9Z7Bh8B4H6rZJ8ltJ8C1cMiKyRz2+FMQf0ha4LOs9HN2BHfJ86bX2TrRTMhKsvKjbNtZjeXR
 ewZ0Zs4utMCCxL9/BpdF3K1KUHzvgmxegMe4dRrIaK0oRnbzsY1nWpxl3CCPYLE5czpxPAkxB
 3Lm2Dxd9M7/KMBZZbkLgmMVBZ2rafEfgqJzJv/gMmSMBK07KX15hkuNoc3UR7d/R/4XV2ngaO
 K4HBJYSRdmM3PvN+Wyp/cFVV1OvjyCNwSYp51U1I/cBf9xNZg8dvWDcFw7pIo58vUKh2Y2Yik
 9k54JjMPnADV4DvMC7Fno2q9ubBupH17tSzgDhGIKQ==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the dtbs_check for imx6 generates warnings like this:

['fsl,imx6sll-tempmon', 'fsl,imx6sx-tempmon'] is too long

So add them to the devicetree binding.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 .../devicetree/bindings/thermal/imx-thermal.yaml    | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/imx-thermal.yaml b/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
index b22c8b59d5c7..9a20c5d74617 100644
--- a/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
+++ b/Documentation/devicetree/bindings/thermal/imx-thermal.yaml
@@ -12,10 +12,15 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - fsl,imx6q-tempmon
-      - fsl,imx6sx-tempmon
-      - fsl,imx7d-tempmon
+    oneOf:
+      - const: fsl,imx6q-tempmon
+      - const: fsl,imx6sx-tempmon
+      - items:
+          - enum:
+              - fsl,imx6sll-tempmon
+              - fsl,imx6ul-tempmon
+          - const: fsl,imx6sx-tempmon
+      - const: fsl,imx7d-tempmon
 
   interrupts:
     description: |
-- 
2.34.1

