Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96749C35247
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 17:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78EBB217BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 17:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgBERXw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 12:23:52 -0500
Received: from foss.arm.com ([217.140.110.172]:49940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbgBERXw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 12:23:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB8BD1FB;
        Wed,  5 Feb 2020 09:23:51 -0800 (PST)
Received: from ssg-dev-vb.kfn.arm.com (E111385.Arm.com [10.50.4.77])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D044A3F52E;
        Wed,  5 Feb 2020 09:23:47 -0800 (PST)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Stefan Wahren <wahrenst@gmx.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>
Subject: [PATCH v3 0/3] hw_random: introduce Arm CryptoCell TRNG driver
Date:   Wed,  5 Feb 2020 19:23:22 +0200
Message-Id: <1580923405-28140-1-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Arm CryptoCell is a hardware security engine.
This patch introduces driver for its TRNG (True Random Number Generator)
engine.

v3 changes: removed few unneeded "#ifdef CONFIG_PM" from the code.

v2 changes: fixed 'make dt_bnding_check' errors.

Hadar Gat (3):
  dt-bindings: add device tree binding for Arm CryptoCell trng engine
  hw_random: cctrng: introduce Arm CryptoCell driver
  MAINTAINERS: add HG as cctrng maintainer

 .../devicetree/bindings/rng/arm-cctrng.yaml        |  51 ++
 MAINTAINERS                                        |   9 +
 drivers/char/hw_random/Kconfig                     |  12 +
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/cctrng.c                    | 766 +++++++++++++++++++++
 drivers/char/hw_random/cctrng.h                    |  69 ++
 6 files changed, 908 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/arm-cctrng.yaml
 create mode 100644 drivers/char/hw_random/cctrng.c
 create mode 100644 drivers/char/hw_random/cctrng.h

-- 
2.7.4

