Return-Path: <SRS0=oEI+=C4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D90C43465
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 19:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6C02100A
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 19:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="XRXcynIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgISTFN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Sep 2020 15:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgISTFN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Sep 2020 15:05:13 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9804DC0613D0
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2020 12:05:12 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l15so8903944wmh.1
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2020 12:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PZQgCTVJaoPDkS3FQ6qHauGfZhEJ//51YELEu9Y52xE=;
        b=XRXcynIbW7WqgbArclPQcpE9rGo25dMyO2eSsemk/YFMHeLfbHiqjst0TEQ+78rHZb
         C68W7Sf5VfKD9bH+9ExiVuabozsCjiY4Efbb4xNDjOLHiu4AKdUEYXptc7wMoCFzzlpS
         G2JxK46RLqiV2GWYyBFtTT6JC/GaJhocAiNXhMfPpzQ8ABJFVhbupCIfiGZQ77aPR0/s
         TJV/phA0E6XQojM9jhIJOHuF66esjN6NqH6QVahCEN3RS/qosrAwNDO/k5a2y+eCrQtR
         bd75Ui8tLMG9whY1VYcRLE62cOubNjW7Pb7X17NbSZnFT4qp0BVCPWvp4WMW/wgZycWY
         SWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PZQgCTVJaoPDkS3FQ6qHauGfZhEJ//51YELEu9Y52xE=;
        b=ULWuBEJZs3p3sYEXCZ9o8HYpU9avZVNMhxEy5a2lyFaiPmo68qF6dZzyj/NrUz9Q5D
         vMMikIYk2A3KR34a5+S9ee39eXx8O9i1ZyuDnqeBJGDGk6pzZ360lMz2ubCncQ4O62AM
         igneJBJF0Ne+V4GUothgYpQOQfz4FFfHy5MdCx+39qewpnMmnAxj4P2g8GVzx7x1xqkx
         2zZogugz5iHVe/tibT1NTz73niOne8BIiCWOOubrMDSXlWU1XTOrss9cuPXU/+XaBdBy
         vYN1hKVJSvrzfmgPzOTuojwSoJ9J1MLdeSBgVtMsmJ2feW0B1Nyw5KEi128DE9b5XSVG
         1tRw==
X-Gm-Message-State: AOAM532EmSxOxB1U0Sq7FYbtKIqcGE+LVXXXPo2y0Ku2DQG8rcpg6ds1
        83oVwfo2UmsBvwuL/c7cdXD21Q==
X-Google-Smtp-Source: ABdhPJxl+y2QxzQ9a3sEy1MWsd8chRltmFlrXrtZ/mWCfmxuovfU7S/Ah6OI/8mW9RcgzuuAzQFmfA==
X-Received: by 2002:a1c:bad5:: with SMTP id k204mr22538053wmf.111.1600542310996;
        Sat, 19 Sep 2020 12:05:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x2sm12624431wrl.13.2020.09.19.12.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 12:05:10 -0700 (PDT)
Date:   Sat, 19 Sep 2020 21:05:08 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     arnd@arndb.de, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Message-ID: <20200919190508.GA15359@Red>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
 <1600367758-28589-5-git-send-email-clabbe@baylibre.com>
 <20200918073128.GA24168@gondor.apana.org.au>
 <20200918080658.GA22656@Red>
 <20200918080915.GA24549@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918080915.GA24549@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 18, 2020 at 06:09:15PM +1000, Herbert Xu wrote:
> On Fri, Sep 18, 2020 at 10:06:58AM +0200, LABBE Corentin wrote:
> >
> > But I think only me will see it and since I already have this on my TODO list, I dont see any interest to leave it failing.
> > Furthermore, having a clean BE boot will permit to enable BE boots for thoses SoCs on kernelCI.
> 
> I'll happily accept patches that fix the actual bug but not ones
> just papering over it.
> 

I am sorry, you are right.
Furthermore, while respining to fix it, it seems that the current fix is enough.
I have rerun a clean rebuild and test on A10/A13/A20/A33 with BE and sun4i-ss is working fine.

I will sent a clean v2.

Regards
