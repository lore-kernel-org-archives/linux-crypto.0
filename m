Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788A7C7EE2A
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 17:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbjFBRit (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 13:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbjFBRis (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 13:38:48 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC9F1B9
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 10:38:46 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96f5d651170so762275266b.1
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 10:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685727525; x=1688319525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPpIUifsrj3WhrOLcjmDKG+n28eYiyTfgghRaS6XkRs=;
        b=IKRPxJ3A0yf2tZl1cV/0w2dtc7OEvW1uj1qqlfdLfH6hbUUfGsHB0M83XAWUkuZEXI
         rWQypeGHOLw7lhGuspNtOMw+mlk1AUWdqj9drpaGt/SxaZqMXLcZmWXcx7uu71+974KQ
         YfOQSvOhd6kPyAndsrGpN35sfO/7fnRVnWxG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685727525; x=1688319525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPpIUifsrj3WhrOLcjmDKG+n28eYiyTfgghRaS6XkRs=;
        b=huMLv+AvDBnKS9u7DLfZXkBdoB52HZJT3YJEBcopbBnDWYEqlFR6yL42At/aAJpvAN
         BjVVMxcugX3x2Mwuu7VIPy5Kl7hwuVyxxSLrofsW+7252sW1SeW8YrD9hPA1M1qMHMsS
         RfQu2GDiDOTShLAFW+F59YSURQc4QaPPIylubVv5QZRltq7GeUW2ibCEeOSf1BTv4Vb2
         C2qNtLp/OPBNOfS9Jd24H2wHrc+u9UD7luAn/BFQeAnPfRpNJtgjbLKJbVszf0nazgFy
         urXKgTyJxxLungov1Cd8jwz39ZpJ7cZzEIx0YyVT7SDA1cuutYzqwcDUvZGVTrBfHU5f
         O9nA==
X-Gm-Message-State: AC+VfDxXCnf+Qp6fP/ILfWp4BO8MT6i1drbKBnuA8l4bnXztBJqqFNpn
        MrQcNSxG+yt1bPdpAF0t/6tH+i3l6E2Y9/FuQ+WGx1Mp
X-Google-Smtp-Source: ACHHUZ6HWO4Ioe9PPMzaYFFtFKdYZg+6bQQk6SjZ+815V1itrRQ8BHSnM49uFa1BTRzXdO1HCyB6vg==
X-Received: by 2002:a17:907:96a6:b0:973:7096:60c2 with SMTP id hd38-20020a17090796a600b00973709660c2mr5605909ejc.20.1685727524827;
        Fri, 02 Jun 2023 10:38:44 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id v4-20020a170906380400b0096f72424e00sm982857ejc.131.2023.06.02.10.38.43
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 10:38:44 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5148f299105so5027927a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 10:38:43 -0700 (PDT)
X-Received: by 2002:a05:6402:202e:b0:505:d16:9374 with SMTP id
 ay14-20020a056402202e00b005050d169374mr3588912edb.9.1685727523436; Fri, 02
 Jun 2023 10:38:43 -0700 (PDT)
MIME-Version: 1.0
References: <4d7e38ff5bbc496cb794b50e1c5c83bcd2317e69.camel@huaweicloud.com>
In-Reply-To: <4d7e38ff5bbc496cb794b50e1c5c83bcd2317e69.camel@huaweicloud.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jun 2023 13:38:26 -0400
X-Gmail-Original-Message-ID: <CAHk-=wj4S0t5RnJQmF_wYwv+oMTKggwdLnrA9D1uMNKq4H4byw@mail.gmail.com>
Message-ID: <CAHk-=wj4S0t5RnJQmF_wYwv+oMTKggwdLnrA9D1uMNKq4H4byw@mail.gmail.com>
Subject: Re: [GIT PULL] Asymmetric keys fix for v6.4-rc5
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 2, 2023 at 10:41=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> sorry for this unusual procedure of me requesting a patch to be pulled.
> I asked for several months the maintainers (David: asymmetric keys,
> Jarkko: key subsystem) to pick my patch but without any luck.

Hmm.

The patch behind that tag looks sane to me, but this is not code I am
hugely familiar with.

Who is the caller that passes in the public_key_signature data on the
stack to public_key_verify_signature()? This may well be the right
point to move it away from the stack in order to have a valid sg-list,
but even if this patch is all good, it would be nice to have the call
chain documented as part of the commit message.

> I signed the tag, but probably it would not matter, since my key is not
> among your trusted keys.

It does matter - I do pull from people even without full chains, I
just end up being a lot more careful, and I still want to see the
signature for any future reference...

DavidH, Herbert, please comment:

>   https://github.com/robertosassu/linux.git tags/asym-keys-fix-for-linus-=
v6.4-rc5

basically public_key_verify_signature() is passed that

     const struct public_key_signature *sig

as an argument, and currently does

        sg_init_table(src_sg, 2);
        sg_set_buf(&src_sg[0], sig->s, sig->s_size);
        sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);


on it which is *not* ok if the s->s and s->digest points to stack data
that ends up not dma'able because of a virtually mapped stack.

The patch re-uses the allocation it already does for the key data, and
it seems sane.

But again, this is not code I look at normally, so...

               Linus
