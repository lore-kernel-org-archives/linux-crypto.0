Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EDEC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 07:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C56223EA
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 07:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603699190;
	bh=jYdIdsNjmje85/OahkfgmIoyvbe7j1NvJRrBjFN21iY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=rz/C9yxXnVpiMxbT0zvrVjtU7gxvwbMgWLJQujFvM53ktn7JbuA8EiKit+dZanu14
	 xRasJdr8QBb8m4dJHreyUX1RwrwHQHncWW42u+tnnb4c79ep7e6/e8gr77emGvPb7X
	 2U7IVrn+aAyJDDoLaUN1IZl/A9D7LhmGLmMIDtAA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771096AbgJZH7t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 03:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771094AbgJZH7t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 03:59:49 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812A9223FD;
        Mon, 26 Oct 2020 07:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603699188;
        bh=jYdIdsNjmje85/OahkfgmIoyvbe7j1NvJRrBjFN21iY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z53RwD0Z6csnVO5i7SxS2CqeGr/oh4P9GOxJ9u7fYuvL393DCMgdh57PsGab9s/7y
         jf8URi7JZMrVrk1NRNRC0qUronTeRiU8Bh+fpHGHMQ38hKFMywW0PNcsQQ4MQ9uUMJ
         bvJKlboiwWozqGVRjudaJziKOIVLtff2vk9KrHSs=
Received: by mail-ot1-f42.google.com with SMTP id 32so7239660otm.3;
        Mon, 26 Oct 2020 00:59:48 -0700 (PDT)
X-Gm-Message-State: AOAM532FMR4deOmLUh3jeX1oEF0Uw0KWBm04EbyUcBtzM6N8LqL65qHQ
        jzjoTRNtBnpY0BPZvFN924gMrD1RQIrwlDILt80=
X-Google-Smtp-Source: ABdhPJy1vu2SPxlhIzlBm29ayhsI84rkhV1k3EPtSv1ap72yxCz9fKlnyRp+dlxpo0d3V10fVfkGolTvfJszJ84L3Lg=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr10154207ots.90.1603699187814;
 Mon, 26 Oct 2020 00:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201025143119.1054168-1-nivedita@alum.mit.edu> <20201025143119.1054168-4-nivedita@alum.mit.edu>
In-Reply-To: <20201025143119.1054168-4-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Oct 2020 08:59:37 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGOQxymx7zKCV8dmy2-0ypvVumDb1thGKCqrKXQrSbZ9Q@mail.gmail.com>
Message-ID: <CAMj1kXGOQxymx7zKCV8dmy2-0ypvVumDb1thGKCqrKXQrSbZ9Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] crypto: lib/sha256 - Don't clear temporary variables
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 25 Oct 2020 at 15:31, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> The assignments to clear a through h and t1/t2 are optimized out by the
> compiler because they are unused after the assignments.
>
> Clearing individual scalar variables is unlikely to be useful, as they
> may have been assigned to registers, and even if stack spilling was
> required, there may be compiler-generated temporaries that are
> impossible to clear in any case.
>
> So drop the clearing of a through h and t1/t2.
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/sha256.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index d43bc39ab05e..099cd11f83c1 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -202,7 +202,6 @@ static void sha256_transform(u32 *state, const u8 *input)
>         state[4] += e; state[5] += f; state[6] += g; state[7] += h;
>
>         /* clear any sensitive info... */
> -       a = b = c = d = e = f = g = h = t1 = t2 = 0;
>         memzero_explicit(W, 64 * sizeof(u32));
>  }
>
> --
> 2.26.2
>
