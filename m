Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8086C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 19:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiJZTP4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiJZTPn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 15:15:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B09220F4B
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 12:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666811740; x=1698347740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RITt5TGcuKkow+MO1NXZ10BR1D+1ocjCoXNF0jm33sM=;
  b=Oa4EnT+EdQScGFP5/I3PVVNsa8a2MZL05//mmaI3KMf8A7dtiNOAixmI
   CjM4QCbAdXPsi8Z02GojYYjf1i/P9syIYTtWsqf/GbiaNSuMWQSESdMTU
   miIjgRJ5qM6501dqlbSvsIsjXPcoZz33yDU30blfG9P8Jd/zHm6nuAvhD
   vxJj0ZYnEicrVjXtgT0HRII+OvA7wKhQ13DvjIJm1aek81JKp3bOxndGq
   Y6MPU3mtNUdnGkB7t1NeB4Xnr8MlsGBy+oXTnbJSMJ5yIrxgDf5Cf7XtA
   4/qh8xu/T8D4ylCaXb8k2KK7Z3ZapTZTOHqSKLTS/vmeJoLlNuGFQtspo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="334662187"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="334662187"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 12:15:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="757430836"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="757430836"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by orsmga004.jf.intel.com with ESMTP; 26 Oct 2022 12:15:19 -0700
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Robert Elliott <elliott@hpe.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 3/4] crypto: tcrypt - Drop module name from print string
Date:   Wed, 26 Oct 2022 12:16:15 -0700
Message-Id: <20221026191616.9169-4-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
References: <20221026191616.9169-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pr_fmt() define includes KBUILD_MODNAME, and so there's no need
for pr_err() to also print it. Drop module name from the print string.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
Changes v1 -> v2: Rebase to tag v6.1-p2
---
 crypto/tcrypt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d380ff8..2878d0e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1329,8 +1329,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
-		       algo);
+		pr_err("skcipher: Failed to allocate request for %s\n", algo);
 		goto out;
 	}
 
-- 
2.37.2

