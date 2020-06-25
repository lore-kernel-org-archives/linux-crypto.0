Return-Path: <SRS0=hy52=AG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C13C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 12:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CAD7206C3
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 12:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404650AbgFYM7Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:59:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:8441 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404845AbgFYM7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jun 2020 08:59:24 -0400
IronPort-SDR: ML4e7jJChGmZesbx+CzGqNS9QIWSPlXrg+sGvH97cQrdkVFZfQMCO3jUc+sizXxjUxE+pQfcps
 4/t82a+B9/sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="142362222"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="142362222"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 05:59:24 -0700
IronPort-SDR: I5Qgqh2Bl2MRAYOb2cOdmA56HvvuVgxBtAqaK/rIafVo2zUI1jqck+izVmqC0DQONcZNzELwCL
 rEdw6VfLA70g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="301979103"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 05:59:23 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/4] crypto: qat - fixes to aes xts
Date:   Thu, 25 Jun 2020 13:59:00 +0100
Message-Id: <20200625125904.142840-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series fixes a few issues with the xts(aes) implementation in the
QuickAssist driver:
 - Requests that are not multiple of the block size are rejected
 - Input key not validated
 - xts(aes) requests with key size 192 bits are rejected with -EINVAL

Giovanni Cabiddu (4):
  crypto: qat - allow xts requests not multiple of block
  crypto: qat - validate xts key
  crypto: qat - remove unused field in skcipher ctx
  crypto: qat - fallback for xts with 192 bit keys

 drivers/crypto/qat/qat_common/qat_algs.c | 97 ++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 8 deletions(-)

-- 
2.26.2

