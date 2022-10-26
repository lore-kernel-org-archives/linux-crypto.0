Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FDFC38A02
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 00:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiJZAOd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiJZAO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 20:14:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995BFF2D
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 17:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666743265; x=1698279265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7QOcXyFI25tk084ulLxRXK57dBECC5/cQhOv6yoHQg=;
  b=NzCuly3sA7RXWQwO1Mqi08/S4g0O+EQHCVs/tc6Ypq8akkefuhl2rWNg
   Vew9KhpxTz2HDGREOegr4MZYSNnx4l/ePdb9ZhcRiiKHkiK5jf9Oddvpd
   NvmfFezgXSmY/nxaMGTozn4dwHIkD7C8CpMMW0qbsCnjA73fm3IDfyta9
   38tL0kATykB8U4i2dOBBbD/b2J5eQYKea4ioGfJ2kQp4+EHx8ihsVtpQN
   1VWUi/XLaMHg3KQFY/Ap6ubWb1bFJcJOhiWXuHBotSEzzT1T+Vl5K97bE
   0G6K0kisG0ll2RDOkaiXyQHS+kk22me389zPqsYDK6slFUOuM36sXVgMT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="288219045"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="288219045"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="662999551"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="662999551"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2022 17:14:24 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH 2/4] crypto: tcrypt - Use pr_info/pr_err
Date:   Tue, 25 Oct 2022 17:15:19 -0700
Message-Id: <20221026001521.4222-3-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
References: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, there's mixed use of printk() and pr_info()/pr_err(). The latter
prints the module name (because pr_fmt() is defined so) but the former does
not. As a result there's inconsistency in the printed output. For example:

modprobe mode=211:

[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)
[...] test 1 (160 bit key, 64 byte blocks): 1 operation in 2336 cycles (64 bytes)

modprobe mode=215:

[...] tcrypt: test 0 (160 bit key, 16 byte blocks): 1 operation in 2173 cycles (16 bytes)
[...] tcrypt: test 1 (160 bit key, 64 byte blocks): 1 operation in 2241 cycles (64 bytes)

Replace all instances of printk() with pr_info()/pr_err() so that the
module name is printed consistently.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 crypto/tcrypt.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7c84206..511e9b4 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -586,8 +586,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
-			get_driver_name(crypto_aead, tfm), e);
+	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -635,8 +635,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				memset(iv, 0xff, iv_len);
 
 			crypto_aead_clear_flags(tfm, ~0);
-			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
-					i, *keysize * 8, bs);
+			pr_info("test %u (%d bit key, %d byte blocks): ",
+				i, *keysize * 8, bs);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -888,8 +888,8 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	printk(KERN_INFO "\ntesting speed of async %s (%s)\n", algo,
-			get_driver_name(crypto_ahash, tfm));
+	pr_info("\ntesting speed of async %s (%s)\n", algo,
+		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
 		pr_err("digestsize(%u) > %d\n", crypto_ahash_digestsize(tfm),
@@ -1459,9 +1459,8 @@ static void test_available(void)
 	const char **name = check;
 
 	while (*name) {
-		printk("alg %s ", *name);
-		printk(crypto_has_alg(*name, 0, 0) ?
-		       "found\n" : "not found\n");
+		pr_info("alg %s %s\n", *name,
+			(crypto_has_alg(*name, 0, 0) ? "found" : "not found"));
 		name++;
 	}
 }
@@ -2882,7 +2881,7 @@ static int __init tcrypt_mod_init(void)
 	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
-		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
+		pr_err("one or more tests failed!\n");
 		goto err_free_tv;
 	} else {
 		pr_debug("all tests passed\n");
-- 
2.37.2

