Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9323FECDFA1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 19:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiJZTP5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiJZTPn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 15:15:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8FA60CB
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 12:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666811743; x=1698347743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bhkap2igs6sTW14iN9WOb9LJ/lQI/UrGD8kgMMJInos=;
  b=Uo90X4ibA/D1O7tu8F2Zq7fn7pQXqxyCtjFCbfLUijOS6iKgCsB/p97a
   7uaOeA+kynSQaw/BQs6FvpE6ehNmE3TWOowgJr9IJTToJrmc4yLIdTpqc
   TDU3A+p4Q9ryI94OyW4gOKRxF/0AiZevmXoIYgl0RZ9oEa1t9oebnPLNV
   CqYHzcLRTKSHQTtOpnq4JCP0Ot8ZPgK+WCWLh+N1nuDHKcppv3gnUwzPJ
   8cyStRJhArsuxec3XWuro/uas4OsJlyRVlsL1RA4jclQJMePZ0jXgn/3Z
   zoE2ZEUjEvyk+6ZIxRkdoedzV/kUb0FIgmuuB5sqZZyNvwKkwenuT39Gd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="334662188"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="334662188"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 12:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="757430841"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="757430841"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2022 12:15:19 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Robert Elliott <elliott@hpe.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 4/4] crypto: tcrypt - Drop leading newlines from prints
Date:   Wed, 26 Oct 2022 12:16:16 -0700
Message-Id: <20221026191616.9169-5-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
References: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The top level print banners have a leading newline. It's not entirely
clear why this exists, but it makes it harder to parse tcrypt test output
using a script. Drop said newlines.

tcrypt output before this patch:

[...]
      testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)

tcrypt output with this patch:

[...] testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks): 1 operation in 2320 cycles (16 bytes)

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
Changes v1 -> v2: Rebase to tag v6.1-p2
---
 crypto/tcrypt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2878d0e..af3ea95 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -324,7 +324,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					  crypto_req_done, &data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	i = 0;
@@ -575,7 +575,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+	pr_info("testing speed of %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
@@ -877,7 +877,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s)\n", algo,
+	pr_info("testing speed of async %s (%s)\n", algo,
 		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
@@ -1117,7 +1117,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 		crypto_init_wait(&data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_skcipher, tfm), e);
 
 	i = 0;
@@ -1324,7 +1324,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+	pr_info("testing speed of %s %s (%s) %s\n", async ? "async" : "sync",
 		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-- 
2.37.2

