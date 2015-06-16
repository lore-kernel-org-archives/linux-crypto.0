From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 7/8] Revert "crypto: testmgr - Disable rfc4543 test"
Date: Tue, 16 Jun 2015 13:54:24 +0800
Message-ID: <E1Z4jpI-0005eF-Ll@gondolin.me.apana.org.au>
References: <20150616054551.GA21524@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47038 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbFPFy3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 01:54:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit 9b9f9296a7b73fbafe0a0a6f2494eaadd97f9f73 as
all in-kernel implementations of GCM have been converted to the
new AEAD interface, meaning that they should now pass the updated
rfc4543 test.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 009714d..ccd19cf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3372,7 +3372,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "rfc4543(gcm(aes))-disabled",
+		.alg = "rfc4543(gcm(aes))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
