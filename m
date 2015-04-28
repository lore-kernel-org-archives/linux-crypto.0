From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] crypto: Wrap the LHS in expressions of the form !x == y
Date: Tue, 28 Apr 2015 15:36:36 +0100
Message-ID: <20150428143636.7186.60019.stgit@warthog.procyon.org.uk>
References: <20150428143630.7186.86312.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030807AbbD1Ogm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2015 10:36:42 -0400
In-Reply-To: <20150428143630.7186.86312.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In the test manager, there are a number of if-statements with expressions of
the form !x == y that incur warnings with gcc-5 of the following form:

../crypto/testmgr.c: In function '__test_aead':
../crypto/testmgr.c:523:12: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
   if (!ret == template[i].fail) {
            ^

By converting the 'fail' member of struct aead_testvec and struct
cipher_testvec to a bool, we can get rid of the warnings.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/testmgr.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 1f5a31f23a59..1cd62a73f0f5 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -54,7 +54,7 @@ struct cipher_testvec {
 	unsigned short tap[MAX_TAP];
 	int np;
 	unsigned char also_non_np;
-	unsigned char fail;
+	bool fail;
 	unsigned char wk; /* weak key flag */
 	unsigned char klen;
 	unsigned short ilen;
@@ -71,7 +71,7 @@ struct aead_testvec {
 	unsigned char atap[MAX_TAP];
 	int np;
 	int anp;
-	unsigned char fail;
+	bool fail;
 	unsigned char novrfy;	/* ccm dec verification failure expected */
 	unsigned char wk; /* weak key flag */
 	unsigned char klen;
@@ -3018,7 +3018,7 @@ static struct cipher_testvec des_enc_tv_template[] = {
 			  "\xb4\x99\x26\xf7\x1f\xe1\xd4\x90",
 		.rlen	= 24,
 	}, { /* Weak key */
-		.fail	= 1,
+		.fail	= true,
 		.wk	= 1,
 		.key	= "\x01\x01\x01\x01\x01\x01\x01\x01",
 		.klen	= 8,
