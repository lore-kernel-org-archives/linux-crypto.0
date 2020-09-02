Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2E0C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 10:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A1A2084C
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 10:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIBK2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 06:28:23 -0400
Received: from auth-smtp.nebula.fi ([217.149.52.145]:36107 "EHLO
        auth-smtp.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgIBK2W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 06:28:22 -0400
Received: from developer-Precision-3630-Tower (82-203-173-204.bb.dnainternet.fi [82.203.173.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: xipheracom)
        by auth-smtp.nebula.fi (Postfix) with ESMTPSA id 6527243AD;
        Wed,  2 Sep 2020 13:28:18 +0300 (EEST)
From:   Atte Tommiska <atte.tommiska@xiphera.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Atte Tommiska <atte.tommiska@xiphera.com>
Subject: [PATCH v3 0/3] hwrng: add support for Xiphera XIP8001B
Date:   Wed,  2 Sep 2020 13:28:14 +0300
Message-Id: <20200902102817.32172-1-atte.tommiska@xiphera.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset introduces a linux driver for Xiphera's XIP8001B IP.
The IP is an FPGA-based TRNG which can be used in various FPGA families.
The IP is in use in multiple customer projects and in Xiphera's own products.

changes in v2: 
  - fixed the 'make dt_binding_check' errors in the devicetree schema.

changes in v3: 
  - added Rob's tags to the first and second patch
  - fixed a typo in the subject line of the second patch
  - removed a redundant line of code from the driver in the third patch

Atte Tommiska (3):
  dt-bindings: vendor-prefixes: Add Xiphera vendor prefix
  dt-bindings: rng: add bindings for Xiphera XIP8001B hwrng
  hwrng: xiphera-trng: add support for XIP8001B hwrng

 .../bindings/rng/xiphera,xip8001b-trng.yaml   |  33 ++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 drivers/char/hw_random/Kconfig                |  10 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/xiphera-trng.c         | 150 ++++++++++++++++++
 5 files changed, 196 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml
 create mode 100644 drivers/char/hw_random/xiphera-trng.c


base-commit: 4c6491a343e91a5a2a699b0b545f8ba1ec1e8c65
-- 
2.28.0

