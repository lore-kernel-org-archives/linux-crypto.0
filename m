Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5CAC28D13
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 10:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiHYKZb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 06:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbiHYKZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 06:25:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A002357DD
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 03:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661423127; x=1692959127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7zGSHvlNM41JBCYeDym4xsEg5nLgykMpvRD7iFwPfLM=;
  b=JFe/WCUApXtce6rZTIP+Mtz8nooYSTtJ9dJt+pHhkSBou/8zO7ozFg3T
   /QAEgZvNnGJOj9T1CY6kqyx4wibmyX2V5I3Ef6o829H2fVIJrCd2QEeyE
   H4Iwd6EF/tB2pa+20iul41+89TlBYjFgLS44+yjNI99Rbfqjjw6221L+x
   29nMs/uNx9coMqutmMOVT1xf+fj83pqNlmkiOxYkTkQNv/ZtSdyTLJbNY
   84wSokqpPFAoHCW7Vf81OaefPQZP3MMOe2oixVhmxvu0Q3E1Xz2g3j8qR
   itAqPRSYxdBPnjO4buUExhn0u835NMbJzKrkhv9LcG7kduBE+ElaaW0j5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="380497104"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="380497104"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 03:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="606357192"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2022 03:25:25 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: testmgr - fix indentation for test_acomp() args
Date:   Thu, 25 Aug 2022 12:24:51 +0200
Message-Id: <20220825102451.4600-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set right indentation for test_acomp().

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 99020fa36b96..bb3850dc0991 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3322,7 +3322,7 @@ static int test_comp(struct crypto_comp *tfm,
 }
 
 static int test_acomp(struct crypto_acomp *tfm,
-			      const struct comp_testvec *ctemplate,
+		      const struct comp_testvec *ctemplate,
 		      const struct comp_testvec *dtemplate,
 		      int ctcount, int dtcount)
 {
-- 
2.37.1

