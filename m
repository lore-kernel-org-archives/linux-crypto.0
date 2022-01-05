Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F38C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jan 2022 15:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241332AbiAEPUd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jan 2022 10:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiAEPUc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jan 2022 10:20:32 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67031C061245
        for <linux-crypto@vger.kernel.org>; Wed,  5 Jan 2022 07:20:32 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id h7so45276701lfu.4
        for <linux-crypto@vger.kernel.org>; Wed, 05 Jan 2022 07:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZS2/8ZpmEESquBZtXcik7qyvXFlcOFjJPJc4BBFGHpI=;
        b=ffgNr1lOsnpNkOP2J2VKXqHe3UtoccsPsBBVXirjBjSh5v+sjrwGs7lCwuOB2PDPW2
         BXr8PtMTbpr/0Rj1zaCBLZqCUnO6KoJs3msPq3Hjj8DG47W8iYr9lx5A2NQoG3ZmbkHk
         KDRMXaOjHG3ATUd6xaRuunIiXQLVBWfVQUrXtzGguCLEuLVQwD4lo8QWXLhuKu4/E5+2
         O61oxDKkuI7mE+YQwD2ATaL2EhbEghoqoIbjsIXsx8KYVglkcMhUzwq3/pRvtgTcZzWF
         Ja4LY1VGHPLkuWeMlH+GMSBMED+jcvknRfwwlCbr04F0YsLu0qO3hu6NDI+mS5RCf+GX
         Anpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZS2/8ZpmEESquBZtXcik7qyvXFlcOFjJPJc4BBFGHpI=;
        b=w4R8+lkrh3yNtWh+3VDgjT2J3Qouzgx3Z/tdN73jqBIlup5Ob/enmv7tt9I4rGNYl1
         Taod6rFb0gyeJvIDkmFQLlKwG54RWPDlxipz1Uuw5NGhQn5q3nSs+pTryIvfeaLQ3Hct
         mLilL2YwOMHWJiziKbKZSmqmUQ+rAEF6V64WQeIKlH/uovtcbZUw6BecyF9if1tjPqNm
         TkyXpl6fyXZcJMlpe4wQWz7e2ywyv6pP4jIfzcmgL+R/vM4UUiiAprugTAtHf6RcYeca
         gIbS1G4WkyCB4nnu39+uBC27BIX/Kt9ECRrWO03ptc/ZY7Tzome3UjaLGZBGcHRM+ew+
         9naw==
X-Gm-Message-State: AOAM532Tgd0ZLP6CzvW7LAVaG+TcFSoEFNe2xJ4x355ZTFwdFvF+bpK5
        XqUc6JoNVw1EpMTwVQkkQgIdyXfbQHCp4rde/aX+Tw==
X-Google-Smtp-Source: ABdhPJx4ykpuDBkworuUcqnrg6aDNpgyKCjwRiKmhC1eSxPpfRH3SkTdmjh+yWGyOVzOEkkW9XuxT8AJdiWxAO5YGN4=
X-Received: by 2002:a05:6512:1156:: with SMTP id m22mr14313487lfg.456.1641396030468;
 Wed, 05 Jan 2022 07:20:30 -0800 (PST)
MIME-Version: 1.0
References: <20211218132541.GA80986@65b4fbea3a32> <YcU+ZNqZ+pNv06QL@gondor.apana.org.au>
 <CAMkAt6rreu0X6DFENqYAAJ_JMEWoS8cvgf7bDhzgFxAnZturrg@mail.gmail.com> <YdTmhCzAzX29PJxj@gondor.apana.org.au>
In-Reply-To: <YdTmhCzAzX29PJxj@gondor.apana.org.au>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 5 Jan 2022 08:20:19 -0700
Message-ID: <CAMkAt6p9pSc6OxaB3ORFpPRZLySB7BP20XhZphY08sPVBBmxCg@mail.gmail.com>
Subject: Re: [PATCH] crypto: fix semicolon.cocci warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>,
        David Rientjes <rientjes@google.com>, kbuild-all@lists.01.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 4, 2022 at 5:30 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jan 04, 2022 at 02:14:16PM -0700, Peter Gonda wrote:
> >
> > Herbert I see the patches I sent here:
> > https://patchwork.kernel.org/project/linux-crypto/list/?series=591933&state=%2A&archive=both.
>
> I meant the bot's patch.
>
> > Are you asking for this bot to resend? Or should I send a fix up patch
> > if that's easier.
>
> If you could resend the bot's fix up patch that would be great.

My mistake, I should have checked first. Someone has already done
this: https://patchwork.kernel.org/project/linux-crypto/patch/20211221003828.101022-1-yang.lee@linux.alibaba.com/
.
>
> Thanks!
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
