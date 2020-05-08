Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE4FC47255
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 21:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C90218AC
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 21:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgEHVb1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 17:31:27 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:56509 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgEHVb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 17:31:26 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MuDPf-1jGAvx2wCD-00uWaB; Fri, 08 May 2020 23:31:24 +0200
Received: by mail-lj1-f173.google.com with SMTP id w20so3211984ljj.0;
        Fri, 08 May 2020 14:31:24 -0700 (PDT)
X-Gm-Message-State: AOAM5314kEMRbua6F9Dp298D9kLMnoxisOhK8qdBfJg6X3LJml7hJrx9
        0TKfCMJurVnxnmj8uofZClrSpOqTCCOjouz5lds=
X-Google-Smtp-Source: ABdhPJyHg8MtU3S0jmVPS8JYIXj9GjAxbHvNtdVIUL9iInah4pcLMe5RRVXMZsvDNN4rp4NQeWT9GblGkhSDIDK95LU=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr3009771lji.73.1588973484186;
 Fri, 08 May 2020 14:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200505135402.29356-1-arnd@arndb.de> <20200506051200.GA831492@ubuntu-s3-xlarge-x86>
In-Reply-To: <20200506051200.GA831492@ubuntu-s3-xlarge-x86>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 May 2020 23:31:07 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2LAgEG7epWFtUZrcgk9OwpVJd+ji9Ru_rq4L-Qk_dYbg@mail.gmail.com>
Message-ID: <CAK8P3a2LAgEG7epWFtUZrcgk9OwpVJd+ji9Ru_rq4L-Qk_dYbg@mail.gmail.com>
Subject: Re: [PATCH] crypto: blake2b - Fix clang optimization for ARMv7-M
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Sterba <dsterba@suse.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Eric Biggers <ebiggers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:EmKph5npPCxYfI9u4L95ryvsW+6lyiFtMKlS8HVYY6z+rUBPWtI
 zui8CXtU1O92hlJJqkdTxouXBaNmOqBP5OIyJ/njdbWSGYVecC0kSFyAU05+OZwJt58Nvl/
 6RctLkG0SyoYWaoLNoDwk83tsZHxvsD2mWfKmK6np9aeLAhDb50pQEq95yCBvNdNC4FRFI7
 NYT82E0GHY8rrdpkyV8Yg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fFsY7uQ7Lyw=:zgU2rXSehQPUjvUaH3nmrV
 aQb3NESTf2Sruw/FeQ4G812+gCyNxLauSPrZu8I3iCCxLIUiF2GPwjShfTDZJNdRpXiFaMas9
 6lySvC6ISiUVAJdGPlQw747S44XVPZ13AarzMkFzu9RA0qwdXOSootwbZUNVDJB6lIQ0ATSld
 gAFUTSco0dpcaWnylPrWCfWSj3v8F41m1nlsnqQJfmh8PlhUS2dQA7nBw4bSLdfl8abUZWDcG
 ryoYXGXhWjnBSy65UInouNcLhGW1ViWsqV8vIYlAalwp6au1hkeyPTRJnvZO43T9koDmw/PLt
 fycDE6gQVByhbDmE33L7hDqBPzwye0sTYod/4ZvqvNODYYr7107D7ThMBIy5ceg0FbqwN6fky
 0G//oiRguIWlQsnLqxUUZ0VMbf/irE+xlVnpJfyZrCV4pzO7D6guxVCf21RJFt9L0t9q/0Gu+
 4aTECpe2tDo35oh7EgjE4xFL1bRYwZZl0RcBjc8c1kX0TXn0v6t7fiERhFA5MBBkc9a6tjzYZ
 PwwJrgAjx9VTh5suWxSl8uSJXsCuADDKm0DCLn4GfYBo88EWJD2+CXmAQe8cx0MUBEsHUFrxh
 IlYFSrWVRef5Lzm0++VLN/lZWhYVztN+mReCq6rpZKOTU14FwiMaYHQGwuDgwBS1BJLF1ulA2
 p/a+6WChYnqp45PjNwA+PU+FtvmDka0kb00lKz3+OtU4QcnovnsXVZwG2zDDsof5aqEpp7vVK
 eoWdIwIPY+hI8AREc4SqlsKCP9Tys+FR5P714R2wUQMHVHY34A+Hty6invFtHYGHtg1VCi1ZW
 2GBUb4zQNQBdE467UVK48XNyz2OcT68Zwcik/u9pvqa9L/+zIs=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 6, 2020 at 7:12 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
> > -
> > +#ifdef CONFIG_CC_IS_CLANG
>
> Given your comment in the bug:
>
> "The code is written to assume no loops are unrolled"
>
> Does it make sense to make this unconditional and take compiler
> heuristics out of it?
>
> > +#pragma nounroll /* https://bugs.llvm.org/show_bug.cgi?id=45803 */
> > +#endif
> >       for (i = 0; i < 8; ++i)
> >               S->h[i] = S->h[i] ^ v[i] ^ v[i + 8];

No, that would not work, as gcc does not support this pragma.

        Arnd
