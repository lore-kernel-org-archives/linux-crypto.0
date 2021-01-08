Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9533C433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 11:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 601C523977
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 11:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbhAHLA3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 06:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbhAHLA3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 06:00:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A3023998
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610103588;
        bh=HsDbo/9xG8H1TnL7loqkecZptlYHpFBdaqW4oxtwICw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DsdT9HiSLmxra4GlTEW40kuroC4f7fCGP6q2hB2xYtMBxYJ6WFWpTn8gjyI/RhgDG
         fduuaBZFXGcs4B1CSyUluGtEtwlXfMQxnNImVD94BARaei2n/zAbvWlNwNHsU0Ht+U
         RQUCn4BEqUvLUZaeTE9VRCDhPEhtP9h1UrkcQfB8R3NhPH6AqOFwz/+dVMR8+442lo
         q1cqL1JnlgSsYDR2Pdxc7rA1ASc550ej0m7J3s5IfjKZwJ3uUNPp3dOd8Dc1pBB7iY
         YikcFTrlIPYuNxIXSj6raIlWPSoexuR1w3wbOXgaFQY2cMowiH9PRNdCpDjNWp6cwM
         G8wghIXYshzPg==
Received: by mail-ot1-f50.google.com with SMTP id d20so9319678otl.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 02:59:48 -0800 (PST)
X-Gm-Message-State: AOAM533fXAWlj5LSQenFciWDWI9uwJru+/85esdNe+LG2/80A4hic2XL
        NJ8zX1lKft0JMqTAivZtJKFqQH0tL+8RxxmmhMA=
X-Google-Smtp-Source: ABdhPJycX9kifwnuXmbC3sYS7HkkxRypSGQljL/fkNcdsLlPmXQ/MpAiF6hQUkE2zJ+qN+7Q+GteoaGaSSR75B6Yn8E=
X-Received: by 2002:a05:6830:2413:: with SMTP id j19mr2199332ots.251.1610103587919;
 Fri, 08 Jan 2021 02:59:47 -0800 (PST)
MIME-Version: 1.0
References: <20210107124128.19791-1-ardb@kernel.org> <X/daxUIwf8iXkbxr@gmail.com>
 <CAMj1kXE_qHkuk0zmhS=F4uFYWHnZumEB_XWyzo4SYXj1vjqKmg@mail.gmail.com>
 <20210108092246.GA13460@gondor.apana.org.au> <CAK8P3a2k_bdhxKUnrae__OpmN807qeJpXHGB1zgAzFqLVZEZuQ@mail.gmail.com>
 <20210108104447.GA13760@gondor.apana.org.au>
In-Reply-To: <20210108104447.GA13760@gondor.apana.org.au>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 8 Jan 2021 11:59:31 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0W0jcqrt1Vp_+qf11y6P5Wy9--f+ou1gEwivizpTShaA@mail.gmail.com>
Message-ID: <CAK8P3a0W0jcqrt1Vp_+qf11y6P5Wy9--f+ou1gEwivizpTShaA@mail.gmail.com>
Subject: Re: [PATCH] crypto - shash: reduce minimum alignment of shash_desc structure
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 8, 2021 at 11:44 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jan 08, 2021 at 11:42:53AM +0100, Arnd Bergmann wrote:
> >
> > How does this work for kernels with CONFIG_VMAP_STACK?
> > I remember some other subsystems (usb, hid) adding workarounds
> > for that, but I don't see those in drivers/crypto
>
> I'm referring to the situation in general and not the subject of
> this thread.
>
> For shash_desc of course it doesn't happen since it sync only.

Ah, got it.

      Arnd
