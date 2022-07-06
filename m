Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F87C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 16:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiGFQ0b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbiGFQ02 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 12:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443EE26568;
        Wed,  6 Jul 2022 09:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D58C86119F;
        Wed,  6 Jul 2022 16:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DEEC341C8;
        Wed,  6 Jul 2022 16:26:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="G9bE9vsz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657124783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TGaoaskizVS4bcoAMHWjn1GMWg5VcBxmemnQ5JP+CXM=;
        b=G9bE9vszLnUC8XSrrd8LaQyfnEWe1NJZmlpsqEayowSRrVA9JC7ZUDvYkvz4EovFg1vUrh
        CpnPnJCNV6x2r9gzqislxbgio7lxlmSV/3b43DpNjsCU95MPPdi0PTXuyFWui2mZjB0oif
        d3Rx8S26M+bU1GQr9z3Ehojz2/uWRSE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8a8c7030 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 6 Jul 2022 16:26:23 +0000 (UTC)
Date:   Wed, 6 Jul 2022 18:26:17 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     Holger Dengler <dengler@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Message-ID: <YsW3qWkIwXboHgim@zx2c4.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com>
 <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
 <7e65130c6e66ce7a9f9eb469eb7e64e0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7e65130c6e66ce7a9f9eb469eb7e64e0@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Harald,

On Wed, Jul 06, 2022 at 06:18:27PM +0200, Harald Freudenberger wrote:
> On 2022-07-05 18:27, Holger Dengler wrote:
> > Hi Jason,
> > 
> > On 05/07/2022 17:11, Jason A. Donenfeld wrote:
> >> Hi Holger,
> >> 
> >> On Tue, Jul 05, 2022 at 04:58:30PM +0200, Holger Dengler wrote:
> >>> It is true, that the performance of the instruction is not really
> >>> relevant, but only for calls outside of an interrupt context. I did
> >>> some ftrace logging for the s390_random_get_seed_long() calls, and -
> >>> as you said - there are a few calls per minute. But there was also
> >>> some repeating calls in interrupt context. On systems with a huge
> >>> interrupt load, this can cause severe performance impacts. I've no
> >> 
> >> It'd be interesting to know more about this. The way you get
> >> arch_random_get_seed_long() from irq context is:
> >> 
> >> get_random_{bytes,int,long,u32,u64}()
> >>   crng_make_state()
> >>     crng_reseed() <-- Rarely
> >>       extract_entropy()
> >>         arch_get_random_seed_long()
> >> 
> >> So if an irq user of get_random_xx() is the unlucky one in the minute
> >> span who has to call crng_reseed() then, yea, that'll happen. But I
> >> wonder about this luck aspect. What scenarios are you seeing where 
> >> this
> >> happens all the time? Which driver is using random bytes *so* commonly
> >> from irq context? Not that, per say, there's anything wrong with that,
> >> but it could be eyebrow raising, and might point to de facto solutions
> >> that mostly take care of this.
> > 
> > I saw a few calls in interrupt context during my tracing, but I didn't
> > look to see which ones they were. Let me figure that out in the next
> > few days and provide more information on that.
> > 
> >> One such direction might be making a driver that does such a thing do 
> >> it
> >> a little bit less, somehow. Another direction would be preferring
> >> non-irqs to handle crng_reseed(), but not disallowing irqs entirely,
> >> with a patch something like the one below. Or maybe there are other
> >> ideas.
> > 
> > Reduce the number of trng in interrupt context is a possibility, but -
> > in my opinion - only one single trng instruction call in interrupt
> > context in one too much.
> > 
> > For the moment, I would propose to drop the buffering but also return
> > false, if arch_random_get_seed_long() is called in interrupt context.
> > 
> > diff --git a/arch/s390/include/asm/archrandom.h
> > b/arch/s390/include/asm/archrandom.h
> > index 2c6e1c6ecbe7..711357bdc464 100644
> > --- a/arch/s390/include/asm/archrandom.h
> > +++ b/arch/s390/include/asm/archrandom.h
> > @@ -32,7 +32,8 @@ static inline bool __must_check
> > arch_get_random_int(unsigned int *v)
> > 
> >  static inline bool __must_check arch_get_random_seed_long(unsigned 
> > long *v)
> >  {
> > -       if (static_branch_likely(&s390_arch_random_available)) {
> > +       if (static_branch_likely(&s390_arch_random_available) &&
> > +           !in_interrupt()) {
> >                 cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
> >                 atomic64_add(sizeof(*v), &s390_arch_random_counter);
> >                 return true;
> > 
> > (on-top of your commit, without our buffering patch)
> > 
> >> 
> >> But all this is to say that having some more of the "mundane" details
> >> about this might actually help us.
> >> 
> >> Jason
> >> 
> >> diff --git a/drivers/char/random.c b/drivers/char/random.c
> >> index e3dd1dd3dd22..81df8cdf2a62 100644
> >> --- a/drivers/char/random.c
> >> +++ b/drivers/char/random.c
> >> @@ -270,6 +270,9 @@ static bool crng_has_old_seed(void)
> >>  	static bool early_boot = true;
> >>  	unsigned long interval = CRNG_RESEED_INTERVAL;
> >> 
> >> +	if (in_hardirq())
> >> +		interval += HZ * 10;
> >> +
> >>  	if (unlikely(READ_ONCE(early_boot))) {
> >>  		time64_t uptime = ktime_get_seconds();
> >>  		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
> >> 
> 
> Hi Holger and Jason
> I tried to find out what is the reason of the invocations in interrupt 
> context.
> First I have to admit that there is in fact not much of 
> arch_get_random_seed_long()
> invocation any more in the recent kernel (5.19-rc5). I see about 100 
> invocations
> within 10 minutes with an LPAR running some qperf and dd dumps on dasds 
> test load.
> About half of these invocations is in interrupt context. I 
> dump_stack()ed some of
> these and I always catch the function
> kfence_guarded_alloc()
>    prandom_u32_max()
>      prandom_u32()
>        get_random_u32()
>          _get_random_bytes()
>            crng_make_state()
>              crng_reseed()
>                extract_entropy()
>                  arch_get_random_seed_long()
> 
> However, with so few invocations it should not make any harm when there 
> is a
> even very expensive trng() invocation in interrupt context.
> 
> But I think we should check, if this is really something to backport to 
> the older
> kernels where arch_get_random_seed_long() is called really frequency.

I backported the current random.c design to old kernels, so the
situation there should be the same as in 5.19-rc5.

So if you feel such rare usage is find even in_hardirq(), then I suppose
there's nothing more to do here?

Jason
