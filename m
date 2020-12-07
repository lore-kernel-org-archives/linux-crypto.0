Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3153C0018C
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 16:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF2823877
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 16:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgLGQ4J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:56:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGQ4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 11:56:09 -0500
From:   Krzysztof Kozlowski <krzk@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] MAINTAINERS: crypto: s5p-sss: drop Kamil Konieczny
Date:   Mon,  7 Dec 2020 17:55:20 +0100
Message-Id: <20201207165521.125129-1-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

E-mails to Kamil Konieczny to his Samsung address bounce with 550 (User
unknown).  Kamil no longer takes care about Samsung S5P SSS driver so
remove the invalid email address from:
 - mailmap,
 - bindings maintainer entries,
 - maintainers entry for S5P Security Subsystem crypto accelerator.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .mailmap                                                      | 1 -
 Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml | 1 -
 Documentation/devicetree/bindings/crypto/samsung-sss.yaml     | 1 -
 MAINTAINERS                                                   | 1 -
 4 files changed, 4 deletions(-)

diff --git a/.mailmap b/.mailmap
index 225546cc8028..ff2699f60a03 100644
--- a/.mailmap
+++ b/.mailmap
@@ -172,7 +172,6 @@ Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
-Kamil Konieczny <k.konieczny@samsung.com> <k.konieczny@partner.samsung.com>
 Kay Sievers <kay.sievers@vrfy.org>
 Kees Cook <keescook@chromium.org> <kees.cook@canonical.com>
 Kees Cook <keescook@chromium.org> <keescook@google.com>
diff --git a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
index 7743eae049ab..676950bb7b37 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
+++ b/Documentation/devicetree/bindings/crypto/samsung-slimsss.yaml
@@ -8,7 +8,6 @@ title: Samsung Exynos SoC SlimSSS (Slim Security SubSystem) module
 
 maintainers:
   - Krzysztof Kozlowski <krzk@kernel.org>
-  - Kamil Konieczny <k.konieczny@partner.samsung.com>
 
 description: |+
   The SlimSSS module in Exynos5433 SoC supports the following:
diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.yaml b/Documentation/devicetree/bindings/crypto/samsung-sss.yaml
index cf1c47a81d7f..6d62b0e42fc9 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.yaml
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.yaml
@@ -8,7 +8,6 @@ title: Samsung Exynos SoC SSS (Security SubSystem) module
 
 maintainers:
   - Krzysztof Kozlowski <krzk@kernel.org>
-  - Kamil Konieczny <k.konieczny@partner.samsung.com>
 
 description: |+
   The SSS module in S5PV210 SoC supports the following:
diff --git a/MAINTAINERS b/MAINTAINERS
index 12dd1fff2a39..c45d4a3be2e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15620,7 +15620,6 @@ F:	drivers/media/i2c/s5k5baf.c
 SAMSUNG S5P Security SubSystem (SSS) DRIVER
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 M:	Vladimir Zapolskiy <vz@mleia.com>
-M:	Kamil Konieczny <k.konieczny@samsung.com>
 L:	linux-crypto@vger.kernel.org
 L:	linux-samsung-soc@vger.kernel.org
 S:	Maintained
-- 
2.25.1

