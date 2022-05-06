Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1914C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 May 2022 07:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389789AbiEFIC7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 May 2022 04:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389792AbiEFIC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 May 2022 04:02:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671D567D1D;
        Fri,  6 May 2022 00:59:16 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651823954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SPOE0gYWj9j1dUjvgP39Og9ua3b0mQKYArT3BeYIUVI=;
        b=255WrnOczyR8EQwEk84iFJCj7oJ4quj5izYkLwsSq66vyRivpLwlq/pzCLKdSma1xzKEzh
        LNdM83Cwb2R36TqLk3wXJygrGjsD9Dgs+XpP5gAXFp0gDfQLYp8if4ybJG89BIE1UzhfaY
        XH3R8Rz0YYqdGVfivs86USKPOop6pSfFUQWEpVF/wGdAih70WGXSRLaEWsn68XKdReifig
        UZp1vw0ODYvXvzx9BgK90PQ2XnWbcpf5n2EqOZZQD1kDcQc8AA9AAEr1Wb0DYYVrQZjZ0h
        GDe+ZTOnoCi6DViTIX0SGN5dQhSsspMkMMEADk4lUutXu/21TeFf8URptclHZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651823954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SPOE0gYWj9j1dUjvgP39Og9ua3b0mQKYArT3BeYIUVI=;
        b=pevZyCpSMuLeLpDdi23KVJ4rQtQaXyYYUTbDx6+vxW8a/19C9mM8QlRtryJ71e/4Bqt67m
        2tO7cvcCscS9otDw==
To:     kernel test robot <oliver.sang@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     0day robot <lkp@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Theodore Ts'o <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        linux-crypto@vger.kernel.org, nathan@kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [timekeeping]  3aeaac747d: PANIC:early_exception
In-Reply-To: <20220506032023.GA23061@xsang-OptiPlex-9020>
References: <20220506032023.GA23061@xsang-OptiPlex-9020>
Date:   Fri, 06 May 2022 09:59:13 +0200
Message-ID: <8735hnhz1q.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 06 2022 at 11:20, kernel test robot wrote:
> PANIC: early exception 0x0d IP 10:ffffffff812cef11 error 0 cr2 0xffff888004a3aff8
> [ 0.000000][ T0] add_device_randomness (kbuild/src/rand-3/drivers/char/random.c:1028) 
> [ 0.000000][ T0] ? dmi_walk_early (kbuild/src/rand-3/drivers/firmware/dmi_scan.c:470) 
> [ 0.000000][ T0] dmi_walk_early (kbuild/src/rand-3/drivers/firmware/dmi_scan.c:151) 
> [ 0.000000][ T0] dmi_present (kbuild/src/rand-3/drivers/firmware/dmi_scan.c:605)

Duh.

So this wants to be:

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2380,6 +2381,20 @@ static int timekeeping_validate_timex(co
 	return 0;
 }
 
+/**
+ * random_get_entropy_fallback - Returns the raw clock source value,
+ * used by random.c for platforms with no valid random_get_entropy().
+ */
+unsigned long random_get_entropy_fallback(void)
+{
+	struct tk_read_base *tkr = &tk_core.timekeeper.tkr_mono;
+	struct clocksource *clock = READ_ONCE(tkr->clock);
+
+	if (!timekeeping_suspended && clock)
+		return clock->read(clock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(random_get_entropy_fallback);
 
 /**
  * do_adjtimex() - Accessor function to NTP __do_adjtimex function
