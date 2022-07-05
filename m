Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776E7C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 15:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiGEPLz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 11:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiGEPLl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 11:11:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D506E15FDE;
        Tue,  5 Jul 2022 08:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71AF961A7E;
        Tue,  5 Jul 2022 15:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BFBC341C7;
        Tue,  5 Jul 2022 15:11:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="k6VAxRI9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657033895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v9T9TO3qcwLamzzcyuNnEB7BYisQks50EClJQ2Qj1II=;
        b=k6VAxRI9ebD6GT5qQLKpTuUIceH11DeTjPY/RbVjuFGKg8Zbb+1jgXm07r+Rupuiu+FiNo
        pcsDwm9Ma6QP0ZmG0YNPguq7h7/nrxQ93MBcqDy7YKX2cO3DlcQfA367WuAma6tp7XEH1U
        aIk1T1ZRmzVRN9/1YtrGzeG+3OMEBMk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b99a77a0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 15:11:34 +0000 (UTC)
Date:   Tue, 5 Jul 2022 17:11:31 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Holger Dengler <dengler@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Message-ID: <YsRUowTs9n98p9EL@zx2c4.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com>
 <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Holger,

On Tue, Jul 05, 2022 at 04:58:30PM +0200, Holger Dengler wrote:
> It is true, that the performance of the instruction is not really
> relevant, but only for calls outside of an interrupt context. I did
> some ftrace logging for the s390_random_get_seed_long() calls, and -
> as you said - there are a few calls per minute. But there was also
> some repeating calls in interrupt context. On systems with a huge
> interrupt load, this can cause severe performance impacts. I've no

It'd be interesting to know more about this. The way you get
arch_random_get_seed_long() from irq context is:

get_random_{bytes,int,long,u32,u64}()
  crng_make_state()
    crng_reseed() <-- Rarely
      extract_entropy()
        arch_get_random_seed_long()

So if an irq user of get_random_xx() is the unlucky one in the minute
span who has to call crng_reseed() then, yea, that'll happen. But I
wonder about this luck aspect. What scenarios are you seeing where this
happens all the time? Which driver is using random bytes *so* commonly
from irq context? Not that, per say, there's anything wrong with that,
but it could be eyebrow raising, and might point to de facto solutions
that mostly take care of this.

One such direction might be making a driver that does such a thing do it
a little bit less, somehow. Another direction would be preferring
non-irqs to handle crng_reseed(), but not disallowing irqs entirely,
with a patch something like the one below. Or maybe there are other
ideas.

But all this is to say that having some more of the "mundane" details
about this might actually help us.

Jason

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e3dd1dd3dd22..81df8cdf2a62 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -270,6 +270,9 @@ static bool crng_has_old_seed(void)
 	static bool early_boot = true;
 	unsigned long interval = CRNG_RESEED_INTERVAL;

+	if (in_hardirq())
+		interval += HZ * 10;
+
 	if (unlikely(READ_ONCE(early_boot))) {
 		time64_t uptime = ktime_get_seconds();
 		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)

