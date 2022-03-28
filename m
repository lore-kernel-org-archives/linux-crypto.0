Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CD0C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Mar 2022 13:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiC1NJ0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Mar 2022 09:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242988AbiC1NJT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Mar 2022 09:09:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480F5DE4E
        for <linux-crypto@vger.kernel.org>; Mon, 28 Mar 2022 06:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648472848; x=1680008848;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ae6YiOvxxEdwLXeOCtDcN81k8iA6NRIkgUp2uQBOWiA=;
  b=LvTUqinCVGvc0pwWPyv3zy09GTir5+rQMBspgNnAV0IwamBGBg0H9baK
   s9jKtDEpKl4dXdloz57ITATJgzKLJbgNOsL0DWamq6BDiHG0g6yWLSPkO
   ccclOltYHEc09LHT7RdxhDHY3YJ5NoxmJzsZcdmdOabR4mPlWtuUU2Lbd
   ovN6PPo1gngjo6w5UurFVHADMn1WxKIXqV2Tk3zwIhRbb9ww74hwT/wnS
   VfN1kbE/yz0l2ftUgXimUz9vlP6XBp2AO/3d11Mlpjm8Oln2n75TlJgtq
   6i6Vw8Soe0+Ql//mgGN4VGyZFuJT3r9PwIRjzTR8vY/MJPC7iAy6wLOdl
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259178987"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259178987"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 06:07:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="563641072"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2022 06:07:22 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/4] crypto: qat - fix dm-crypt related issues
Date:   Mon, 28 Mar 2022 14:07:10 +0100
Message-Id: <20220328130714.31606-1-giovanni.cabiddu@intel.com>
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

The last, re-enables the crypto instances in the QAT driver which were
disabled due to the issues above.

Giovanni Cabiddu (4):
  crypto: qat - use pre-allocated buffers in datapath
  crypto: qat - refactor submission logic
  crypto: qat - add backlog mechanism
  crypto: qat - re-enable registration of algorithms

 drivers/crypto/qat/qat_4xxx/adf_drv.c         |   7 -
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 drivers/crypto/qat/qat_common/adf_transport.c |  11 ++
 drivers/crypto/qat/qat_common/adf_transport.h |   1 +
 .../qat/qat_common/adf_transport_internal.h   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 148 +++++++++---------
 drivers/crypto/qat/qat_common/qat_algs_send.c |  91 +++++++++++
 drivers/crypto/qat/qat_common/qat_algs_send.h |  10 ++
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  54 ++++---
 drivers/crypto/qat/qat_common/qat_crypto.c    |  37 ++++-
 drivers/crypto/qat/qat_common/qat_crypto.h    |  40 +++++
 11 files changed, 299 insertions(+), 102 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.h

-- 
2.35.1

