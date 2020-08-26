Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423E5C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 09:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12CEB2075E
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 09:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZ9GJQS3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHZJHr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgHZJHp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 05:07:45 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795F3C061574
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 02:07:45 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id b79so396267wmb.4
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 02:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NhNd+58Ke9NXCgIaYKHAdShT/zbomUPozimvfjSixrU=;
        b=qZ9GJQS3j8rbsLLz/ln5goSk4ciwiqFL3uriCAVdtXXs3ELwIMm3H+K/W20gzFZz9E
         kvwaPukYfJcchgKITR7xXA+3dwS6kT1aZnd3KJYpkvqcXItHatLqbMDpTGJ8soTsX9mT
         xjEKsPYnWH6WExD0R2sLkUzNiu/OK7LaUfKy25ysvpu+bpxjLShkVOltBMkS9XEMPrql
         8LTsnq5AR21yv30QQmpZnTy+FYnMhoYkiGaj/AduLJ5/KXXvzlH0BzbGbyTWSTUkaaso
         /m4dRHmQgwCDSLnDQ++Rusb8wO6FOEkjIDKwCnFXxq36p/GMKbdAJTo7UC4BzfZrA6nq
         2IMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NhNd+58Ke9NXCgIaYKHAdShT/zbomUPozimvfjSixrU=;
        b=QYipdX+7P6MhbYreRYTtOAgcWS4T0QBU2oNLWl7eTwj3DJq88QnX9PNnLj2XnCg10z
         ql5ooqwt5FmOKcXKqpwwaAokeXrjOZlmQ0gfBoaSfMHmwBHHxDzR+CvZxPuiyGfMWZbo
         KF+NePY2f8k8GGzvxd85rQ3sIQfwXMP0YtbfrWsHHr3DKqb+hhac++3Tv+qt+3XrOf43
         OzbBc5v2huEbdYOZa8rA28WYM8QnSL80VuYFgUhjsXGG9smseqQFZmNCqOOttznvbjSy
         +6r5c6UEnUxZ8yKzNBdkLQ3NUs54MEGuzH/VQWIAtkCIXcLU/n/Ilmzd0Zpi1H1d5ILs
         7T3g==
X-Gm-Message-State: AOAM530WjBJoj+iLG+ImNCf+uc4rVIPKRsory8JNoc95N0bgLcWiom7X
        XLqoNIDAS65S/dONZAVZ4voQf7XACe0=
X-Google-Smtp-Source: ABdhPJzy787HWfNugnEyjD7drq4MnTq6HvvxuTzC14P2JbChQS+bEZDdkstqKeYkWmRO0GND5tmcJw==
X-Received: by 2002:a7b:c1cb:: with SMTP id a11mr6300390wmj.90.1598432860506;
        Wed, 26 Aug 2020 02:07:40 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id v16sm3788118wmj.14.2020.08.26.02.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:07:39 -0700 (PDT)
Date:   Wed, 26 Aug 2020 11:07:38 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Martin Cerveny <M.Cerveny@computer.org>
Cc:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: PROBLEM: SHA1 on Allwinner V3s failed
Message-ID: <20200826090738.GA6772@Red>
References: <alpine.GSO.2.00.2008260919550.23953@dmz.c-home.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.GSO.2.00.2008260919550.23953@dmz.c-home.cz>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 26, 2020 at 09:52:30AM +0200, Martin Cerveny wrote:
> Hello.
> 
> [1.] One line summary of the problem:
> 
> SHA1 on Allwinner V3s failed
> 

Hello

Since only SHA1 is failling, could you try to use the "allwinner,sun8i-a33-crypto", just in case V3s has the same SHA1 HW quirck than A33.

Regards
