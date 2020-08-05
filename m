Return-Path: <SRS0=mrTw=BP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9146C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 05:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9143E20842
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Aug 2020 05:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgHEF5L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Aug 2020 01:57:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57636 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHEF5L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Aug 2020 01:57:11 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k3CQG-0005ap-6c; Wed, 05 Aug 2020 15:57:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Aug 2020 15:57:08 +1000
Date:   Wed, 5 Aug 2020 15:57:08 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] tcrypt: Add support for hash speed testing with keys
Message-ID: <20200805055707.GA2630@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently if you speed test a hash that requires a key you'll get an
error because tcrypt does not set a key by default.  This patch
allows a key to be set using the new module parameter klen.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ba0b7702f2e9..174d0911f80a 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -63,6 +63,7 @@ static u32 type;
 static u32 mask;
 static int mode;
 static u32 num_mb = 8;
+static unsigned int klen;
 static char *tvmem[TVMEMSIZE];
 
 static const char *check[] = {
@@ -864,8 +865,8 @@ static void test_mb_ahash_speed(const char *algo, unsigned int secs,
 			goto out;
 		}
 
-		if (speed[i].klen)
-			crypto_ahash_setkey(tfm, tvmem[0], speed[i].klen);
+		if (klen)
+			crypto_ahash_setkey(tfm, tvmem[0], klen);
 
 		for (k = 0; k < num_mb; k++)
 			ahash_request_set_crypt(data[k].req, data[k].sg,
@@ -1099,8 +1100,8 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 			break;
 		}
 
-		if (speed[i].klen)
-			crypto_ahash_setkey(tfm, tvmem[0], speed[i].klen);
+		if (klen)
+			crypto_ahash_setkey(tfm, tvmem[0], klen);
 
 		pr_info("test%3u "
 			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
@@ -2418,7 +2419,8 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		if (mode > 300 && mode < 400) break;
 		/* fall through */
 	case 318:
-		test_hash_speed("ghash-generic", sec, hash_speed_template_16);
+		klen = 16;
+		test_hash_speed("ghash", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		/* fall through */
 	case 319:
@@ -3076,6 +3078,8 @@ MODULE_PARM_DESC(sec, "Length in seconds of speed tests "
 		      "(defaults to zero which uses CPU cycles instead)");
 module_param(num_mb, uint, 0000);
 MODULE_PARM_DESC(num_mb, "Number of concurrent requests to be used in mb speed tests (defaults to 8)");
+module_param(klen, uint, 0);
+MODULE_PARM_DESC(klen, "Key length (defaults to 0)");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Quick & dirty crypto testing module");
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 7e5fea811670..9f654677172a 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -25,7 +25,6 @@ struct aead_speed_template {
 struct hash_speed {
 	unsigned int blen;	/* buffer length */
 	unsigned int plen;	/* per-update length */
-	unsigned int klen;	/* key length */
 };
 
 /*
@@ -97,34 +96,6 @@ static struct hash_speed generic_hash_speed_template[] = {
 	{  .blen = 0,	.plen = 0, }
 };
 
-static struct hash_speed hash_speed_template_16[] = {
-	{ .blen = 16,	.plen = 16,	.klen = 16, },
-	{ .blen = 64,	.plen = 16,	.klen = 16, },
-	{ .blen = 64,	.plen = 64,	.klen = 16, },
-	{ .blen = 256,	.plen = 16,	.klen = 16, },
-	{ .blen = 256,	.plen = 64,	.klen = 16, },
-	{ .blen = 256,	.plen = 256,	.klen = 16, },
-	{ .blen = 1024,	.plen = 16,	.klen = 16, },
-	{ .blen = 1024,	.plen = 256,	.klen = 16, },
-	{ .blen = 1024,	.plen = 1024,	.klen = 16, },
-	{ .blen = 2048,	.plen = 16,	.klen = 16, },
-	{ .blen = 2048,	.plen = 256,	.klen = 16, },
-	{ .blen = 2048,	.plen = 1024,	.klen = 16, },
-	{ .blen = 2048,	.plen = 2048,	.klen = 16, },
-	{ .blen = 4096,	.plen = 16,	.klen = 16, },
-	{ .blen = 4096,	.plen = 256,	.klen = 16, },
-	{ .blen = 4096,	.plen = 1024,	.klen = 16, },
-	{ .blen = 4096,	.plen = 4096,	.klen = 16, },
-	{ .blen = 8192,	.plen = 16,	.klen = 16, },
-	{ .blen = 8192,	.plen = 256,	.klen = 16, },
-	{ .blen = 8192,	.plen = 1024,	.klen = 16, },
-	{ .blen = 8192,	.plen = 4096,	.klen = 16, },
-	{ .blen = 8192,	.plen = 8192,	.klen = 16, },
-
-	/* End marker */
-	{  .blen = 0,	.plen = 0,	.klen = 0, }
-};
-
 static struct hash_speed poly1305_speed_template[] = {
 	{ .blen = 96,	.plen = 16, },
 	{ .blen = 96,	.plen = 32, },
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
