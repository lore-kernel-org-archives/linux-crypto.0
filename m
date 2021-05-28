Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B493BC2B9F7
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 14:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9387F613EB
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 14:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhE1Ovd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 10:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbhE1Ovc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 10:51:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126AC061574
        for <linux-crypto@vger.kernel.org>; Fri, 28 May 2021 07:49:57 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l18-20020a1c79120000b0290181c444b2d0so2534918wme.5
        for <linux-crypto@vger.kernel.org>; Fri, 28 May 2021 07:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k4/Q9LKJZ/p6Cfz4YScBzLWuD3IoHybG41Fusz0viNw=;
        b=DjqQFgPMrmgF8ovO8dwMR4Nfxhev3NPadgHxm1SDIFyXXyUwa8KmTLbkwDNXfKAM6e
         p05dlo8Ik9Z8QMaHhPW1N5Oe4p9jKMSXbXNkE0YHyqhab5nMGz9AmG6mAq7uk54J6BjS
         kmciIFCM3oFeFeTLJ+IT+unKBzlbwZEGmxWeDVjebizU/pNUQq9O+pnNYuWQ0FbdhdKG
         dF35OtPqiweR5FY3x5MOdr7B29DeWnJIsgmupQWchKK+87/hl/DVpIkMgg209sAEKl2h
         LhnnyS0/RpjKfC0Ld9Ac7lTUv+b9pWkogobWVDsVuFiQI9S/OxP1+Ot266WSPUznzsKL
         p1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k4/Q9LKJZ/p6Cfz4YScBzLWuD3IoHybG41Fusz0viNw=;
        b=n4Dq7Y9HtG8rlCpEbYGXsOp02y3CZXEu0BEZ70i/OpMKCpAG9CLMpZN7tmIgpRdrFg
         eyVYtNJiUxxurx2j4ChcWfve7bCRrVNQObov5gxjplMinz9mLcudgwZXLXw2zvFPygim
         +tgJrT8RpfFqUvyraF0ToKvMrikxxhAWoZMzab6XyMKiMOvX5SrdZZg+PjWV8TFW5n5Y
         seHzXKT1Pqsjuo5zC9j7fh8PElLNLjZRJrmbKsV9ymYWOTqSxtqmsPomhQb9X4VsJHTK
         HzjbNtJRNX/FGQWWpEeriXwMXCqQNaAAaXPBrIbo3PlJphrCFjdFxthc9G4iu5hXer7I
         2Lbw==
X-Gm-Message-State: AOAM533fFkS64+LD/bYvsFEs7pQM+DPxKi2wl29WghgyEeJxYw8R+K+Y
        jK7eSfQEz5ZAAKSra68C4upSFQ==
X-Google-Smtp-Source: ABdhPJxIiUPehbrKrAqkbtQEM9myk7dxHYdKgdQo+sg6gS7VxEodQks76xQP1JHtyeUljY3gF6MedQ==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr8733938wmh.102.1622213395995;
        Fri, 28 May 2021 07:49:55 -0700 (PDT)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id 89sm626826wrq.14.2021.05.28.07.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:49:55 -0700 (PDT)
Date:   Fri, 28 May 2021 15:49:53 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Jason Wessel <jason.wessel@windriver.com>,
        Douglas Anderson <dianders@chromium.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Biederman <ebiederm@xmission.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
        kexec <kexec@lists.infradead.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel: fix numerous spelling mistakes
Message-ID: <20210528144953.akwuf5nwky4kt3to@maple.lan>
References: <20210526035345.9113-1-thunder.leizhen@huawei.com>
 <20210526035345.9113-2-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526035345.9113-2-thunder.leizhen@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 26, 2021 at 11:53:45AM +0800, Zhen Lei wrote:
> Fix some spelling mistakes in comments:
> suspeneded ==> suspended
> occuring ==> occurring
> wont ==> won't
> detatch ==> detach
> represntation ==> representation
> hexidecimal ==> hexadecimal
> delimeter ==> delimiter
> architecure ==> architecture
> accumalator ==> accumulator
> evertything ==> everything
> contingous ==> contiguous
> useable ==> usable
> musn't ==> mustn't
> alloed ==> allowed
> immmediately ==> immediately
> Allocted ==> Allocated
> noone ==> no one
> unparseable ==> unparsable
> dependend ==> dependent
> callled ==> called
> alreay ==> already
> childs ==> children
> implemention ==> implementation
> situration ==> situation
> overriden ==> overridden
> asynchonous ==> asynchronous
> accumalate ==> accumulate
> syncrhonized ==> synchronized
> therefor ==> therefore
> ther ==> their
> capabilites ==> capabilities
> lentgh ==> length
> watchog ==> watchdog
> assing ==> assign
> Retun ==> Return
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  kernel/acct.c                  | 2 +-
>  kernel/context_tracking.c      | 2 +-
>  kernel/cpu.c                   | 2 +-
>  kernel/debug/debug_core.c      | 2 +-
>  kernel/debug/kdb/kdb_main.c    | 8 ++++----
>  kernel/debug/kdb/kdb_private.h | 2 +-

For these three files:

Acked-by: Daniel Thompson <daniel.thompson@linaro.org>


Daniel.
