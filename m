Return-Path: <SRS0=AMvw=QM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62615C282D7
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C53F20844
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Feb 2019 09:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfBEJbJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Feb 2019 04:31:09 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40733 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbfBEJbJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Feb 2019 04:31:09 -0500
Received: by mail-ot1-f66.google.com with SMTP id s5so4579004oth.7
        for <linux-crypto@vger.kernel.org>; Tue, 05 Feb 2019 01:31:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EtmGn+xXsDk5C/YUn8SkWO501C3T7/VLddv7mal6Tyc=;
        b=N/cmGoBZgpUNp84ZMV5BHUZeDQwsYSLhUyaaBZnVMaTbL5TF+mVbVPLW2ouiNVE9LV
         ssdwtSd3icMeXGToGYfkGyR0h2Fh/a0ngyifKjBAJUmWff2okkpOZx4kSPcPyTCUjKDr
         gHqKu/dUh6p6ZxatZJ8WBAsGFOXvGIbBrsXTfFRoeDl/GmFLivvtuYgzgC8FoUru8ecA
         is/bS3NloYZAH9+7KxCmHh0axdIvIc7DOFmzIPUAcA2PC5dp++I5I3d3MKYhKeaVPMpu
         0O5uPLOXqa5S7maRS3ZNrDV+SrSLdjWmFYwQ6ELOnFknyiO5IvNBM8DKnsy5ZWJfTpRK
         XwHw==
X-Gm-Message-State: AHQUAuaGpD2NRhqyJV2r+AHu/Bz1Cs/Fj2l4W5WjoTiF/pBNMBQlkwv4
        An6a9iVWUGW9R3LWvWW7SaUKL48i43phEVkaP/hCJQ==
X-Google-Smtp-Source: AHgI3IZeaHVB2+0X5o/rGob63wmfRSc7/uZpsVMynWAF02NquH9eqCYRpzvPEOXXfDC0jOHpmQdM5kvwzF7nG+d+eFU=
X-Received: by 2002:aca:2403:: with SMTP id n3mr2048061oic.328.1549359068575;
 Tue, 05 Feb 2019 01:31:08 -0800 (PST)
MIME-Version: 1.0
References: <20190201075150.18644-1-ebiggers@kernel.org> <20190201075150.18644-3-ebiggers@kernel.org>
In-Reply-To: <20190201075150.18644-3-ebiggers@kernel.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 5 Feb 2019 10:30:57 +0100
Message-ID: <CAFqZXNtqwiEZCd1Ua2NMHX8Lr20ptbM7yQL5m-bwXUztXGAWdA@mail.gmail.com>
Subject: Re: [PATCH v2 02/15] crypto: morus - fix handling chunked inputs
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 1, 2019 at 8:52 AM Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The generic MORUS implementations all fail the improved AEAD tests
> because they produce the wrong result with some data layouts.  The issue
> is that they assume that if the skcipher_walk API gives 'nbytes' not
> aligned to the walksize (a.k.a. walk.stride), then it is the end of the
> data.  In fact, this can happen before the end.  Fix them.
>
> Fixes: 396be41f16fd ("crypto: morus - Add generic MORUS AEAD implementations")
> Cc: <stable@vger.kernel.org> # v4.18+
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>


> ---
>  crypto/morus1280.c | 13 +++++++------
>  crypto/morus640.c  | 13 +++++++------
>  2 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/crypto/morus1280.c b/crypto/morus1280.c
> index 78ba09db7328c..0747732d5b78a 100644
> --- a/crypto/morus1280.c
> +++ b/crypto/morus1280.c
> @@ -362,18 +362,19 @@ static void crypto_morus1280_process_crypt(struct morus1280_state *state,
>                                            const struct morus1280_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *dst;
> -       const u8 *src;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, walk.nbytes);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>  }
>
> diff --git a/crypto/morus640.c b/crypto/morus640.c
> index 5cf530139b271..1617a1eb8be13 100644
> --- a/crypto/morus640.c
> +++ b/crypto/morus640.c
> @@ -361,18 +361,19 @@ static void crypto_morus640_process_crypt(struct morus640_state *state,
>                                           const struct morus640_ops *ops)
>  {
>         struct skcipher_walk walk;
> -       u8 *dst;
> -       const u8 *src;
>
>         ops->skcipher_walk_init(&walk, req, false);
>
>         while (walk.nbytes) {
> -               src = walk.src.virt.addr;
> -               dst = walk.dst.virt.addr;
> +               unsigned int nbytes = walk.nbytes;
>
> -               ops->crypt_chunk(state, dst, src, walk.nbytes);
> +               if (nbytes < walk.total)
> +                       nbytes = round_down(nbytes, walk.stride);
>
> -               skcipher_walk_done(&walk, 0);
> +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> +                                nbytes);
> +
> +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
>  }
>
> --
> 2.20.1
>


--
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
