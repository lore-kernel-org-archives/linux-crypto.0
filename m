Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E88C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 14:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDCA920737
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 14:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="piHoVbQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGCOdv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgGCOdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 10:33:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8496C08C5C1;
        Fri,  3 Jul 2020 07:33:50 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t18so7532696ilh.2;
        Fri, 03 Jul 2020 07:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=TEiqJa9+FS+SQXQKIC7/ALNi4cJmrJm7CDMMd+hF6lk=;
        b=piHoVbQoKIDrTeziXVgSLF6/nJckZa/48J0h2ZXHbv9YjrN0GSwLtUgkDqTzo4yeiF
         u30XX+tSkIvAed37IO+XnDyxxgrySxTB5FCaaBdaQTsFDuKxCQ3G+6Pf5DVVaF2QdCg6
         GTRRotzsUCSjHUYlNfBdL3JrktYOa4kUXxZ5SHgfYUWz4XyqsEvuFdALDHA7C+OqhaW+
         F7dZXivkCH0tt3ZDCwVetXM+6Gh+6qLTta9fC73GhoseA93vqosDM3PQWJ9cEjKP/HoZ
         g0p2yFEINPUF1OIHpK/vxFWIGwYmbhdOvlPtNr+eS/OmThFNcUl8FAUikmUHVSDhn7I3
         uHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=TEiqJa9+FS+SQXQKIC7/ALNi4cJmrJm7CDMMd+hF6lk=;
        b=hUCuk21e+1MoW6ThVhZpy5X49zMDw8RGSw8fwpOlXm3FPOppnbpCTJjaS77Thxm5Gq
         Gvj5FwJA+wEd6VL3+c9t7DdIphqUNcu74nG70rWR7s7gmxcbstzYlJjydDLPau94vEcg
         eZX3ByyCo/KYwegGiduSYIOAhY3hNvNeSYL4j7OptmdwAjJHi0s14ktxxzcdcmrJ5+a/
         B1iLEfF9+cBLHNW7NIWYWOynimkAprzkvynFEYUZoted0dHMTHFzFj95T13iB8MaRcOC
         22DP0cVpXi0XIx1YpIr4WhZsILzSQoEno6QMxUV/G3+Il3NTFLqjGYLl/s+OnKXuDYZi
         0qFw==
X-Gm-Message-State: AOAM531naLuI+7RSAZx/I6G6Oqw0ZxpbnmJn1smtDi99LzpislY24Qsv
        HKggvALmrRKdZfHRHVgg6G9tuitPpWkDct1lspOO8ZnDa5FFxg==
X-Google-Smtp-Source: ABdhPJwwvVRh7GzGav81qqwnElq39VP5rpZArnndCXz0RQGRhY3iQVwRJJVb65Tzvy3tHxGqoJceWXTIJEZ4M80Ye9c=
X-Received: by 2002:a92:d843:: with SMTP id h3mr18966003ilq.255.1593786830335;
 Fri, 03 Jul 2020 07:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200622232434.162730-1-caij2003@gmail.com> <20200703044832.GD23200@gondor.apana.org.au>
 <CA+icZUWwpY9rnfgyy81-78fH+PH4wmAS-+yZFBDCjBbARabQfg@mail.gmail.com> <20200703125949.GA28373@gondor.apana.org.au>
In-Reply-To: <20200703125949.GA28373@gondor.apana.org.au>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 3 Jul 2020 16:33:39 +0200
Message-ID: <CA+icZUU=OvtLpzgQyCckCJ-LJ5asGAJgCnVQF9f+Fn-7tKn5mQ@mail.gmail.com>
Subject: Re: [PATCH] crypto, x86: aesni: add compatibility with IAS
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Jian Cai <caij2003@gmail.com>, jiancai@google.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        manojgupta@google.com, maskray@google.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 3, 2020 at 3:00 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jul 03, 2020 at 10:36:43AM +0200, Sedat Dilek wrote:
> >
> > Can you please apply my patch, too?
>
> Please repost your patch without the 5.7 tag.
>

Sent out a v5:

Changes v4->v5:
- Drop "5.7" tag from subject line as requested by Herbert Xu
- Add Link to LLVM bug #24494 (thanks Nick)

Thanks.

- Sedat -

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200703125949.GA28373%40gondor.apana.org.au.
