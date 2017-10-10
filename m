From: Robert Baronescu <robert.baronescu@nxp.com>
Subject: [PATCH 2/2] crypto: tcrypt - fix buffer lengths in test_aead_speed()
Date: Tue, 10 Oct 2017 13:22:00 +0300
Message-ID: <1507630920-9014-2-git-send-email-robert.baronescu@nxp.com>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
        Robert Baronescu <robert.baronescu@nxp.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:14560
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751420AbdJJKWK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2017 06:22:10 -0400
In-Reply-To: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the way the length of the buffers used for
encryption / decryption are computed.
For e.g. in case of encryption, input buffer does not contain
an authentication tag.

Signed-off-by: Robert Baronescu <robert.baronescu@nxp.com>
---
 crypto/tcrypt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index bd9b66c..e339960 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -342,7 +342,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			}
 
 			sg_init_aead(sg, xbuf,
-				    *b_size + (enc ? authsize : 0));
+				    *b_size + (enc ? 0 : authsize));
 
 			sg_init_aead(sgout, xoutbuf,
 				    *b_size + (enc ? authsize : 0));
@@ -350,7 +350,9 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			sg_set_buf(&sg[0], assoc, aad_size);
 			sg_set_buf(&sgout[0], assoc, aad_size);
 
-			aead_request_set_crypt(req, sg, sgout, *b_size, iv);
+			aead_request_set_crypt(req, sg, sgout,
+					       *b_size + (enc ? 0 : authsize),
+					       iv);
 			aead_request_set_ad(req, aad_size);
 
 			if (secs)
-- 
1.9.3
