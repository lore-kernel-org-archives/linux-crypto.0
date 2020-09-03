Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43857C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 18:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E1320BED
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599156257;
	bh=P4D7LHg3zV2WYkumu6IlVHebD/yFLzaR9+3encueUSU=;
	h=From:To:Subject:Date:List-ID:From;
	b=RySWrmYN+LcBhvvMGs8UIXx9/YsBirbTd4c+da4ZMPSCnDSYN7r0JAZ3wVMQLZWlB
	 Ny5VWAfZHoQkEVXc11nPKhStWdSsYtgX8jS5Eilv3QPvkMwPLRwBE66+ggsiCJGtta
	 /bauQ45/GfTdrnY9LwfSb5mteBJPdoCZ/BJTgSJA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgICSEI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 14:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgICSEI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 14:04:08 -0400
Received: from localhost.localdomain (unknown [194.230.155.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA14420716;
        Thu,  3 Sep 2020 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599156248;
        bh=P4D7LHg3zV2WYkumu6IlVHebD/yFLzaR9+3encueUSU=;
        h=From:To:Subject:Date:From;
        b=nZgcK63sN7PkGNKn2shlb2wOwcpxA6BZpNsr1FGp8DsmEBrHh88l0VP8zR/dhl1vU
         S6COWRVr+YMM7rxj9bd5dkZO6NOm6laPQjFZePuSsxKbIf9U/3uHoIV4PvspOIlVHJ
         dVTc/bF0RPDi7yW4JWm9k66v1c9x35eVacY0aWGI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dt-bindings: crypto: slimsss: Correct a typo in compatible
Date:   Thu,  3 Sep 2020 20:03:58 +0200
Message-Id: <20200903180400.2865-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Correct a typo in the compatible - missing trailing 's'.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
index 04fe5dfa794a..7743eae049ab 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
+++ b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
@@ -19,7 +19,7 @@ description: |+
 properties:
   compatible:
     items:
-      - const: samsung,exynos5433-slim-ss
+      - const: samsung,exynos5433-slim-sss
 
   reg:
     maxItems: 1
-- 
2.17.1

