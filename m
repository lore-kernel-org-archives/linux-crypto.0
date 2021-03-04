Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10B5C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 18:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A242664F64
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 18:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhCDSm7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 13:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhCDSmc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 13:42:32 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DF8C061574
        for <linux-crypto@vger.kernel.org>; Thu,  4 Mar 2021 10:41:52 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id d13so31236379edp.4
        for <linux-crypto@vger.kernel.org>; Thu, 04 Mar 2021 10:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YGAuQa1PUoEh5FNPfeCOcSMYAZSWyrSrhiaRmAC+sLo=;
        b=YVlyzmtAtju2fBUZIUHuYe4UO+bGNsChE/keiCLGA1MpdbuEKwlVaMdzqJal7fjdfX
         zbn61uczeQcCx9QdLukkkpEXwKpLg/2k3sEa35kOIZ0rC51/Vm38wWFtMRVymurHPhav
         c5RfTFHYw+hsu5hbjRFr2/fsB7YUExA0KwQsT1giezXdRQDlmdayFGgjZ+0u4MdjQsp8
         UP1gecAhHH5aZNJNAu7fuDNJAzeHon31iQoeZG/GStrAnJUMX5t7I4LMpwxy1PfUl69L
         ooAa2ZMeSG4TYs4+eIuppjIrjItmNKkZnYz2f08uRM/FqvncNhB5fgJGfA/Rs5ppn7fd
         3rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YGAuQa1PUoEh5FNPfeCOcSMYAZSWyrSrhiaRmAC+sLo=;
        b=sZbAeoeMF5R7Bht0y5W4XFGXQ2TASiSK222xEA4/XlajMmZbAlLBzAP55Ty3Z5VWWb
         lP0JyuSoq1FjzwssqbdEU+A8HkRoWhGAuBtkJZIaGbx27D25egm2o+LYGtmGrc1FjksT
         MrbdXlIGBE9ybnssAUfYhzfSJS9zf4nUyUzEXQ2Zkd9zhvIyHwAoIoJA5y8z1BMNE/Yb
         lali3/XOgikB1MQqexwgIiAH1ZhmgEHlkutxs9dierz3pQnRKDKsYodbDoJ+DISyOY0t
         fKnlLRR5Y6n8PlweE00NLZqmxAtIBBwKzbM/VFjUERL8xfpKj9/abiPQPZZ2YfWwX/k6
         aFnA==
X-Gm-Message-State: AOAM533/ikcAYt3DkSbxmU2pB1uaFT8dbuU7PSEIlgFdxaVsRMrJJdwZ
        eIORm3LZxUNzqfYadJyZXta63OnjSqevUGYau73MNg==
X-Google-Smtp-Source: ABdhPJw51VJr6G077eQYamXJLrL3nXTygODsuW6wr3+TZzOpbk+Xd/YlahOGxDurRbb16/lu4byb+e0KjME54lb+DUA=
X-Received: by 2002:a05:6402:2ce:: with SMTP id b14mr5984770edx.13.1614883311038;
 Thu, 04 Mar 2021 10:41:51 -0800 (PST)
MIME-Version: 1.0
References: <20210225182716.1402449-1-thara.gopinath@linaro.org> <20210304053027.GC25972@gondor.apana.org.au>
In-Reply-To: <20210304053027.GC25972@gondor.apana.org.au>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Date:   Thu, 4 Mar 2021 13:41:15 -0500
Message-ID: <CALD-y_y8qidsypp7=F-5OLitaq3B1E==c+eQgyqq7hv9t3xcmw@mail.gmail.com>
Subject: Re: [PATCH 0/7] Add support for AEAD algorithms in Qualcomm Crypto
 Engine driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Biggers <ebiggers@google.com>, ardb@kernel.org,
        sivaprak@codeaurora.org, linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 4 Mar 2021 at 00:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Feb 25, 2021 at 01:27:09PM -0500, Thara Gopinath wrote:
> > Enable support for AEAD algorithms in Qualcomm CE driver.  The first three
> > patches in this series are cleanups and add a few missing pieces required
> > to add support for AEAD algorithms.  Patch 4 introduces supported AEAD
> > transformations on Qualcomm CE.  Patches 5 and 6 implements the h/w
> > infrastructure needed to enable and run the AEAD transformations on
> > Qualcomm CE.  Patch 7 adds support to queue fallback algorithms in case of
> > unsupported special inputs.
> >
> > This series is dependant on https://lkml.org/lkml/2021/2/11/1052.
>
> Did this patch series pass the fuzz tests?

Hi Herbert,

Yes it did. The last patch adds fallback for unsupported cases and
this will make it pass the fuzz tests.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Warm Regards
Thara
