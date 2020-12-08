Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8821EC4361B
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 14:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 586E223A6A
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Dec 2020 14:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgLHOfk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:35:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgLHOfk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Dec 2020 09:35:40 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: tcrypt - avoid signed overflow in byte count
Date:   Tue,  8 Dec 2020 15:34:41 +0100
Message-Id: <20201208143441.2796-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The signed long type used for printing the number of bytes processed in
tcrypt benchmarks limits the range to -/+ 2 GiB, which is not sufficient
to cover the performance of common accelerated ciphers such as AES-NI
when benchmarked with sec=1. So switch to u64 instead.

While at it, fix up a missing printk->pr_cont conversion in the AEAD
benchmark.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/tcrypt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a647bb298fbc..a4a11d2b57bd 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -199,8 +199,8 @@ static int test_mb_aead_jiffies(struct test_mb_aead_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -471,8 +471,8 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 			return ret;
 	}
 
-	printk("%d operations in %d seconds (%ld bytes)\n",
-	       bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+	        bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
@@ -764,8 +764,8 @@ static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1201,8 +1201,8 @@ static int test_mb_acipher_jiffies(struct test_mb_skcipher_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1441,8 +1441,8 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 			return ret;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
-- 
2.17.1

