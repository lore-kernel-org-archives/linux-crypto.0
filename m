Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A85AC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 02:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6242B64E82
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 02:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBIC37 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBIC3t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 21:29:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED1464E24
        for <linux-crypto@vger.kernel.org>; Tue,  9 Feb 2021 02:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612837749;
        bh=RS4snx0ibJnYbmiGL+ZJbV+7BCD6Xe7JdSrE1Hm2Muc=;
        h=From:To:Subject:Date:From;
        b=f1sfDMqkLfOM9FMF7PrlItpL6QaynzBBDeSyzoZ87vZLccIsNOirjNzyeYMenI1zb
         QO5SYX+PO6F/j8hVhA+wZfdVZeUlH3mgqLbPUSKXs9IRwm66EBJ5CHF4V453GhN6gv
         +uVnQLFP/Fy+EjFNOW2vV6cUWVzQNUzEbVYBt7XZBk+QR5pDMW210Yjo/FkRcP5D+y
         x/ea9K5KjvClHlVAAY7DX9eeh2rx5QdTcvve5L22YS3QZaGsJXJANdsjGKY8ztGXuu
         6qvSfI/2S339SjDNpBLW+Gn9vtEMvDZ6JRtac08XbGqBuJfTbKfZSul9lzzmnkJWIk
         QBe0ko85MPLRw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: arm/blake2b - drop unnecessary return statement
Date:   Mon,  8 Feb 2021 18:28:16 -0800
Message-Id: <20210209022816.3405596-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Neither crypto_unregister_shashes() nor the module_exit function return
a value, so the explicit 'return' is unnecessary.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/blake2b-neon-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/blake2b-neon-glue.c b/arch/arm/crypto/blake2b-neon-glue.c
index 34d73200e7fa..4b59d027ba4a 100644
--- a/arch/arm/crypto/blake2b-neon-glue.c
+++ b/arch/arm/crypto/blake2b-neon-glue.c
@@ -85,8 +85,8 @@ static int __init blake2b_neon_mod_init(void)
 
 static void __exit blake2b_neon_mod_exit(void)
 {
-	return crypto_unregister_shashes(blake2b_neon_algs,
-					 ARRAY_SIZE(blake2b_neon_algs));
+	crypto_unregister_shashes(blake2b_neon_algs,
+				  ARRAY_SIZE(blake2b_neon_algs));
 }
 
 module_init(blake2b_neon_mod_init);
-- 
2.30.0.478.g8a0d178c01-goog

