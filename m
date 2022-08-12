Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2983BC282E7
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Aug 2022 14:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiHLOQq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Aug 2022 10:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbiHLOQX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Aug 2022 10:16:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F387697B
        for <linux-crypto@vger.kernel.org>; Fri, 12 Aug 2022 07:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660313782; x=1691849782;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ll0tucs6GTmwW6IXKFv5XRG5pDUiX7dLKYD4OvDfnT8=;
  b=b9OtLUfMUDGj2snQUK0EI9c0Uj4TLARJC/YgG9gbYbQwWcbjqMfNgZcU
   hOAUirddaIcFiVFz8dtOX3kvUURB9ccYoFwSTpAFcZ/uWQmTg2vSsjqOF
   uuj2slowg46OBu3Q9UOlL3Kkc0Hi0N7MBzt9OuSrA8KaHVUR5jKp6S5fe
   K7w/K++7qmC5sYeJKWQy3GzNyBNb4TAWoLBkb7xNx2UpFwOXRwQJ9lGHc
   v3MatOMxy5FKh0nrizbClFIF89SYf1XuHnJ6AwSH1OFpG0K5y3PqsN2X7
   D2AXoWXL/ITOXYx22OCMCLV5wKA9vHJvm033lsOceXdmc8OKIPf8TnSA9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="292867748"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="292867748"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 07:16:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="748206689"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by fmsmga001.fm.intel.com with ESMTP; 12 Aug 2022 07:16:20 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: testmgr - extend acomp tests for NULL destination buffer
Date:   Fri, 12 Aug 2022 16:16:02 +0200
Message-Id: <20220812141602.5571-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Acomp API supports NULL destination buffer for compression
and decompression requests. In such cases allocation is
performed by API.

Add test cases for crypto_acomp_compress() and crypto_acomp_decompress()
with dst buffer allocated by API.

Tests will only run if CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/testmgr.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5349ffee6bbd..bf905c1e89ed 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3417,6 +3417,21 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+		crypto_init_wait(&wait);
+		sg_init_one(&src, input_vec, ilen);
+		acomp_request_set_params(req, &src, NULL, ilen, 0);
+
+		ret = crypto_wait_req(crypto_acomp_compress(req), &wait);
+		if (ret) {
+			pr_err("alg: acomp: compression failed on NULL dst buffer test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
+		}
+#endif
+
 		kfree(input_vec);
 		acomp_request_free(req);
 	}
@@ -3478,6 +3493,20 @@ static int test_acomp(struct crypto_acomp *tfm,
 			goto out;
 		}
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+		crypto_init_wait(&wait);
+		acomp_request_set_params(req, &src, NULL, ilen, 0);
+
+		ret = crypto_wait_req(crypto_acomp_decompress(req), &wait);
+		if (ret) {
+			pr_err("alg: acomp: decompression failed on NULL dst buffer test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
+			kfree(input_vec);
+			acomp_request_free(req);
+			goto out;
+		}
+#endif
+
 		kfree(input_vec);
 		acomp_request_free(req);
 	}
-- 
2.37.1

