From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: testmgr - add test vector for fcrypt
Date: Sat, 19 Jan 2013 13:31:36 +0200
Message-ID: <20130119113136.20877.48105.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:40977 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3ASLbl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:31:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

fcrypt is used only as pcbc(fcrypt), but testmgr does not know this.
Use the zero key, zero plaintext pcbc(fcrypt) test vector for
testing plain 'fcrypt' to hide "no test for fcrypt" warnings.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index edf4a08..efd8b20 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2269,6 +2269,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ecb(fcrypt)",
+		.test = alg_test_skcipher,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = fcrypt_pcbc_enc_tv_template,
+					.count = 1
+				},
+				.dec = {
+					.vecs = fcrypt_pcbc_dec_tv_template,
+					.count = 1
+				}
+			}
+		}
+	}, {
 		.alg = "ecb(khazad)",
 		.test = alg_test_skcipher,
 		.suite = {
