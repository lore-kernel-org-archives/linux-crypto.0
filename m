Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE13C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 13:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA80206B7
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 13:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="1QMmwVtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgFONDA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730455AbgFONC6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 09:02:58 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B27AC061A0E
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2020 06:02:58 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g10so14534450wmh.4
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2020 06:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7NuIO3P9BiKiClf+gIYNheUV8PABe5hNFRgi4pHcvCY=;
        b=1QMmwVtPmdoBBPgNf0gtk/PbGnQ8GRNykH9T9prLxXaICZfxcxbDJLKF4TJVHHZTp9
         5l8ZjVHowMmcyZjUIxmwPAdp/WB1/7vrLTAP9fY/OEdh+Zn7x0uWci5hnnclpWB2FmjH
         +jdMom/24wMjxZsOvGyg3vrkT9rAv9IdVmCoIR6RzJ1ycwFPzklE8WfG510xGuipCHXo
         8riIWQTsL7jUCOTtjilQQLHAwJLwI3YHHD4KMMYELnM2NzrMxJ8L5mkFiF4835+EjeBl
         FMrZppNeuGGMj6APtCDbAngPn/i+j1Vd8ReGKuUmVCXqLxFfZCz6dG+g2Ms5eTWX/UpR
         mkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7NuIO3P9BiKiClf+gIYNheUV8PABe5hNFRgi4pHcvCY=;
        b=L71G4z3wePIl+9d45xmKMm3gfj84PourfbwMN6ki3K5x0aJ556bB16K7lrTvWAriiy
         KvBxrdt76tRs1F4K9YgADJ51sdxqd2YiWcQsBJYOrhkr4s8OzaWVgCkb0snu0Ec3SzHf
         Z02tspBcBq5CtVhULIDmdyuQNxR6eUMrOiKkxmBQy1zdeK12UvxRsDozECgLy93LhJxT
         gyxJv1Fa2W2btQlNhpJ+Be50YkXh505PfIAZ80Kp03VJx2vZKDnQHARByXrD+gNW0rU4
         lt8WaIQV2IG8f/AkEJn7a6d6QLpIk01nckPJeLxwLPVf8CLJn3EaTRA5H/0/fDdmaMHY
         FgFw==
X-Gm-Message-State: AOAM533NbjpEuCt7TCLR/E8Xkhc8KhC5gcxeElw2UddEICodG2RV5Smg
        DBrHMVYgYG68C0lSOK5y072nkw==
X-Google-Smtp-Source: ABdhPJwyEWtQ2T5pTNZIqREl1GxsviMtbRfUnZ+RP8ElBpEjq8N46tHrWNtvxP6SWL614Jk0oFIcXQ==
X-Received: by 2002:a1c:9c49:: with SMTP id f70mr12684511wme.74.1592226176022;
        Mon, 15 Jun 2020 06:02:56 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id v19sm22443569wml.26.2020.06.15.06.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 06:02:55 -0700 (PDT)
Date:   Mon, 15 Jun 2020 15:02:53 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 13/14] crypto: sun8i-ce: Add support for the PRNG
Message-ID: <20200615130253.GA8958@Red>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
 <2397344.pSczEbEFGg@tauon.chronox.de>
 <20200427084137.GA8787@Red>
 <5634597.9v007L4FOH@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5634597.9v007L4FOH@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 27, 2020 at 11:23:15AM +0200, Stephan Mueller wrote:
> Am Montag, 27. April 2020, 10:41:37 CEST schrieb LABBE Corentin:
> 
> Hi Corentin,
> 
> > > Shouldn't they all be kzfree?
> > 
> > Yes
> > Probably it miss also a memzero_explicit, I think that seeds/data are
> > sensitive
> 
> kzfree uses memset_secure since very recently. So, kzfree should be all you 
> need.
> 
> 

Hello

I still dont see any memset_secure in kzfree (mm/slab_common.c).
Does I miss something ?

Regards
