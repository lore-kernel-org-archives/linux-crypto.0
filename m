Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBF7C38A02
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 00:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiJZAOf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiJZAOd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 20:14:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD5FF02D
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 17:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666743268; x=1698279268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D+yRZVtW6YlSiGP4TdyUqsJIv3Knp4JMfbOpdmcIFiQ=;
  b=LkIZYRC8gcSs3zsAExsSCUzHs7b7en4HjeVy2mAG7gZ1Y9rwTYOHr1SI
   JNSWqz/20d2HpAEjkHnqewlKwy5D6OLWcE99DVDmy2nUcciktbCKsz3mh
   7wLQxc8nTsXYDvt0RGgEaucE5BHtiQaXQwGZZCo1m4rQ0wsW+Lm6gcGrR
   JbbS/e4adHVdz3O6yTeS4nEuTad6HSRpVYs249TFNOA6qyzhoNx8SORtF
   q7fjD2kOjyGfW8lkO7LqwyycYyZIj3obkuidgaeDuNs3lvMARKyLakUEN
   LNopAKJK8JcW/MTfuYugEcXmaz6c6FSCBo1SsfzV1MSYIFCG3gD6DdfWQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="288219047"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="288219047"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:14:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="662999554"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="662999554"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2022 17:14:24 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH 3/4] crypto: tcrypt - Drop module name from print string
Date:   Tue, 25 Oct 2022 17:15:20 -0700
Message-Id: <20221026001521.4222-4-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
References: <20221026001521.4222-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pr_fmt() define includes KBUILD_MODNAME, and so there's no need
for pr_err() to also print it. Drop module name from the print string.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 crypto/tcrypt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 511e9b4..35868d5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1340,8 +1340,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
-		       algo);
+		pr_err("skcipher: Failed to allocate request for %s\n", algo);
 		goto out;
 	}
 
-- 
2.37.2

