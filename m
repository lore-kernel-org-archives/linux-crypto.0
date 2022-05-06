Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB85C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 08:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiEFI1Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 04:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbiEFI1P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 04:27:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F57689BA
        for <linux-crypto@vger.kernel.org>; Fri,  6 May 2022 01:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651825413; x=1683361413;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m9J0niEBr8HxeYkRfTRw/l0rZ0wWq/Qy8/cUPqxkd08=;
  b=ZeMnrqCh65rvVDxZGpUlf+m+CJ1O43s3H42u+F/QKfeiQvABkPodPQYV
   SHSBa+EcxqgxS5J0E79zCH9lU0dv1AJxDwp9IF0KLppkHsJiZU96iNRL2
   7y93zYAxNulKJxiI0SG26velL39bQQVrp4rekf6IUCbIWBLPqUFKsIUCy
   kq6407e3fFjlOYnkYhUFF4iwWBV01RJzm5OJcuH70NykMsNZLc5vMPiCc
   4bt5U9WAoiXShN7h+K6r4LDgo9KYZ6KiBHqmTYt2s4MvokDU+S+ZUwuHo
   pPZvRwXSDNaK+q7NG+4H7e78f4DCi1jw/D2wwuh8p6HNxzVUCpDSDE8CT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328938416"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="328938416"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 01:23:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563708857"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 01:23:31 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        vdronov@redhat.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 00/12] crypto: qat - re-enable algorithms
Date:   Fri,  6 May 2022 09:23:15 +0100
Message-Id: <20220506082327.21605-1-giovanni.cabiddu@intel.com>
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

Giovanni Cabiddu (12):
  crypto: qat - use pre-allocated buffers in datapath
  crypto: qat - refactor submission logic
  crypto: qat - add backlog mechanism
  crypto: qat - fix memory leak in RSA
  crypto: qat - remove dma_free_coherent() for RSA
  crypto: qat - remove dma_free_coherent() for DH
  crypto: qat - set to zero DH parameters before free
  crypto: qat - add param check for RSA
  crypto: qat - add param check for DH
  crypto: qat - use memzero_explicit() for algs
  crypto: qat - honor CRYPTO_TFM_REQ_MAY_SLEEP flag
  crypto: qat - re-enable registration of algorithms

 drivers/crypto/qat/qat_4xxx/adf_drv.c         |   7 -
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 drivers/crypto/qat/qat_common/adf_transport.c |  11 +
 drivers/crypto/qat/qat_common/adf_transport.h |   1 +
 .../qat/qat_common/adf_transport_internal.h   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 173 ++++-----
 drivers/crypto/qat/qat_common/qat_algs_send.c |  86 +++++
 drivers/crypto/qat/qat_common/qat_algs_send.h |  11 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 327 +++++++++---------
 drivers/crypto/qat/qat_common/qat_crypto.c    |  10 +-
 drivers/crypto/qat/qat_common/qat_crypto.h    |  44 +++
 11 files changed, 415 insertions(+), 257 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs_send.h

-- 
2.35.1

