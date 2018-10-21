Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2D9ECDE43
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 07:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A51D62083E
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Oct 2018 07:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="O1SlPRPF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A51D62083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJUPTU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Oct 2018 11:19:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40199 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeJUPTT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 11:19:19 -0400
Received: by mail-io1-f67.google.com with SMTP id w16-v6so25296139iom.7
        for <linux-crypto@vger.kernel.org>; Sun, 21 Oct 2018 00:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=mLG7SsBWZFc0aEPe7x64XvlALpoJn/y4DlQdAmcOIxU=;
        b=O1SlPRPFU0NJUcPmzrfwezZiOvKc2NPCDAuLUnM/UQWukZJZ8aRRHTYryWcuGW1AdM
         +8WgkXUV7LMhYKAwofxbhWie5o5j6zVQKzJvwvZIZxVcTfqfdis0eGiF0yiMxwnFqL6x
         W9S06fRffI7M/dTRwJIONuIiP8KXX5OKgWNXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=mLG7SsBWZFc0aEPe7x64XvlALpoJn/y4DlQdAmcOIxU=;
        b=I3QwsuthabeuOjLkKJD270z9mIJXvqjGDRS/GjIbe1nOOvWxor8dLomzFibnorizRO
         AqQGrYlf0/hBuUqcszhtZFII1Bx+EZCJmyyak45eh9484m2Loo/HB6nE7xDW/wYsz6qC
         1dhyeRmTpgZzHUhXLKova3oarI4L/vT+keJB3WP8/EDSxsQhSDeFxJD/6eTxFne+8FKh
         5iIioe59t8cONng8oFEU6+CjYhvqqIp7T/1KArj0yMc3svfmjs8OHVG7pfNfaaIt6K7q
         5vifJsHAJxpGc+wEAXLRJOH7+zCCINkDmZ6x5Wryx3czvf4V6QPf9msVIS0syJHf23nY
         3lEA==
X-Gm-Message-State: AGRZ1gJ9Tf0BougPRYHF+Gy3tR7Yd7X6x0z3jLprmY/o1zkgWviO9obV
        8DzHoNWuJvJfmbQmo3hLShu7pqiEMtvn4K2CI7pTnQ==
X-Google-Smtp-Source: AJdET5ckfpioInXbYgFgicHFKWFaY+YQY8aKI27VhgtDt3D30EhQ897l8nrB9n+5N5hVpkDpAzV6hlTYTmC/abh4cp8=
X-Received: by 2002:a6b:be83:: with SMTP id o125-v6mr6412168iof.173.1540105559576;
 Sun, 21 Oct 2018 00:05:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Sun, 21 Oct 2018 00:05:58
 -0700 (PDT)
In-Reply-To: <20181019230153.28201-1-dbaryshkov@gmail.com>
References: <20181019230153.28201-1-dbaryshkov@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 21 Oct 2018 09:05:58 +0200
Message-ID:
 <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
To:     Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181021070558.BdM_FxGOiOXfcBltBviy8lhNmN-XatVdoG5J91PdY68@z>

(+ James)

On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream with
> IV, rather than with data stream, resulting in incorrect decryption.
> Test vectors will be added in the next patch.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  crypto/cfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/cfb.c b/crypto/cfb.c
> index a0d68c09e1b9..fd4e8500e121 100644
> --- a/crypto/cfb.c
> +++ b/crypto/cfb.c
> @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct skcipher_walk *walk,
>
>         do {
>                 crypto_cfb_encrypt_one(tfm, iv, dst);
> -               crypto_xor(dst, iv, bsize);
> +               crypto_xor(dst, src, bsize);
>                 iv = src;
>
>                 src += bsize;
> --
> 2.19.1
>
