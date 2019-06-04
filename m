Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF0DC28CC6
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3993420874
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="PvF4LzwJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfFDUbc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:31:32 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:63635 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfFDUbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 16:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559680291; x=1591216291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GcMoPRXMHB7SOwtcOdUWfd9ABsMHYh/l/vnzcxwmq0E=;
  b=PvF4LzwJP/2+qkL4b6iZPQT9gwP54T7Ys/5RvhMAABx50/TQekh2DTMc
   ybdIHuHMemmKzLvMC2d+leNntiR96vPoDSfNgCA/tkoR0HoeYFDzaUT6P
   c5BgTzpIPT9eGlKOPREZae4k2S9QjOBmRDsITLzB3f1n3w4uIw5Nl0Ije
   s=;
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="803552790"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Jun 2019 20:31:29 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 554C11A0D0E;
        Tue,  4 Jun 2019 20:31:29 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:28 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:28 +0000
Received: from dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com
 (10.200.136.151) by mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 4 Jun 2019 20:31:28 +0000
Received: by dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com (Postfix, from userid 5131138)
        id 9D9CC47DE5; Tue,  4 Jun 2019 20:31:28 +0000 (UTC)
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
Subject: [PATCH 1/3] arm/arm64: Add smccc hypervisor service identifiers
Date:   Tue, 4 Jun 2019 20:30:58 +0000
Message-ID: <20190604203100.15050-2-alisaidi@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20190604203100.15050-1-alisaidi@amazon.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SMC calling convention defines service identifiers for generic and
vendor specific hypervisor services. This patch adds those services to
the list of existing service identifiers.

Signed-off-by: Ali Saidi <alisaidi@amazon.com>
---
 include/linux/arm-smccc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 18863d56273c..bcf796801e3b 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -54,6 +54,8 @@
 #define ARM_SMCCC_OWNER_SIP		2
 #define ARM_SMCCC_OWNER_OEM		3
 #define ARM_SMCCC_OWNER_STANDARD	4
+#define ARM_SMCCC_OWNER_STANDARD_HV	5
+#define ARM_SMCCC_OWNER_VENDOR_HV	6
 #define ARM_SMCCC_OWNER_TRUSTED_APP	48
 #define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
-- 
2.15.3.AMZN

