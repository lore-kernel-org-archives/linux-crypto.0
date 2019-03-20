Return-Path: <SRS0=fE7s=RX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CEBC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 10:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BC692184E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Mar 2019 10:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfCTKlI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:41:08 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:40984 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfCTKlH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Mar 2019 06:41:07 -0400
Received: from ramsan ([84.194.111.163])
        by baptiste.telenet-ops.be with bizsmtp
        id qAh51z0023XaVaC01Ah5ua; Wed, 20 Mar 2019 11:41:05 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1h6Yee-0005M8-UF; Wed, 20 Mar 2019 11:41:04 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1h6Yee-0005bb-R5; Wed, 20 Mar 2019 11:41:04 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] crypto: Grammar s/options/option/, s/to/the/
Date:   Wed, 20 Mar 2019 11:41:03 +0100
Message-Id: <20190320104103.21506-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes: ccb778e1841ce04b ("crypto: api - Add fips_enable flag")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index bbab6bf3351982c9..14f3a98e32f78d06 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -27,8 +27,8 @@ config CRYPTO_FIPS
 	depends on (CRYPTO_ANSI_CPRNG || CRYPTO_DRBG) && !CRYPTO_MANAGER_DISABLE_TESTS
 	depends on (MODULE_SIG || !MODULES)
 	help
-	  This options enables the fips boot option which is
-	  required if you want to system to operate in a FIPS 200
+	  This option enables the fips boot option which is
+	  required if you want the system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
 	  this is.
 
-- 
2.17.1

