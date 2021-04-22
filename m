Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1501C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 06:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CE56145C
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 06:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhDVGx0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 02:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbhDVGxR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 02:53:17 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725BDC061343;
        Wed, 21 Apr 2021 23:52:27 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o9-20020a1c41090000b029012c8dac9d47so2584845wma.1;
        Wed, 21 Apr 2021 23:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4Mr+n7ZQ3cZFYLCKc8MLozw5D9Em36zAwZCuEwbAFBs=;
        b=PTcqXGzYbqtq9HA89/Giwu3cBu7geqyM810zNixuMHsF3K9ttvmSrqU64g2znksMH6
         3bllN0oMbvJxaDy7AZWDgNTdwv+3ZzKdTWBHYtmsI2LDzJ0m90d6WwHh6lVB/dvbIOuB
         Sv+dqcTOOdgdk6f6B2ckw3SduKqIfImSO0oy8SHVVqBSXqDhqlSlOqsAGTCe/DVG79cj
         FAJy5c1j1Se+o2uOyRnBZaaf6YOUtd+cqPmo5s4E3h1qHveLqYRX6UnJIfFqVbpwJX1s
         8LpT898HeXPwK9Sa++Hpyi8glA9+4mbu1AsNEeouIVpK26fFpR1JU+8ypWsheGfXFaOj
         Cx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4Mr+n7ZQ3cZFYLCKc8MLozw5D9Em36zAwZCuEwbAFBs=;
        b=tJsLZ6Q4gpsny8Kbx7/NgBtEFmhUaD537RABQg0awrj8bJC7Ra1IZaEa2w//xy5sdL
         qD2kYE1dLMMvyY0FuUR+NnPMMeACy11lZ8d8WWGiBQgjQ50ne+pcHIhizUgVZ0bz7sF7
         4svmRuo9/20WY+sFJ9iPIl4r+MifJUwk++3fbmplwzPINsCQSCGZq5j5daqZTrFBHrDS
         9wKBx0KQrB+sF5XLwnQ9rjGfUAnSLtUSOVm85v8JKcmSZsCiSb0DGxiQeozGe7cdFFRu
         oL81NB/R35cpI0UB5aQM2fedsn4Gz55gLM6C4E/AB7se5AnuFLvBVkAog0Hx4OpvX27S
         ZnDA==
X-Gm-Message-State: AOAM5319LSOoMvvnfHzXp71BZ7CUGiEOC9/kJLMmccZ78ZWCtJejV8pp
        yMOQPIBp0DvXDgnvdkC8LkQ=
X-Google-Smtp-Source: ABdhPJyVX/Mx6WDBKnlla2+e7c/JaAz/PfBMvtW7Rja4vz/A/dPhSnPaqO35XxD4PDJdlIjI5jzeWw==
X-Received: by 2002:a1c:9d85:: with SMTP id g127mr13658126wme.62.1619074345858;
        Wed, 21 Apr 2021 23:52:25 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id v2sm1972259wrr.26.2021.04.21.23.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:52:25 -0700 (PDT)
Date:   Thu, 22 Apr 2021 08:52:23 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: cortina/gemini: hwrng: what is its quality ?
Message-ID: <YIEdJ3G/QwA8/BEU@Red>
References: <YICFBQ8mQRJ4zSh9@Red>
 <20210422001430.GA4246@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210422001430.GA4246@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Apr 22, 2021 at 10:14:30AM +1000, Herbert Xu a écrit :
> On Wed, Apr 21, 2021 at 10:03:17PM +0200, Corentin Labbe wrote:
> > hello
> > 
> > I work on the crypto part of the cortina/gemini SL3516 SoC.
> > The datasheet mention a HWRNG in its IP but really briefly:
> > """
> > The implementation is a 32-bit Hardware Random Number Generator that has a uniformed
> > distribution between 0 and 2^32 -1. The hardware randomness is created by sampling data from
> > different clock domains, and feeding it as input to the 32-bit maximum length LFSR (Linear Feedback
> > Shift Register)
> > """
> > 
> > Piping its output to rngtest give:
> > dd if=/dev/hwrng count=2000 bs=2048 | rngtest
> > rngtest 6.11
> > rngtest: starting FIPS tests...
> > rngtest: entropy source drained
> > rngtest: bits received from input: 32768000
> > rngtest: FIPS 140-2 successes: 1191
> > rngtest: FIPS 140-2 failures: 447
> > rngtest: FIPS 140-2(2001-10-10) Monobit: 183
> > rngtest: FIPS 140-2(2001-10-10) Poker: 116
> > rngtest: FIPS 140-2(2001-10-10) Runs: 346
> > 2000+0 records in
> > 2000+0 records out
> > rngtest: FIPS 140-2(2001-10-10) Long run: 0
> > rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> > rngtest: input channel speed: (min=303.606; avg=3143.352; max=9712.208)Kibits/s
> > rngtest: FIPS tests speed: (min=7.104; avg=10.332; max=10.638)Mibits/s
> > rngtest: Program run time: 13303224 microseconds
> > 
> > That's a quite number of failure.
> > Can the hwrng still be used with some "hwrng->quality" setting ?
> > Or it is just too many failure to be used ?
> 
> If in doubt just leave it zero and the admin can override it if
> necessary.
> 

But as an admin, what value I can set ?
If I do a rule-of-3, success rate is 73%.
So does a quality of 730 is ok ?

