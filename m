Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED07DC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 18:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB5E2086A
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 18:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pRpaIJUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIYSMI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 14:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgIYSMH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 14:12:07 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C14C0613CE;
        Fri, 25 Sep 2020 11:12:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a9so4394399wmm.2;
        Fri, 25 Sep 2020 11:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=peKSZZv/3gch7m7CK+PuIaqJRq3FyLjvEDI1jpnv750=;
        b=pRpaIJUqQjkqw6bRm/2R7blJ6O3KEmLRnXtjDVxqqs2lGFyb74ac+dVMdxh77WKddm
         qyTaJEsEMpObuYhhPXKtryw1urlZqbln3v9uRKEo6I2MOvWSczuKSjmBoSeGHV8WzRFT
         2+c4PzFQaFmHveltaK33NrTPrZkz2zGgxJ08iap2vQcX8tM1BA4ofjlb0Err0Aqv/Knk
         63B3mwkZFSe64n2Uhs6pRr0FeCQwSx5AJ1wcuNBzMa7iqUnZeEF7MjsZlYM42f5a4xL/
         oR1MuT22vC2Xa2PYqhWP12B6Ni+Z2h1dWyTbecIq2A5phvXFk9a1msgGjTw4MIOp0HBW
         5D0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=peKSZZv/3gch7m7CK+PuIaqJRq3FyLjvEDI1jpnv750=;
        b=EQ8sMwX5f6AW/kssiFbbTPzQXXGpwQlAE5MrMJiipKfbWw8fB62prL/6ts6DPvqyYr
         gCLf7mpMq30aeiW/hysTm30nZfPdIJD+JvMUTqAHOdt+EgndxdcdhYNdLNzz4gqgr7lb
         5iyvuhozEOY/iee4LAJPQ2CuFyfZOcaQEiM6xLISCvsGQx01nLxkZqmshu0t+CSzM3r3
         yYf1UaaQHUc+fAaUf0I235v3ags6CcwEkLySrvxxcUalilkYFs65qyFlUPj8tv6Hs2yY
         hdpSl4ekGf3TqfWB+mDI79EcSMW7vjbRIiFvHS/Rfm4XcYozxtC/63WOiIcg+U0czmPs
         mxDg==
X-Gm-Message-State: AOAM530VbQq+gKEBkAudRIRv+4OYcZib/eQgqNTKhuMTBY0TAoeg/jY2
        LDtvWVNkRjNiDRy1Lw+gXaE=
X-Google-Smtp-Source: ABdhPJxZvrVfLyQNosyiqJ+YnRZQYo+QLgncx0LWJ0hyamcXwxXU8sIDE244LW5ALbbwIiq4VNYBDA==
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr4355391wmh.152.1601057526226;
        Fri, 25 Sep 2020 11:12:06 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id k8sm3858176wma.16.2020.09.25.11.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:12:05 -0700 (PDT)
Date:   Fri, 25 Sep 2020 20:12:03 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Will Deacon <will@kernel.org>, tj@kernel.org,
        jiangshanlai@gmail.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200925181203.GA26463@Red>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <20200303074819.GB9935@Red>
 <20200303213111.op2vtxfmwtn7i6db@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303213111.op2vtxfmwtn7i6db@ca-dmjordan1.us.oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 03, 2020 at 04:31:11PM -0500, Daniel Jordan wrote:
> On Tue, Mar 03, 2020 at 08:48:19AM +0100, Corentin Labbe wrote:
> > The patch fix the issue. Thanks!
> 
> Thanks for trying it!
> 
> > So you could add:
> > Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Tested-on: sun50i-h6-pine-h64
> > Tested-on: imx8mn-ddr4-evk
> > Tested-on: sun50i-a64-bananapi-m64
> 
> I definitely will if the patch turns out to be the right fix.
> 
> thanks,
> Daniel

Hello

I forgot about this problem since the patch is in my branch since.
But a co-worker hit this problem recently and without this patch my CI still have it.

Regards
