Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33AFC43219
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 08:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiKJIPL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbiKJIPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 03:15:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185731B1D0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 00:15:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A752A61DC3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A520C433D7
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068106;
        bh=8zY/anngcz+FEltTmxAC07IEno7jSt5nwm0l9nQ8Qow=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uTaoGZt5j2Z8i0LA1gISekJvS8i5USotWkiaV/sIOM4vj98RF92f343yDAwYNfnX/
         PdOoJwVWSK/jk2yyCVgQjCFhd9/Jkqw9K1F4JSXCltuPXmroQjorDz9xrm/qWsz/ZQ
         9z6IVMKmb7VOZqBcYMk7tgEJNJ45HVLAVpSRKxjix9z2B49VU95jO9U0JRCcEmamDk
         dOfNVBWGRm6CygW0UBfqeqYeLBq0wrBTSYxghvZJDED0DHr1uaYJ36UP97MxvLES/M
         mFt2tGmBP76CQObmvegusopiYYpDmRQgf9jSgcRwRt7WEnBVbrdIlWhCTVv2EjXwH2
         YD2o0m8cafB9g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 5/6] crypto: silence noisy kdf_sp800108 self-test
Date:   Thu, 10 Nov 2022 00:13:45 -0800
Message-Id: <20221110081346.336046-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110081346.336046-1-ebiggers@kernel.org>
References: <20221110081346.336046-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the kdf_sp800108 self-test only print a message on success when
fips_enabled, so that it's consistent with testmgr.c and doesn't spam
the kernel log with a message that isn't really important.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/kdf_sp800108.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/kdf_sp800108.c b/crypto/kdf_sp800108.c
index c6e3ad82d5f7a..c3f9938e1ad27 100644
--- a/crypto/kdf_sp800108.c
+++ b/crypto/kdf_sp800108.c
@@ -140,7 +140,7 @@ static int __init crypto_kdf108_init(void)
 		WARN(1,
 		     "alg: self-tests for CTR-KDF (hmac(sha256)) failed (rc=%d)\n",
 		     ret);
-	} else {
+	} else if (fips_enabled) {
 		pr_info("alg: self-tests for CTR-KDF (hmac(sha256)) passed\n");
 	}
 
-- 
2.38.1

