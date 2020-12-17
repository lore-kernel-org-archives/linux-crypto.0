Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC702C2BBCA
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B726C238EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgLQRXO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:23:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:47104 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgLQRXO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 12:23:14 -0500
IronPort-SDR: HVc1NM6ruPs8GOrpr9o1wKQI/vdpSmslRZXbtXWo2wd22WMYZeCMlgXt7m/Z+Jr4rxnnSc/uwo
 nFyXVlxvFceg==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="260017867"
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="260017867"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:27 -0800
IronPort-SDR: 9SjjL7ULRooZsCAYJjJ2L0Yu1O3NW4pFY90CT9yLMhTTzaxb6aRdy+bvZdsBCXr6uzqry0GE1u
 o0f8wKS7t1hg==
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="369930920"
Received: from cdonohoe-mobl2.ger.corp.intel.com (HELO dalessan-mobl1.ir.intel.com) ([10.252.13.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2020 09:21:24 -0800
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Date:   Thu, 17 Dec 2020 17:20:55 +0000
Message-Id: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I'm posting this patch series as RFC since there are a few open points on
which I'd like to have the opinion of the crypto maintainers and the rest of
kernel community.

The patch series adds the Intel Keem Bay OCS ECC crypto driver, which
enables hardware-accelerated ECDH on the Intel Keem Bay SoC.

The open points are the followings:

1. The OCS ECC HW supports the NIST P-384 curve, which, however, is not
   supported by Linux ECDH software implementation ('crypto/ecdh.c').
   Support for P-384 is added to the driver anyway by reserving a curve id
   for P-384 in 'include/crypto/ecdh.h' and defining the cure parameters in
   'drivers/crypto/keembay/ocs-ecc-curve-defs.h'. Is this reasonable?

2. The OCS ECC HW does not support the NIST P-192 curve. We were planning to
   add SW fallback for P-192 in the driver, but the Intel Crypto team
   (which, internally, has to approve any code involving cryptography)
   advised against it, because they consider P-192 weak. As a result, the
   driver is not passing crypto self-tests. Is there any possible solution
   to this? Is it reasonable to change the self-tests to only test the
   curves actually supported by the tested driver? (not fully sure how to do
   that).

3. Another request from our crypto team was to make private key generation
   optional in the driver, since they advice against automatic key
   generation. As a result, the driver passes the P-256 self test only when
   CONFIG_CRYPTO_DEV_KEEMBAY_OCS_ECDH_GEN_PRIV_KEY_SUPPORT=y. Is that
   acceptable?


Daniele Alessandrelli (2):
  crypto: ecc - Move ecc.h to include/crypto/internal
  crypto: ecc - Export additional helper functions

Prabhjot Khurana (4):
  crypto: engine - Add KPP Support to Crypto Engine
  crypto: ecdh - Add Curve ID for NIST P-384
  dt-bindings: crypto: Add Keem Bay ECC bindings
  crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC Driver

 Documentation/crypto/crypto_engine.rst        |    4 +
 .../crypto/intel,keembay-ocs-ecc.yaml         |   47 +
 MAINTAINERS                                   |   11 +
 crypto/crypto_engine.c                        |   27 +
 crypto/ecc.c                                  |   18 +-
 crypto/ecdh.c                                 |    2 +-
 crypto/ecrdsa.c                               |    2 +-
 crypto/ecrdsa_defs.h                          |    2 +-
 drivers/crypto/keembay/Kconfig                |   31 +
 drivers/crypto/keembay/Makefile               |    2 +
 drivers/crypto/keembay/keembay-ocs-ecc.c      | 1003 +++++++++++++++++
 drivers/crypto/keembay/ocs-ecc-curve-defs.h   |   68 ++
 include/crypto/ecdh.h                         |    1 +
 include/crypto/engine.h                       |    5 +
 {crypto => include/crypto/internal}/ecc.h     |   44 +
 15 files changed, 1257 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
 create mode 100644 drivers/crypto/keembay/keembay-ocs-ecc.c
 create mode 100644 drivers/crypto/keembay/ocs-ecc-curve-defs.h
 rename {crypto => include/crypto/internal}/ecc.h (87%)


base-commit: 90cc8cf2d1ab87d708ebc311ac104ccbbefad9fc
-- 
2.26.2

