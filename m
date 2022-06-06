Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3742DC43334
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jun 2022 06:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiFFGtx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jun 2022 02:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiFFGtw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jun 2022 02:49:52 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9471148
        for <linux-crypto@vger.kernel.org>; Sun,  5 Jun 2022 23:49:49 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 2566YuTK035312;
        Mon, 6 Jun 2022 14:34:56 +0800 (GMT-8)
        (envelope-from neal_liu@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.10) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 14:49:40 +0800
From:   Neal Liu <neal_liu@aspeedtech.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        "Andrew Jeffery" <andrew@aj.id.au>,
        Johnny Huang <johnny_huang@aspeedtech.com>
CC:     <linux-aspeed@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <BMC-SW@aspeedtech.com>
Subject: [PATCH v2 0/5] Add Aspeed crypto driver for hardware acceleration
Date:   Mon, 6 Jun 2022 14:49:30 +0800
Message-ID: <20220606064935.1458903-1-neal_liu@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.10.10]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 2566YuTK035312
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Aspeed Hash and Crypto Engine (HACE) is designed to accelerate the
throughput of hash data digest, encryption and decryption.

These patches aim to add Aspeed hash & crypto driver support.
The hash & crypto driver also pass the run-time self tests that
take place at algorithm registration.

Tested-by below configs:
- CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
- CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
- CONFIG_DMA_API_DEBUG=y
- CONFIG_DMA_API_DEBUG_SG=y

Change since v1:
- Add more error handlers, including DMA memory allocate/free, DMA
  map/unmap, clock enable/disable, etc.
- Fix check dma_map error for config DMA_API_DEBUG
- Fix dt-binding doc & dts node naming


Neal Liu (5):
  crypto: aspeed: Add HACE hash driver
  dt-bindings: clock: Add AST2600 HACE reset definition
  ARM: dts: aspeed: Add HACE device controller node
  dt-bindings: crypto: add documentation for aspeed hace
  crypto: aspeed: add HACE crypto driver

 .../bindings/crypto/aspeed,ast2500-hace.yaml  |   53 +
 MAINTAINERS                                   |    7 +
 arch/arm/boot/dts/aspeed-g6.dtsi              |    8 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/aspeed/Kconfig                 |   38 +
 drivers/crypto/aspeed/Makefile                |    8 +
 drivers/crypto/aspeed/aspeed-hace-crypto.c    | 1028 ++++++++++++
 drivers/crypto/aspeed/aspeed-hace-hash.c      | 1409 +++++++++++++++++
 drivers/crypto/aspeed/aspeed-hace.c           |  350 ++++
 drivers/crypto/aspeed/aspeed-hace.h           |  292 ++++
 include/dt-bindings/clock/ast2600-clock.h     |    1 +
 12 files changed, 3196 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/aspeed,ast2500-hace.yaml
 create mode 100644 drivers/crypto/aspeed/Kconfig
 create mode 100644 drivers/crypto/aspeed/Makefile
 create mode 100644 drivers/crypto/aspeed/aspeed-hace-crypto.c
 create mode 100644 drivers/crypto/aspeed/aspeed-hace-hash.c
 create mode 100644 drivers/crypto/aspeed/aspeed-hace.c
 create mode 100644 drivers/crypto/aspeed/aspeed-hace.h

-- 
2.25.1

