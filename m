Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC48C282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B017F208CB
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ta7hdhGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfFDUbz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:31:55 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10746 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFDUbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 16:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559680292; x=1591216292;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Qvgi9EebcCKTkJL3XH6n75abRSmA+1KjL0uPQ7HHAeo=;
  b=Ta7hdhGDoJNbDuzf92aEfFIfqNN7443vpBk8sGQTF9UWGhbUKN9ieR59
   gsOnxsL2GrXJiVmfPM2HkOzhTY9q92lesBR/VXMUAM+pHEjrLOA09O8jI
   BKOzdV6ci24zWxs9CLvPCpUGLHq9Yr61HX8G6106erqcQDVO2MscpDLhF
   o=;
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="399352827"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 04 Jun 2019 20:31:30 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id 4FA1CA21DD;
        Tue,  4 Jun 2019 20:31:29 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:28 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:28 +0000
Received: from dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com
 (10.200.136.151) by mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 4 Jun 2019 20:31:28 +0000
Received: by dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com (Postfix, from userid 5131138)
        id 9A8BA47DE4; Tue,  4 Jun 2019 20:31:28 +0000 (UTC)
From:   Ali Saidi <alisaidi@amazon.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ali Saidi <alisaidi@amazon.com>,
        Ron Rindjunsky <ronrindj@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 0/3] Add support for Graviton TRNG
Date:   Tue, 4 Jun 2019 20:30:57 +0000
Message-ID: <20190604203100.15050-1-alisaidi@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AWS Graviton based systems provide an Arm SMC call in the vendor defined
hypervisor region to read random numbers from a HW TRNG and return them to the
guest. 

We've observed slower guest boot and especially reboot times due to lack of
entropy and providing access to a TRNG is meant to address this. 

Ali Saidi (3):
  arm/arm64: Add smccc hypervisor service identifiers
  arm64: export acpi_psci_use_hvc
  hwrng: Add support for AWS Graviton TRNG

 MAINTAINERS                           |   6 ++
 arch/arm64/kernel/acpi.c              |   1 +
 drivers/char/hw_random/Kconfig        |  13 ++++
 drivers/char/hw_random/Makefile       |   1 +
 drivers/char/hw_random/graviton-rng.c | 123 ++++++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h             |   2 +
 6 files changed, 146 insertions(+)
 create mode 100644 drivers/char/hw_random/graviton-rng.c

-- 
2.15.3.AMZN

