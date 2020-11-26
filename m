Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150A0C56202
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 11:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB1121D42
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 11:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbgKZL5e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 06:57:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:7383 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387979AbgKZL5d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 06:57:33 -0500
IronPort-SDR: YZ901kI8nHOcQvms1nF4wnOx+55CHDUENjYRMtBzmxZZdXzw4T7V4yaHwveTWLc27gOpC6aGDZ
 r0bZBmCHEEZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="160048300"
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="160048300"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 03:52:07 -0800
IronPort-SDR: jGFtbjvAMvjlmFUZUfPy5sFcu9pM7bt0BIvtEvVggHnpw3ymar2WHrQDW8OC9Vjb5KZMb1Hstb
 e8KhrSmjsWUw==
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="362781517"
Received: from smaciag-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.251.85.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 03:52:04 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: [PATCH 0/2] crypto: Add Keem Bay OCS AES/SM4 driver
Date:   Thu, 26 Nov 2020 11:51:46 +0000
Message-Id: <20201126115148.68039-1-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Intel Keem Bay SoC has an Offload Crypto Subsystem (OCS) featuring a
crypto engine for accelerating AES/SM4 operations.

This driver adds support for such hardware thus enabling hardware
acceleration for the following transformations on the Intel Keem Bay SoC:

- ecb(aes), cbc(aes), ctr(aes), cts(cbc(aes)), gcm(aes) and cbc(aes);
  supported for 128-bit and 256-bit keys.

- ecb(sm4), cbc(sm4), ctr(sm4), cts(cbc(sm4)), gcm(sm4) and cbc(sm4);
  supported for 128-bit keys.

The driver passes crypto manager self-tests, including the extra tests
(CRYPTO_MANAGER_EXTRA_TESTS=y).

Note: this driver is different from the Keem Bay OCS HCU driver previously
submitted. Keem Bay OCS HCU provides hardware-accelerated ahash, while
Keem Bay AES/SM4 (i.e., this driver) provides hardware-accelerated
skcipher and aead.


Daniele Alessandrelli (1):
  dt-bindings: Add Keem Bay OCS AES bindings

Mike Healy (1):
  crypto: keembay-ocs-aes: Add support for Keem Bay OCS AES/SM4

 .../crypto/intel,keembay-ocs-aes.yaml         |   45 +
 MAINTAINERS                                   |   10 +
 drivers/crypto/Kconfig                        |    2 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/keembay/Kconfig                |   39 +
 drivers/crypto/keembay/Makefile               |    5 +
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 1713 +++++++++++++++++
 drivers/crypto/keembay/ocs-aes.c              | 1489 ++++++++++++++
 drivers/crypto/keembay/ocs-aes.h              |  129 ++
 9 files changed, 3433 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-aes.yaml
 create mode 100644 drivers/crypto/keembay/Kconfig
 create mode 100644 drivers/crypto/keembay/Makefile
 create mode 100644 drivers/crypto/keembay/keembay-ocs-aes-core.c
 create mode 100644 drivers/crypto/keembay/ocs-aes.c
 create mode 100644 drivers/crypto/keembay/ocs-aes.h


base-commit: c3a98c3ad5c0dc60a1ac66bf91147a3f39cac96b
-- 
2.26.2

