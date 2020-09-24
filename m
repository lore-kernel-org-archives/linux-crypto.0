Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82290C4363D
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 00:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0E6221EB
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 00:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LwEuuqfK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIXAi1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 20:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIXAi1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 20:38:27 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F72DC0613CE
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2020 17:38:27 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id 7so1082050vsp.6
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2020 17:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=waZjCmSpO3i5o1DA7ctQNChokzWdr5lp+TlG4nTes68=;
        b=LwEuuqfKGytuwo3rt3YGfnCrVze5peyLSIrRzexnTgCPIMq85ECtRTR1Xp91EDmS17
         fstEhZYpyT4Qm1JQM9FJg1H0snRkG6lVR7MrTHVPIa0avqJl69zNKDtzPvn3berJkm7q
         adwJWBYKJU7leoP7AhFwU1gVekPXTVa+PnPtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=waZjCmSpO3i5o1DA7ctQNChokzWdr5lp+TlG4nTes68=;
        b=my2oo2LDBbJ0M4wwHTLZerKymcxMmOVfrtx0yWHEssnTC3auts6Dkp9DqFBiWwFpNe
         i21jSscDwMAoFKlr6qyENMqP4WJmH8vyLonK98F4oAKPDYJ/ollPpHC9jlDoXyIoFaUe
         m0Qvxe59MImcMxK/lh4bSrmi5P1V87xgGD6wHnK2bBvF0elK9wGqcEOH0Lqf1dvIq+Kj
         TmMIg+G/d6QVm4sNr0sV1I+GRgveugqoBVJTAs7YhJKxstfVC0B3JmdYyYxmOzrEkzE8
         9RMwiYAwSdy018l+ZRxZvK3IEfeWrmZPSC3bpPGYn5ZjqPKd33A9iW+j5usq0xPm5Mj2
         02qg==
X-Gm-Message-State: AOAM530z93cwnV97hnmkhddRG5cDle7QOmNLKzIzETMx6KgpK/3jr7wD
        g9SxIL27gWakGeuSHm16kdQ6HcAEmVmIjQ==
X-Google-Smtp-Source: ABdhPJz9r4XubHVTjTKXEzyrlN/zqoKNREqbV46nB8Cz6ozmcXXvhX4v6oAbgPXmvSte+JoBJ/cNZw==
X-Received: by 2002:a67:be08:: with SMTP id x8mr2342151vsq.43.1600907906231;
        Wed, 23 Sep 2020 17:38:26 -0700 (PDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id b17sm181690vsr.17.2020.09.23.17.38.25
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:38:25 -0700 (PDT)
Received: by mail-vs1-f52.google.com with SMTP id w25so1066271vsk.9
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2020 17:38:25 -0700 (PDT)
X-Received: by 2002:a67:ec9a:: with SMTP id h26mr2375057vsp.34.1600907905068;
 Wed, 23 Sep 2020 17:38:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200923182230.22715-1-ardb@kernel.org> <20200923182230.22715-2-ardb@kernel.org>
In-Reply-To: <20200923182230.22715-2-ardb@kernel.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 23 Sep 2020 17:38:13 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X15Td9GOYx_swGRYQfmW8ffdJzs_MtSv+7XQbeaHr7eA@mail.gmail.com>
Message-ID: <CAD=FV=X15Td9GOYx_swGRYQfmW8ffdJzs_MtSv+7XQbeaHr7eA@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: xor - defer load time benchmark to a later time
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Wed, Sep 23, 2020 at 11:22 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Currently, the XOR module performs its boot time benchmark at core
> initcall time when it is built-in, to ensure that the RAID code can
> make use of it when it is built-in as well.
>
> Let's defer this to a later stage during the boot, to avoid impacting
> the overall boot time of the system. Instead, just pick an arbitrary
> implementation from the list, and use that as the preliminary default.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/xor.c | 29 +++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)

Seems like it'll work to me.  Thanks!

Reviewed-by: Douglas Anderson <dianders@chromium.org>

-Doug
