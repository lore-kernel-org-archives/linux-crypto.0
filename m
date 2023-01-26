Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A17C05027
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Jan 2023 17:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjAZRxI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Jan 2023 12:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjAZRxE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2023 12:53:04 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B140BC5
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2023 09:53:02 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id y69so882224iof.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Jan 2023 09:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ruZ3ZrhvHKFVcSAooTKjxNYHkuqfA/6C+pUVjWMpIMY=;
        b=MXieEj45X6rjvlxfCCELBcxmLzDlhJGxXeqBF45+9oOOH8vol56kN8FkPXQgxwEfeF
         da6n/39dXt8sywTEkd1Id73g818je8vc5fkP2S+2RR6oVAUSi4l+rPS9La8OVW64R3Bz
         DVzPO0LfMky8awGycoyTrCpSPt65oEuZ7IxcSOs4pjuLDw9KzXaJSsVB8lsmOv9A8zaU
         DbG4dii524I9mbc+Dx3+CfMFzFB+sHr+k5qZercOSzGgVWtbrWJYF4nOaCweiyidflMX
         KTBXKEOqr206gYq2MiOCYgCLCF9evAqcy1fiBaJ5XTdwfCD87BusKFA1GlG/38/JYmNe
         AmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ruZ3ZrhvHKFVcSAooTKjxNYHkuqfA/6C+pUVjWMpIMY=;
        b=1edG/HK85rYsKDhtmRSlaq0hPHQMrKazVvcM1BI0/HndSpUew/q+SWGcln6G8w7sCP
         dpD1zYG3rB8VJHvjZshLsUCO0rkcIkKu2tHZZZCHvyNU1nlIspExIB9XxTZ7Or1SPBvT
         2xPdN0RL/Pq86gG1iNcnVd+H8Uw9AR64Pox6BOedQWWCCkUJ1vSo7fmPxWYeDxPgIwbP
         C3kUe0tOQfz4RT7SQ1TwgH0ofCwNdaUTTkrtA0zvCSU0RHP59I1kl4k8LH8fjBHas6Iw
         DZVfIh4ZuEFGDbw2/Zo2SCV8/MJHVI5AXwU0XTwdDcAW0btWEcP8/I4kvtLZiYZkAFIl
         V41w==
X-Gm-Message-State: AO0yUKWSW2zBMwtuLBZPe0zRbZj9NRi0hWLW7Mzqy458TuX1gN7rgHup
        oanofjXsdssdICNRIlhO+sVYuQLoCk/AM5Q+0Me7Fg==
X-Google-Smtp-Source: AK7set/MCSfMfvEfBfkfQ92GW9bItojOLmYBxL6p19AIsziIQFN4rj32CaYwboxczS0X6jA2HNS7XYcHbi/GzYjJzdM=
X-Received: by 2002:a02:ad06:0:b0:3a9:5776:864 with SMTP id
 s6-20020a02ad06000000b003a957760864mr784150jan.67.1674755581907; Thu, 26 Jan
 2023 09:53:01 -0800 (PST)
MIME-Version: 1.0
References: <20230125012801.362496-1-ebiggers@kernel.org> <14506678-918f-81e1-2c26-2b347ff50701@intel.com>
 <CAG48ez1NaWarARJj5SBdKKTYFO2MbX7xO75Rk0Q2iK8LX4BwFA@mail.gmail.com> <394c92e2-a9aa-37e1-7a34-d7569ac844fd@intel.com>
In-Reply-To: <394c92e2-a9aa-37e1-7a34-d7569ac844fd@intel.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 26 Jan 2023 18:52:25 +0100
Message-ID: <CAG48ez0ZK3pMqkto4DTZPNyddYcv8jPHQDNhYoFEPvSRLf80fQ@mail.gmail.com>
Subject: Re: [PATCH] x86: enable Data Operand Independent Timing Mode
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Roxana Bradescu <roxabee@chromium.org>,
        Adam Langley <agl@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 26, 2023 at 5:40 PM Dave Hansen <dave.hansen@intel.com> wrote:
> On 1/26/23 05:52, Jann Horn wrote:
> > On Wed, Jan 25, 2023 at 4:30 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >> Translating from Intel-speak: Intel thinks that DOITM purely a way to
> >> make the CPU run slower if you haven't already written code specifically
> >> to mitigate timing side channels.  All pain, no gain.
> >>
> >> The kernel as a whole is not written that way.
> >
> > The kernel as a whole also doesn't really use the FPU registers for
> > anything other than checksumming and cryptography and stuff like that
> > (it's disabled in the compiler flags because the FPU registers
> > normally contain userspace state that must not be clobbered). The
> > instructions listed on that Intel help page are all weird PM* and VP*
> > arithmetic instructions that can't be generated from C code in the
> > kernel (except for weird subsystems in which every function is only
> > callable in kernel-FPU-enabled mode and the compiler is set to enable
> > FPU instruction generation, by which I mean amdgpu).
>
> Maybe I'm totally missing something, but I thought the scope here was
> the "non-data operand independent timing behavior for the listed
> instructions" referenced here:
>
> > https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/best-practices/data-operand-independent-timing-isa-guidance.html
>
> where the "listed instructions" is this list:
>
> > https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/resources/data-operand-independent-timing-instructions.html
>
> For example, that includes XOR with the 0x31 and 0x81 opcodes which
> there are plenty of in the kernel.

That list says at the top: "The table below lists instructions that
have data-independent timing."

And the "MCDT (MXCSR-Sensitivity)" column that marks instructions that
do not actually have data-independent timing if you set the MSR to the
unsafe state is only marked for PMADDUBSW, PMADDWD, PMULDQ, PMULHRSW,
PMULHUW, PMULHW, PMULLD, PMULLW, PMULUDQ, VPLZCNTD, VPLZCNTQ,
VPMADD52HUQ, VPMADD52LUQ, VPMADDUBSW, VPMADDWD, VPMULDQ, VPMULHRSW,
VPMULHUW, VPMULHW, VPMULLD, VPMULLQ, VPMULLW, VPMULUDQ. All the others
are guaranteed to always have data-independent timing, if I understand
the table correctly.

> That's a bit wider scope than the crazy instructions like VPLZCNTD.  The
> crazy instructions list that I _think_ you were grepping for is the
> "Instructions That May Exhibit MCDT Behavior".  That's also a fun one,
> but it is more narrow than the DOITM list.
