Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBBBC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AAD221473
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbfGBLja (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 07:39:30 -0400
Received: from foss.arm.com ([217.140.110.172]:48092 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfGBLja (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 07:39:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21884344;
        Tue,  2 Jul 2019 04:39:30 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC9FF3F246;
        Tue,  2 Jul 2019 04:39:28 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] crypto: ccree: cleanups, fixes and TEE FIPS support
Date:   Tue,  2 Jul 2019 14:39:17 +0300
Message-Id: <20190702113922.24911-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clean up unused ivgen support code and add support for notifiying
Trusted Execution Enviornment of FIPS tests failures in FIPS mode.

Gilad Ben-Yossef (4):
  crypto: ccree: drop legacy ivgen support
  crypto: ccree: account for TEE not ready to report
  crypto: fips: add FIPS test failure notification chain
  crypto: ccree: notify TEE on FIPS tests errors

 crypto/fips.c                         |  11 +
 crypto/testmgr.c                      |   4 +-
 drivers/crypto/ccree/Makefile         |   2 +-
 drivers/crypto/ccree/cc_aead.c        |  76 +------
 drivers/crypto/ccree/cc_aead.h        |   3 +-
 drivers/crypto/ccree/cc_driver.c      |  12 +-
 drivers/crypto/ccree/cc_driver.h      |  10 -
 drivers/crypto/ccree/cc_fips.c        |  31 ++-
 drivers/crypto/ccree/cc_ivgen.c       | 276 --------------------------
 drivers/crypto/ccree/cc_ivgen.h       |  55 -----
 drivers/crypto/ccree/cc_pm.c          |   2 -
 drivers/crypto/ccree/cc_request_mgr.c |  47 +----
 include/linux/fips.h                  |   7 +
 13 files changed, 68 insertions(+), 468 deletions(-)
 delete mode 100644 drivers/crypto/ccree/cc_ivgen.c
 delete mode 100644 drivers/crypto/ccree/cc_ivgen.h

-- 
2.21.0

