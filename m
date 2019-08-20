Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A35C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 10:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F504206DF
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 10:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NZhc5g6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfHTK5O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 06:57:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40271 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbfHTK5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 06:57:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so11915581wrd.7
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2019 03:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98qjiU0RLQfpP+E/K7E40DkhQrUVY99Cv4VbFwpXIdE=;
        b=NZhc5g6Po0y7fipk5LSU9It+yU/8zmVLvWKenSr8A5F3380M4mvYyj7fAZsrQTxUbY
         MyLtrqnOvdOwpFZN0iQxUyVpMdJvqQOCiBNRVu+xrOUQCIFp/yfN/YQUZYiN8RmlFAvD
         d/QGouxgcqyNUxtNKwDnBcvm2SNoiNXukEXx6x6/rveKbOSvfBAOS/M3PYQojxg/lIMV
         nUxZ9Av6auRom3qUM1o5fRY3wdhp9GbPaZBB6KLnNNJQg2hBDUizjxNzBhUaozIeUxbB
         LZDgJD7Guo5b0M3P6j0k02pvGaH+UJptmi7cc0N/VLWTyF/OPb78dYwBv2IQnmfKVXM3
         WWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98qjiU0RLQfpP+E/K7E40DkhQrUVY99Cv4VbFwpXIdE=;
        b=j4Gvtfq7BlOrgd5uuHZf/A1uPvT1MDY2lkxG9H87r09y1tSPQ6DGx/qU8tuaNI92Ur
         t1hysJZTnra7SIMcIdYi3cwfOZdOdfqi5tdnvLElJCO/K4TdDooOpAF7Lhb0FVC/74/2
         OqvMOQLY2oUTGHRvsj3XwsUo9FAzqWd2tV+s/GTV+dK3D5PtkFD5UCWqqjo7MyPR8DdP
         GfWF003/ZacSWx4n5GW4QOxdwwtXluhdLoqlK3CoCj3WbaJ2piVyCBe2KFbp11TDow3P
         kqk1BE6YF2FOyG7B1nYIFmIdc/SO4+ikT55xiTB7UWW2/Zbe3dVAL+lyr5jUGjXwZvQE
         rbvg==
X-Gm-Message-State: APjAAAU/LY2Niso0MyWKYUNEf4CzXe//pzOFK1MGiXxhB819Jtox/cRc
        swcq1zTJVQYSAm8jv5IWlHGGHepMQC9UimdCDCDoJHBAiIoO42bu
X-Google-Smtp-Source: APXvYqwtnuJb1/oEfZ5NQaF7TnI6kZVMtvBJF3Qt67JpNEpW2p1RdqZeuoVk240AM/aFMrEu0lfmrSHQkg7q/kztwPY=
X-Received: by 2002:adf:9222:: with SMTP id 31mr18050325wrj.93.1566298631670;
 Tue, 20 Aug 2019 03:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org>
 <20190819142226.1703-3-ard.biesheuvel@linaro.org> <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
In-Reply-To: <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 20 Aug 2019 13:57:00 +0300
Message-ID: <CAKv+Gu9Z=qkEVpkQYsCy5Q_EvMuQ1KzPVataWs+x4vhS_wB27Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: s5p - use correct block size of 1 for ctr(aes)
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 20 Aug 2019 at 13:24, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, 19 Aug 2019 at 16:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > Align the s5p ctr(aes) implementation with other implementations
> > of the same mode, by setting the block size to 1.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  drivers/crypto/s5p-sss.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index ef90c58edb1f..010f1bb20dad 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > @@ -2173,7 +2173,7 @@ static struct crypto_alg algs[] = {
> >                 .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
> >                                           CRYPTO_ALG_ASYNC |
> >                                           CRYPTO_ALG_KERN_DRIVER_ONLY,
> > -               .cra_blocksize          = AES_BLOCK_SIZE,
> > +               .cra_blocksize          = 1,
>
> This makes sense but I wonder how does it work later with
> s5p_aes_crypt() and its check for request length alignment
> (AES_BLOCK_SIZE). With block size of 1 byte, I understand that
> req->nbytes can be for example 4 bytes which is not AES block
> aligned... If my reasoning is correct, then the CTR mode in s5p-sss is
> not fully working.
>


I re-ran the kernelci.org tests with this change, and I saw no more failures.

https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.3-rc1-197-gc8809c50be4f/
