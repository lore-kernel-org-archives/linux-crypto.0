Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF1CC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 07:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40056223AC
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 07:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603699161;
	bh=/fGqu8xrhCGoVU5KPsNJLhNRGjQAfSf+VUBWI9Mep8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=PEZOsNxo0o2tigV38pssotque9KzscFtbHGErMpk2u1MhTpYtSUB93yDH53s0W2dd
	 8ElDYM14SjgTIcepouA5WKcL7ckIslyQvD9thdeQFzsaWd04SKRXZZYC8MSanih9hV
	 bmXUX9bmdhp2IDS7eUtqZoUJkaXWECiPEnoMNdC8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771081AbgJZH7U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 03:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771080AbgJZH7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 03:59:19 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD8B1223B0;
        Mon, 26 Oct 2020 07:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603699158;
        bh=/fGqu8xrhCGoVU5KPsNJLhNRGjQAfSf+VUBWI9Mep8c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rHdzkpMWjr0vpfR6LZj2Ys6WLEXpmKcPrV8LKONe55e3nBNbBj5jy2awA04gLaZbV
         7E1ypKSvdyv3CeA9ZIW8so7T3yvQ3Ykvco4SVOY/oi7srou7Gg6p1giig/7/fhNdvt
         ArdCZGl/kCg1bCxsd2q5eJKiqH6hTsEf+umgbanM=
Received: by mail-ot1-f42.google.com with SMTP id f37so7194818otf.12;
        Mon, 26 Oct 2020 00:59:18 -0700 (PDT)
X-Gm-Message-State: AOAM531TSE/0R4LXYeOHtixhMqhzp/J3AzTbPjpIjXqGsEudzQjxlrp9
        v9ml2g/W1qtWGSdxOBylQMDWCTrbXvTwKL9oM0o=
X-Google-Smtp-Source: ABdhPJzHPJqtWVcWZzDlg9b8POsi0aa/92lqVDfVzrJ35httQg+D1x+4YMRnD8KWwSuImG03Q9r2Cry8c4YmE/vxR3w=
X-Received: by 2002:a05:6830:1f13:: with SMTP id u19mr3277545otg.108.1603699158195;
 Mon, 26 Oct 2020 00:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201025143119.1054168-1-nivedita@alum.mit.edu> <20201025143119.1054168-2-nivedita@alum.mit.edu>
In-Reply-To: <20201025143119.1054168-2-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Oct 2020 08:59:07 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE618YtdrCg7BRqiD2K4S2x1S7L7gZgS+25WUNM+Q8TFw@mail.gmail.com>
Message-ID: <CAMj1kXE618YtdrCg7BRqiD2K4S2x1S7L7gZgS+25WUNM+Q8TFw@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] crypto: lib/sha256 - Use memzero_explicit() for
 clearing state
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
> Without the barrier_data() inside memzero_explicit(), the compiler may
> optimize away the state-clearing if it can tell that the state is not
> used afterwards. At least in lib/crypto/sha256.c:__sha256_final(), the
> function can get inlined into sha256(), in which case the memset is
> optimized away.
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/sha256.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 2321f6cb322f..d43bc39ab05e 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -265,7 +265,7 @@ static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
>                 put_unaligned_be32(sctx->state[i], &dst[i]);
>
>         /* Zeroize sensitive information. */
> -       memset(sctx, 0, sizeof(*sctx));
> +       memzero_explicit(sctx, sizeof(*sctx));
>  }
>
>  void sha256_final(struct sha256_state *sctx, u8 *out)
> --
> 2.26.2
>
