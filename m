Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21889C38A2D
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 19:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiJZTPx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbiJZTPk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 15:15:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79A915FDD
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 12:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666811738; x=1698347738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rIy1pm1E3UTsh2lHEs2DoJFDIsysiXeoPioWwBYIRDg=;
  b=cyj8ZSdEwv4prF589lQUMCdtP5GzI0Gf1dSAOqMndDrh0rsaNLIcjCiO
   pqjvI93y4qxWFoAeTD2hWmZMDsfFQOMhoGl+7SDBLr17a30+MeiP71lBX
   wCzH008pKL068HfZF/0GLaiYT9QwVKUdu7KswRy7ht5VwrWYbqk4McXOs
   k2aKbUvo56okp3Wzq2Qs2YJIA2xRkfGBsErTuSTfAFBmyuNRgEL8bxXGC
   WdD4nTfHWdl3Ay4t+lISRFDD1GhWi9/Y6o/916x71Ea28vk/QIO6Q2PNc
   qo/n75avjo/iOqKBZCJ+qrtEjTRs827JIM/ND4z/WnsS07dfzi4YKDWW0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="334662185"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="334662185"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 12:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="757430826"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="757430826"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2022 12:15:18 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Robert Elliott <elliott@hpe.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 1/4] crypto: tcrypt - Use pr_cont to print test results
Date:   Wed, 26 Oct 2022 12:16:13 -0700
Message-Id: <20221026191616.9169-2-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
References: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For some test cases, a line break gets inserted between the test banner
and the results. For example, with mode=211 this is the output:

[...]
      testing speed of rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] test 0 (160 bit key, 16 byte blocks):
[...] 1 operation in 2373 cycles (16 bytes)

--snip--

[...]
      testing speed of gcm(aes) (generic-gcm-aesni) encryption
[...] test 0 (128 bit key, 16 byte blocks):
[...] 1 operation in 2338 cycles (16 bytes)

Similar behavior is seen in the following cases as well:

  modprobe tcrypt mode=212
  modprobe tcrypt mode=213
  modprobe tcrypt mode=221
  modprobe tcrypt mode=300 sec=1
  modprobe tcrypt mode=400 sec=1

This doesn't happen with mode=215:

[...] tcrypt:
              testing speed of multibuffer rfc4106(gcm(aes)) (rfc4106-gcm-aesni) encryption
[...] tcrypt: test 0 (160 bit key, 16 byte blocks): 1 operation in 2215 cycles (16 bytes)

--snip--

[...] tcrypt:
              testing speed of multibuffer gcm(aes) (generic-gcm-aesni) encryption
[...] tcrypt: test 0 (128 bit key, 16 byte blocks): 1 operation in 2191 cycles (16 bytes)

This print inconsistency is because printk() is used instead of pr_cont()
in a few places. Change these to be pr_cont().

checkpatch warns that pr_cont() shouldn't be used. This can be ignored in
this context as tcrypt already uses pr_cont().

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
Changes v1 -> v2: Rebase to tag v6.1-p2
---
 crypto/tcrypt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a82679b..6aed45c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -506,8 +506,8 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 
 out:
 	if (ret == 0)
-		printk("1 operation in %lu cycles (%d bytes)\n",
-		       (cycles + 4) / 8, blen);
+		pr_cont("1 operation in %lu cycles (%d bytes)\n",
+			(cycles + 4) / 8, blen);
 
 	return ret;
 }
@@ -727,8 +727,8 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 			return ret;
 	}
 
-	printk("%6u opers/sec, %9lu bytes/sec\n",
-	       bcount / secs, ((long)bcount * blen) / secs);
+	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
+		bcount / secs, ((long)bcount * blen) / secs);
 
 	return 0;
 }
-- 
2.37.2

