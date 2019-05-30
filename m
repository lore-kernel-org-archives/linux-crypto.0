Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B75CC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A00625A39
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 14:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r7mmQx/M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfE3OLw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 10:11:52 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52676 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfE3OLv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 10:11:51 -0400
Received: by mail-it1-f194.google.com with SMTP id t184so10078676itf.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2019 07:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3m+GACOpj4FpxTfagkQ56YHJBgCqLctr+f1GcaAlBKI=;
        b=r7mmQx/MZFOJbicAL0UI1sOzinV94EgrU9O0u7jEhPqiptJnmddsYUSPm6on0kSrFU
         xQp6ZR2QHiJ8kS333/mkLjOlU0owecS7mHTcI+8Q8w1Ufa0yemmz/wFyrLvCEbMdiG4g
         awWPIkJOFlfBdmi1Y5w8qzOOaTJAe210hkBkpB46Sw/pRJwbjTL1DZdo888zGLDYbKAn
         3zh7IGr4/NmN1B1+kmNGKVuJ/Mr8SrrOolOuPxRCZpv9/5pP6hgnFnVRiyNMinILW+3m
         iZahnc9s3SC8bhVTKSYkb9QT0z94Z7n7JqCOn/Gqt+Du9essV5xI2CJUYj6PLn2liJUG
         irxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3m+GACOpj4FpxTfagkQ56YHJBgCqLctr+f1GcaAlBKI=;
        b=CMTsJczi8ORGQ4WS10+Etc32u534iJB61RQwT4LOXYWRxm1WDFaKR8tJpBUvv0y85G
         e29uR0jKSwdetvr3Dk8kZfskAFjCZsIe7HtC8qoq06A1sA97CIwiaildCp+VTce4tXFd
         kacGWY6SPs/47jJrw+H6JvgJIRrVUKT2QU6kjezIrdYeP7hElgHPbAD5p4QcyKB+B6dQ
         uyUFoHmDKknwM8Cp0Z/Aa+FeQydLdK7DQz5AmWOW7SbxaWX5N5W8SzovvLZLJn4/dyEM
         OaVkUmhFZ07ilAayaRwlytK1XQMldU8M56SDXPj7rywDtctx4WOBPVZj05G2/8Ea9xC1
         9xjA==
X-Gm-Message-State: APjAAAWzHBN/c1DIzVJjfrJN45nR+k4YisZhXnn5Pqw19JPuAGNIzVHl
        XVnhQ5r7OegZ50FgHggrQthfK47aMFdbvLZ031DfDw==
X-Google-Smtp-Source: APXvYqxlk8ceqS9HRJKUfgBmZuPgL2m9fPkzhV4JV6IB5Nb7Kcw2FyUXVE+x8OcM8KUkiooPFDCXgf6wVOc9oPemd4M=
X-Received: by 2002:a02:a494:: with SMTP id d20mr2418000jam.62.1559225511157;
 Thu, 30 May 2019 07:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <1559149856-7938-1-git-send-email-iuliana.prodan@nxp.com>
 <20190529202728.GA35103@gmail.com> <CAKv+Gu-4KqcY=WhwY98JigTzeXaL5ggYEcu7+kNzNtpO2FLQXg@mail.gmail.com>
 <VI1PR04MB44459EEF7BCD3458BB3D143D8C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530133427.qrwjzctac2x6nsby@gondor.apana.org.au> <VI1PR04MB444562A2352FE4BAD7F681258C180@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20190530135800.ekcso3n2p5zkg6yv@gondor.apana.org.au>
In-Reply-To: <20190530135800.ekcso3n2p5zkg6yv@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 30 May 2019 16:11:37 +0200
Message-ID: <CAKv+Gu-3zzN=cikd4PftCVo2fJi9t_0kqZHBQncjokYQV5wVnA@mail.gmail.com>
Subject: Re: [PATCH] crypto: gcm - fix cacheline sharing
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 May 2019 at 15:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, May 30, 2019 at 01:45:47PM +0000, Iuliana Prodan wrote:
> >
> > On the current structure of caamalg, to work, iv needs to be copied
> > before memcpy(iv, req->iv, ivsize), from skcipher_edesc_alloc function.
> > For this we need edesc, but this cannot be allocated before knowing how
> > much memory we need. So, to make it work, we'll need to modify more in CAAM.
>
> All the copying does is:
>
>         if (ivsize)
>                 scatterwalk_map_and_copy(req->iv, req->src, req->cryptlen -
>                                          ivsize, ivsize, 0);
>
> Why do you need to allocate the edesc before doing this?
>

Because that is where the incoming iv is currently consumed. Copying
it out like this wipes the input IV from memory.
