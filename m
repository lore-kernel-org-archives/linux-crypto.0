Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134F1C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 18:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiAaSSE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343914AbiAaSSC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jan 2022 13:18:02 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37069C06173D
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jan 2022 10:18:02 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id u14so28574735lfo.11
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jan 2022 10:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ghH8jtplUqlqoTmkawJXMXbuH6NA7Ot3MZ8fNYa4sIs=;
        b=Y9U+b93Fixwmnt670FvcAf1nnjmkuxjYkp7xKkkknflknGCJbrUVfNnL/GDIIoWs13
         IxtBwK3FPUm1loJe3nb8E5KMK59s+IdSQt/B4b1zEVaLDbejh/mTlu4zJNydyiZy+d0q
         AtMrZxNtlNLlS+yjS4QJaCRA9P4ppaWeLVy6r5mAXkdYibmV7Z3/ZzfoWpwu4Q2W6R1M
         eWIJF9QX71E9MKKe/s1z9fozi5jmZF2vNe4QDSdTQMRcpUPN9+v3SaKo+ltvWLitgI54
         pClB0zbp46Ok82dyO2514A+WfixCWQAhbsVk2eGTerNfGKVmlu80drqykbJwXE2HbObq
         3KRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ghH8jtplUqlqoTmkawJXMXbuH6NA7Ot3MZ8fNYa4sIs=;
        b=zbeisCNEhs3R6tb5kS3deY6bUA5Fbb29u/diOlu6q491WyV1jXUNIxaoDAGdewxhrO
         IZg+QoI5e15QJTBePkamYa6+6sOTZJBTYwNjCxxHYDqkRk2tQLFxkFlJHMykcLzBmcDp
         +lz1XTMAQpjtRjchIqAhj4UubvsRQM8aXC9YM2WXHIQIIY/0UysADzZx3edW2VHISIqf
         dQ3xXeCNr7aL3gF9q0spaZ/Qj7yDz98PusRs9HnkTQe/agYIg5lL9CwnHlyXO+Te5Ys0
         81pxeRDsphnSIZt3qxcpJ7kGngl5bVkoIpc3hNJHH16O0ADluqUuCNl/d4u7QUMiHqDZ
         nUGA==
X-Gm-Message-State: AOAM532+BzPF4jZ8oLbB8WTulX/cCwlaSdlXBlv/D5yd9/esZEA9TAzS
        ms/XovWllwhYzhcriUHv/+Oy3kyUve2u6SSm1m7hHA==
X-Google-Smtp-Source: ABdhPJzOsII3rKHTFo22BGXW9GwCpgQGtKfVocjvPXZjMenHSnd71485hT0X2Oa+C80Zf6WziPjJ1GYr2hKVuM4uh+Q=
X-Received: by 2002:a05:6512:e87:: with SMTP id bi7mr16874064lfb.550.1643653080398;
 Mon, 31 Jan 2022 10:18:00 -0800 (PST)
MIME-Version: 1.0
References: <20220129224529.76887-1-ardb@kernel.org> <20220129224529.76887-2-ardb@kernel.org>
 <CAKwvOdmW6cxMT_X9T+O98x55MY_b0zCaJWArU4OfTay6Ceyovg@mail.gmail.com>
In-Reply-To: <CAKwvOdmW6cxMT_X9T+O98x55MY_b0zCaJWArU4OfTay6Ceyovg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 31 Jan 2022 10:17:49 -0800
Message-ID: <CAKwvOdkvAs95g0G4d=X7ZEB3-7d0gaHdsJ7Jjue6BWykWiwEWg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] lib/xor: make xor prototypes more friendely to
 compiler vectorization
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 31, 2022 at 10:13 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Sat, Jan 29, 2022 at 2:45 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Modern compilers are perfectly capable of extracting parallelism from
> > the XOR routines, provided that the prototypes reflect the nature of the
> > input accurately, in particular, the fact that the input vectors are
> > expected not to overlap. This is not documented explicitly, but is
> > implied by the interchangeability of the various C routines, some of
> > which use temporary variables while others don't: this means that these
> > routines only behave identically for non-overlapping inputs.
> >
> > So let's decorate these input vectors with the __restrict modifier,
> > which informs the compiler that there is no overlap. While at it, make
> > the input-only vectors pointer-to-const as well.
> >
> > Tested-by: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> Thanks for the patch!
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> I like how you renamed the parameters in
> arch/powerpc/include/asm/xor_altivec.h, arch/powerpc/lib/xor_vmx.h,
> and arch/powerpc/lib/xor_vmx_glue.c.  It's not befitting for the
> suffix _in to be used when the first param is technically more of an
> "inout" param.  Though, you might also want to update the parameter
> names in arch/powerpc/lib/xor_vmx.c.

Also, this patch fixes an instance of -Wframe-larger-than we observed with ppc:

Link: https://github.com/ClangBuiltLinux/linux/issues/563
-- 
Thanks,
~Nick Desaulniers
