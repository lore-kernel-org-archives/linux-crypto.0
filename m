Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969F9C38A2D
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 00:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiJZAOf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiJZAOa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 20:14:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC13F026
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 17:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666743268; x=1698279268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RLeRy02UDLbgH5ueJOC13SZ9/4/BYgI+G6G0HsM/qIM=;
  b=HO62yPYfR7pS2lQvEqsBYkun4WJEdJegFLdYUB/H0P9CRDt1tjuHZu1L
   PPcv1Vx03gcD4i9lOcRXTcMde8yY2mCVqtuvJHkeYPgE5odK8SLyVPzE4
   Vj2Iiohp6Tp8+2aH4NkrakxH2HwG52C4Sx+fNKnbNsg17QwPNYHaDpdQw
   M7BpwuoaHX2w4zkXwXEXjbOZzOqylVLArvuxfEdpkBF+3P6JefXhfXwSt
   0JOluU+1cUdLDKKOiRjWBsF+y287MifISivBKBQrSL2kU4S6mH4X3YJA9
   uhPoEyQk5Q4si1GFXY2VSIL4C6VSrYCsRJ/Dpyx80Q1jkFWqhYyr0LK0n
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="288219049"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="288219049"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="662999557"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="662999557"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2022 17:14:24 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH 4/4] crypto: tcrypt - Drop leading newlines from prints
Date:   Tue, 25 Oct 2022 17:15:21 -0700
Message-Id: <20221026001521.4222-5-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
References: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
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
 crypto/tcrypt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 35868d5..8339838 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -335,7 +335,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					  crypto_req_done, &data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	i = 0;
@@ -586,7 +586,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	}
 
 	crypto_init_wait(&wait);
-	pr_info("\ntesting speed of %s (%s) %s\n", algo,
+	pr_info("testing speed of %s (%s) %s\n", algo,
 		get_driver_name(crypto_aead, tfm), e);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
@@ -888,7 +888,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of async %s (%s)\n", algo,
+	pr_info("testing speed of async %s (%s)\n", algo,
 		get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
@@ -1128,7 +1128,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 		crypto_init_wait(&data[i].wait);
 	}
 
-	pr_info("\ntesting speed of multibuffer %s (%s) %s\n", algo,
+	pr_info("testing speed of multibuffer %s (%s) %s\n", algo,
 		get_driver_name(crypto_skcipher, tfm), e);
 
 	i = 0;
@@ -1335,7 +1335,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 		return;
 	}
 
-	pr_info("\ntesting speed of %s %s (%s) %s\n", async ? "async" : "sync",
+	pr_info("testing speed of %s %s (%s) %s\n", async ? "async" : "sync",
 		algo, get_driver_name(crypto_skcipher, tfm), e);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-- 
2.37.2

