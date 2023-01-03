Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D396BC3DA7D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 14:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbjACOCG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 09:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbjACOCF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 09:02:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB85FD2F3
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 06:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66330B80ED7
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 14:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D60C433F1
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672754521;
        bh=KwR+AP7Jj+KziTdD94+570fYpG8HYLialbGB47tPHII=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i8glW/OpsEPIikQMPpQUDIxX9d2SmSoSSvnlhb5o0d82VZypJ0iDqM6kSUWMZ5lLq
         f9x0fq90c0KjKfrZfMp1YHdtZ2TkdywOpx8BYagvv46PiPWunWuMj6gHfgSvR20ILo
         +1zF4XALDYUHZe3Gyd2I7SAp6j2JAZOEWezS/9jPIljVSYyqzCSa6axLEGYTkI8w2E
         wvjkn37ZSn8mMMs0BMsHsHTL9F1Y5dOSM61k/xEpPDdoAM23W8UL5shd5UFhOdtc0z
         eBrPA8oLipR+CPVp2yJ6sB6yNfjh9kUi9mPRoebFVu3rlgfyVMw3tGLX465k4pQ2QD
         ccusyp3H6U0bg==
Received: by mail-lf1-f50.google.com with SMTP id j17so36285782lfr.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 06:02:01 -0800 (PST)
X-Gm-Message-State: AFqh2kqk0VNvAryu+KhR6J1HWE2EkK2vQlhwYyYIVyATR/HghLJKWsC+
        eEe4NSqZc7e/TiSZkE7YRcSBSVJQNaUoiyHoQbY=
X-Google-Smtp-Source: AMrXdXvvUPTpuOQmiShGvU2ZCphvRuE1oYKbP2mg/TCbIjRh7zK8KT5uVmS9NFiY1/WWDcKE2GkrFlVYfXe+SpRXTs0=
X-Received: by 2002:ac2:5d4e:0:b0:4b5:964d:49a4 with SMTP id
 w14-20020ac25d4e000000b004b5964d49a4mr3738999lfd.637.1672754519038; Tue, 03
 Jan 2023 06:01:59 -0800 (PST)
MIME-Version: 1.0
References: <CGME20230103111359eucas1p137cb823bdc80d790544de20c3835faf2@eucas1p1.samsung.com>
 <Y7NizHFsWfMW/cC2@sol.localdomain> <dleftjbknfoopx.fsf%l.stelmach@samsung.com>
In-Reply-To: <dleftjbknfoopx.fsf%l.stelmach@samsung.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 3 Jan 2023 15:01:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGY4zZovOKY5kD54pFEXeOoX=3JCuHVCDpQJf+Wo+oBiw@mail.gmail.com>
Message-ID: <CAMj1kXGY4zZovOKY5kD54pFEXeOoX=3JCuHVCDpQJf+Wo+oBiw@mail.gmail.com>
Subject: Re: xor_blocks() assumptions
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 3 Jan 2023 at 12:14, Lukasz Stelmach <l.stelmach@samsung.com> wrote:
>
> It was <2023-01-02 pon 15:03>, when Eric Biggers wrote:
> > On Mon, Jan 02, 2023 at 11:44:35PM +0100, Lukasz Stelmach wrote:
> >> I am researching possibility to use xor_blocks() in crypto_xor() and
> >> crypto_xor_cpy(). What I've found already is that different architecture
> >> dependent xor functions work on different blocks between 16 and 512
> >> (Intel AVX) bytes long. There is a hint in the comment for
> >> async_xor_offs() that src_cnt (as passed to do_sync_xor_offs()) counts
> >> pages. Thus, it is assumed, that the smallest chunk xor_blocks() gets is
> >> a single page. Am I right?
> >>
> >> Do you think adding block_len field to struct xor_block_template (and
> >> maybe some information about required alignment) and using it to call
> >> do_2 from crypto_xor() may work? I am thinking especially about disk
> >> encryption where sectors of 512~4096 are handled.
> >>
> >
> > Taking a step back, it sounds like you think the word-at-a-time XOR in
> > crypto_xor() is not performant enough, so you want to use a SIMD (e.g. NEON,
> > SSE, or AVX) implementation instead.
>
> Yes.
>
> > Have you tested that this would actually give a benefit on the input
> > sizes in question,
>
> --8<---------------cut here---------------start------------->8---
> [    0.938006] xor: measuring software checksum speed
> [    0.947383]    crypto          :  1052 MB/sec
> [    0.953299]    arm4regs        :  1689 MB/sec
> [    0.960674]    8regs           :  1352 MB/sec
> [    0.968033]    32regs          :  1352 MB/sec
> [    0.972078]    neon            :  2448 MB/sec
> --8<---------------cut here---------------end--------------->8---
>

This doesn't really answer the question. This only tells us that NEON
is faster on this core when XOR'ing the same cache-hot page multple
times in succession.

So the question is really which crypto algorithm you intend to
accelerate with this change, and the input sizes it operates on.

If the algo in question is the generic XTS template wrapped around a
h/w accelerated implementation of ECB, I suspect that we would be
better off wiring up xor_blocks() into xts.c, rather than modifying
crypto_xor() and crypto_xor_cpy(). Many other calls to crypto_xor()
operate on small buffers where this optimization is unlikely to help.

So rephrase the question: which invocation of crypto_xor() is the
bottleneck in the use case you are trying to optimize?


> (Linux 6.2.0-rc1 running on Odroid XU3 board with Arm Cortex-A15)
>
> The patch below copies, adapts and plugs in __crypto_xor() as
> xor_block_crypto.do_2. You can see its results labeled "crypto" above.
> Disk encryption is comparable to RAID5 checksumming so the results above
> should be adequate.
>
> > especially considering that SIMD can only be used in the kernel if
> > kernel_fpu_begin() is executed first?
>
> That depends on architecture. As far as I can tell this applies to Intel
> only.
>

On ARM, you must use kernel_neon_begin/_end() when using SIMD in
kernel mode, which comes down to the same thing.

> > It also would be worth considering just optimizing crypto_xor() by
> > unrolling the word-at-a-time loop to 4x or so.
>
> If I understand correctly the generic 8regs and 32regs implementations
> in include/asm-generic/xor.h are what you mean. Using xor_blocks() in
> crypto_xor() could enable them for free on architectures lacking SIMD or
> vector instructions.
>

-- 
Ard.
