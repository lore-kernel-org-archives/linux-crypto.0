Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B456ECA9EA0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 06:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8422220659
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 06:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d3E9ue+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfJ1GUu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 02:20:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39260 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfJ1GUu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 02:20:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so8506323wra.6
        for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2019 23:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=llIvbuQZkok97wxZ5YRzO3v5zhC8IGckqKQjrjYjIvg=;
        b=d3E9ue+06kHNnDqAASgZVQs/YYZm26QWcDV4BRilYMu3mXLeqlJpXcO7TsWL4VEC1B
         U5baMJLe2nuHQhhmLqbRt9G9bqGwExWe3GJQm0JQojFqw89YGNume05u6vLVAiVbqHmq
         KjSs5ceqISrnvxnkmEOQiEmR9LdMCwCjBV3D5cJFimAYkt8h0UOr7V+SNSG96E94rsX6
         SlzEeXtmT9EgMqfBmvrAW4Ye1p/YOsxT44Q6L9xcxzLjwIUItSlJZas4NdtrdjQA5Wbr
         PNVipujcRYKFhyq7c67FPQfhJAwY7evKX2BS9edqjjkYql8kEk0vU2zm6XNzOfrUY9so
         fVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=llIvbuQZkok97wxZ5YRzO3v5zhC8IGckqKQjrjYjIvg=;
        b=G4DFDS6e8Tux7H70CF7dDXWZSqgL3gZquqhvCNbL5hfPEcv+S3AM2hWJJZcDxCqB4n
         GPG341CkClwY1IymFIystrwiK8/JVNjF44/nV4C3aY0oVQHHTDaBOlbw1VysU2wgEo+a
         BX+nscx0RoLRwdYF0hoSik4GvbqCROWFmHs55xu8O7OFuOuaF2YQn34GNT+MDwjbr2Tp
         Ka2nxULTG1wkfDPl57UrzamviHBvObZw4QUjjOD48u8JGstgIlrF09hHIkQnUavOFSTI
         tKS+IwkncLsyWYfI9pE695n7oQBG8xdfKqoeT2ZauEiJPNgolyQJz1SBWZqGjz2jxFMX
         s45w==
X-Gm-Message-State: APjAAAUuYycmaltztVupw7g6WvebbHcLg7lGsaeaKpOa00INp0u/TbTM
        SXv9zndLEly2RJrBBZ2lhXQrnYXyg3CXGFnMaqiIz9uPFWeZ2A==
X-Google-Smtp-Source: APXvYqye8DOAQTy1Hj4f6CRnt/bU9Z4QL9MThZazl8GIFUUj2m62vpBP4gdeyTTTWSk1fon9mHeW5jk5uMptdg4X/NM=
X-Received: by 2002:adf:8289:: with SMTP id 9mr14429527wrc.0.1572243647698;
 Sun, 27 Oct 2019 23:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-25-ard.biesheuvel@linaro.org> <74d5c30d-d842-5bdb-ebb8-2aa47ffb5e8d@c-s.fr>
 <CAKv+Gu8V57Z2WixfYZSdT+rqsobqDYZ-Hyer6Aq9khUNeUsxmQ@mail.gmail.com> <be890dfd-a1aa-86e1-b1c7-99b72ad137d0@c-s.fr>
In-Reply-To: <be890dfd-a1aa-86e1-b1c7-99b72ad137d0@c-s.fr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 28 Oct 2019 07:20:46 +0100
Message-ID: <CAKv+Gu98fsPOZ3reGs6wXd+hzNa_pdVZ6+XDFoXhey7C39sfFw@mail.gmail.com>
Subject: Re: [PATCH v2 24/27] crypto: talitos - switch to skcipher API
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 27 Oct 2019 at 14:05, Christophe Leroy <christophe.leroy@c-s.fr> wr=
ote:
>
>
>
> Le 27/10/2019 =C3=A0 12:05, Ard Biesheuvel a =C3=A9crit :
> > On Sun, 27 Oct 2019 at 11:45, Christophe Leroy <christophe.leroy@c-s.fr=
> wrote:
> >>
> >>
> >>
> >> Le 24/10/2019 =C3=A0 15:23, Ard Biesheuvel a =C3=A9crit :
> >>> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher inter=
face")
> >>> dated 20 august 2015 introduced the new skcipher API which is suppose=
d to
> >>> replace both blkcipher and ablkcipher. While all consumers of the API=
 have
> >>> been converted long ago, some producers of the ablkcipher remain, for=
cing
> >>> us to keep the ablkcipher support routines alive, along with the matc=
hing
> >>> code to expose [a]blkciphers via the skcipher API.
> >>>
> >>> So switch this driver to the skcipher API, allowing us to finally dro=
p the
> >>> blkcipher code in the near future.
> >>>
> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>
> >> With this series, I get the following Oops at boot:
> >>
> >
> > Thanks for the report.
> >
> > Given that the series only modifies ablkcipher implementations, it is
> > rather curious that the crash occurs in ahash_init(). Can you confirm
> > that the crash does not occur with this patch reverted?
>
> Yes I confirm.
>
> You changed talitos_cra_init_ahash(). talitos_init_common() is not
> called anymore. I think that's the reason.
>

Thanks a lot for digging into this

Does this fix things for you?

index c29f8c02ea05..d71d65846e47 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3053,7 +3053,7 @@ static int talitos_cra_init_ahash(struct crypto_tfm *=
tfm)
        crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
                                 sizeof(struct talitos_ahash_req_ctx));

-       return 0;
+       return talitos_init_common(ctx, talitos_alg);
 }

 static void talitos_cra_exit(struct crypto_tfm *tfm)
