Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2DAC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AAB6137C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Oct 2021 10:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJTKh6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:37:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:7379 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhJTKh6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Oct 2021 06:37:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="228622884"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="228622884"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:44 -0700
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="527005545"
Received: from dhicke3x-mobl1.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.29.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:35:41 -0700
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] Keem Bay OCS ECC crypto driver
Date:   Wed, 20 Oct 2021 11:35:33 +0100
Message-Id: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This patch series adds the Intel Keem Bay OCS ECC crypto driver, which
enables hardware-accelerated 'ecdh-nist-p256' and 'ecdh-nist-p384' on
the Intel Keem Bay SoC.

The following changes to core crypto code are also done:
- KPP support is added to the crypto engine (so that the new driver can
  use it).
- 'crypto/ecc.h' is moved to 'include/crypto/internal' (so that this and
  other drivers can use the symbols exported by 'crypto/ecc.c').
- A few additional functions from 'crypto/ecc.c' are exported (so that
  this and other drivers can use them and avoid code duplication).

The driver passes crypto manager self-tests.

A previous version of this patch series was submitted as an RFC:
https://lore.kernel.org/linux-crypto/20201217172101.381772-1-daniele.alessandrelli@linux.intel.com/

Changes from previous RFC submission (RFC-v1):
- Switched to the new 'ecdh-nist-p256' and 'ecdh-nist-p384' algorithm
  names
- Dropped the CONFIG_CRYPTO_DEV_KEEMBAY_OCS_ECDH_GEN_PRIV_KEY_SUPPORT
  Kconfig option

Daniele Alessandrelli (2):
  crypto: ecc - Move ecc.h to include/crypto/internal
  crypto: ecc - Export additional helper functions

Prabhjot Khurana (3):
  crypto: engine - Add KPP Support to Crypto Engine
  dt-bindings: crypto: Add Keem Bay ECC bindings
  crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC Driver

 Documentation/crypto/crypto_engine.rst        |    4 +
 .../crypto/intel,keembay-ocs-ecc.yaml         |   47 +
 MAINTAINERS                                   |   11 +
 crypto/crypto_engine.c                        |   26 +
 crypto/ecc.c                                  |   14 +-
 crypto/ecdh.c                                 |    2 +-
 crypto/ecdsa.c                                |    2 +-
 crypto/ecrdsa.c                               |    2 +-
 crypto/ecrdsa_defs.h                          |    2 +-
 drivers/crypto/keembay/Kconfig                |   19 +
 drivers/crypto/keembay/Makefile               |    2 +
 drivers/crypto/keembay/keembay-ocs-ecc.c      | 1017 +++++++++++++++++
 include/crypto/engine.h                       |    5 +
 {crypto => include/crypto/internal}/ecc.h     |   36 +
 14 files changed, 1180 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
 create mode 100644 drivers/crypto/keembay/keembay-ocs-ecc.c
 rename {crypto => include/crypto/internal}/ecc.h (90%)


base-commit: 06f6e365e2ecf799c249bb464aa9d5f055e88b56
-- 
2.31.1

