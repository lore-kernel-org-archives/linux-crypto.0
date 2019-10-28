Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0A5CA9EBC
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 10:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E10621479
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 10:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s34NV/eB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732961AbfJ1KkM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 06:40:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34973 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732924AbfJ1KkM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 06:40:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id x5so1306862wmi.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2019 03:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wr2jB851O+Opabs2ncsRBVcciUPBCA3lrlYshLldd9k=;
        b=s34NV/eBsfrsmnM8gawO9IncDU29TJ/OixXrJIVh9DoAAwbw19pfRB7a3xNHY2dpvH
         XaA9sRueiyAR9tinh2M/ifZZIt8RW4da5AFBDID0yLqznNVe5UVq6CuZ/brLO/wSyf/k
         6WRV7+tm7FrTPVSujilPRL0E+PIQT7X+QyVw5C2PB/V1WBcutFYAHcQURajbhvHrraJq
         uDlLW3jpzA9CCh50ITWucj/GTGPrCLiQwdpvCRTUWDzNezlcQaW2M9C7k3k4LlbXdI0C
         8WNFQciSk+YcaJSlM3IPAOdP+vkvtgCXO/uU/OD88aT8RC1lq0sI60ux3k6c3RFeByRz
         58vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wr2jB851O+Opabs2ncsRBVcciUPBCA3lrlYshLldd9k=;
        b=KyUW9iBTytTTez94TJdxA+J080OJQEHlEb9kY0HYTHCtHA++/bftXb1lQTkLydLLdP
         ymHQdV6W3rKc9vcY8CwADx8ZUXi+dNgS8R7xoXJdo3YDlXdWnuqBqhE+rZsQQVHwoJe0
         11yVoVUQuZKld2gHxehPAZlCULF3JTgOH6kZE6VtrfzK9CT028Ht1Kvoun3yquVADYg8
         gwr0reO5CBdXWVn0U9V0Z1LwkIXDZLGINjnKmZYR+G2U/mZ+J8/v14QMYw2hRJwWPlmq
         isJD112LBFVi/J2Z5IZIPwVsMEKKYY0LWmaaF+LSWK9HvkQZ1Vu01uZHqd0nWIFLM/kS
         PRnQ==
X-Gm-Message-State: APjAAAU6hCAz3RBd871ik1StMn74A5Jbxxme9M6esHNPFyMuEpqUQpjd
        wgDTQHYgNK07MPykdSrwcY4jTzicNy01wYBlduXvCg==
X-Google-Smtp-Source: APXvYqwVH/fSKEI9S8WWgBlBjFIJOCDGaL3B4OioYYnEABa3hVfQzfE+jwprVk0jomziwhcZsLU1d89FsuBk7OXUeSE=
X-Received: by 2002:a1c:64d6:: with SMTP id y205mr14021992wmb.136.1572259208307;
 Mon, 28 Oct 2019 03:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-25-ard.biesheuvel@linaro.org> <74d5c30d-d842-5bdb-ebb8-2aa47ffb5e8d@c-s.fr>
 <CAKv+Gu8V57Z2WixfYZSdT+rqsobqDYZ-Hyer6Aq9khUNeUsxmQ@mail.gmail.com>
 <be890dfd-a1aa-86e1-b1c7-99b72ad137d0@c-s.fr> <CAKv+Gu98fsPOZ3reGs6wXd+hzNa_pdVZ6+XDFoXhey7C39sfFw@mail.gmail.com>
 <63c941df-ae15-733f-3b0b-35fc0ce6af51@c-s.fr>
In-Reply-To: <63c941df-ae15-733f-3b0b-35fc0ce6af51@c-s.fr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 28 Oct 2019 11:39:57 +0100
Message-ID: <CAKv+Gu9G5LxE3UCV0TizkucXWsGGn78crPxTDBRJFQuaqN0wPw@mail.gmail.com>
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

On Mon, 28 Oct 2019 at 11:36, Christophe Leroy <christophe.leroy@c-s.fr> wr=
ote:
>
>
>
> Le 28/10/2019 =C3=A0 07:20, Ard Biesheuvel a =C3=A9crit :
> > On Sun, 27 Oct 2019 at 14:05, Christophe Leroy <christophe.leroy@c-s.fr=
> wrote:
> >>
> >>
> >>
> >> Le 27/10/2019 =C3=A0 12:05, Ard Biesheuvel a =C3=A9crit :
> >>> On Sun, 27 Oct 2019 at 11:45, Christophe Leroy <christophe.leroy@c-s.=
fr> wrote:
> >>>>
> >>>>
> >>>>
> >>>> Le 24/10/2019 =C3=A0 15:23, Ard Biesheuvel a =C3=A9crit :
> >>>>> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher int=
erface")
> >>>>> dated 20 august 2015 introduced the new skcipher API which is suppo=
sed to
> >>>>> replace both blkcipher and ablkcipher. While all consumers of the A=
PI have
> >>>>> been converted long ago, some producers of the ablkcipher remain, f=
orcing
> >>>>> us to keep the ablkcipher support routines alive, along with the ma=
tching
> >>>>> code to expose [a]blkciphers via the skcipher API.
> >>>>>
> >>>>> So switch this driver to the skcipher API, allowing us to finally d=
rop the
> >>>>> blkcipher code in the near future.
> >>>>>
> >>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>>>
> >>>> With this series, I get the following Oops at boot:
> >>>>
> >>>
> >>> Thanks for the report.
> >>>
> >>> Given that the series only modifies ablkcipher implementations, it is
> >>> rather curious that the crash occurs in ahash_init(). Can you confirm
> >>> that the crash does not occur with this patch reverted?
> >>
> >> Yes I confirm.
> >>
> >> You changed talitos_cra_init_ahash(). talitos_init_common() is not
> >> called anymore. I think that's the reason.
> >>
> >
> > Thanks a lot for digging into this
> >
> > Does this fix things for you?
>
> Yes it does.
> Thanks.
> Christophe
>

Thanks a lot for confirming.
