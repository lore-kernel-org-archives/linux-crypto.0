Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF224C7EE29
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjFAKLh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbjFAKKo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:10:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF3C186
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 03:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685614207; x=1717150207;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fj+M5mdvQuX3HrOTVNH55R/p0Ym8lDxmTXIz/t/P/uA=;
  b=nhgDBWXentbjx+Hs5j6zh6hoLjVREvIYgrybGvV2vBuSQeguivDqhblD
   0VpgK96dJEWgIq6d2BhMDim1UUXYNiKSarO2c2dyXMN2Fbbt9UlS/x4zD
   LzZLUBWhmC0gQDtg261InRnsyzCBH+3s8D+kiWwwEn+1qL8zp2rwvkfc2
   mdcBy6UlhQafscvtfSktI10MBDZ5sPMQH7AZXSr9AGNnnKTUjOKmbsGO1
   njxZBymeUJ60TyWJLLx/ivq4ENCTorbcDt0U4Q2qqb23aLdYiVvhbtLbV
   Ph+cuKBO8b9ddUdKlm0A7Vi9kp5kfHUGwhiVva5tbRNNrALOyCt+UC0KH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="358791274"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="358791274"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 03:10:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="1037435169"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="1037435169"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jun 2023 03:10:05 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: qat - unmap buffers before free
Date:   Thu,  1 Jun 2023 11:09:58 +0100
Message-Id: <20230601101000.18293-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks functions for RSA and DH free the memory allocated for the
source and destination buffers before unmapping it.
This sequence is not correct.

Change the cleanup sequence to unmap the buffers before freeing them.

Hareshx Sankar Raj (2):
  crypto: qat - unmap buffer before free for DH
  crypto: qat - unmap buffers before free for RSA

 .../crypto/intel/qat/qat_common/qat_asym_algs.c    | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

-- 
2.40.1

