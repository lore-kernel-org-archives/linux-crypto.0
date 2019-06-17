Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C997C31E44
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC9DC2080A
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="XtlskwgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfFQIwE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 04:52:04 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:38611 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFQIwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 04:52:04 -0400
Received: by mail-ua1-f66.google.com with SMTP id j2so3199767uaq.5
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 01:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JUqP3OKeD9bPLmSeCNOPOKYOA3EuQZNFNBZVHYzC5g4=;
        b=XtlskwgAxUNAXyFcXU16C6KAhEpQNCyyXjj/AqlIJZIPfIDfe9DP0YJEN8hUAybdZS
         GeF4UKONeKyJ16gBgPsvAi2PpvkgnDWRV530xC5Fhd1QqHmm2yPAXv+70RA+rKE5rEBj
         9OvPRoBYneEwIjZyfG6ds0OZ8k7zGP7BsfwJJ3yCeYjfJPQC1a+hovGdIfMsNX8aeChl
         2EoDLFZy79Y8Ra7HxUSdwkf/HAQt3tsb9ll/BlDyQe1ajUGFXwuqRHfAyqy5PzculMNI
         BR8xoqtihnK7YQd9hRUtQuxdNnjLEKq5dBY7QGM/mt/Ss2hnCRiW8IALIkwW2pQDXOKr
         I9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JUqP3OKeD9bPLmSeCNOPOKYOA3EuQZNFNBZVHYzC5g4=;
        b=j25fYyMrTO7olza5PS4biWW8IiTZBhyEGZn4MsNsLws3Z8W7xPtIJksl5/lMIPrnAI
         zvQFFQi5qVk73soF866pLa9iY1SzcM5Zct8CMWChp6pdx5BSQs4f+T8ng2KoQxwa/w2K
         5x04W104216NcZDzvFqWiHzugteKhtci6U3Sn3+eC/6nA7edcNiK1ldXX6Lxm/DHdPvu
         Wyp4F5thVXQptQTn+YsMm/U77OURs4mRZdRtzRsZmQUREhU5JRdsKRBjXDXbYc4WqAUT
         ix20eYwpB5KO+45r8lO19Yo7TcR/gSeCeWNoY4etvz1u0AtU6cUYX5hq+0v8uSTv18UT
         THoA==
X-Gm-Message-State: APjAAAV3xdb7jqwwAEgSvnPU4Ig/1YJ2UPaOS2aZGkclv6TKkxVuBHGy
        pidieODjZFtA3EwPKNl6XWWhNOeqisz9TnFnp03e0sou
X-Google-Smtp-Source: APXvYqxUsRrEeCO+S9+Ink2+fjaOAiIAOcXiVQUU81FYi7df7idYsDJ/kS+jTivSSuU+OpV27+CqsbxLSOqSeurMJ9U=
X-Received: by 2002:ab0:208c:: with SMTP id r12mr41428470uak.27.1560761523133;
 Mon, 17 Jun 2019 01:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org> <20190616204419.GE923@sol.localdomain>
In-Reply-To: <20190616204419.GE923@sol.localdomain>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 17 Jun 2019 11:51:52 +0300
Message-ID: <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 16, 2019 at 11:44 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> [+Cc dm-devel and linux-fscrypt]
>
> On Fri, Jun 14, 2019 at 10:34:01AM +0200, Ard Biesheuvel wrote:
> > This series is presented as an RFC for a couple of reasons:
> > - it is only build tested
> > - it is unclear whether this is the right way to move away from the use=
 of
> >   bare ciphers in non-crypto code
> > - we haven't really discussed whether moving away from the use of bare =
ciphers
> >   in non-crypto code is a goal we agree on
> >
> > This series creates an ESSIV shash template that takes a (cipher,hash) =
tuple,
> > where the digest size of the hash must be a valid key length for the ci=
pher.
> > The setkey() operation takes the hash of the input key, and sets into t=
he
> > cipher as the encryption key. Digest operations accept input up to the
> > block size of the cipher, and perform a single block encryption operati=
on to
> > produce the ESSIV output.
...
> I agree that moving away from bare block ciphers is generally a good idea=
.  For
> fscrypt I'm fine with moving ESSIV into the crypto API, though I'm not su=
re a
> shash template is the best approach.  Did you also consider making it a s=
kcipher
> template so that users can do e.g. "essiv(cbc(aes),sha256,aes)"?  That wo=
uld
> simplify things much more on the fscrypt side, since then all the ESSIV-r=
elated
> code would go away entirely except for changing the string "cbc(aes)" to
> "essiv(cbc(aes),sha256,aes)".

I will also add that going the skcipher route rather than shash will
allow hardware tfm providers like CryptoCell that can do the ESSIV
part in hardware implement that as a single API call and/or hardware
invocation flow.
For those system that benefit from hardware providers this can be beneficia=
l.

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
