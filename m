Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBBAC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 11:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6DD020885
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 11:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgHTK7W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 06:59:22 -0400
Received: from auth-smtp.nebula.fi ([217.149.52.145]:42118 "EHLO
        auth-smtp.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731523AbgHTK60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 06:58:26 -0400
Received: from developer-Precision-3630-Tower (82-203-173-204.bb.dnainternet.fi [82.203.173.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: xipheracom)
        by auth-smtp.nebula.fi (Postfix) with ESMTPSA id 4A0CE4447;
        Thu, 20 Aug 2020 13:58:04 +0300 (EEST)
From:   Atte Tommiska <atte.tommiska@xiphera.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Atte Tommiska <atte.tommiska@xiphera.com>
Subject: [PATCH v2 1/3] dt-bindings: vendor-prefixes: Add Xiphera vendor prefix
Date:   Thu, 20 Aug 2020 13:51:20 +0300
Message-Id: <70cc429f5e7e8f3213b86e4b97999580953db877.1597914503.git.atte.tommiska@xiphera.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1597914503.git.atte.tommiska@xiphera.com>
References: <cover.1597914503.git.atte.tommiska@xiphera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Xiphera is an FPGA-based cryptographic solutions provider based in
Finland.
Website of the company: https://xiphera.com/

Signed-off-by: Atte Tommiska <atte.tommiska@xiphera.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2baee2c817c1..28ae913682b5 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1174,6 +1174,8 @@ patternProperties:
     description: Shenzhen Xingbangda Display Technology Co., Ltd
   "^xinpeng,.*":
     description: Shenzhen Xinpeng Technology Co., Ltd
+  "^xiphera,.*":
+    description: Xiphera Ltd.
   "^xlnx,.*":
     description: Xilinx
   "^xnano,.*":
-- 
2.28.0

