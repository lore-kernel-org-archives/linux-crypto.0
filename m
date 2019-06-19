Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6A9C31E5B
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 15:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4429521881
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 15:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qyMSheO7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfFSPp0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 11:45:26 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45829 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSPp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 11:45:26 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so39110056ioc.12
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 08:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YF5GIjRAndHPUW8ip4P0tj5IaS2t9gDC60YoZnzPNZ4=;
        b=qyMSheO71KevECSQ7JG80qKXQs7Bfbce+jbT8oZxikJk8VCooFlY/kWmXAPXhjzykm
         k7GdQP9Z02RRMCxcxrBFlXptVogBZ+wwqaZcQjYkD9x5N1zoA8LwvgYQu2l7xeT2Kbos
         CzQSMHZalIhYyk7LYhiQ/WvGhgWSn76RrVmxXwyuk5sswSy0f7rz8xHGrbGGxgb+GPv+
         Sal6p5jSpvsYC3HOHzquZLweMNwhSBd/+k5ICGwgy6FqfbA+1/vFB+TeUnOBVyAldMG2
         o1XD3gsCV2Qm7XbgtBkh4wXwJUu69UrfLGmsieObNkrmCUNvMIz8dEyKIfZ7x2twDy+E
         3AVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YF5GIjRAndHPUW8ip4P0tj5IaS2t9gDC60YoZnzPNZ4=;
        b=UPes3vnArYGAivnL7BZbjW/0FMtMafpaEoknvKxt+HKYvRqU4KjArGyMZZkO2H7evN
         ZSOi5/fhP9tDUU5aLFbar2TOqYwLrnUCGroF9OyGDL2vQBx7uqBgvKMChO1lIALDwaZ6
         Ran+oSuZ58mN0PgtedLPyR0Wpw75JrWD/6z+hMoJM4L2oOiMa+uSsplBBWNxpc5AJEKQ
         PaCKOCOJ+wNxobDNUmKY1cBGmj9W1NW9RTY0o+a/2qbtIMEOUO9i2/r/BiExt28AxI/Z
         UFfAaiAE5lUy25zpD2AJzQ4OGjhFni2C9gUths74kGDLjLEHE7xUCyi5NB2pfGAsxdNo
         UwPA==
X-Gm-Message-State: APjAAAUl0BwPtapUQJk5ECjBlbrVuo2caX2JX44IwntJtUyt5BUFvuvg
        oLHPPt31aCEQ3rHp0pMngZjR2hL0GhKV++3cEcxTEw==
X-Google-Smtp-Source: APXvYqxwFPYbyCqSLmVnqyo/+MkmgWGDZGE2ADYFN7l3/kxmvwG6feuxxKVJIhuSoPfd2X6vWA46PHWbG+hjdjvwSYo=
X-Received: by 2002:a02:5a89:: with SMTP id v131mr6696187jaa.130.1560959125252;
 Wed, 19 Jun 2019 08:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <20190618212749.8995-2-ard.biesheuvel@linaro.org> <CAAUqJDsi_acZj09xiimYGfyJVPt0zo=3-2PHuGnSKSaq82-RQA@mail.gmail.com>
In-Reply-To: <CAAUqJDsi_acZj09xiimYGfyJVPt0zo=3-2PHuGnSKSaq82-RQA@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 17:45:13 +0200
Message-ID: <CAKv+Gu_okSc=Ep9nbdqnbB1hVRmr8O4tChDPm+m7O+jb1pBD_A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Jun 2019 at 17:18, Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.co=
m> wrote:
>
> Hi Ard,
>
> ut 18. 6. 2019 o 23:28 Ard Biesheuvel <ard.biesheuvel@linaro.org> nap=C3=
=ADsal(a):
> > Implement a template that wraps a (skcipher,cipher,shash) or
> > (aead,cipher,shash) tuple so that we can consolidate the ESSIV handling
> > in fscrypt and dm-crypt and move it into the crypto API. This will resu=
lt
> > in better test coverage, and will allow future changes to make the bare
> > cipher interface internal to the crypto subsystem, in order to increase
> > robustness of the API against misuse.
> >
> > Note that especially the AEAD handling is a bit complex, and is tightly
> > coupled to the way dm-crypt combines AEAD based on the authenc() templa=
te
> > with the ESSIV handling.
>
> Wouldn't it work better to have a template only for skcipher and in
> dm-crypt just inject the essiv() template into the cipher string? For
> example: "authenc(hmac(sha256),cbc(aes))-essiv:sha256" ->
> "authenc(hmac(sha256),essiv(cbc(aes),aes,sha256))". That seems to me a
> much simpler hack. (But maybe I'm missing some issue in that
> approach...)
>

Unfortunately, that doesn't work. When using AEADs, dm-crypt also puts
the IV in the AAD area.
