Return-Path: <SRS0=63hd=DX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853FCC43457
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD2021D40
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390877AbgJPR2b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Oct 2020 13:28:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:5396 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732302AbgJPR2b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Oct 2020 13:28:31 -0400
IronPort-SDR: F1ZdE3lPQMzh+tzhA4Z+BBc96NAucCQGhN//mk22lduK/Q9qQcwhlou/GqBf9dSkVX8HlRvqQx
 qdLF07VtVebQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="153570022"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="153570022"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:28:23 -0700
IronPort-SDR: qWDqfqZU10c7b/gbksS0K0nf5uubNWZ5cv12KWD7Ys5lkkWtd0VPCvAX+oakzXqLJbEGACOHDA
 q3yBhJFyt4dQ==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="464750835"
Received: from apurdea-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.84.178])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 10:28:20 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH 0/3] crypto: Add Keem Bay OCS HCU driver
Date:   Fri, 16 Oct 2020 18:27:56 +0100
Message-Id: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Intel Keem Bay SoC has an Offload Crypto Subsystem (OCS) featuring a
Hashing Control Unit (HCU) for accelerating hashing operations.

This driver adds support for such hardware thus enabling hardware-accelerated
hashing on the Keem Bay SoC for the following algorithms:
- sha224 and hmac(sha224)
- sha256 and hmac(sha256)
- sha384 and hmac(sha384)
- sha512 and hmac(sha512)
- sm3    and hmac(sm3)

The driver is passing crypto manager self-tests, including the extra tests
(CRYPTO_MANAGER_EXTRA_TESTS=y).


Daniele Alessandrelli (1):
  MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver

Declan Murphy (2):
  dt-bindings: crypto: Add Keem Bay OCS HCU bindings
  crypto: keembay: Add Keem Bay OCS HCU driver

 .../crypto/intel,keembay-ocs-hcu.yaml         |   52 +
 MAINTAINERS                                   |   11 +
 drivers/crypto/Kconfig                        |    2 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/keembay/Kconfig                |   23 +
 drivers/crypto/keembay/Makefile               |    5 +
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 1473 +++++++++++++++++
 drivers/crypto/keembay/ocs-hcu.c              |  590 +++++++
 drivers/crypto/keembay/ocs-hcu.h              |  113 ++
 9 files changed, 2270 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
 create mode 100644 drivers/crypto/keembay/Kconfig
 create mode 100644 drivers/crypto/keembay/Makefile
 create mode 100644 drivers/crypto/keembay/keembay-ocs-hcu-core.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.h


base-commit: 3093e7c16e12d729c325adb3c53dde7308cefbd8
-- 
2.26.2

