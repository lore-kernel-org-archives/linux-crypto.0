From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] pkcs7: return correct error code if pkcs7_check_authattrs() fails
Date: Sun, 26 Nov 2017 23:18:44 -0800
Message-ID: <20171127071844.26106-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33880 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdK0HTg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 02:19:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If pkcs7_check_authattrs() returns an error code, we should pass that
error code on, rather than using ENOMEM.

Fixes: 99db44350672 ("PKCS#7: Appropriately restrict authenticated attributes and content type")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index c1ca1e86f5c4..a6dcaa659aa8 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -148,8 +148,10 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
 	}
 
 	ret = pkcs7_check_authattrs(ctx->msg);
-	if (ret < 0)
+	if (ret < 0) {
+		msg = ERR_PTR(ret);
 		goto out;
+	}
 
 	msg = ctx->msg;
 	ctx->msg = NULL;
-- 
2.15.0
