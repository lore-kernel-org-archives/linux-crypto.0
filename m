From: Colin King <colin.king@canonical.com>
Subject: [PATCH] PKCS#7: fix unitialized boolean 'want'
Date: Sat, 27 Feb 2016 12:45:26 +0000
Message-ID: <1456577126-5351-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>,
	James Morris <james.l.morris@oracle.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Peter Jones <pjones@redhat.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60311 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbcB0Mpl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 07:45:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The boolean want is not initialized and hence garbage. The default should
be false (later it is only set to true on tne sinfo->authattrs check).

Found with static analysis using CoverityScan

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 8f3056c..7a24e16 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL_GPL(pkcs7_free_message);
 static int pkcs7_check_authattrs(struct pkcs7_message *msg)
 {
 	struct pkcs7_signed_info *sinfo;
-	bool want;
+	bool want = false;
 
 	sinfo = msg->signed_infos;
 	if (sinfo->authattrs) {
-- 
2.7.0
