From: Terence Eden <terence.eden@gmail.com>
Subject: [PATCH] "its" == "something belong to it". "it's" == "it is", "it has", "it was", etc. Sorry - just bugged me as I was reading the code.
Date: Mon, 17 Nov 2014 17:06:04 +0000
Message-ID: <1416243964-9790-1-git-send-email-terence.eden@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	edent <github.com@shkspr.mobi>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65301 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKQRGk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 12:06:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: edent <github.com@shkspr.mobi>

Signed-off-by: edent <github.com@shkspr.mobi>
---
 crypto/ahash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f6a36a5..ffbcda3 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -271,7 +271,7 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 	/*
 	 * WARNING: We do not backup req->priv here! The req->priv
 	 *          is for internal use of the Crypto API and the
-	 *          user must _NOT_ _EVER_ depend on it's content!
+	 *          user must _NOT_ _EVER_ depend on its content!
 	 */
 
 	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
-- 
1.9.1
