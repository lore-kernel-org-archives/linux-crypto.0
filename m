Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949DDC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B0942084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k6D8p7QE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbfJDPFW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:05:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40599 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388802AbfJDPFV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:05:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id l3so7627960wru.7
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 08:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ekjrUdXZysZBgjOdshj5/zqIHgmJSBhb5PKNjrF4mcU=;
        b=k6D8p7QE0Qz1Im4fttY4SppkXF0pEgTEFKXmDBOf1ouFZ9UEI990gVtzCG7agWWFkc
         j00e5EXS+19ZQzVJ97ODFkZGaDppk0sc0Ywf0/Kq6F+YnwDlstPgs5eTWG0udcYNsSaz
         KxlRXlNFikVHFRtZn8cTrIF9kZ3GDD9ZOymVeowVJANAu3IIvOs6Kw9LzHGuOSo6dpHm
         NJim1Ztmo+AVF61eqJEcRCQuqn836Hqts1qb52UbfCDphJRh72rHiM2JJF6l2Pl5+Fkp
         Yucv/2ulnWxFPrMK+8Gmhm0iX0l3yrou/WAvJ5CnmbY8NGUp+L6Yg1psXPIW53nT1l8t
         5zag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ekjrUdXZysZBgjOdshj5/zqIHgmJSBhb5PKNjrF4mcU=;
        b=EKvC1OB108wFCtOX6n+AefqVFfJoBpz7lfzpRMMT42lZefu6Ue5fmG3kEY1OEW+ct1
         Tm+1PxinB2zeGipbgVMz0xY63rZoreyiZ9rb9aTEqPT3cKcnNl7JtW3D0tuzubD+Z2Pc
         VY4EUmboI7mzKUm2e1iIk+Sr7s8xO65O/mEsG2hNTdTCL341ytqyimm5tUA4iqNNjXFJ
         kF4nPuNZ3XjrlG7n4OJpjnM1S70lWpq0nSQMVwP5ltPo81QEUPyQVeqOYsYLeGF9nQM4
         VFmFHkTc1xQ7ajLUqCfgwKKOYKydxfGomDm9STUz5eAQztDargVs0dV25vcMhXelvCdf
         YNwQ==
X-Gm-Message-State: APjAAAUnAqdmah0kOIutpyqZuNVRfuddnbHkNdhtvyBY8CcwCU/mJ/MI
        W9tUJxfwl8v03+Hosfqxb9x5ywWkev4pUhg7KlFwUg==
X-Google-Smtp-Source: APXvYqxwCv9PJZoxn02AomtlMxz5iPWOz0mkPghhshR0jdF3rBgspyuKd7ZWf/hmXE0XXxHZIcZycn9JKgOcaVKQNwY=
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr12637760wru.246.1570201517913;
 Fri, 04 Oct 2019 08:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org> <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com> <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
In-Reply-To: <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 17:05:05 +0200
Message-ID: <CAKv+Gu_=7Gq+4=TGn7XqJX=F4VoR-YbgsLADYuw9PuGKWDvCxA@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 16:59, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Fri, Oct 4, 2019 at 4:44 PM Ard Biesheuvel <ard.biesheuvel@linaro.org>=
 wrote:
> > The round count is passed via the fifth function parameter, so it is
> > already on the stack. Reloading it for every block doesn't sound like
> > a huge deal to me.
>
> Please benchmark it to indicate that, if it really isn't a big deal. I
> recall finding that memory accesses on common mips32r2 commodity
> router hardware was extremely inefficient. The whole thing is designed
> to minimize memory accesses, which are the primary bottleneck on that
> platform.
>

Reloading a single word from the stack each time we load, xor and
store 64 bytes of data from/to memory is highly unlikely to be
noticeable.

> Seems like this thing might be best deferred for after this all lands.
> IOW, let's get this in with the 20 round original now, and later you
> can submit a change for the 12 round and Ren=C3=A9 and I can spend time
> dusting off our test rigs and seeing which strategy works best. I very
> nearly tossed out a bunch of old router hardware last night when
> cleaning up. Glad I saved it!

I don't agree but I don't care deeply enough to argue about it :-)
