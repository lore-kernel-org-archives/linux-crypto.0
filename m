Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4322C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Dec 2022 10:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiLOKX2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Dec 2022 05:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiLOKXO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2022 05:23:14 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D993727909
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:22:58 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v126so1174656ybv.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AwhkEbxM6tluhQHQ2bMB+VVzWMkBJMG5LjBZ53z9agQ=;
        b=df6yB12zHMgxqT0YjoTekaQalMFCuXOyvsiuJqcoR1wyiF6r3guce+kram8HT5zyk4
         B9eKS2zuJ6t8894vy+P67gkGl3AunmrZHnVjiCQZluCJPUGQOL+dx4C2iYJdeMBlPuso
         P5d46zwMWaDRuKz+Oy4qnPFRoDbbGQm4kcXNzYY89NWdkt7QL+M0BRj5hZiAUFBMECqG
         itBWzkas8gonRf1N0sdEc8Zcm6Q8vJLWnHmmlXDpJBvLHF8S4ePbuxM/yfJdHSZV4WOP
         44NiBLRC43/rQrcUiS/Lm5iRNWxP4Q8rrhNMdKLBygRDzs0/xbI4moDu/xg3Wq7Y8vkL
         zlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AwhkEbxM6tluhQHQ2bMB+VVzWMkBJMG5LjBZ53z9agQ=;
        b=2OLrQ15bKUfWJqPduGkLwON9cAhuCDfjEXNDGSt/xP3q5t6k/45S6J5TFieWEbQXjI
         O45uYd9ccceoLDIUM+TwA4Q/D4yk+x/X5E/GAMQva/uQgC4wz4zFgzbhXY53QmblncC4
         mfdRz3B+Dq22kFr8OAqqj26B/ebNJdrEc5RtiXzbwnzAFrlN4J2QvT7QVL59GgL0hn+s
         NvNS/2h8JcUIdNmdHTfEPv+KI/xRD26SnOee3+xswarM9Bg5eO6R0KJkrMSaYBtGB+qW
         VToKXXcKsJ48gfRjF95Tp3LaieRfmWAD9EhEIoDvJAqFq94PBIN1uRnkyD17f6YhqLKQ
         XbQw==
X-Gm-Message-State: ANoB5pnOy/S4HnMk1DDw6Upa2JmfiOmHo57FpOLUQ1gVkYYykCODu1Sn
        LVydqElUvooQk04zUGm3Nw2N9wRkvxLSngGiewk3HU4vMuKfViqs
X-Google-Smtp-Source: AA0mqf5R8cdwngRlCXsYEEB4ePShZ4y5CTQfa/eIVb58a6nYbRmHstyShfyTvDDj51eHdZAeqLoxqn+XmU/v0dAnTCk=
X-Received: by 2002:a25:7648:0:b0:6fe:54d5:2524 with SMTP id
 r69-20020a257648000000b006fe54d52524mr24044987ybc.522.1671099777243; Thu, 15
 Dec 2022 02:22:57 -0800 (PST)
MIME-Version: 1.0
References: <20221207103936.2198407-1-ardb@kernel.org> <20221207103936.2198407-2-ardb@kernel.org>
In-Reply-To: <20221207103936.2198407-2-ardb@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 15 Dec 2022 11:22:46 +0100
Message-ID: <CACRpkdZ6qYG2N=W-zcOutPApJ+r_3xJ5ax5dQBhVjS9hky1trA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ARM: vfp: Manipulate VFP state with softirqs disabled
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 7, 2022 at 11:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:

> In a subsequent patch, we will relax the kernel mode NEON policy, and
> permit kernel mode NEON to be used not only from task context, as is
> permitted today, but also from softirq context.
>
> Given that softirqs may trigger over the back of any IRQ unless they are
> explicitly disabled, we need to address the resulting races in the VFP
> state handling, by disabling softirq processing in two distinct but
> related cases:
> - kernel mode NEON will leave the FPU disabled after it completes, so
>   any kernel code sequence that enables the FPU and subsequently accesses
>   its registers needs to disable softirqs until it completes;
> - kernel_neon_begin() will preserve the userland VFP state in memory,
>   and if it interrupts the ordinary VFP state preserve sequence, the
>   latter will resume execution with the VFP registers corrupted, and
>   happily save them to memory.
>
> Given that disabling softirqs also disables preemption, we can replace
> the existing preempt_disable/enable occurrences in the VFP state
> handling asm code with new macros that dis/enable softirqs instead.
> In the VFP state handling C code, add local_bh_disable/enable() calls
> in those places where the VFP state is preserved.
>
> One thing to keep in mind is that, once we allow NEON use in softirq
> context, the result of any such interruption is that the FPEXC_EN bit in
> the FPEXC register will be cleared, and vfp_current_hw_state[cpu] will
> be NULL. This means that any sequence that [conditionally] clears
> FPEXC_EN and/or sets vfp_current_hw_state[cpu] to NULL does not need to
> run with softirqs disabled, as the result will be the same. Furthermore,
> the handling of THREAD_NOTIFY_SWITCH is guaranteed to run with IRQs
> disabled, and so it does not need protection from softirq interruptions
> either.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Tricky patch, I had to read it a few times and visualize the concepts,
but I am sufficiently convinced that it does the right thing.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
