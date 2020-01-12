Return-Path: <SRS0=5sH2=3B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A58C33CA2
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jan 2020 16:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F622080D
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jan 2020 16:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgALQ7I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jan 2020 11:59:08 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:45570 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbgALQ7I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jan 2020 11:59:08 -0500
Received: from ramsan ([84.195.182.253])
        by andre.telenet-ops.be with bizsmtp
        id pUz5210065USYZQ01Uz5bc; Sun, 12 Jan 2020 17:59:06 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iqgZt-00086E-AQ; Sun, 12 Jan 2020 17:59:05 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iqgZt-0005X0-9P; Sun, 12 Jan 2020 17:59:05 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial] crypto: essiv - fix AEAD capitalization and preposition use in help text
Date:   Sun, 12 Jan 2020 17:58:58 +0100
Message-Id: <20200112165858.21214-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

"AEAD" is capitalized everywhere else.
Use "an" when followed by a written or spoken vowel.

Fixes: be1eb7f78aa8fbe3 ("crypto: essiv - create wrapper template for ESSIV generation")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5575d48473bd4a7f..cdb51d4272d0cc7c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -511,10 +511,10 @@ config CRYPTO_ESSIV
 	  encryption.
 
 	  This driver implements a crypto API template that can be
-	  instantiated either as a skcipher or as a aead (depending on the
+	  instantiated either as an skcipher or as an AEAD (depending on the
 	  type of the first template argument), and which defers encryption
 	  and decryption requests to the encapsulated cipher after applying
-	  ESSIV to the input IV. Note that in the aead case, it is assumed
+	  ESSIV to the input IV. Note that in the AEAD case, it is assumed
 	  that the keys are presented in the same format used by the authenc
 	  template, and that the IV appears at the end of the authenticated
 	  associated data (AAD) region (which is how dm-crypt uses it.)
-- 
2.17.1

