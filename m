Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3ADAFA3740
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 00:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiJZAOe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiJZAO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 20:14:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F7AF0A
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 17:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666743265; x=1698279265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CwqlATylNXQ/41W/TI6pwG8wa/tqCwk66PnLDF3n8jc=;
  b=ViiLVItqgycop5bWxbHEEyk3L2Os/x0lwun6vj/WgVS27hc/TAyQ/ZGS
   sRwmYQu/s5LtEVUIoZpI8j6veIcpEPI9BFLL6/pIMYUXOd4A8KyW0Dcou
   qfTwqzWXRUCoxYqvTbiiteGaCq5xy/C5rKZa8MCuWfjheipUAiIpt3AEY
   YlfbXfeu/ElDZxVKt0J/CiWkKDMPqpcg8MqocT2PwrIGs7LZaVOedttPN
   dqdeIs71h20dTu3/zVY0RO9ZgawSVOqhLDK7WSO3ROQHmuM+W4hhmdZX+
   JqB1dLafWgs5c0QrM5Olduaqg2lNway1p8ibOWDbaVJonhU9ItoeXIjbu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="288219043"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="288219043"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="662999547"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="662999547"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2022 17:14:23 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH 1/4] crypto: tcrypt - Use pr_cont to print test results
Date:   Tue, 25 Oct 2022 17:15:18 -0700
Message-Id: <20221026001521.4222-2-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
References: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
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
 crypto/tcrypt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 59eb8ec..7c84206 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -517,8 +517,8 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 
 out:
 	if (ret == 0)
-		printk("1 operation in %lu cycles (%d bytes)\n",
-		       (cycles + 4) / 8, blen);
+		pr_cont("1 operation in %lu cycles (%d bytes)\n",
+			(cycles + 4) / 8, blen);
 
 	return ret;
 }
@@ -738,8 +738,8 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
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

