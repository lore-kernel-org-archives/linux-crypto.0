Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39CFC4338F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Jul 2021 20:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA54060EEA
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Jul 2021 20:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhGaUtj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Jul 2021 16:49:39 -0400
Received: from foss.arm.com ([217.140.110.172]:52358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhGaUti (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Jul 2021 16:49:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C095ED6E;
        Sat, 31 Jul 2021 13:49:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 979383F70D;
        Sat, 31 Jul 2021 13:49:29 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Ali Saidi <alisaidi@amazon.com>,
        Jon Nettleton <jon@solid-run.com>
Subject: [PATCH v4 0/2] hwrng: Add Arm SMCCC TRNG based driver
Date:   Sat, 31 Jul 2021 21:48:43 +0100
Message-Id: <20210731204845.21196-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "Arm True Random Number Generator Firmware Interface"[1] provides
an SMCCC based interface to a true hardware random number generator.
So far we are using that in arch_get_random_seed(), but it might be
useful to expose the entropy through the /dev/hwrng device as well. This
allows to assess the quality of the implementation, by using "rngtest"
from the rng-tools package, for example.

Patch 1 creates a platform device, triggered by the previous discovery
of the SMCCC TRNG service.
Patch 2 implements a hw_random platform driver, which is instantiated
through this said platform device.

The driver can be loaded as module, or built into the kernel.

[1] https://developer.arm.com/documentation/den0098/latest/

Changelog v3 ... v4:
- drop pointless driver loading message
- drop unneeded init() routine

Changelog v2 ... v3:
- split platform device and driver

Changelog v1 ... v2:
- fix building as a module
- de-register device upon exit
- mention module name in Kconfig

Andre Przywara (2):
  firmware: smccc: Register smccc_trng platform device
  hwrng: Add Arm SMCCC TRNG based driver

 drivers/char/hw_random/Kconfig          |  14 +++
 drivers/char/hw_random/Makefile         |   1 +
 drivers/char/hw_random/arm_smccc_trng.c | 123 ++++++++++++++++++++++++
 drivers/firmware/smccc/smccc.c          |  17 ++++
 4 files changed, 155 insertions(+)
 create mode 100644 drivers/char/hw_random/arm_smccc_trng.c

-- 
2.17.6

