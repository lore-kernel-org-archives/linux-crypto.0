Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9887FC4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 17:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC9C229CA
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 17:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbhAKR2u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbhAKR2p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 12:28:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 369C722ADF
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610386085;
        bh=sfYwU8Z/mmlETt8BfyTFtcWDnJ+dgKTdDefZ9u/qr6M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CQx4suZe8HlRn5mD1whm99zsJsVBKBg730lAAr+jzE2xkxnnrI2gdj/KRhCQK/jVa
         o6gDF+xhEWMy1V5d/Y9fGkZ45z6bFd5voYxZk+7vAwCIpjB8/9CPD+uFZPxOhUQMYi
         TmcKdtd7PYiXQ25T7xxyFkL4jxwiIl55NGCczSPkcv38tDAGfyj5QzdDpO2fBygvDu
         Y0NsrD9f6Wjn+wS7huwD5wldWM2KOKJ+yNACbSH7kZgAeVJrkRZMUqWY9dIgk58P3y
         MchstJz8wj/QyrISYC/S7o4lQhd4SumMK11X416tp0oiNU/h7sa3b+wXvYgVZN+sce
         AExEBovZk8t4A==
Received: by mail-ot1-f47.google.com with SMTP id i6so437694otr.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 09:28:05 -0800 (PST)
X-Gm-Message-State: AOAM531+sowvrpspdVVB7uY0Nok9oclRhLQ8i4Vt5A8vRCzzSxeTywG3
        Aqxe8oqAI78GVoYkKSOKS/2lquSOLFaDUYfH4dM=
X-Google-Smtp-Source: ABdhPJw7PLpJN217DFGY9So7oyBQLLMBd9zzn0aETA9A9Hna+LVYc24r5ggyjwNzaiKHrXrsr+Kjg2sohuWzSxQNhX4=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr169444ote.108.1610386084553;
 Mon, 11 Jan 2021 09:28:04 -0800 (PST)
MIME-Version: 1.0
References: <20210111165237.18178-1-ardb@kernel.org>
In-Reply-To: <20210111165237.18178-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 11 Jan 2021 18:27:53 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEBPjmCGPPme=rXqadLQeNdqzeyr7uw1WsUoHUqQv1_LQ@mail.gmail.com>
Message-ID: <CAMj1kXEBPjmCGPPme=rXqadLQeNdqzeyr7uw1WsUoHUqQv1_LQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 11 Jan 2021 at 17:52, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> CRC-T10DIF is a very poor match for the crypto API:
> - every user in the kernel calls it via a library wrapper around the
>   shash API, so all callers share a single instance of the transform
> - each architecture provides at most a single optimized implementation,
>   based on SIMD instructions for carryless multiplication
>
> In other words, none of the flexibility it provides is put to good use,
> and so it is better to get rid of this complexity, and expose the optimized
> implementations via static calls instead. This removes a substantial chunk
> of code, and also gets rid of any indirect calls on architectures that
> obsess about those (x86)
>
> If this approach is deemed suitable, there are other places where we might
> consider adopting it: CRC32 and CRC32(C).
>
> Patch #1 does some preparatory refactoring and removes the library wrapper
> around the shash transform.
>
> Patch #2 introduces the actual static calls, along with the registration
> routines to update the crc-t10dif implementation at runtime.
>
> Patch #3 updates the generic CRC-T10DIF shash driver so it distinguishes
> between the optimized library code and the generic library code.
>
> Patches #4 to #7 update the various arch implementations to switch over to
> the new method.
>
> Special request to Peter to take a look at patch #2, and in particular,
> whether synchronize_rcu_tasks() is sufficient to ensure that a module
> providing the target of a static call can be unloaded safely.
>

It seems I may have managed to confuse myself slightly here: without
an upper bound on the size of the input of the crc_t10dif() routine, I
suppose we can never assume that all its callers have finished.

Insights welcome ...
