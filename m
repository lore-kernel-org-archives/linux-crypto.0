Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B47AC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C721F218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552623686;
	bh=YnGh9eX22GKHm7jZDTWoolgOWcJhpAoZOYzAvqeWJ/Y=;
	h=From:To:Subject:Date:List-ID:From;
	b=i9S5PpIxLBOetUPveI7MdfkhTbQlShRjjH3A7cxdjrTr8qFviTir0hDc3jiiymPlc
	 I0rxsaPdTw51zJxjJs+wy9XpTYvZ5wDyO1nxz6NqzpSqwkkUU/n1f/SpE1IDal/OcM
	 iSs0WSlzIGyQR3vxEEqZq5gK+ZUnjM9BpIUT+iyg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfCOEV0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfCOEVZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:21:25 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38BA12186A;
        Fri, 15 Mar 2019 04:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552623685;
        bh=YnGh9eX22GKHm7jZDTWoolgOWcJhpAoZOYzAvqeWJ/Y=;
        h=From:To:Subject:Date:From;
        b=bJacZXCCJBvsXnWymBXbC7pXOMF0qR6mtnBSF/ochQE1aNZR18g+Q0JnDR/5Bwgwk
         g7imJEtCC2F66ejEyE7uAsYfm/na3LIAxwVZZjTROyKn8rs8njVA3gxvm4HT2N3C9c
         BLv+3GeSQ5xiGV61v49Rx+WfCYqqSqpsJ/Z0aYds=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: chacha-generic - use crypto_xor_cpy()
Date:   Thu, 14 Mar 2019 21:20:36 -0700
Message-Id: <20190315042037.32297-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In chacha_docrypt(), use crypto_xor_cpy() instead of crypto_xor().
This avoids having to memcpy() the src buffer to the dst buffer.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/chacha_generic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 90ec0ec1b4f7..a7fae9b73ec4 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -22,18 +22,16 @@ static void chacha_docrypt(u32 *state, u8 *dst, const u8 *src,
 	/* aligned to potentially speed up crypto_xor() */
 	u8 stream[CHACHA_BLOCK_SIZE] __aligned(sizeof(long));
 
-	if (dst != src)
-		memcpy(dst, src, bytes);
-
 	while (bytes >= CHACHA_BLOCK_SIZE) {
 		chacha_block(state, stream, nrounds);
-		crypto_xor(dst, stream, CHACHA_BLOCK_SIZE);
+		crypto_xor_cpy(dst, src, stream, CHACHA_BLOCK_SIZE);
 		bytes -= CHACHA_BLOCK_SIZE;
 		dst += CHACHA_BLOCK_SIZE;
+		src += CHACHA_BLOCK_SIZE;
 	}
 	if (bytes) {
 		chacha_block(state, stream, nrounds);
-		crypto_xor(dst, stream, bytes);
+		crypto_xor_cpy(dst, src, stream, bytes);
 	}
 }
 
-- 
2.21.0

