From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: testmgr: notify expected failures on aead tests
Date: Mon, 19 Jan 2015 15:54:24 +0200
Message-ID: <1421675664-26107-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <horia.geanta@freescale.com>, <tudor.ambarus@freescale.com>,
	"Cristian Stoica" <cristian.stoica@freescale.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:64288
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751403AbbASPZu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2015 10:25:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some hardware drivers (e.g. caamalg) log failed operations reported by
hw to assist in debugging. However, these messages are confusing when they
are the result of a testmgr test that is expected to fail.

This patch puts the driver messages in their testing context and helps the
user classify them as harmless.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/testmgr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 235b1ff..ec19e98 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -573,9 +573,11 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 			if (!ret)
 				break;
 		case -EBADMSG:
-			if (template[i].novrfy)
-				/* verification failure was expected */
+			if (template[i].novrfy) {
+				pr_info("aead%s: expected %s failure on test %d for %s: ret=-EBADMSG\n",
+					d, e, j, algo);
 				continue;
+			}
 			/* fall through */
 		default:
 			pr_err("alg: aead%s: %s failed on test %d for %s: ret=%d\n",
@@ -723,9 +725,11 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 			if (!ret)
 				break;
 		case -EBADMSG:
-			if (template[i].novrfy)
-				/* verification failure was expected */
+			if (template[i].novrfy) {
+				pr_info("aead%s: expected %s failure on test %d for %s: ret=-EBADMSG\n",
+					d, e, j, algo);
 				continue;
+			}
 			/* fall through */
 		default:
 			pr_err("alg: aead%s: %s failed on chunk test %d for %s: ret=%d\n",
-- 
2.2.0
