Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B9FC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 14:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442277AbiEFOmy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 10:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442286AbiEFOmv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 10:42:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E6B6A42D
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 07:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651847947; x=1683383947;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PptSanh6NCuDve3xGS6fyaJwCpqyeNxlYDFoVFJRfEs=;
  b=BGLNy8PStGS2cFHkqw2KIh4FNwc+lOIfY+/W7zDJWX27lrWj5b02vgcw
   keL/uLHLsHQsRanE5mB/u4eQjQOZ9rgwOeUo3qQYENV9LOyEx+Gr8Jk1N
   S1PqJ8raHrc8n2n0ZM/Iwz2VD3hun86SEp7dO3ctIdYe3tHvIRQbZ6x8C
   mXHPmpPy79MoLgujuW6mqkCfv/ap0R18HUMqwgslCoKxADJivg7mka6p3
   u3qkC+UlSSoaTNYIkfn7i1guFJydwxnQ/9BgeKJy/SsBfpjRV39N2COS7
   I8UqU84l+kDrUpJxHBLWfNg4xNB3hb3hJXZ9zSLqb4a2rrx9DYbEGI9dn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248387448"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248387448"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 07:39:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="537914788"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga006.jf.intel.com with ESMTP; 06 May 2022 07:39:05 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 00/11] crypto: qat - re-enable algorithms
Date:   Fri,  6 May 2022 15:38:52 +0100
Message-Id: <20220506143903.31776-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set is an extension of a previous set called `crypto: qat - fix dm-crypt
related issues` which aims to re-enable the algorithms in the QAT driver
after [1].

This fixes a number of issues with the implementation of the QAT algs,
both symmetric and asymmetric.
In particular this set enables the QAT driver to handle correctly the
flags CRYPTO_TFM_REQ_MAY_BACKLOG and CRYPTO_TFM_REQ_MAY_SLEEP,
fixes an hidden issue in RSA and DH which appeared after commit f5ff79fddf0e,
related to the usage of dma_free_coherent() from a tasklet and includes
important fixes in the akcipher algorithms.

One item to mention is that, differently from the previous set, this
one does not removes the flag CRYPTO_ALG_ALLOCATES_MEMORY which will
be removed after the conversation in [2] is closed.

[1] https://lore.kernel.org/linux-crypto/YiEyGoHacN80FcOL@silpixa00400314/
[2] https://lore.kernel.org/linux-crypto/Yl6PlqyucVLCzwF5@silpixa00400314/

Changes from v1:
  - Clarified commit message in `crypto: qat - refactor submission logic`
    to indicate why the patch should be included in stable kernels
  - Removed `crypto: qat - use memzero_explicit() for algs` from set
    after feedback from Greg KH
  - Replaced memzero_explicit() with memset() in `crypto: qat - set to
    zero DH parameters before free` after feedback from Greg KH

Giovanni Cabiddu (11):
  crypto: qat - use pre-allocated buffers in datapath
  crypto: qat - refactor submission logic
  crypto: qat - add backlog mechanism
  crypto: qat - fix memory leak in RSA
  crypto: qat - remove dma_free_coherent() for RSA
  crypto: qat - remove dma_free_coherent() for DH
  crypto: qat - set to zero DH parameters before free
  crypto: qat - add param check for RSA
  crypto: qat - add param check for DH
  crypto: qat - honor CRYPTO_TFM_REQ_MAY_SLEEP flag
  crypto: qat - re-enable registration of algorithms

 drivers/crypto/qat/qat_4xxx/adf_drv.c         |   7 -
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 drivers/crypto/qat/qat_common/adf_transport.c |  11 +
 drivers/crypto/qat/qat_common/adf_transport.h |   1 +
 .../qat/qat_common/adf_transport_internal.h   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 153 +++++----
 drivers/crypto/qat/qat_common/qat_algs_send.c |  86 +++++
 drivers/crypto/qat/qat_common/qat_algs_send.h |  11 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 307 +++++++++---------
 drivers/crypto/qat/qat_common/qat_crypto.c    |  10 +-
 drivers/crypto/qat/qat_common/qat_crypto.h    |  44 +++
 11 files changed, 395 insertions(+), 237 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.h

-- 
2.35.1

