From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] crypto: testmgr - Update rfc4543 test vectors
Date: Mon, 15 Jun 2015 16:09:41 +0800
Message-ID: <E1Z4PSf-00083h-M9@gondolin.me.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37239 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbFOIJp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 04:09:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch updates the rfc4543 test vectors to the new format
where the IV is part of the AD.  For now these vectors are still
unused.  They will be reactivated once all rfc4543 implementations
have migrated.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4c2b3e5..110142c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -20309,8 +20309,9 @@ static struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
 			  "\x22\x43\x3c\x64",
 		.klen	= 20,
 		.iv	= zeroed_string,
-		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07",
-		.alen	= 8,
+		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.alen	= 16,
 		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
 			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
 			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
@@ -20339,8 +20340,9 @@ static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
 			  "\x22\x43\x3c\x64",
 		.klen	= 20,
 		.iv	= zeroed_string,
-		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07",
-		.alen	= 8,
+		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.alen	= 16,
 		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
 			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
 			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
@@ -20365,8 +20367,9 @@ static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
 			  "\x22\x43\x3c\x64",
 		.klen	= 20,
 		.iv	= zeroed_string,
-		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07",
-		.alen	= 8,
+		.assoc	= "\x00\x00\x43\x21\x00\x00\x00\x07"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.alen	= 16,
 		.input	= "\x45\x00\x00\x30\xda\x3a\x00\x00"
 			  "\x80\x01\xdf\x3b\xc0\xa8\x00\x05"
 			  "\xc0\xa8\x00\x01\x08\x00\xc6\xcd"
