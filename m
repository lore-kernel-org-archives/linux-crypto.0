Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894DFC433E6
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 14:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D94964E2B
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 14:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhBXODQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 09:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbhBXNIk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D06D64F96;
        Wed, 24 Feb 2021 12:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171291;
        bh=0RFYgfXxVTQ5sYXpGbQ79U+wh2waQAJCNQz/uDfVLAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YzfMpRRlTksVHQsgStecHYKwpJ5u3pxKoweuUY7MS7xgiKAdV7b81XhMM0c9eWh3t
         WvrsxDMm16wOHrfK7vlZi/lr7s8Ajln45DIYX+nd8LvG6boOrHND6Kfsrqom/CH2HT
         TCV88dQt5mq9HvYEVlvLzU8kIzfeNZNmCvTdLy3dkqoYjroaK5QLoGwggmP+/DJdRn
         X6YOb2d/Y+ugvzvgXOKjddxV6vLADrwTsNsdZVs4Ctsp4vg7sitTCrcc8pUJIQi3YC
         sJgs3dzMD7S34L4mqsRff7spAs85X0ZthZmZtPpYvc9Q2ev4q5MA2/m3RkZZ3/ziCc
         oC06EK+Dy75jQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/26] crypto: tcrypt - avoid signed overflow in byte count
Date:   Wed, 24 Feb 2021 07:54:20 -0500
Message-Id: <20210224125435.483539-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 303fd3e1c771077e32e96e5788817f025f0067e2 ]

The signed long type used for printing the number of bytes processed in
tcrypt benchmarks limits the range to -/+ 2 GiB, which is not sufficient
to cover the performance of common accelerated ciphers such as AES-NI
when benchmarked with sec=1. So switch to u64 instead.

While at it, fix up a missing printk->pr_cont conversion in the AEAD
benchmark.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tcrypt.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d332988eb8dea..bf797c613ba2d 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -202,8 +202,8 @@ static int test_mb_aead_jiffies(struct test_mb_aead_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -472,8 +472,8 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 			return ret;
 	}
 
-	printk("%d operations in %d seconds (%ld bytes)\n",
-	       bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+	        bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
@@ -763,8 +763,8 @@ static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1200,8 +1200,8 @@ static int test_mb_acipher_jiffies(struct test_mb_skcipher_data *data, int enc,
 			goto out;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount * num_mb, secs, (long)bcount * blen * num_mb);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount * num_mb, secs, (u64)bcount * blen * num_mb);
 
 out:
 	kfree(rc);
@@ -1438,8 +1438,8 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 			return ret;
 	}
 
-	pr_cont("%d operations in %d seconds (%ld bytes)\n",
-		bcount, secs, (long)bcount * blen);
+	pr_cont("%d operations in %d seconds (%llu bytes)\n",
+		bcount, secs, (u64)bcount * blen);
 	return 0;
 }
 
-- 
2.27.0

