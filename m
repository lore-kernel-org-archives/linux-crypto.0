Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33CCC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C090C229C9
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 00:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhAPAcc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 19:32:32 -0500
Received: from mail.zx2c4.com ([167.71.246.149]:43924 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbhAPAcc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 19:32:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1610757107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n8iZPICWYsO+RYtUEO2xzdAJtVxcHhgNAS7/3a61bNc=;
        b=hqXeTJOab5lSqGizo5Goq1JXQwiFXKNrkojE/Y2VllC0XhsfQ5WpIaQJlGTvnppYR6SLlX
        02WtezXaeM56GtwvPSFV2SRWEoFmq2S021S0AGYyDV/tH1TUHb1PfHTzVwzrTDDXeZZd8a
        U7CHyb9nhZsZgAqrb7T7gXOu/uqe8sE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b9f0ebe2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sat, 16 Jan 2021 00:31:47 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id x78so2220653ybe.11
        for <linux-crypto@vger.kernel.org>; Fri, 15 Jan 2021 16:31:47 -0800 (PST)
X-Gm-Message-State: AOAM532lZvttp6iHs+Fq1AGGmmHTnEopwGeIfgbyJMiBcE1hZhzyaQWc
        rgenI1x61wUgQG0UqNQD8u45k26+L3WGcjUv5Ss=
X-Google-Smtp-Source: ABdhPJxDknOg1S42lhxITKXJO4locrrQIj3jBUR7BozAupYytAfbGWXOg9PCix+CvL/JDcoAki5SjvUeSshMekG4vR8=
X-Received: by 2002:a25:c7d0:: with SMTP id w199mr18970424ybe.279.1610757106864;
 Fri, 15 Jan 2021 16:31:46 -0800 (PST)
MIME-Version: 1.0
References: <20210115171743.1559595-1-Jason@zx2c4.com> <20210115193012.3059929-1-Jason@zx2c4.com>
 <7628A3E4-B5AB-4C3C-9328-9E7F788E2928@oracle.com>
In-Reply-To: <7628A3E4-B5AB-4C3C-9328-9E7F788E2928@oracle.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 16 Jan 2021 01:31:36 +0100
X-Gmail-Original-Message-ID: <CAHmME9r+kdyF-rR6sG3TKUTo5T+zG_uaeL294vaKRMi+_TdXkQ@mail.gmail.com>
Message-ID: <CAHmME9r+kdyF-rR6sG3TKUTo5T+zG_uaeL294vaKRMi+_TdXkQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib/chacha20poly1305 - define empty module
 exit function
To:     John Donnelly <john.p.donnelly@oracle.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 16, 2021 at 1:30 AM John Donnelly
<john.p.donnelly@oracle.com> wrote:
>
>
>
> > On Jan 15, 2021, at 1:30 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > With no mod_exit function, users are unable to unload the module after
> > use. I'm not aware of any reason why module unloading should be
> > prohibited for this one, so this commit simply adds an empty exit
> > function.
> >
> > Reported-and-tested-by: John Donnelly <john.p.donnelly@oracle.com>
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>
> Thanks!
>
> Would someone be kind enough to remind when this appears and I will apply it to our product ? We like to use published commits when possible.
>
> JD

It'll show up in one of these two repos in a week or two:
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/
