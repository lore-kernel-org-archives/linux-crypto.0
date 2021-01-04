Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAE9C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DAE7224F4
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbhADRWp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:22:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:43978 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbhADRWp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 12:22:45 -0500
IronPort-SDR: UNQvjFQDCu3Q5O+q3tkYhMg41KA1sErTUVPvgcRnOwYiQwLloS3LzylVtYRDPdCpGtDyg8PRli
 hUsAOFtcraww==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177135625"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="177135625"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 09:22:04 -0800
IronPort-SDR: NoNHUHXBUUTFz8f+Ft2+m1/piaTTLPW8n0TCCaYU/arplpLTjNb8qwH678ae0pXKBzV6j+2q7F
 aYIgmkf07QKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="345962813"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2021 09:22:03 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] crypto: qat - fix issues reported by smatch
Date:   Mon,  4 Jan 2021 17:21:56 +0000
Message-Id: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix warnings and errors reported by the static analysis tool smatch in
the QAT driver.

Adam Guerin (3):
  crypto: qat - fix potential spectre issue
  crypto: qat - change format string and cast ring size
  crypto: qat - reduce size of mapped region

 drivers/crypto/qat/qat_common/adf_transport.c       |  2 ++
 drivers/crypto/qat/qat_common/adf_transport_debug.c |  4 ++--
 drivers/crypto/qat/qat_common/qat_asym_algs.c       | 12 ++++++------
 3 files changed, 10 insertions(+), 8 deletions(-)

-- 
2.29.2

