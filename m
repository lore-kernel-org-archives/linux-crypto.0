Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE64FC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C3542083D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFXH7a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:59:30 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34989 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFXH7a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:59:30 -0400
Received: by mail-ot1-f67.google.com with SMTP id j19so12616680otq.2
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y5rTUEYsELOvvw4ngFAJeKVFrPW5LktCBQ0fE2buR+k=;
        b=C5b2FWPBYFsJ4qiHn7xKIlgsnWP9XoKrNNTTLRo91MEVbjOFFgyf75634DD0qwhD0A
         OWLiuSVAz/6Wn7GAQjuu+JKYDfmYCfbjao2mWN/zlo9qH3+bPBTWhcmqZ5Taer0a6CQP
         HB+F9QMHmLOOEanVD2zS1qchALbRdJ8RWKfe+GzWTFTT/KQViL9RCHddm5YME26NTGNL
         IE/13bJ9CTPTzakZaIyiCXJXLL0sRCQ2PbvO/6iyOGONSeKTSXCRqXjfxt0yvrA0suA/
         CfvPkR05XyplbDbYQdamOGHkOyF1ZZ070WHAues2G/uAkbnSQe8MrT4jh9R/lLEGPyi+
         RTVQ==
X-Gm-Message-State: APjAAAVSh9R6fLLj+CpTAc99xqZQQEq0lhuGamlvlYgP4byEkhn42Y9A
        d48y1k7sR2XnQgcbd40YO0cngB6cIrrd8t+H++HZ1klp
X-Google-Smtp-Source: APXvYqxZq+86CfX0eMEndXfGqzlMquFnxv7MRNp1HZttJvo4RvO8uiNDODAZ3uGhr+Q/FFza7QtsQab+jUEGzZopOyY=
X-Received: by 2002:a9d:7a45:: with SMTP id z5mr10818120otm.197.1561363169678;
 Mon, 24 Jun 2019 00:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org> <20190624073818.29296-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20190624073818.29296-2-ard.biesheuvel@linaro.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 24 Jun 2019 09:59:18 +0200
Message-ID: <CAFqZXNt4PgTB1Ocmui4CCYTCbguAqmcrdA=ZMbA6anH3LBX9EQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] crypto: aegis128 - use unaliged helper in unaligned
 decrypt path
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Mon, Jun 24, 2019 at 9:38 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Use crypto_aegis128_update_u() not crypto_aegis128_update_a() in the
> decrypt path that is taken when the source or destination pointers
> are not aligned.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/aegis128.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/aegis128.c b/crypto/aegis128.c
> index d78f77fc5dd1..125e11246990 100644
> --- a/crypto/aegis128.c
> +++ b/crypto/aegis128.c
> @@ -208,7 +208,7 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
>                         crypto_aegis_block_xor(&tmp, &state->blocks[1]);
>                         crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
>
> -                       crypto_aegis128_update_a(state, &tmp);
> +                       crypto_aegis128_update_u(state, &tmp);

The "tmp" variable used here is declared directly on the stack as
'union aegis_block' and thus should be aligned to alignof(__le64),
which allows the use of crypto_aegis128_update_a() ->
crypto_aegis_block_xor(). It is also passed directly to
crypto_aegis_block_xor() a few lines above. Or am I missing something?


>
>                         memcpy(dst, tmp.bytes, AEGIS_BLOCK_SIZE);
>
> --
> 2.20.1
>

--
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
