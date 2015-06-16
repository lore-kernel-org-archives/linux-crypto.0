From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 1/8] crypto: testmgr - Disable rfc4543 test
Date: Tue, 16 Jun 2015 13:54:16 +0800
Message-ID: <E1Z4jpA-0005cY-VT@gondolin.me.apana.org.au>
References: <20150616054551.GA21524@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37458 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbFPFyW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 01:54:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Because the old rfc4543 implementation always injected an IV into
the AD, while the new one does not, we have to disable the test
while it is converted over to the new AEAD interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ccd19cf..009714d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3372,7 +3372,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "rfc4543(gcm(aes))",
+		.alg = "rfc4543(gcm(aes))-disabled",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
