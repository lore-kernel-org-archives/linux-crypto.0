From: Denis Cheng <crquan@gmail.com>
Subject: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h instead
Date: Tue, 27 Nov 2007 10:47:12 +0800
Message-ID: <1196131632-7285-1-git-send-email-crquan@gmail.com>
References: <20071126143939.GB28022@gondor.apana.org.au>
	<1196098095-8995-1-git-send-email-crquan@gmail.com>
	<1196100104.31590.11.camel@localhost>
	<20071127013540.GA793@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, dengxw@163.com,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Joe Perches <joe@perches.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ro-out-1112.google.com ([72.14.202.179]:3477 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXK0Cp3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 21:45:29 -0500
Received: by ro-out-1112.google.com with SMTP id p4so1389663roc
        for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 18:45:28 -0800 (PST)
In-Reply-To: <20071127013540.GA793@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
this is against the lastest cryptodev tree.

 crypto/tcrypt.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1e12b86..ae762c2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -87,12 +87,11 @@ static char *check[] = {
 	"camellia", "seed", "salsa20", NULL
 };
 
-static void hexdump(unsigned char *buf, unsigned int len)
+static inline void hexdump(unsigned char *buf, unsigned int len)
 {
-	while (len--)
-		printk("%02x", *buf++);
-
-	printk("\n");
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
+			16, 1,
+			buf, len, 0);
 }
 
 static void tcrypt_complete(struct crypto_async_request *req, int err)
-- 
1.5.3.5
