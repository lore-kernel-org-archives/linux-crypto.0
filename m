Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B349CC433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 08:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DDA2082E
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 08:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgFZIEs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 04:04:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:37504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgFZIEs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 04:04:48 -0400
IronPort-SDR: PUvajEQlhu9Bx4NBb3jMn4PJR0StR+qB4Bw/fPy9wHHHIGCB6bFFGjXQULi1EOdi9UVzeeZgD+
 /B2YnotlRhAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="146739881"
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="146739881"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 01:04:48 -0700
IronPort-SDR: fcRd9hs8Qvb2eltzmzZ0CrL3t2E80ZKw+zjqmClxGQuZM8fymCpYTzr4i3FL4c6PaE2zoGTp4I
 7DLwAZhCDHxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="479756330"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jun 2020 01:04:46 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/4] crypto: qat - fixes to aes xts
Date:   Fri, 26 Jun 2020 09:04:25 +0100
Message-Id: <20200626080429.155450-1-giovanni.cabiddu@intel.com>
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

Changes from v1:
 - Removed extra pair of parenthesis around PTR_ERR in patch #4 (crypto:
   qat - allow xts requests not multiple of block)

Giovanni Cabiddu (4):
  crypto: qat - allow xts requests not multiple of block
  crypto: qat - validate xts key
  crypto: qat - remove unused field in skcipher ctx
  crypto: qat - fallback for xts with 192 bit keys

 drivers/crypto/qat/qat_common/qat_algs.c | 97 ++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 8 deletions(-)

-- 
2.26.2

