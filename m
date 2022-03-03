Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F04FC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 18:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiCCSOT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 13:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiCCSOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 13:14:19 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C00EA75F
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 10:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646331213; x=1677867213;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4xqR1BVOwp+QcHniOrSt1P56q9F4HFPOe+k9p60BXFw=;
  b=drc+nZM/+VHnI/qSso5G3iSEAscyz7CpCsddLM+mfxUE7z5NlqQKHesf
   V8b1mkhxWEO7/goxHR0gRpJjrLedDwgwc7USBKRs9EwGnTFbs+uJ7KvdD
   X/t2dzIxQapsIeDJsZfbgOfqiZ/pNkULgv5KDKQeQwME+MSUFYnCjKK9D
   jd8KhTfiy2biAEipZBv262sqq1xjPujGWI6sC38wKBMLiO9OJhnuESX9n
   Zb1ppzcCxrYvVeoRJ+EEKHmvbirnUjLsoQ+gzqnOiLunitGxKe2OSY78n
   UONbw0gnWejS7jjaClfu+6dzQZxMrjKoHuuZY19Bws77CL/0PBWeBOOQO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="278447731"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="278447731"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 10:00:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="640279624"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 10:00:48 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [RFC 0/3] crypto: qat - fix dm-crypt related issues
Date:   Thu,  3 Mar 2022 18:00:33 +0000
Message-Id: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
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

The second patch addresses a stall in the dm-crypt + QAT usecase by
adding support for the CRYPTO_TFM_REQ_MAY_BACKLOG flag. If the HW queue
is full, the driver enqueues the request in a list and resubmit it at
a later time, avoiding losing it.

The last, removes the CRYPTO_ALG_ALLOCATES_MEMORY flag from the aead and
skcipher implementations so that the driver can be used by dm-crypt.

Although the set is functional, I marked it as RFC as I want to do some
code improvements on the second patch, `crypto: qat - add backlog
mechanism`, do additional performance profiling and optimizations.

Giovanni Cabiddu (2):
  crypto: qat - use pre-allocated buffers in datapath
  crypto: qat - remove CRYPTO_ALG_ALLOCATES_MEMORY flag

Vishnu Das Ramachandran (1):
  crypto: qat - add backlog mechanism

 drivers/crypto/qat/qat_common/adf_transport.c |  12 +
 drivers/crypto/qat/qat_common/adf_transport.h |   1 +
 .../qat/qat_common/adf_transport_internal.h   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 305 +++++++++++++-----
 drivers/crypto/qat/qat_common/qat_crypto.h    |  26 ++
 5 files changed, 269 insertions(+), 76 deletions(-)

-- 
2.35.1

