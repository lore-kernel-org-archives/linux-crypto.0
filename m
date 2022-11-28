Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C071C43217
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Nov 2022 12:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiK1MYY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Nov 2022 07:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiK1MXb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2022 07:23:31 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D9F37
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2022 04:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669638117; x=1701174117;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jtrjTLoFxeHXbBXIQ2xVpfJgMN0Z3onTRjpMjDRlHBU=;
  b=lVRfKVjtPA22QhkSX5nxQAOe07k09e4KooDfbiS5qNjsktn78tHcZEzP
   td6BNPd5qq547K2yXQ7q9EXCY3yJ42ndSZlV/BIVDdqN0k5Il55CFzoI7
   /oU8Ll/gHSVJUTu4ya2P5wexS25aUEn2Ao+pV99YmVavBo9n3zepvIN9G
   y5Dr2TNiJc90Wz//wGDifv/nQU4uHhmVR1ik1RSt7RDjqCtTX5vetDXRj
   VILKRVRhkQbsN0UQMkiuZ0cirEO5KBUHYS+nlorSKG1sUGLjfoq4OzN66
   JG6lw05AiHzpOb/T/iDKXQjKIDnM3rtFeWEhkej4K92xKUQ/33LbwnRgX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="313517855"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="313517855"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 04:21:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="817806190"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="817806190"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga005.jf.intel.com with ESMTP; 28 Nov 2022 04:21:54 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 11/12] crypto: acomp - define max size for destination
Date:   Mon, 28 Nov 2022 12:21:22 +0000
Message-Id: <20221128122123.130459-12-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221128122123.130459-1-giovanni.cabiddu@intel.com>
References: <20221128122123.130459-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The acomp API allows to send requests with a NULL destination buffer. In
this case, the algorithm implementation needs to allocate the
destination scatter list, perform the operation and return the buffer to
the user. For decompression, data is likely to expand and be bigger
than the allocated buffer.

Define the maximum size (128KB) that acomp implementations will allocate
for decompression operations as destination buffer when they receive a
request with a NULL destination buffer.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 include/crypto/acompress.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index cb3d6b1c655d..e4bc96528902 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -11,6 +11,7 @@
 #include <linux/crypto.h>
 
 #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
+#define CRYPTO_ACOMP_DST_MAX		131072
 
 /**
  * struct acomp_req - asynchronous (de)compression request
-- 
2.38.1

