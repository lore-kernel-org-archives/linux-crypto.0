Return-Path: <SRS0=B+FN=SQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD27C10F13
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Apr 2019 23:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB5742084E
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Apr 2019 23:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555284289;
	bh=MOZ/nqioSHYTtXMt7IrAccVXaYkV8ciM8yHr4DlyOZM=;
	h=From:To:Subject:Date:List-ID:From;
	b=JeW80KwycXMfZ9EU1NafXG+coDKbYpsQqyNQCaVaK9z3MuzGTwn576ftvmXszIpTi
	 iFZiZLVf3IBnSEl6bPgx3afX+xmMGBdUl5mujy4YMw4rjMzJY+BUwZp6lRfh/Vu5jU
	 TFTesWF4ZbARC49wC4hCyGtAPZXGMpetN2Fmko8c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbfDNXYs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 19:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfDNXYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 19:24:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E895E20833;
        Sun, 14 Apr 2019 23:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555284288;
        bh=MOZ/nqioSHYTtXMt7IrAccVXaYkV8ciM8yHr4DlyOZM=;
        h=From:To:Subject:Date:From;
        b=n04um4jW81x9jOXe0t50HNNyn1ADkr6cH1L/RL6c+kOQ26ZInWRJ+P4Eiw1ZcRY8Z
         SLPkvGd669HXSMsLEF6NSaxENgrhU01PYgPVj5IabRU0a7MuZ7VoQ90jxVPiBV5prq
         sCe7c+8Bn+cy8tGJjj0FTemgHFdbBSoMeQHYLJ9A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: shash - fix missed optimization in shash_ahash_digest()
Date:   Sun, 14 Apr 2019 16:23:33 -0700
Message-Id: <20190414232333.4215-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

shash_ahash_digest(), which is the ->digest() method for ahash tfms that
use an shash algorithm, has an optimization where crypto_shash_digest()
is called if the data is in a single page.  But an off-by-one error
prevented this path from being taken unless the user happened to provide
extra data in the scatterlist.  Fix it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 15b369c4745f6..b85930e9a7a2e 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -307,7 +307,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 
 	if (nbytes &&
 	    (sg = req->src, offset = sg->offset,
-	     nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
+	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
 		void *data;
 
 		data = kmap_atomic(sg_page(sg));
-- 
2.21.0

