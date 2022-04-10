Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24665C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Apr 2022 19:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiDJTtX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Apr 2022 15:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiDJTtX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Apr 2022 15:49:23 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006236210B
        for <linux-crypto@vger.kernel.org>; Sun, 10 Apr 2022 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649620032; x=1681156032;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WSN6dHNcWEcA+qWBm031A0zXsH36N6TSf9UiBFOlPR4=;
  b=IcdMpsKUT7+HPVe9gQr7vY30VKT5SVHMZZuOQquaIUojms+a/TMQFq0R
   M1DkMrA7Yw4NeQ1PiGMJqisqwPZnBzywg+orkWW+6sT683gjqmXnaVbHt
   vJSC9oO/u09L+q/Xa8uD7SUq3wfQnJtGFTRhkuHoiK4GZug2xA06Ui8wZ
   osC/+SP8fsLUow7p1L8CiRMZvXS01sC97vqbFDACOxdSWD3Z+t4umbaKE
   m/AZqURNn8Sf6hLIthIpSUcKSW2o4OGRfFRTvE3WZtFMk6c8RVtp4hi0J
   6ovC3gg+QnnD5gd2zDp+mjW5Xb0pOLPsQRJWkIGeiuV4W2LbnWqwtVTJw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="324905153"
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="324905153"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2022 12:47:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,250,1643702400"; 
   d="scan'208";a="506849181"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga003.jf.intel.com with ESMTP; 10 Apr 2022 12:47:10 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 0/3] crypto: qat - fix dm-crypt related issues
Date:   Sun, 10 Apr 2022 20:47:04 +0100
Message-Id: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set fixes the issues related with the dm-crypt + QAT driver
use-case.

The first patch fixes a potential dead-lock that might occur when using
dm-crypt + QAT in out of memory conditions. The datapaths of the aead
and skcipher implementations have been changed to use pre-allocated
buffers that are part of the request contexts.
The also removes the CRYPTO_ALG_ALLOCATES_MEMORY flag from the aead and
skcipher implementations.

The second patch refactors the submission logic in preparation for the
introduction of a backlog queue to handle crypto requests with the
CRYPTO_TFM_REQ_MAY_BACKLOG flag set.

The third patch addresses a stall in the dm-crypt + QAT usecase by
adding support for the CRYPTO_TFM_REQ_MAY_BACKLOG flag. If the HW queue
is full, the driver enqueues the request in a list and resubmit it at
a later time, avoiding losing it.

Changes from v1:
 - Patch #3: removed worqueues. Requests in the backlog queue are now
   resubmitted in the context of the callback of a previously submitted
   request. This reduces the CPU utilization as the resubmit backlog
   function always finds a free slot in the HW queues when resubmits a
   job.

Changes from v2:
  - Patch #3: added initialization of list element before insertion in
    backlog list.
  - Patch #3: changed read order of pointer to backlog structure in the
    callback. The pointer to the backlog structure, which is part of the
    request context, needs to be read before the request is completed.
    This is since the user might free the request structure after the
    request is completed.
  - Removed patch 4 to keep the algorithms disabled as there is now a
    regression on the rsa implementation after commit f5ff79fddf0e
    ("dma-mapping: remove CONFIG_DMA_REMAP") is showing a regression
    unrelated to this set.

Giovanni Cabiddu (3):
  crypto: qat - use pre-allocated buffers in datapath
  crypto: qat - refactor submission logic
  crypto: qat - add backlog mechanism

 drivers/crypto/qat/qat_common/Makefile        |   1 +
 drivers/crypto/qat/qat_common/adf_transport.c |  11 ++
 drivers/crypto/qat/qat_common/adf_transport.h |   1 +
 .../qat/qat_common/adf_transport_internal.h   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 151 ++++++++++--------
 drivers/crypto/qat/qat_common/qat_algs_send.c |  86 ++++++++++
 drivers/crypto/qat/qat_common/qat_algs_send.h |  11 ++
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  57 ++++---
 drivers/crypto/qat/qat_common/qat_crypto.c    |   3 +
 drivers/crypto/qat/qat_common/qat_crypto.h    |  39 +++++
 10 files changed, 273 insertions(+), 88 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.h

-- 
2.35.1

