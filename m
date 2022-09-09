Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F78ECAAD3
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 10:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIIKty (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 06:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIIKtc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 06:49:32 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282B8EA3
        for <linux-crypto@vger.kernel.org>; Fri,  9 Sep 2022 03:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662720564; x=1694256564;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4u8KVOfDE2QDFCJqQoWfyarMk0heCBQ+xGu/lpmd0AY=;
  b=fC4hmkxesgNE+wKtLDzkeaW7gQiBFuXcldcjqoecHPoIYsVb8aF0IauJ
   NY+ST1krckkrXrRglMUzx4d4DtEMMqa9v60i4hdipB60GbY4nGCtmL8r1
   B2HN542o10qqfdYa+iWIet739YYdM1W+l5s/DzfPaWocSKqhEHIMBdkBJ
   CKCVi5OEImcVTilyGucqazBGpmyxZOFrCpSAaY9Y77IVq1dZ4j4Are1aO
   mqp39qQsxBK1mlY/minyndlrQikkZUEYd7RaW4b0UcZFS9Udfhu99pQbW
   eNQlq+xMhJduRWMfBqkq60aE+XgoYGYPCisOHN32O8Mr/q8C6sudIsNoW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="295030994"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="295030994"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 03:49:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="677115229"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga008.fm.intel.com with ESMTP; 09 Sep 2022 03:49:22 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] crypto: qat - fix DMA mappings
Date:   Fri,  9 Sep 2022 11:49:11 +0100
Message-Id: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set fixes a set of issues related to an improper use of the DMA
APIs reported when CONFIG_DMA_API_DEBUG is selected and by the static
analyzer Smatch.

The first patch fixes an overlapping DMA mapping which occurs when
in-place operations that share the same buffers but a different
scatterlist structure are sent to the implementations of aead and
skcipher in the QAT driver.
The second commit reverts a patch that attempted to fix a warning
reported by Smatch. This improperly reduced the mapping size for the
region of memory used to store the input and output parameters that are
passed to the FW for performing the RSA and DH algorithms.
The last patch properly fixes the issues that the reverted commit
attempted to fix.

Damian Muszynski (2):
  crypto: qat - fix DMA transfer direction
  crypto: qat - use reference to structure in dma_map_single()

Giovanni Cabiddu (1):
  Revert "crypto: qat - reduce size of mapped region"

 drivers/crypto/qat/qat_common/qat_algs.c      | 18 +++++++++-----
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 24 +++++++++----------
 2 files changed, 24 insertions(+), 18 deletions(-)

-- 
2.37.1

