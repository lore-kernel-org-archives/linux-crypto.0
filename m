Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C2FC433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 16:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74907207DE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 16:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgIGQ0D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:26:03 -0400
Received: from gw.c-home.cz ([89.24.150.100]:42061 "EHLO dmz.c-home.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730271AbgIGQZ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 12:25:59 -0400
Received: from ubuntu1804.c-home.cz (unifi.c-home.cz [192.168.1.239])
        by dmz.c-home.cz (8.14.4+Sun/8.14.4) with ESMTP id 087GP1f2019439;
        Mon, 7 Sep 2020 18:25:08 +0200 (CEST)
From:   Martin Cerveny <m.cerveny@computer.org>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v3 1/2] dt-bindings: crypto: Add compatible for V3s
Date:   Mon,  7 Sep 2020 18:24:57 +0200
Message-Id: <20200907162458.23730-2-m.cerveny@computer.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200907162458.23730-1-m.cerveny@computer.org>
References: <20200907162458.23730-1-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allwinner V3s has crypto engine similar to that in A33.
So add compatible.

Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
---
 .../devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
index fc823572bcff..d7d64335120c 100644
--- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
@@ -25,6 +25,9 @@ properties:
           - const: allwinner,sun4i-a10-crypto
       - items:
           - const: allwinner,sun8i-a33-crypto
+      - items:
+          - const: allwinner,sun8i-v3s-crypto
+          - const: allwinner,sun8i-a33-crypto
 
   reg:
     maxItems: 1
-- 
2.17.1

