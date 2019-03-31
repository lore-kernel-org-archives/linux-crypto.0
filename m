Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D20C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E2120872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062761;
	bh=vj0ldUVe/yaqln0Fd+R3F3nJs4jWI87sXLJHmDEcxfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=n1eMsz7VRB2uIAAGIapSOrMvPzrEtDPjH/T+plyUONCfxng+bNs4IaCfpPJ+ZWO50
	 9YOUCaVJicLLO2/OvTAmN9B+dG2T+szasb4Ald1nv3zZjxv00Kw24NJOhFQv5lETnG
	 SEcPRrBxcIQUM9F44NA6txXxXpG2yUvkq7fk9law=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfCaUF6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731353AbfCaUF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF2721873;
        Sun, 31 Mar 2019 20:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062757;
        bh=vj0ldUVe/yaqln0Fd+R3F3nJs4jWI87sXLJHmDEcxfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlawHOHCexcAJiB0T3dFBE9UIq9Jre7W47iQq1paXpuqcIkyKHP2rUunMDsP3fgFo
         szX2meXlQavf1FfOQBQa1OrktO5WiKmKVs6LX6tGo9J+2NzmRie3OSgsM7HkukMIhb
         uZumzqYeOM/B2Iv0s2st+y1paJ0GuSpXYD1T9sQg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [RFC/RFT PATCH 04/18] crypto: skcipher - restore default skcipher_walk::iv on error
Date:   Sun, 31 Mar 2019 13:04:14 -0700
Message-Id: <20190331200428.26597-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When the user-provided IV buffer is not aligned to the algorithm's
alignmask, skcipher_walk_virt() allocates an aligned buffer and copies
the IV into it.  However, skcipher_walk_virt() can fail after that
point, and in this case the buffer will be freed.

This causes a use-after-free read in callers that read from walk->iv
unconditionally, e.g. the LRW template.  For example, this can be
reproduced by trying to encrypt fewer than 16 bytes using "lrw(aes)".

Fix it by making skcipher_walk_first() reset walk->iv to walk->oiv if
skcipher_walk_next() fails.

This addresses a similar problem as commit 2b4f27c36bcd ("crypto:
skcipher - set walk.iv for zero-length inputs"), but that didn't
consider the case where skcipher_walk_virt() fails after copying the IV.

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation, when the extra
self-tests were run on a KASAN-enabled kernel.

Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk interface")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index bcf13d95f54ac..0f639f018047d 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -426,19 +426,27 @@ static int skcipher_copy_iv(struct skcipher_walk *walk)
 
 static int skcipher_walk_first(struct skcipher_walk *walk)
 {
+	int err;
+
 	if (WARN_ON_ONCE(in_irq()))
 		return -EDEADLK;
 
 	walk->buffer = NULL;
 	if (unlikely(((unsigned long)walk->iv & walk->alignmask))) {
-		int err = skcipher_copy_iv(walk);
+		err = skcipher_copy_iv(walk);
 		if (err)
 			return err;
 	}
 
 	walk->page = NULL;
 
-	return skcipher_walk_next(walk);
+	err = skcipher_walk_next(walk);
+
+	/* On error, don't leave 'walk->iv' pointing to freed buffer. */
+	if (unlikely(err))
+		walk->iv = walk->oiv;
+
+	return err;
 }
 
 static int skcipher_walk_skcipher(struct skcipher_walk *walk,
-- 
2.21.0

