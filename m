Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75306C7EE32
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Jun 2023 15:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbjFCPf2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Jun 2023 11:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjFCPfH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2023 11:35:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E4F123;
        Sat,  3 Jun 2023 08:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685806507; x=1717342507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=+YuUSbnWKYlNrEuY9wZwu6rqIXV81jiJurK8saoa8ho=;
  b=IPGwlJjtHIOuknD+ntiJi93vcmpgNgOH9ShLRr5q340I4G41iYXBRRrz
   1DqP/0617EEbitY6+ZIs15ConNO6UQLOfFjwcoAAUEXxjh/60r2JxON83
   FGzirX02VQ6Poy8XYMOhRLroe2bod1zU0Qgzedbyw0D3kvYO9v1nPWjuY
   HalTrG65+1v4f/r0EwggcUCajIuY99RtQuqaGar4g4uojgQ456YU3ZZa3
   qn7isEl+fNYVJhYpfPW2uS1Jx0pfiQGiWxI2H3nJJkpJkEWy0cbwAQDLv
   T9+QFNlyLikqZTH7OLwxOzMY3yh/657SoenAXGHfgn9k3Mc4jH8XAmWlt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="356097428"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="356097428"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 08:35:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="702274258"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; 
   d="scan'208";a="702274258"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by orsmga007.jf.intel.com with ESMTP; 03 Jun 2023 08:35:05 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com
Cc:     ebiggers@kernel.org, elliott@hpe.com, gmazyland@gmail.com,
        luto@kernel.org, dave.hansen@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de, mingo@kernel.org, x86@kernel.org,
        herbert@gondor.apana.org.au, ardb@kernel.org,
        dan.j.williams@intel.com, bernie.keany@intel.com,
        charishma1.gairuboyina@intel.com,
        lalithambika.krishnakumar@intel.com, nhuck@google.com,
        chang.seok.bae@intel.com, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v8 06/12] x86/keylocker: Define Key Locker CPUID leaf
Date:   Sat,  3 Jun 2023 08:22:21 -0700
Message-Id: <20230603152227.12335-7-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230603152227.12335-1-chang.seok.bae@intel.com>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Both Key Locker enabling code in the x86 core and AES Key Locker code
in the crypto library will need to reference some CPUID bits. Define
these feature-specific CPUID leaf and bits.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v6:
* Tweak the changelog -- comment the reason first and then brief the
  change.

Changes from RFC v2:
* Separate out the code as a new patch.
---
 arch/x86/include/asm/keylocker.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
index 9b3bec452b31..1717e0866254 100644
--- a/arch/x86/include/asm/keylocker.h
+++ b/arch/x86/include/asm/keylocker.h
@@ -5,6 +5,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/bits.h>
 #include <asm/fpu/types.h>
 
 /**
@@ -21,5 +22,11 @@ struct iwkey {
 	struct reg_128_bit encryption_key[2];
 };
 
+#define KEYLOCKER_CPUID			0x019
+#define KEYLOCKER_CPUID_EAX_SUPERVISOR	BIT(0)
+#define KEYLOCKER_CPUID_EBX_AESKLE	BIT(0)
+#define KEYLOCKER_CPUID_EBX_WIDE	BIT(2)
+#define KEYLOCKER_CPUID_EBX_BACKUP	BIT(4)
+
 #endif /*__ASSEMBLY__ */
 #endif /* _ASM_KEYLOCKER_H */
-- 
2.17.1

