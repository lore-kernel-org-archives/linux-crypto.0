Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EDFFA373E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 19:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiJZTP6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbiJZTPn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 15:15:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EC74684D
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 12:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666811743; x=1698347743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mK1z+lgAAA6HzwL5SvTV3An8gucz7W/J956Gwuujhn8=;
  b=M+ANFQ24jjwB3+WZzTFrmpWGTrTyy1sB+zYnNgoyuSijf0TS1VLn+ZP1
   hUGIpf1cAhyXXU4pWhE46493Q6I0UqWuUfSdOpwdmi6d2VdiFylY5UKVL
   r57RqDfRQh7Esrf2Y4zZnzsXY1M1lZZRzzc0bgUVoQh+FhjX2ActGD6zC
   ZSN+j4PY6owVWvyzniaFp0iAEeAJGOWS/Pf5fxhl3DB2jEcWRiLEaQ/Z9
   lvgLi50QR6yR21JppsCtE/a3ijHqn2irRGwL59H7KV3dwU1cGubWyxSgi
   /bCNHGETBd4AtoLnsr1SNzZphPuFsGjI+rFU0EhKxgTmLSR69QEow1y65
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="334662186"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="334662186"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 12:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="757430831"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="757430831"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2022 12:15:19 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Robert Elliott <elliott@hpe.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 2/4] crypto: tcrypt - Use pr_info/pr_err
Date:   Wed, 26 Oct 2022 12:16:14 -0700
Message-Id: <20221026191616.9169-3-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
References: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
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
Changes v1 -> v2: Rebase to tag v6.1-p2, resolve conflicts
---
 crypto/tcrypt.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6aed45c..d380ff8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -575,8 +575,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
-			get_driver_name(crypto_aead, tfm), e);
+	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -624,8 +624,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 				memset(iv, 0xff, iv_len);
 
 			crypto_aead_clear_flags(tfm, ~0);
-			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
-					i, *keysize * 8, bs);
+			pr_info("test %u (%d bit key, %d byte blocks): ",
+				i, *keysize * 8, bs);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -877,8 +877,8 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	printk(KERN_INFO "\ntesting speed of async %s (%s)\n", algo,
-			get_driver_name(crypto_ahash, tfm));
+	pr_info("\ntesting speed of async %s (%s)\n", algo,
+		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
 		pr_err("digestsize(%u) > %d\n", crypto_ahash_digestsize(tfm),
@@ -2885,7 +2885,7 @@ static int __init tcrypt_mod_init(void)
 	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
-		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
+		pr_err("one or more tests failed!\n");
 		goto err_free_tv;
 	} else {
 		pr_debug("all tests passed\n");
-- 
2.37.2

