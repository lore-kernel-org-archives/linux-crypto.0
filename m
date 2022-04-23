Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB8AC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Apr 2022 21:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbiDWVbt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Apr 2022 17:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237205AbiDWVbl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Apr 2022 17:31:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E079F4F447;
        Sat, 23 Apr 2022 14:27:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35033B80B1D;
        Sat, 23 Apr 2022 21:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C5FC385A5;
        Sat, 23 Apr 2022 21:27:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eatu7IA+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1650749263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5nR87uOKXXd54FwCfFxFI6wdMpbbvs52+8XcBr77mU=;
        b=eatu7IA+OSvreuJMcyPb347ZycJdSP0rPhpv4kAPSZBhbS5W2jQsoBz/k2t8+okeHWY7ld
        WcODHNb8DMoDyowVFKKKaVr3bcXvx7OFH3RM/xEUX6yrrb80iwg7MOWPaMCUPju9txjFt2
        nlqI+oJ9x97XcHLLhBm4AMjJvWfTEeY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3aaca72a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 23 Apr 2022 21:27:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, arnd@arndb.de
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v6 15/17] sparc: use fallback for random_get_entropy() instead of zero
Date:   Sat, 23 Apr 2022 23:26:21 +0200
Message-Id: <20220423212623.1957011-16-Jason@zx2c4.com>
In-Reply-To: <20220423212623.1957011-1-Jason@zx2c4.com>
References: <20220423212623.1957011-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling random_get_entropy_fallback() would be
preferable, because that always needs to return _something_, even
falling back to jiffies eventually. It's not as though
random_get_entropy_fallback() is super high precision or guaranteed to
be entropic, but basically anything that's not zero all the time is
better than returning zero all the time.

This is accomplished by just including the asm-generic code like on
other architectures, which means we can get rid of the empty stub
function here.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/sparc/include/asm/timex_32.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/timex_32.h b/arch/sparc/include/asm/timex_32.h
index 542915b46209..f86326a6f89e 100644
--- a/arch/sparc/include/asm/timex_32.h
+++ b/arch/sparc/include/asm/timex_32.h
@@ -9,8 +9,6 @@
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 
-/* XXX Maybe do something better at some point... -DaveM */
-typedef unsigned long cycles_t;
-#define get_cycles()	(0)
+#include <asm-generic/timex.h>
 
 #endif
-- 
2.35.1

