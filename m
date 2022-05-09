Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826EDC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  9 May 2022 13:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiEINiZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 May 2022 09:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiEINiY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 May 2022 09:38:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3E922A2F3
        for <linux-crypto@vger.kernel.org>; Mon,  9 May 2022 06:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652103270; x=1683639270;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fJDtz5qyotD7Q0fNMrwQgjBWMRXBnOtlENsRarfqtEM=;
  b=juMveDsJA7zS8gxLlRdsUibMmkGQJsHjJn8htEsLqOnW1TJbWwfWs4DN
   lziaAuN5UYO3ItkXtHEeF5G9J+UbJjoKSWl2ff6Lur/SJKNio9H47lq2+
   6ngfkjx9VXOmIH+/72+1s8EduPKRwPZQrWwEJUl/J9SX91KeoQg5AdnDK
   2pqWB4f0Vn9+2x2mhxLmPjeJTNHpJy3+8Y2u9PwmokB+QPG7VLSHYHTez
   eR+8O03BmXOBBmwAdbMPY5VErAb4ROBAHDRKrKguyntt6v6Derremto7m
   aP2zHGczNtbAqS45GL0wPo8eZiCSGuEdXjeA6f5zvUVxDERe+7/rPongG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="248952301"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="248952301"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 06:34:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="622967123"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga008.fm.intel.com with ESMTP; 09 May 2022 06:34:27 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 00/10] crypto: qat - re-enable algorithms
Date:   Mon,  9 May 2022 14:34:07 +0100
Message-Id: <20220509133417.56043-1-giovanni.cabiddu@intel.com>
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
related to the usage of dma_free_coherent() from a tasklet, and includes
important fixes in the akcipher algorithms.

One item to mention is that, differently from the previous set, this
one does not removes the flag CRYPTO_ALG_ALLOCATES_MEMORY which will
be removed after the conversation in [2] is closed.

[1] https://lore.kernel.org/linux-crypto/YiEyGoHacN80FcOL@silpixa00400314/
[2] https://lore.kernel.org/linux-crypto/Yl6PlqyucVLCzwF5@silpixa00400314/

Changes from v2:
  - Removed `crypto: qat - set to zero DH parameters before free` from
    set.
  - Added fixes tags to patches `crypto: qat - add param check for RSA`
    and `crypto: qat - add param check for DH`

Changes from v1:
  - Clarified commit message in `crypto: qat - refactor submission logic`
    to indicate why the patch should be included in stable kernels
  - Removed `crypto: qat - use memzero_explicit() for algs` from set
    after feedback from Greg KH
  - Replaced memzero_explicit() with memset() in `crypto: qat - set to
    zero DH parameters before free` after feedback from Greg KH

Giovanni Cabiddu (10):
  crypto: qat - use pre-allocated buffers in datapath
  crypto: qat - refactor submission logic
  crypto: qat - add backlog mechanism
  crypto: qat - fix memory leak in RSA
  crypto: qat - remove dma_free_coherent() for RSA
  crypto: qat - remove dma_free_coherent() for DH
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
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 304 +++++++++---------
 drivers/crypto/qat/qat_common/qat_crypto.c    |  10 +-
 drivers/crypto/qat/qat_common/qat_crypto.h    |  44 +++
 11 files changed, 392 insertions(+), 237 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.h

-- 
2.35.1

