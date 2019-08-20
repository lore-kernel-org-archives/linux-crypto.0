Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBA3C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 11:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4353C2082F
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 11:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566300254;
	bh=5WCmJYRjGpn+/SzaeT1Y1kTMHP0lsFrPkA4AnobQEis=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xBRRjyZAbyYVs1lp74V+2KCBrtBKMouBdzdAEXpCOLldaRT9X0+8l0sykTFuQ5/Gy
	 XeqogiIhPNZpPY7i10SpQ0D+j4BmvHt+0A4Cpy/ZQkV1Q31DbkHoyKBS3LNnT4u+sK
	 1QoOBRAde1SG4qrOwAP44X2bySuraI4ELUhVRQIU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfHTLYN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729383AbfHTLYN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 07:24:13 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B572082F;
        Tue, 20 Aug 2019 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566300251;
        bh=5WCmJYRjGpn+/SzaeT1Y1kTMHP0lsFrPkA4AnobQEis=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rPDLY8JGRAPctm5VksmKdMerPoVtblNx+7xLzl0wLrqOdswPZKJuVf1rvv3xmpNKQ
         ezgDI2o+sjOIaNVOGRl8aL661w8B0rE6Mo9v63rMFLu/E6xozrEAyB9eu4MivnuDM3
         A+rR9ydi4Ua/m4AWbTC5NpNhbrtdZV84dwJjS48U=
Received: by mail-lj1-f181.google.com with SMTP id x4so4764284ljj.6;
        Tue, 20 Aug 2019 04:24:11 -0700 (PDT)
X-Gm-Message-State: APjAAAWyzfwKn4KczLC9ZxOuQeotnEUfZCNIR4bVwZioO3mq0eFgw0+L
        3TFfKMEXPWiDegLQnjWhqoPES8iGJ765HSbg6tA=
X-Google-Smtp-Source: APXvYqxzAfLyfemh8k/ZsYvQfGRIuwh5IYd1pkDj29qYZ/FB8+jUX9XDMia3RD54186qN/4aW8aQ8GRiHeyTQPphwwM=
X-Received: by 2002:a2e:9acf:: with SMTP id p15mr15670614ljj.13.1566300249554;
 Tue, 20 Aug 2019 04:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org>
 <20190819142226.1703-3-ard.biesheuvel@linaro.org> <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
 <CAKv+Gu9Z=qkEVpkQYsCy5Q_EvMuQ1KzPVataWs+x4vhS_wB27Q@mail.gmail.com>
In-Reply-To: <CAKv+Gu9Z=qkEVpkQYsCy5Q_EvMuQ1KzPVataWs+x4vhS_wB27Q@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 20 Aug 2019 13:23:58 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfReqxQZfN8TdpPQZLbNEgkWm7_KinQz=qvQxQ4_vOowA@mail.gmail.com>
Message-ID: <CAJKOXPfReqxQZfN8TdpPQZLbNEgkWm7_KinQz=qvQxQ4_vOowA@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: s5p - use correct block size of 1 for ctr(aes)
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

On Tue, 20 Aug 2019 at 12:57, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 20 Aug 2019 at 13:24, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Mon, 19 Aug 2019 at 16:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > Align the s5p ctr(aes) implementation with other implementations
> > > of the same mode, by setting the block size to 1.
> > >
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  drivers/crypto/s5p-sss.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > > index ef90c58edb1f..010f1bb20dad 100644
> > > --- a/drivers/crypto/s5p-sss.c
> > > +++ b/drivers/crypto/s5p-sss.c
> > > @@ -2173,7 +2173,7 @@ static struct crypto_alg algs[] = {
> > >                 .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
> > >                                           CRYPTO_ALG_ASYNC |
> > >                                           CRYPTO_ALG_KERN_DRIVER_ONLY,
> > > -               .cra_blocksize          = AES_BLOCK_SIZE,
> > > +               .cra_blocksize          = 1,
> >
> > This makes sense but I wonder how does it work later with
> > s5p_aes_crypt() and its check for request length alignment
> > (AES_BLOCK_SIZE). With block size of 1 byte, I understand that
> > req->nbytes can be for example 4 bytes which is not AES block
> > aligned... If my reasoning is correct, then the CTR mode in s5p-sss is
> > not fully working.
> >
>
>
> I re-ran the kernelci.org tests with this change, and I saw no more failures.
>
> https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.3-rc1-197-gc8809c50be4f/

Indeed, self tests are passing. Anyway the change is correct so:
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
