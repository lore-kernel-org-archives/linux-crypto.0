Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD12C2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 08:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DF5C20773
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 08:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603699345;
	bh=u7gIFsaZApJjD2/VYS+ThxztiaP8WkJFHr4IYJ9i5Ug=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XEO0H1alBFqnTIAFn2p32feNez2cdrRroWsXFVMUWdFnkuokCMt78eiGfy46w677i
	 nj/7uEd15lM30DHYt7C0UIclf1dsCNoKNvhLANIvq/Wny0A2Wgq17pbsmUGVhnN1sT
	 xQf919y8bYZ2rfTjExFxmjf10Zs14NHmkUhbm+oA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420953AbgJZICW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 04:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1419349AbgJZICW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 04:02:22 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7243223AE;
        Mon, 26 Oct 2020 08:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603699341;
        bh=u7gIFsaZApJjD2/VYS+ThxztiaP8WkJFHr4IYJ9i5Ug=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OLXQxMTwiCDm5iwYwg5KvNHxgkEH0mA/+B4b1qRYm8AHhPPmhxvaqcaJNqr6WCAz/
         1I4wjNj+npXF+3YMMkcro6LoDJeoRXwWAR//G1NaIV2JBX+vlYMp7ZX5C37ceiNWlB
         bmNpgpYZgddD6AW+Bjr/Osp/Pvoq5nGR+89+stlo=
Received: by mail-oi1-f173.google.com with SMTP id m128so9669599oig.7;
        Mon, 26 Oct 2020 01:02:21 -0700 (PDT)
X-Gm-Message-State: AOAM532/u3iqOG8ze9pQirw+Q5DoK0+BfSs9AWYiVkn6k/fLmlT6+Z2u
        w+hpxu5Ua37UKeG64OPCsoBpUjOOt/6e0506bzU=
X-Google-Smtp-Source: ABdhPJyA2V35nWfIBXoREfr6rWvKk70JMYvUnAB6b32G9ojZlMZ3xx1t9SKTVYC3xPnszHYwzirfW2ZrTlOyGCYNbfk=
X-Received: by 2002:aca:4085:: with SMTP id n127mr11770959oia.33.1603699341004;
 Mon, 26 Oct 2020 01:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201025143119.1054168-1-nivedita@alum.mit.edu> <20201025143119.1054168-7-nivedita@alum.mit.edu>
In-Reply-To: <20201025143119.1054168-7-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Oct 2020 09:02:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEiNGnUmo=ZR3=Eij8hnD0kZef8rEcG2H7Q7vq4OeyTSA@mail.gmail.com>
Message-ID: <CAMj1kXEiNGnUmo=ZR3=Eij8hnD0kZef8rEcG2H7Q7vq4OeyTSA@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] crypto: lib/sha256 - Unroll LOAD and BLEND loops
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
> Unrolling the LOAD and BLEND loops improves performance by ~8% on x86_64
> (tested on Broadwell Xeon) while not increasing code size too much.
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/sha256.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index e2e29d9b0ccd..cdef37c05972 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -76,12 +76,28 @@ static void sha256_transform(u32 *state, const u8 *input, u32 *W)
>         int i;
>
>         /* load the input */
> -       for (i = 0; i < 16; i++)
> -               LOAD_OP(i, W, input);
> +       for (i = 0; i < 16; i += 8) {
> +               LOAD_OP(i + 0, W, input);
> +               LOAD_OP(i + 1, W, input);
> +               LOAD_OP(i + 2, W, input);
> +               LOAD_OP(i + 3, W, input);
> +               LOAD_OP(i + 4, W, input);
> +               LOAD_OP(i + 5, W, input);
> +               LOAD_OP(i + 6, W, input);
> +               LOAD_OP(i + 7, W, input);
> +       }
>
>         /* now blend */
> -       for (i = 16; i < 64; i++)
> -               BLEND_OP(i, W);
> +       for (i = 16; i < 64; i += 8) {
> +               BLEND_OP(i + 0, W);
> +               BLEND_OP(i + 1, W);
> +               BLEND_OP(i + 2, W);
> +               BLEND_OP(i + 3, W);
> +               BLEND_OP(i + 4, W);
> +               BLEND_OP(i + 5, W);
> +               BLEND_OP(i + 6, W);
> +               BLEND_OP(i + 7, W);
> +       }
>
>         /* load the state into our registers */
>         a = state[0];  b = state[1];  c = state[2];  d = state[3];
> --
> 2.26.2
>
