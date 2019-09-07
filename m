Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA63C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 00:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D5F208C3
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 00:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rTExvh5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393634AbfIGAxP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 20:53:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50351 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391367AbfIGAxP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 20:53:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id c10so8173697wmc.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fPsBlQeiZODgFZA78wRPxMMkZep/F4eQmpcWJaVo2Xg=;
        b=rTExvh5dzWJ90SWvbllCRvapshUgOV4YE1K3mlAwMeM6EMmIayEFe11ZECqQRwswq5
         u0B0NEJl4pVyW280ip90HhBTl5LfT2lKGrJuXp/bjumCSd9dYU7euPXDaFhMjPo++9cu
         FogP31GTyjB5YrMTfDgGTun0nZpwGW2nrLhf4yiKnUeYr/fdyxzhCCiEZn0+V2Ze2zrV
         4eaCzshzaJVHBSMOQMPGUe7PZ/KxSFwtEsN6zXZxkwyv2UTQFfhdETT4dtzPKEtohn0B
         PvKPUG3FbceHzjObJPh70g9PBbyN//GtbyYQJxDNone5DmjsCPm3oWf+zvE0hsg4Ajhs
         O+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fPsBlQeiZODgFZA78wRPxMMkZep/F4eQmpcWJaVo2Xg=;
        b=Cx4yPDJeRDTiK//Az9HtAYMfbsn4pg9mlgl6Z9jxp+W5GVqI11xPIUvnaMatVcfnFY
         N5AT8UJ4twMMGdl+CDCWLnOSyA2JdIszYayNeMrLE5lHk8vqP6yG9shqQR4oMIE8l9Zy
         eVpIr+tgfbrOvOXEVAkn4X2Y/JG2F2Qd5jAfXMGj2rFr1cE29QMKxhcC6/kdFyKgmdXy
         MQUnBHPChgqE1kxWRSuimWjohPKx+XwIHm3gr6YQiTvL8Xg8gqfEqy5ZbZ1qcVeoB4vl
         OjTMcB/HdtYDAIJ+f2gZNlCr85+fv1ZY87yAZl//ThtgZC1e54b3ofz8attL5Ryc1VGe
         L5vw==
X-Gm-Message-State: APjAAAWTEKfRpErPqgSdDhBR/FPMDPbNjl2XQEhTPD5OXNXInbkybiyN
        sH/ZgqRlbCuOjVAaxCjjoQWEczOE35W9C2BdtqUq+hfLWu9yuQ==
X-Google-Smtp-Source: APXvYqzZlQZZ6cBosOj/j6vKHq+1ZrGz6T/ErJuXMCnB0PnioAemAXtnfBs9IRJOFCNxOwQCKJOjMCX3Sptwwr7Ycx8=
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr9595590wmg.53.1567817593179;
 Fri, 06 Sep 2019 17:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190821143253.30209-9-ard.biesheuvel@linaro.org>
 <20190830080347.GA6677@gondor.apana.org.au> <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au> <20190903135020.GB5144@zzz.localdomain>
 <20190903223641.GA7430@gondor.apana.org.au> <20190905052217.GA722@sol.localdomain>
 <20190905054032.GA3022@gondor.apana.org.au> <20190906015753.GA803@sol.localdomain>
 <20190906021550.GA17115@gondor.apana.org.au> <20190906031306.GA20435@gondor.apana.org.au>
In-Reply-To: <20190906031306.GA20435@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 6 Sep 2019 17:52:56 -0700
Message-ID: <CAKv+Gu8n5AtzzRG-avEsAjcrNSGKKcs73VRneDTJeTsNc+fUrA@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: skcipher - Unmap pages after an external error
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 5 Sep 2019 at 20:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> skcipher_walk_done may be called with an error by internal or
> external callers.  For those internal callers we shouldn't unmap
> pages but for external callers we must unmap any pages that are
> in use.
>
> This patch distinguishes between the two cases by checking whether
> walk->nbytes is zero or not.  For internal callers, we now set
> walk->nbytes to zero prior to the call.  For external callers,
> walk->nbytes has always been non-zero (as zero is used to indicate
> the termination of a walk).
>
> Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Fixes: 5cde0af2a982 ("[CRYPTO] cipher: Added block cipher type")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 5d836fc3df3e..22753c1c7202 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -90,7 +90,7 @@ static inline u8 *skcipher_get_spot(u8 *start, unsigned int len)
>         return max(start, end_page);
>  }
>
> -static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
> +static int skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
>  {
>         u8 *addr;
>
> @@ -98,19 +98,21 @@ static void skcipher_done_slow(struct skcipher_walk *walk, unsigned int bsize)
>         addr = skcipher_get_spot(addr, bsize);
>         scatterwalk_copychunks(addr, &walk->out, bsize,
>                                (walk->flags & SKCIPHER_WALK_PHYS) ? 2 : 1);
> +       return 0;
>  }
>
>  int skcipher_walk_done(struct skcipher_walk *walk, int err)
>  {
> -       unsigned int n; /* bytes processed */
> -       bool more;
> +       unsigned int n = walk->nbytes;
> +       unsigned int nbytes = 0;
>
> -       if (unlikely(err < 0))
> +       if (!n)
>                 goto finish;
>
> -       n = walk->nbytes - err;
> -       walk->total -= n;
> -       more = (walk->total != 0);
> +       if (likely(err >= 0)) {
> +               n -= err;
> +               nbytes = walk->total - n;
> +       }
>
>         if (likely(!(walk->flags & (SKCIPHER_WALK_PHYS |
>                                     SKCIPHER_WALK_SLOW |

With this change, we still copy out the output in the
SKCIPHER_WALK_COPY or SKCIPHER_WALK_SLOW cases. I'd expect the failure
case to only do the kunmap()s, but otherwise not make any changes that
are visible to the caller.


> @@ -126,7 +128,7 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
>                 memcpy(walk->dst.virt.addr, walk->page, n);
>                 skcipher_unmap_dst(walk);
>         } else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
> -               if (err) {
> +               if (err > 0) {
>                         /*
>                          * Didn't process all bytes.  Either the algorithm is
>                          * broken, or this was the last step and it turned out
> @@ -134,27 +136,29 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
>                          * the algorithm requires it.
>                          */
>                         err = -EINVAL;
> -                       goto finish;
> -               }
> -               skcipher_done_slow(walk, n);
> -               goto already_advanced;
> +                       nbytes = 0;
> +               } else
> +                       n = skcipher_done_slow(walk, n);
>         }
>
> +       if (err > 0)
> +               err = 0;
> +
> +       walk->total = nbytes;
> +       walk->nbytes = 0;
> +
>         scatterwalk_advance(&walk->in, n);
>         scatterwalk_advance(&walk->out, n);
> -already_advanced:
> -       scatterwalk_done(&walk->in, 0, more);
> -       scatterwalk_done(&walk->out, 1, more);
> +       scatterwalk_done(&walk->in, 0, nbytes);
> +       scatterwalk_done(&walk->out, 1, nbytes);
>
> -       if (more) {
> +       if (nbytes) {
>                 crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
>                              CRYPTO_TFM_REQ_MAY_SLEEP : 0);
>                 return skcipher_walk_next(walk);
>         }
> -       err = 0;
> -finish:
> -       walk->nbytes = 0;
>
> +finish:
>         /* Short-circuit for the common/fast path. */
>         if (!((unsigned long)walk->buffer | (unsigned long)walk->page))
>                 goto out;
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
