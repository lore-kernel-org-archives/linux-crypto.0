Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0972C32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 20:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2B2321BE3
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 20:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhUUpvBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389413AbfHGUcr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 16:32:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36798 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389420AbfHGUcr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 16:32:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so42489906plt.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 13:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iNrWyfe14EceBCcyBHxBfD+ggPp/iRoNtelJDekGiAI=;
        b=WhUUpvBZt2uzgtZrwRpApkr3h2AQ8OSv5m4AP1aPd3RRubs5ynFGruDQi1el+rqdYh
         EPKR9HgmTHlo0wmUFAbix83zfvGpmAbURQda5r3qhIgG8FWGmXPzN0LOU9aGp6dnry/W
         MSO5tdbF3/fqI4jx7Syk6h9Nvi/l7f1X4Iurxf4LCGvCDokG/Ft2coCtAFxpKFBMIz2N
         iJHFfyINB99M3YpKn1JYNKol+u6QBz9bqVYqPoThPEIxBQbeQS1sERoX2vyld4TFIhl9
         ZERm6mSr5g2s+7lFnAtLU93LIDk5JMKN4ujp3Ay9csyTRSVirzfgFMfjavnYTUcluBOw
         3fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iNrWyfe14EceBCcyBHxBfD+ggPp/iRoNtelJDekGiAI=;
        b=s3KCPeInl4+AW1pG0VQMxD4dqhUDK9FoZnkUrZr5UhZUOf3SI/nzcIAQFXFBl0w3CG
         pv7Zm7HFol0o/IlGQAObxH/uJkECzuv0aafaXfurnFUgvnBEn/VHWec8K8kIbhasO5Gr
         3romuT8d5MnhE265ZO7L1LXP844JoBPOEIhxmucxMtyTcxp7d+nmxtp+ZMIVvUqMgO6a
         pXI5cAUd2iL138BrDZr+cLO2xmjXqIcE+4AbrCFvLp7DDWdSaDFd6zTR0jYkd+cpfFmT
         d4JBSHhCmyToz9xqYHBJGTFErWLMuTcfFS06swVwZ7InYHxIEW35azbjvKm4oJ+x9qZQ
         pamA==
X-Gm-Message-State: APjAAAXzYNLzJbrybEs6ezgcW9O/QqmBrs0CynDx2l95LX0qmIAecKlq
        rUUVHVHSHZmabsvzqNLce1ACa32nnNti/L6K2uQ=
X-Google-Smtp-Source: APXvYqwJ48aiy3WtRRB+nksMzErwZvmZaoysf22D4gGdTN6n1sc3PafZU9tmqvPaMBvDTKhjBUxJwQGuzCPOo/w2QCA=
X-Received: by 2002:a62:e716:: with SMTP id s22mr11253638pfh.250.1565209966420;
 Wed, 07 Aug 2019 13:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com> <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com> <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com> <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
In-Reply-To: <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 7 Aug 2019 22:32:35 +0200
Message-ID: <CAAUqJDuMUHqd4J7TNRbMiEDNeb_GCJPhJUQJoOJo5zXKmL72nQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts - Add support for Cipher Text Stealing
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

st 7. 8. 2019 o 19:44 Milan Broz <gmazyland@gmail.com> nap=C3=ADsal(a):
> On 07/08/2019 17:13, Pascal Van Leeuwen wrote:
> >>>> Seems there is no mistake in your code, it is some bug in aesni_inte=
l implementation.
> >>>> If I disable this module, it works as expected (with aes generic and=
 aes_i586).
> >>>>
> >>> That's odd though, considering there is a dedicated xts-aes-ni implem=
entation,
> >>> i.e. I would not expect that to end up at the generic xts wrapper at =
all?
> >>
> >> Note it is 32bit system, AESNI XTS is under #ifdef CONFIG_X86_64 so it=
 is not used.
> >>
> > Ok, so I guess no one bothered to make an optimized XTS version for i38=
6.
> > I quickly browsed through the code - took me a while to realise the ass=
embly is
> > "backwards" compared to the original Intel definition :-) - but I did n=
ot spot
> > anything obvious :-(
> >
> >> I guess it only ECB part ...
>
> Mystery solved, the skcipher subreq must be te last member in the struct.
> (Some comments in Adiantum code mentions it too, so I do not think it
> just hides the corruption after the struct. Seems like another magic requ=
irement
> in crypto API :-)

Oh, yes, this makes sense! I would have noticed this immediately if I
had looked carefully at the struct definition :) The reason is that
the skcipher_request struct is followed by a variable-length request
context. So when you want to nest requests, you need to make the
subrequest the last member and declare your request context size as:
size of your request context struct + size of the sub-algorithm's
request context.

It is a bit confusing, but it is the only reasonable way to support
variably sized context and at the same time keep the whole request in
a single allocation.

>
> This chunk is enough to fix it for me:
>
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -33,8 +33,8 @@ struct xts_instance_ctx {
>
>  struct rctx {
>         le128 t, tcur;
> -       struct skcipher_request subreq;
>         int rem_bytes, is_encrypt;
> +       struct skcipher_request subreq;
>  };
>
> While at it, shouldn't be is_encrypt bool?
>
> Thanks,
> Milan
