Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D322BC2BA19
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 07:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADDA820781
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 07:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587628086;
	bh=LbnhmMfvitCTIggf1UmKQ6jkAVYasWbP2XpydlwCgi8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=inRKX5jfbn8CqFKsfbrpaHbuJMC6Iq6l8qBDEQD6GXbeEr6zyPA8/k+PAJkXRp6AP
	 LkuRhdaLxhLxUbaeOxa7yxrHNXv2lEzjXaebj/mryaB0Hd0KyF4+zP8Po4hGKhxE7r
	 1RuzNd4VU2+PPthSqOJopK9yHRnUursWwLOs8A3s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgDWHsG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgDWHsF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 03:48:05 -0400
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49CD320781;
        Thu, 23 Apr 2020 07:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587628085;
        bh=LbnhmMfvitCTIggf1UmKQ6jkAVYasWbP2XpydlwCgi8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fRAblcZIAKl/+y3XakBp9dg36fyoosssKOAUedUxkb8ozKxDCcJXwoUr6t7SheNtP
         8OpKCOhxyQLm5UchDeLT70YrfX3nvHJ9JwHwCZvDsIN54x68MlpEiASw6a5YtGJ61l
         r/CZPVMRM/vYEWLp7lCHNUR2ARleeVnl0isS2zpk=
Received: by mail-il1-f170.google.com with SMTP id e8so4643853ilm.7;
        Thu, 23 Apr 2020 00:48:05 -0700 (PDT)
X-Gm-Message-State: AGi0PuaIu16hQ52U+wvwS3h3QerIv7HniDukfhqHFYUZklB0bBuSWxrg
        +58k/7yg6b6+0K0CD9mizp3F70khh+BmD3iH7VE=
X-Google-Smtp-Source: APiQypKNATjPQwmj04xG86W/VSk+32MltYr5UKx21IGPfk6KrXvzAlYcN+pPjEmNzXxJvkiL0tInaDkyulvtXvujHzU=
X-Received: by 2002:a92:aa0f:: with SMTP id j15mr2200985ili.211.1587628084769;
 Thu, 23 Apr 2020 00:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200422200344.239462-1-Jason@zx2c4.com> <20200422231854.675965-1-Jason@zx2c4.com>
 <CAMj1kXHV=ryaFmj0jhQVGBd31nfHs7q5RtSyu7dY6GdEJJsr7A@mail.gmail.com> <beb32f2b-f16a-d235-f2a5-026b32dbc5b8@c-s.fr>
In-Reply-To: <beb32f2b-f16a-d235-f2a5-026b32dbc5b8@c-s.fr>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Apr 2020 09:47:53 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHYne8iE8wg9zoacp36tcVg+yqKoF6f1guwu1KUVXcqkA@mail.gmail.com>
Message-ID: <CAMj1kXHYne8iE8wg9zoacp36tcVg+yqKoF6f1guwu1KUVXcqkA@mail.gmail.com>
Subject: Re: [PATCH crypto-stable v3 1/2] crypto: arch/lib - limit simd usage
 to 4k chunks
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 23 Apr 2020 at 09:40, Christophe Leroy <christophe.leroy@c-s.fr> wr=
ote:
>
>
>
> Le 23/04/2020 =C3=A0 09:18, Ard Biesheuvel a =C3=A9crit :
> > FYI: you shouldn't cc stable@vger.kernel.org directly on your patches,
> > or add the cc: line. Only patches that are already in Linus' tree
> > should be sent there.
> >
> > Also, the fixes tags are really quite sufficient. In fact, it is
> > actually rather difficult these days to prevent something from being
> > taken into -stable if the bots notice that it applies cleanly.
>
> According to Kernel Documentation,
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html :
>
>
> Patches that fix a severe bug in a released kernel should be directed
> toward the stable maintainers by putting a line like this:
>
> Cc: stable@vger.kernel.org
>
> into the sign-off area of your patch (note, NOT an email recipient). You
> should also read Documentation/process/stable-kernel-rules.rst in
> addition to this file.
>
>
> Isn't it correct anymore ?
>

So this states clearly that you should not actually cc the patch to
stable@vger.kernel.org, you should only add the cc: line to the commit
log area if it fixes a *severe* bug. Once the patch makes it into
Linus' tree, the cc: line will be used by the -stable maintainers to
locate the patch and pull it in.

But as I pointed out, even with just the fixes: tags, the patch will
be picked up by -stable anyway. Omitting the cc: line helps prevent
inadvertently sending the patch to stable@vger.kernel.org directly,
since git send-email typically honours Cc: lines in its input in its
default configuration.
