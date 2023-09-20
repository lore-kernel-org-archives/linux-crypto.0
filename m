Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCF1C04FEE
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 19:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjITTnV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 15:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjITTnU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 15:43:20 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256CA3
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 12:43:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99c136ee106so15399566b.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 12:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1695238992; x=1695843792; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=piPcn5jP84Mk94uBsWZooyBKmFjEME+EXsVwt6XYvDs=;
        b=ZtJa7m2J/ldGdabNdtcRaSb6em6ywDNYiNo2JFffeuMsXmV5pslFiH/wIzqqR4AY1a
         cXo8TtylSEXLnfftt1soRjlgew6lJVAjurpqgQ0vZfftehkAKoCgcVbyKuZVyvVgHhLY
         UGDnvvLTyPeuarDdiBOt5obScW27eldYOEWTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695238992; x=1695843792;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=piPcn5jP84Mk94uBsWZooyBKmFjEME+EXsVwt6XYvDs=;
        b=K8X6IzIr0yt9cvVfvOxZvuTmofygRp6FnasSZ01OttO9OxpJz9wasiOIdTOTbrSblt
         kUB293R4iuZN/Jq0fSr4sHcC4lCyh1jwl/WRs+KbT2VA4z866JSHioe+M9/1/2xkcdc/
         /ityIt6S7tvtTTqrzNZAzm3PCsajjt40WXxnMMlxzBiJ84CSKUeDsNE6Q+IcHiGU2NRc
         Mh0XISfEB8gJD/qtyZ+XdaHg4bTLkuF6loiyKRVTDE40CTGZ5UkYJHEmMXDJ4+DHQAs4
         t2xmAFQnHTNqZtfWZRd4/XTlc1SY1/SC7IcWF5l/m05Y//OzEhaXes6O9BWyoleXBWpp
         HGzQ==
X-Gm-Message-State: AOJu0YwISgSSTvrzmElWN13TIFR+PvvzuG3eTNqE12a6SlZjWJHgL+5x
        IYxtnz+PYhVAntwbXcSHENfP6qC5dih1VLRgMeSlx006
X-Google-Smtp-Source: AGHT+IEeeqeU4dZyH4z8XxzDOMY+Da9eoa1Fu1jQ3D3xeLnuQ43P0fPKO1NVLoJwSPy8D1TtXEmfJw==
X-Received: by 2002:a17:906:92:b0:9a1:c0e9:58ff with SMTP id 18-20020a170906009200b009a1c0e958ffmr2885402ejc.11.1695238992615;
        Wed, 20 Sep 2023 12:43:12 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906248a00b00993928e4d1bsm9722919ejb.24.2023.09.20.12.43.11
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 12:43:11 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-52889bc61b6so126043a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 12:43:11 -0700 (PDT)
X-Received: by 2002:a05:6402:184e:b0:523:3fff:5ce2 with SMTP id
 v14-20020a056402184e00b005233fff5ce2mr3044193edy.41.1695238991470; Wed, 20
 Sep 2023 12:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230920060615.GA2739@sol.localdomain> <CAHk-=wja26UmHQCu48n_HN5t5w3fa6ocm5d_VrJe6-RhCU_x9A@mail.gmail.com>
 <20230920193203.GA914@sol.localdomain>
In-Reply-To: <20230920193203.GA914@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 20 Sep 2023 12:42:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wicaC9BhbgufM_Ym6bkjrRcB7ZXSK00fYEmiAcFmwN3Kg@mail.gmail.com>
Message-ID: <CAHk-=wicaC9BhbgufM_Ym6bkjrRcB7ZXSK00fYEmiAcFmwN3Kg@mail.gmail.com>
Subject: Re: [RFC] Should writes to /dev/urandom immediately affect reads?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Sept 2023 at 12:32, Eric Biggers <ebiggers@kernel.org> wrote:
>
> >
> > Also, are there any relevant architectures where
> > "try_to_generate_entropy()" doesn't work? IOW, why do you even care?
> >
>
> There are, as shown by the fact that the full unification of /dev/urandom and
> /dev/random failed yet again.

No, no. That only showed that such architectures exist. It didn't show
that any *relevant* architectures exist.

The ones reported on were 32-bit arm, m68k, microblaze, sparc32,
xtensa.. Maybe others.

> But similarly, that's unrelated.

They are related in the sense fo "why do you actually *care*?"

Because I don't see why any of this actually matters.

               Linus
