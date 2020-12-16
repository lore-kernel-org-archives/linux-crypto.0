Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D00EC2BBCA
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE34233CE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 11:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgLPLsv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 06:48:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:27995 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgLPLsv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 06:48:51 -0500
IronPort-SDR: dvUR0Dvtd4vInGdaoAn6BxrD9vgdwjFUNj8e+58VOBo4UtfFOZO7uRhle2mq4w7sM93LreJDJW
 qH8h2VQLmXxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="154856586"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="154856586"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:05 -0800
IronPort-SDR: mw6V4X+kWItnM7h5ADAiCrJmgqyFR3J+R1aoKxvRKPm36tpYNYS55mN8A45XXfTfLkTqEdMYL0
 +KQ8EbJs0VaQ==
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="368985136"
Received: from johnlyon-mobl.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.90.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 03:47:02 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: [PATCH v4 0/5] crypto: Add Keem Bay OCS HCU driver
Date:   Wed, 16 Dec 2020 11:46:34 +0000
Message-Id: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
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

v3 -> v4:
- Addressed comments from Mark Gross.
- Added Reviewed-by-tag from Rob Herring to DT binding patch.
- Driver reworked to better separate the code interacting with the hardware
  from the code implementing the crypto ahash API.
- Main patch split into 3 different patches to simplify review (patch series is
  now composed of 5 patches)

v2 -> v3:
- Fixed more issues with dt-bindings (removed useless descriptions for reg,
  interrupts, and clocks)

v1 -> v2:
- Fixed issues with dt-bindings

Daniele Alessandrelli (3):
  crypto: keembay-ocs-hcu - Add HMAC support
  crypto: keembay-ocs-hcu - Add optional support for sha224
  MAINTAINERS: Add maintainers for Keem Bay OCS HCU driver

Declan Murphy (2):
  dt-bindings: crypto: Add Keem Bay OCS HCU bindings
  crypto: keembay - Add Keem Bay OCS HCU driver

 .../crypto/intel,keembay-ocs-hcu.yaml         |   46 +
 MAINTAINERS                                   |   11 +
 drivers/crypto/keembay/Kconfig                |   29 +
 drivers/crypto/keembay/Makefile               |    3 +
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 1264 +++++++++++++++++
 drivers/crypto/keembay/ocs-hcu.c              |  840 +++++++++++
 drivers/crypto/keembay/ocs-hcu.h              |  106 ++
 7 files changed, 2299 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
 create mode 100644 drivers/crypto/keembay/keembay-ocs-hcu-core.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.c
 create mode 100644 drivers/crypto/keembay/ocs-hcu.h


base-commit: 7bba37a1591369e2e506d599b8f5d7d0516b2dbc
-- 
2.26.2

