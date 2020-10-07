Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C37C4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 19:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5002C20872
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 19:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcN3zsM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgJGTlX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgJGTlX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 15:41:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF35C061755;
        Wed,  7 Oct 2020 12:41:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id n6so3390721wrm.13;
        Wed, 07 Oct 2020 12:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BlXTl6Hst6j2ZWlhRy8AiZeKdtWqE6ffJKL4bR3bTTQ=;
        b=kcN3zsM/ZtIXY6Z3zNNaFiikNc/iRaBZnxWvNYxoXEUtzNiHbwXZE4CR024aHVJEt3
         dXZoZeL6K3E3uWH8Xp9tFUjWpzrtRdRM9v1kwZdo7Ed4w0h6bFcL0v1ixtz9pjUhzzkE
         TU/3b5FJtRRkNVZVxbNiInzha9rZEHRsxWTUTlUN2rhDPp6S+3m1pN6xficRXceeERJ7
         QCkvpeB5aJ4MuBZnnXgrkAep6Rt5RGtqj1tYUiMsArrJSipocmOvPJ0Z6gelvX/+YHaq
         bBPMlYl0XA9kURPuUbQuH42W/milxSPmX4C/iLklEzeXB9/C12CppD3jJbhAvWIhw09i
         a+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BlXTl6Hst6j2ZWlhRy8AiZeKdtWqE6ffJKL4bR3bTTQ=;
        b=JmmGgUb5jJhH8KXazu1Z10EHToVqUIu7kLExO/L0e7PlepPq/kIhjqVeg/AFgiqyYO
         heZzZqp78dB92yadWJ+pDGpUa/q7T4LVkNovO2j+y4LI05jMfRkf+gLU/tMs7gMy6V8U
         /4dab/j99xxfYGBdX1H2Wgh0x97///Bw7F1NWHgs1PR2DmJFmryROstF/sRrErg5Pjpp
         OODRGgUOuRco9LlMb9k2Y/+VZpqpCK/8nCkiidLoQMxmgacexYdbi2/v86NJQ/jc/Q/S
         uI4qPcLKTsLWHJT9qQwTtaIKC55290co8rKTHD0R/tb7QtQ0Ktg8aNbp2Pq3t/JXhQUK
         Y9ng==
X-Gm-Message-State: AOAM530qtLiA+K/nQViK/wKe4z/M8GVfclsTSkT3eP8fIrJWY6WQxwlQ
        wss44cqzmgPd7v91qdvyMkQ=
X-Google-Smtp-Source: ABdhPJy/7viZdAja+X9JBIUZBanX5mxDMsnzvuFIPvUeDKF3xHLhGKTLJJ0EwcgvuZBD0cR6EcQ74A==
X-Received: by 2002:adf:ce01:: with SMTP id p1mr4928562wrn.33.1602099680845;
        Wed, 07 Oct 2020 12:41:20 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id c1sm4156555wru.49.2020.10.07.12.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 12:41:19 -0700 (PDT)
Date:   Wed, 7 Oct 2020 21:41:17 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, mark.rutland@arm.com,
        jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, tj@kernel.org,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20201007194117.GA4859@Red>
References: <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <e7c92da2-42c0-a97d-7427-6fdc769b41b9@arm.com>
 <20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com>
 <20201001175022.GA22444@Red>
 <20201005170910.vxwrdwnzlw3ahkb4@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005170910.vxwrdwnzlw3ahkb4@ca-dmjordan1.us.oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 05, 2020 at 01:09:10PM -0400, Daniel Jordan wrote:
> On Thu, Oct 01, 2020 at 07:50:22PM +0200, Corentin Labbe wrote:
> > On Tue, Mar 03, 2020 at 04:30:17PM -0500, Daniel Jordan wrote:
> > > Barring other ideas, Corentin, would you be willing to boot with
> > > 
> > >     trace_event=initcall:*,module:* trace_options=stacktrace
> > > 
> > > and
> > > 
> > > diff --git a/kernel/module.c b/kernel/module.c
> > > index 33569a01d6e1..393be6979a27 100644
> > > --- a/kernel/module.c
> > > +++ b/kernel/module.c
> > > @@ -3604,8 +3604,11 @@ static noinline int do_init_module(struct module *mod)
> > >  	 * be cleaned up needs to sync with the queued work - ie
> > >  	 * rcu_barrier()
> > >  	 */
> > > -	if (llist_add(&freeinit->node, &init_free_list))
> > > +	if (llist_add(&freeinit->node, &init_free_list)) {
> > > +		pr_warn("%s: schedule_work for mod=%s\n", __func__, mod->name);
> > > +		dump_stack();
> > >  		schedule_work(&init_free_wq);
> > > +	}
> > >  
> > >  	mutex_unlock(&module_mutex);
> > >  	wake_up_all(&module_wq);
> > > 
> > > but not my earlier fix and share the dmesg and ftrace output to see if the
> > > theory holds?
> > > 
> > > Also, could you attach your config?  Curious now what your crypto options look
> > > like after fiddling with some of them today while trying and failing to see
> > > this on x86.
> > > 
> > > thanks,
> > > Daniel
> > 
> > Hello
> > 
> > Sorry for the very delayed answer.
> > 
> > I fail to reproduce it on x86 (qemu and  real hw) and arm.
> > It seems to only happen on arm64.
> 
> Thanks for the config and dmesg, but there's no ftrace.  I see it's not
> configured in your kernel, so could you boot with my earlier debug patch plus
> this one and the kernel argument initcall_debug instead?
> 
> I'm trying to see whether it really is a request module call from the crypto
> tests that's triggering this warning.  Preeetty likely that's what's happening,
> but want to be sure since I can't reproduce this.  Then I can post the fix.
> 

I have added CONFIG_FTRACE=y and your second patch.
The boot log can be seen at http://kernel.montjoie.ovh/108789.log

But it seems the latest dump_stack addition flood a bit.
I have started to read ftrace documentation, but if you have a quick what to do in /sys/kernel/debug/tracing, it will be helpfull.

