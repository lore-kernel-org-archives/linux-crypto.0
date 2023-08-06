Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71036C00528
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Aug 2023 19:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjHFT3p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Aug 2023 15:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHFT3o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Aug 2023 15:29:44 -0400
X-Greylist: delayed 605 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Aug 2023 12:29:42 PDT
Received: from smtp.jvdsn.com (smtp.jvdsn.com [IPv6:2603:c020:1:bd00::1:3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC43E1719
        for <linux-crypto@vger.kernel.org>; Sun,  6 Aug 2023 12:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
        t=1691349577; bh=4o2p4GOxYIDvcvcYKzRsf4b2twXDZVXQo9TkvKb93Hw=;
        h=From:To:Cc:Subject:Date;
        b=brZhzRPSTKkXezRyHNFTGRIUMb4+u8CR5LbLcuPfSaAjytirXNE1aWW84KwRkrCe4
         G1kGqVno87CuosSPH8f9axEBekOAQoxQOxlmGzwNGSyaWZzpZJjuavMiP5GvsUNUld
         2WX9vP+G28i+CveO7st853GQXT1CKHcxPIp3g9lXRFdL6zb/aM3ErCSD8KlfcjYYxa
         IwpRVTw9onyUO/jjOItnaQeyiEVL4ESnwg9Uqr8HwYYwna2MlvNzz7D5+f/QxtS0Bo
         BH2TNt5mW1vvKYnV0gVlZ2lRObgRVgBgf02z0G0snFgaWrG7ZaUrcLAhw+9W541nd7
         RDWKwcNoEwbhw==
From:   Joachim Vandersmissen <git@jvdsn.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] Add clarifying comments to Jitter Entropy RCT cutoff values.
Date:   Sun,  6 Aug 2023 14:19:03 -0500
Message-ID: <20230806191903.83423-1-git@jvdsn.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RCT cutoff values are correct, but they don't exactly match the ones
one would expect when computing them using the formula in SP800-90B. This
discrepancy is due to the fact that the Jitter Entropy RCT starts at 1. To
avoid any confusion by future reviewers, add some comments and explicitly
subtract 1 from the "correct" cutoff values in the definitions.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/jitterentropy.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index c7d7f2caa779..fe9c233ec769 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -89,10 +89,14 @@ struct rand_data {
 	unsigned int rct_count;			/* Number of stuck values */
 
 	/* Intermittent health test failure threshold of 2^-30 */
-#define JENT_RCT_CUTOFF		30	/* Taken from SP800-90B sec 4.4.1 */
-#define JENT_APT_CUTOFF		325	/* Taken from SP800-90B sec 4.4.2 */
+	/* From an SP800-90B perspective, this RCT cutoff value is equal to 31. */
+	/* However, our RCT implementation starts at 1, so we subtract 1 here. */
+#define JENT_RCT_CUTOFF		(31 - 1)	/* Taken from SP800-90B sec 4.4.1 */
+#define JENT_APT_CUTOFF		325			/* Taken from SP800-90B sec 4.4.2 */
 	/* Permanent health test failure threshold of 2^-60 */
-#define JENT_RCT_CUTOFF_PERMANENT	60
+	/* From an SP800-90B perspective, this RCT cutoff value is equal to 61. */
+	/* However, our RCT implementation starts at 1, so we subtract 1 here. */
+#define JENT_RCT_CUTOFF_PERMANENT	(61 - 1)
 #define JENT_APT_CUTOFF_PERMANENT	355
 #define JENT_APT_WINDOW_SIZE	512	/* Data window size */
 	/* LSB of time stamp to process */
-- 
2.41.0

