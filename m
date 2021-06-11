Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69C5C48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 10:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C16613DD
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 10:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhFKKJ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 06:09:56 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:35248 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhFKKJ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 06:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1623406075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hL2rC0Jg+AZGattAfe5RyKX376d2ZDQJHJvHgYucxeA=;
        b=hgn5UxU6op8iVIe+wm3SwtoysyMNA+/3303vtdzpACPna+rJS/NxRU3CNZavcizRACd+9z
        /R94hj067KJuifYG1ADODKw/ehg+yN20tzM03C914B2kTq7ynjddJUmw+8ghHSmwDTucK8
        wwpXfrNEUdoc+LJ4at697DbsmTdmEBI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 503091b9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 11 Jun 2021 10:07:55 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id m9so3556922ybo.5
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 03:07:55 -0700 (PDT)
X-Gm-Message-State: AOAM533SzJXgGx9Kn1zjkP2q/aJYms+F2QZOoj8o9JZGg0hg285zzP3o
        felz72guu5hEW5yrknSRNzAXyEz/RydMnzS0oGs=
X-Google-Smtp-Source: ABdhPJynBlCc287Krig26GvEH/zHmtA6mD/U/JUcsbYvviYfX2XYTKfG/YBdRsPDjTtskzwnjEHSXZY9i9NLUQsznl8=
X-Received: by 2002:a25:389:: with SMTP id 131mr4852255ybd.306.1623406074726;
 Fri, 11 Jun 2021 03:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210603055341.24473-1-liuhangbin@gmail.com> <20210611072312.GE23016@gondor.apana.org.au>
In-Reply-To: <20210611072312.GE23016@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 11 Jun 2021 12:07:43 +0200
X-Gmail-Original-Message-ID: <CAHmME9qE=CAtNjTPTwapUf0eGALkwbL+qVGRi3F88J_sE2-1vQ@mail.gmail.com>
Message-ID: <CAHmME9qE=CAtNjTPTwapUf0eGALkwbL+qVGRi3F88J_sE2-1vQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/curve25519 - fix cpu feature checking logic
 in mod_exit
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Is there a reason why in
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/patch/?id=1b82435d17774f3eaab35dce239d354548aa9da2
you didn't mark it with the Cc: stable@ line that I included above my
Reviewed-by? Netdev no longer has their own stable process. Do you
have something else in mind for this?

Jason
