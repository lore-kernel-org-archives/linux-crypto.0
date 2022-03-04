Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B40C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Mar 2022 18:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiCDSEu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbiCDSEt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Mar 2022 13:04:49 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC0B1C57D9
        for <linux-crypto@vger.kernel.org>; Fri,  4 Mar 2022 10:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646417040; x=1677953040;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mHXlxeFlvf0WV61ragTOOUlIdZWv1ty29AFQH6e8/dE=;
  b=VP48VKH9IVMLIrMUeDn5U7WhNo6n+Yj/3wN6fS4ay/Z/buDP2ncvjP+Y
   AhuTdUQZdxsAzsnqxn1bPKgcI9oMhxqQY/HAqLvxLDJd6ejQFcS62ORpK
   gQ3xvIZOOpUI4Q2aIu5MOi6KUbR7fpJTOiuiNCCu+GNxZ+TcI9jmBMWYH
   TI+/S3YGBRKtF+z7W4BeAooB+EDPRSOutgVc+2t84yYl3ajCRu78pC9Qq
   g2SQrIoe5aTBIybIrjxK6aBhJ9YsucWyrclHDI77fpHLTsIrdog5RAy2D
   ikWa7UIGAZDbFsE8MMJziq0UCb7jxZuiZSgvApzpnYJ7apW4a7K+N/tYD
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="314744406"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="314744406"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 10:04:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="552308513"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 04 Mar 2022 10:03:58 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] crypto: qat - resolve warnings reported by clang
Date:   Fri,  4 Mar 2022 18:03:53 +0000
Message-Id: <20220304180356.22469-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Resolve minor issues reported by clang, when compiling the driver with
W=2, and by scan-build.

Giovanni Cabiddu (3):
  crypto: qat - remove unneeded assignment
  crypto: qat - fix initialization of pfvf cap_msg structures
  crypto: qat - fix initialization of pfvf rts_map_msg structures

 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c   | 2 +-
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.35.1

