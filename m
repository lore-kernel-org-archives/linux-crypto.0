Return-Path: <SRS0=Zt4K=UB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABB7C28CC3
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Jun 2019 00:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0DE2776C
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Jun 2019 00:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="rIWMv8hN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFBAnW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 20:43:22 -0400
Received: from condef-10.nifty.com ([202.248.20.75]:50758 "EHLO
        condef-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFBAnV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 20:43:21 -0400
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-10.nifty.com with ESMTP id x520cQ6M029160
        for <linux-crypto@vger.kernel.org>; Sun, 2 Jun 2019 09:38:26 +0900
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x520cKBo006195;
        Sun, 2 Jun 2019 09:38:20 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x520cKBo006195
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559435901;
        bh=VPMWdmiaMMit8aN3x2Svzq92UM7PBXY5o/g1AChMeqw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rIWMv8hNY4lqui1No4RF7wbo/bN5gy3vTAda/lC5cTq8bPLlEBCZbsqjZ5Ex4wqKt
         0kjfGsFGMV5r9p6VzVV+rhu+PGTHbBk1sWB74VBjTr2hVhSKmrw2rbkjZovPOCIalx
         2xmaWGzJUozR3soe5kAwII6KTUuJtyeeYCJDIIULsqtiPLR7qZzTSXCLpUkmO5EaP7
         T+Lzd5+DR4DZ6+0tMooKWTWr7d6yPrjCIfXNu7poNweTpjRjhg60hJSFMC5o719LgG
         WDvc6eT+RBwknd9x1biTV6KvJ5AiJMBXA4+Di6m68KAF18pP058nOtHwna3rQmPa8D
         CnvQfqhiSbodg==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id 7so5250768uah.1;
        Sat, 01 Jun 2019 17:38:20 -0700 (PDT)
X-Gm-Message-State: APjAAAVB94RgSPzS/XJv0ATYD3TMhvZ5DnRW3GlOJRQRVxiq8Bc5Vyb3
        11swrhTyh7JIEvZS3essSv2jKITjjvtflKBsHWk=
X-Google-Smtp-Source: APXvYqzqZ75H6WWeaX+LmWXIu9i2MAyw2MtmcZ5+WQel0nCu4TR+kFBGEkCow4ynoBFcyfjMf0nwuCrztJEVw9Vvwt4=
X-Received: by 2002:a9f:24a3:: with SMTP id 32mr8228855uar.109.1559435899588;
 Sat, 01 Jun 2019 17:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190601144943.126995-1-alex_y_xu@yahoo.ca> <20190601162907.GB6261@kroah.com>
 <155941810155.1991.11907646865432946934@pink.alxu.ca>
In-Reply-To: <155941810155.1991.11907646865432946934@pink.alxu.ca>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Sun, 2 Jun 2019 09:37:43 +0900
X-Gmail-Original-Message-ID: <CAK7LNASoaiBCObeEPO-hcrg9ftsGq2QWXoG+R8TWv1z53HJvXw@mail.gmail.com>
Message-ID: <CAK7LNASoaiBCObeEPO-hcrg9ftsGq2QWXoG+R8TWv1z53HJvXw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ux500 - fix license comment syntax error
To:     Alex Xu <alex_y_xu@yahoo.ca>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        allison@lohutok.net, alexios.zavras@intel.com, swinslow@gmail.com,
        rfontana@redhat.com, linux-spdx@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 2, 2019 at 4:41 AM Alex Xu <alex_y_xu@yahoo.ca> wrote:
>
> Quoting Greg KH (2019-06-01 16:29:07)
> > On Sat, Jun 01, 2019 at 10:49:43AM -0400, Alex Xu (Hello71) wrote:
> > > Causes error: drivers/crypto/ux500/cryp/Makefile:5: *** missing
> > > separator.  Stop.
> > >
> > > Fixes: af873fcecef5 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 194")
> > > Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
> > > ---
> > >  drivers/crypto/ux500/cryp/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Also, how did 0-day not catch this?  Is this an odd configuration that
> > it can not build?
>
> I had to run "make clean" to get the error.

I think this copyright block is ugly.


# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) ST-Ericsson SA 2010
# Author: shujuan.chen@stericsson.com for ST-Ericsson.

looks nicer IMHO.




-- 
Best Regards
Masahiro Yamada
