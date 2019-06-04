Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC68C28CC3
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A91C920B7C
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ImJawrh9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFDUbj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:31:39 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:63635 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfFDUbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 16:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559680292; x=1591216292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ppSMBj7M9LtRxxqAyTLnY4a7CzGJ8fmmTXh653jqMx0=;
  b=ImJawrh92G4IcGwV+bGi6VC3PDTPYdQcX4GGchcf2kSMs22pKadHdNJa
   KZKf/N7Juw7l74gpKiPfnmQbCcx4iDXqGTc0eEd8jpsEdxXOctYD3PCf8
   6CK7rezVtXE22nzAK2zONpRw4SdSXVdImR/kOvLhxHP/6QfwW74+M1Flj
   E=;
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="803552791"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Jun 2019 20:31:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 8F374A20A1;
        Tue,  4 Jun 2019 20:31:29 +0000 (UTC)
Received: from EX13D02UWB003.ant.amazon.com (10.43.161.48) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:29 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D02UWB003.ant.amazon.com (10.43.161.48) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:28 +0000
Received: from dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com
 (10.200.136.151) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 4 Jun 2019 20:31:29 +0000
Received: by dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com (Postfix, from userid 5131138)
        id A0CA347DE6; Tue,  4 Jun 2019 20:31:28 +0000 (UTC)
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
Subject: [PATCH 2/3] arm64: export acpi_psci_use_hvc
Date:   Tue, 4 Jun 2019 20:30:59 +0000
Message-ID: <20190604203100.15050-3-alisaidi@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20190604203100.15050-1-alisaidi@amazon.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow a module that wants to make SMC calls to detect if it should be
using smc or hvc.

Signed-off-by: Ali Saidi <alisaidi@amazon.com>
---
 arch/arm64/kernel/acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 803f0494dd3e..ea41c6541d3c 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -119,6 +119,7 @@ bool acpi_psci_use_hvc(void)
 {
 	return acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC;
 }
+EXPORT_SYMBOL_GPL(acpi_psci_use_hvc);
 
 /*
  * acpi_fadt_sanity_check() - Check FADT presence and carry out sanity
-- 
2.15.3.AMZN

