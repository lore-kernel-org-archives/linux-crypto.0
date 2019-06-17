Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDF6C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 18:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB53F208C0
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 18:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s2x+GLgj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfFQSGe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 14:06:34 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33171 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfFQSGd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 14:06:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so4422219plo.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 11:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhRgtDIt6R2N0eJi1UmB7YTz8KS8tM0macXGE9nqdZc=;
        b=s2x+GLgjYPd8Xg0GhBSWf6eW8XLV4JUoqr3G1YmHuu2K+iodUBvpvu1YQPwASYoFop
         WAADcSL6bJOwSCY1j2DMOJTT805W2qfalJy+e8iwd5DvhJeIMGthWstPQzA7NDR4JG8L
         mtsNlEz75urLATfYZAMwKA90dIBsiAyVc7APR77tupQtMuQfAmfkkN+eKBDx5uP0AemN
         4FC6U8H0dOWiEh8cRxzudB6Bd+cyYseC7zS2g7SVAt//i+MlwzASXf6y7s17A4nAToBD
         JTrgRNA32dyXdhaNUyaB0vgnqIxz1LkDBQod7X0/VpJ9QLccQmW9AatG3GvJvsINcxsx
         D0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhRgtDIt6R2N0eJi1UmB7YTz8KS8tM0macXGE9nqdZc=;
        b=U1XtubQlrz/HIm9g1LUwt11tHlghKxfsH2UBhFQlx43ql/0/nsLcCVMjkHO8YskOFm
         uYp19NqjdsGaZUxkhAjNEUdltx1ySxblNZbJWwNrDXGfcrXr1rPdGM9vRw7ijBgSM+eC
         QZ7DZnp1BY//MQZ0ZQhb+HV7SWunK04Yyviu+cp+c9o6Oa8WcF08scVcxYNjqLXupMC+
         6Rij3jJgQ7rCmJP4et+fraOv/X87hh/b69eZ1dl9xXIPL8U3oiv068wGJr+P8YdyjHv5
         tI0VhuqGvPYUrI1EwNTiCqka6zS2UgnPFVbCyCU/+BMTZ6qr6rJuBQ9iZKYtDRj+Vng3
         kpaA==
X-Gm-Message-State: APjAAAWpHFA++BEa0YLLSbRt+Ey8eDd12v/qpXvG/8DGeDFzrzwhDqA4
        cUWBaOp74ohCcsfQB7pNV0BSAwIVOUwbRJE5sQ8LqA==
X-Google-Smtp-Source: APXvYqxtJsqT6d1q0UH9MlyOBm2K+9CPyi3fn81/wmR0jrdsZKIVXELsXKyevIUptLTT241ffLu3bmLl12whdmlv6MA=
X-Received: by 2002:a17:902:9f93:: with SMTP id g19mr93428569plq.223.1560794792655;
 Mon, 17 Jun 2019 11:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
In-Reply-To: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 17 Jun 2019 11:06:21 -0700
Message-ID: <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 6:35 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Hi,
>
> while digging through a ClangBuiltLinux issue when linking with LLD
> linker on x86-64 I checked the settings for...
>
> .rodata.cst16 and .rodata.cst32
>
> ...in crypto tree and fell over this change in...
>
> commit "crypto: x86/crct10dif-pcl - cleanup and optimizations":
>
> -.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16
> +.section .rodata.cst32.byteshift_table, "aM", @progbits, 32
> .align 16
>
> Is that a typo?
> I would have expected...
> .rodata.cst32.XXX -> .align 32
> or
> rodata.cst16.XXX -> .align 16
>
> But I might be wrong as I am no expert for crypto and x86/asm.
>
> Thanks in advance.
>
> Regards,
> - Sedat -
>
> [1] https://github.com/ClangBuiltLinux/linux/issues/431
> [2] https://bugs.llvm.org/show_bug.cgi?id=42289

> [3] https://git.kernel.org/linus/0974037fc55c

+ Peter, Fangrui (who have looked at this, and started looking into
this from LLD's perspective)

In fact, looking closer at that diff, the section in question
previously had 32b alignment.  Eric, was that change intentional?  It
seems funny to have a 32b entity size but a 16b alignment.

PDF page 81 / printed page 67 of this doc:
https://web.eecs.umich.edu/~prabal/teaching/resources/eecs373/Assembler.pdf
says:

"The linker may remove duplicates within sections with the
same name, same entity size and same flags. "

So for us, LLD is NOT merging these sections due to differing
alignments, which is producing warnings when loading such kernel
modules that link against these object files.
-- 
Thanks,
~Nick Desaulniers
