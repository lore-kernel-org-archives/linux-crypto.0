Return-Path: <SRS0=/kEc=EJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C888C388F2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 18:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE506223AC
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Nov 2020 18:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgKCStn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:49:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:53371 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgKCStn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Nov 2020 13:49:43 -0500
IronPort-SDR: Npe6XtkSen4crdYkaEa9XXvCDhePwPJgPoEnIgkNsIcbNzC7jSmhzHP/aUG/ne9hTRoRbEVO4U
 MYDqOkDrAPQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="253818877"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="253818877"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 10:49:42 -0800
IronPort-SDR: A19//EAffO2TD+y/taTVuDCtC0XbrbsEjlu4Jxv+Tzb5+TDPPGYIw1mDxjHd/y2OOKSdfInkH3
 kGVNymhlAWQA==
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="528595200"
Received: from riglesi-mobl.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.9.152])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 10:49:40 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v2 0/3] crypto: Add Keem Bay OCS HCU driver
Date:   Tue,  3 Nov 2020 18:49:22 +0000
Message-Id: <20201103184925.294456-1-daniele.alessandrelli@linux.intel.com>
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

v1 -> v2:
- Fixed issues with dt-bindings

Daniele Alessandrelli (1):
  MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver

Declan Murphy (2):
  dt-bindings: crypto: Add Keem Bay OCS HCU bindings
  crypto: keembay: Add Keem Bay OCS HCU driver

 .../crypto/intel,keembay-ocs-hcu.yaml         |   51 +
 MAINTAINERS                                   |   11 +
 drivers/crypto/Kconfig                        |    2 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/keembay/Kconfig                |   20 +
 drivers/crypto/keembay/Makefile               |    5 +
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 1484 +++++++++++++++++
 drivers/crypto/keembay/ocs-hcu.c              |  593 +++++++
 drivers/crypto/keembay/ocs-hcu.h              |  115 ++
 9 files changed, 2282 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
 create mode 100644 drivers/crypto/keembay/Kconfig
 create mode 100644 drivers/crypto/keembay/Makefile
 create mode 100644 drivers/crypto/keembay/keembay-ocs-hcu-core.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.h


base-commit: c3a98c3ad5c0dc60a1ac66bf91147a3f39cac96b
-- 
2.26.2

