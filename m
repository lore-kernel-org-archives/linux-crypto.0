Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633DAC5517A
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 14:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14E742074B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Nov 2020 14:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKKONJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Nov 2020 09:13:09 -0500
Received: from foss.arm.com ([217.140.110.172]:54764 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgKKOMT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Nov 2020 09:12:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B86651042;
        Wed, 11 Nov 2020 06:12:18 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B111D3F718;
        Wed, 11 Nov 2020 06:12:16 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Ofir Drang <ofir.drang@arm.com>, Rob Herring <robh@kernel.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: crypto: update ccree optional params
Date:   Wed, 11 Nov 2020 16:11:36 +0200
Message-Id: <20201111141138.836-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201111141138.836-1-gilad@benyossef.com>
References: <20201111141138.836-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document ccree driver supporting new optional parameters allowing to
override cache parameters.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
index 6130e6eb4af8..fb4ba4a3af4c 100644
--- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
+++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
@@ -13,6 +13,10 @@ Required properties:
 Optional properties:
 - clocks: Reference to the crypto engine clock.
 - dma-coherent: Present if dma operations are coherent.
+- cache-attributes: override default cache attributes with "write-through" or "write-back".
+  Default is write through, write allocate.
+- sharability-domain: override default cache sharability domain with "inner-sharable".
+  Default is outer-sharable (712, 703, 713 only).
 
 Examples:
 
-- 
2.29.2

