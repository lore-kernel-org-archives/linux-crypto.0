From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] Added one larger ghash testvector (400 bytes) to the testmgr.
Date: Thu, 21 May 2015 17:34:31 +0200
Message-ID: <1432222471-10966-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51728 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbbEUPet (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 11:34:49 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
	Thu, 21 May 2015 16:34:48 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5C49117D8062
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 16:35:37 +0100 (BST)
Received: from d06av12.portsmouth.uk.ibm.com (d06av12.portsmouth.uk.ibm.com [9.149.37.247])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4LFYiNg64159798
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 15:34:44 GMT
Received: from d06av12.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av12.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4LFYhqK018358
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 09:34:44 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 crypto/testmgr.h |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 90f43b9..6003143 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -1822,7 +1822,7 @@ static struct hash_testvec tgr128_tv_template[] = {
 	},
 };
 
-#define GHASH_TEST_VECTORS 5
+#define GHASH_TEST_VECTORS 6
 
 static struct hash_testvec ghash_tv_template[] =
 {
@@ -1875,6 +1875,63 @@ static struct hash_testvec ghash_tv_template[] =
 		.psize	= 20,
 		.digest	= "\xf8\x94\x87\x2a\x4b\x63\x99\x28"
 			  "\x23\xf7\x93\xf7\x19\xf5\x96\xd9",
+	}, {
+		.key	= "\x0a\x1b\x2c\x3d\x4e\x5f\x64\x71"
+			"\x82\x93\xa4\xb5\xc6\xd7\xe8\xf9",
+		.ksize	= 16,
+		.plaintext = "\x56\x6f\x72\x20\x6c\x61\x75\x74"
+			"\x65\x72\x20\x4c\x61\x75\x73\x63"
+			"\x68\x65\x6e\x20\x75\x6e\x64\x20"
+			"\x53\x74\x61\x75\x6e\x65\x6e\x20"
+			"\x73\x65\x69\x20\x73\x74\x69\x6c"
+			"\x6c\x2c\x0a\x64\x75\x20\x6d\x65"
+			"\x69\x6e\x20\x74\x69\x65\x66\x74"
+			"\x69\x65\x66\x65\x73\x20\x4c\x65"
+			"\x62\x65\x6e\x3b\x0a\x64\x61\x73"
+			"\x73\x20\x64\x75\x20\x77\x65\x69"
+			"\xc3\x9f\x74\x20\x77\x61\x73\x20"
+			"\x64\x65\x72\x20\x57\x69\x6e\x64"
+			"\x20\x64\x69\x72\x20\x77\x69\x6c"
+			"\x6c\x2c\x0a\x65\x68\x20\x6e\x6f"
+			"\x63\x68\x20\x64\x69\x65\x20\x42"
+			"\x69\x72\x6b\x65\x6e\x20\x62\x65"
+			"\x62\x65\x6e\x2e\x0a\x0a\x55\x6e"
+			"\x64\x20\x77\x65\x6e\x6e\x20\x64"
+			"\x69\x72\x20\x65\x69\x6e\x6d\x61"
+			"\x6c\x20\x64\x61\x73\x20\x53\x63"
+			"\x68\x77\x65\x69\x67\x65\x6e\x20"
+			"\x73\x70\x72\x61\x63\x68\x2c\x0a"
+			"\x6c\x61\x73\x73\x20\x64\x65\x69"
+			"\x6e\x65\x20\x53\x69\x6e\x6e\x65"
+			"\x20\x62\x65\x73\x69\x65\x67\x65"
+			"\x6e\x2e\x0a\x4a\x65\x64\x65\x6d"
+			"\x20\x48\x61\x75\x63\x68\x65\x20"
+			"\x67\x69\x62\x74\x20\x64\x69\x63"
+			"\x68\x2c\x20\x67\x69\x62\x20\x6e"
+			"\x61\x63\x68\x2c\x0a\x65\x72\x20"
+			"\x77\x69\x72\x64\x20\x64\x69\x63"
+			"\x68\x20\x6c\x69\x65\x62\x65\x6e"
+			"\x20\x75\x6e\x64\x20\x77\x69\x65"
+			"\x67\x65\x6e\x2e\x0a\x0a\x55\x6e"
+			"\x64\x20\x64\x61\x6e\x6e\x20\x6d"
+			"\x65\x69\x6e\x65\x20\x53\x65\x65"
+			"\x6c\x65\x20\x73\x65\x69\x74\x20"
+			"\x77\x65\x69\x74\x2c\x20\x73\x65"
+			"\x69\x20\x77\x65\x69\x74\x2c\x0a"
+			"\x64\x61\x73\x73\x20\x64\x69\x72"
+			"\x20\x64\x61\x73\x20\x4c\x65\x62"
+			"\x65\x6e\x20\x67\x65\x6c\x69\x6e"
+			"\x67\x65\x2c\x0a\x62\x72\x65\x69"
+			"\x74\x65\x20\x64\x69\x63\x68\x20"
+			"\x77\x69\x65\x20\x65\x69\x6e\x20"
+			"\x46\x65\x69\x65\x72\x6b\x6c\x65"
+			"\x69\x64\x0a\xc3\xbc\x62\x65\x72"
+			"\x20\x64\x69\x65\x20\x73\x69\x6e"
+			"\x6e\x65\x6e\x64\x65\x6e\x20\x44"
+			"\x69\x6e\x67\x65\x2e\x2e\x2e\x0a",
+		.psize	= 400,
+		.digest = "\xad\xb1\xc1\xe9\x56\x70\x31\x1d"
+			"\xbb\x5b\xdf\x5e\x70\x72\x1a\x57",
 	},
 };
 
-- 
1.7.9.5
