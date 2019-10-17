Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61748ECE58E
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 15:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34F1820872
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 15:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rtG7U/WF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407699AbfJQP3C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 11:29:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36512 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407690AbfJQP3C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 11:29:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id m18so3013256wmc.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 08:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ekt2r633krBIKdm2MRWn1/pbuY6S29TraTxsvnoK4k=;
        b=rtG7U/WFEJB937Z+UVa7zX93QaONAQY6vMOSjaE/oYZkhh4E4IlI7dU+lRGEsJwSyA
         mymkOhBUkVE6YLDzZhDWJIWv/XRTly2XbhE+BioypJNcpOJW7FBP2z/j7nHOhQecV+fu
         fL2/XPHmaAkSk3IaJA+V050VgvfGv2HtmATwlaUVKV6+ePESSqHNCk62XsACKWvn+edL
         HkANTtvyN4Wfo62Boe8Nclhv5FwClad+EPHthVIPdHYQKxQMh4TQjTITGGS0ARd5gkJj
         Op5jHtvoqsuSyRVNPiNSE5/UtL5/7TYcnJ5c2mjYYijHfDfynZOaj2XkOcs5jTbNfNkc
         nErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ekt2r633krBIKdm2MRWn1/pbuY6S29TraTxsvnoK4k=;
        b=U8T63wyLHXExnveWX6/nRLaSE7UorAGie6Dlyr+Own0GUjUTAXoq33GI24rZ6d1lWI
         Lb44F9x/XqWXrBJQHFPRGIxPqdjupOQy196ygZ0tqWXGG8k5RLNbtsYL3w6cRrZ9y8jU
         bF+vwx2/bTNichi9qOsKv0ymrLZMe4qFrhW0+w+v5DtGijeZsG4QJi7+hdFKaxlUWFHW
         d14UWh3EqTcXsqmehdKWMpeBRqkoZa2jAqCGbgr/1WcWW2sVnp1DFRI7HZ73GwrsKAiu
         4aJYgVvaxxhlXR442AVz8n5PXNaQxyEhLAB2xEDfsuGiZcd3Cong0ygJ5SsGhirYRk1p
         xQHw==
X-Gm-Message-State: APjAAAU3GNpBxa/p+y/Br8GG+J8mLqjxij4RgYhez6vXCihxaCi1sLVb
        FvxIIlJIEPQ/4JKozsGbPlVHqGfsj5k7LC33GApGZg==
X-Google-Smtp-Source: APXvYqwQkbkxfA5DYAC5X7GLKci02tkbzr1oFaST60w1ilVREPi79ZyDCQMpkLqMnzKmdtR1QNgJ17evb3jAUFvvsKk=
X-Received: by 2002:a1c:a651:: with SMTP id p78mr3454453wme.53.1571326138344;
 Thu, 17 Oct 2019 08:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
 <CGME20191014121950epcas4p18dbe227632fbee9b09f322d80deeb1c1@epcas4p1.samsung.com>
 <20191014121910.7264-8-ard.biesheuvel@linaro.org> <c07712f3-dea5-7953-82a0-706c1fe0e5d6@samsung.com>
In-Reply-To: <c07712f3-dea5-7953-82a0-706c1fe0e5d6@samsung.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 17 Oct 2019 17:28:48 +0200
Message-ID: <CAKv+Gu_R1WUn98n1FYdrY0S4B5+a9aKKLCqqKk=_9Q=zjXhaAQ@mail.gmail.com>
Subject: Re: [PATCH 07/25] crypto: s5p - switch to skcipher API
To:     Kamil Konieczny <k.konieczny@samsung.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 17 Oct 2019 at 17:18, Kamil Konieczny <k.konieczny@samsung.com> wrote:
>
> Hi,
>
> On 14.10.2019 14:18, Ard Biesheuvel wrote:
> > Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> > dated 20 august 2015 introduced the new skcipher API which is supposed to
> > replace both blkcipher and ablkcipher. While all consumers of the API have
> > been converted long ago, some producers of the ablkcipher remain, forcing
> > us to keep the ablkcipher support routines alive, along with the matching
> > code to expose [a]blkciphers via the skcipher API.
> >
> > So switch this driver to the skcipher API, allowing us to finally drop the
> > blkcipher code in the near future.
> >
> > Cc: Krzysztof Kozlowski <krzk@kernel.org>
> > Cc: Vladimir Zapolskiy <vz@mleia.com>
> > Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>
> > Cc: linux-samsung-soc@vger.kernel.org
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
>
> There are comments for hash functions changed, see below.
> With that fixed, you can add my
>
> Reviewed-by: Kamil Konieczny <k.konieczny@samsung.com>
> Tested-by: Kamil Konieczny <k.konieczny@samsung.com>
>

Thanks!

> >  drivers/crypto/s5p-sss.c | 191 ++++++++++----------
> >  1 file changed, 91 insertions(+), 100 deletions(-)
> >  [...]
> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index 010f1bb20dad..e6f1d4d5186c 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > [...]
> > @@ -660,7 +660,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
> >  {
> >       struct platform_device *pdev = dev_id;
> >       struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
> > -     struct ablkcipher_request *req;
> > +     struct skcipher_request *req;
> >       int err_dma_tx = 0;
> >       int err_dma_rx = 0;
> >       int err_dma_hx = 0;
>
> These two comments below should not be touched, they are for hash part.
>
> > @@ -1208,7 +1208,7 @@ static int s5p_hash_prepare_sgs(struct s5p_hash_reqctx *ctx,
> >   *
> >   * Note 1: we can have update flag _and_ final flag at the same time.
> >   * Note 2: we enter here when digcnt > BUFLEN (=HASH_BLOCK_SIZE) or
> > - *      either req->nbytes or ctx->bufcnt + req->nbytes is > BUFLEN or
> > + *      either req->cryptlen or ctx->bufcnt + req->cryptlen is > BUFLEN or
> >   *      we have final op
> >   */
> >  static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
> > @@ -1555,7 +1555,7 @@ static int s5p_hash_final_shash(struct ahash_request *req)
> >   * s5p_hash_final() - close up hash and calculate digest
> >   * @req:     AHASH request
> >   *
> > - * Note: in final req->src do not have any data, and req->nbytes can be
> > + * Note: in final req->src do not have any data, and req->cryptlen can be
> >   * non-zero.
> >   *
> >   * If there were no input data processed yet and the buffered hash data is
> > [...]
>
> --
> Best regards,
> Kamil Konieczny
> Samsung R&D Institute Poland
>
