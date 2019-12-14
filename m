Return-Path: <SRS0=D8v3=2E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBFAC43603
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Dec 2019 13:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206F024658
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Dec 2019 13:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eU6hf604"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfLNNFY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Dec 2019 08:05:24 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:36663 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfLNNFY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Dec 2019 08:05:24 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 363a0ee7
        for <linux-crypto@vger.kernel.org>;
        Sat, 14 Dec 2019 12:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=hYC2PaaBwR3br+jRNZ3yRFwJE6g=; b=eU6hf6
        049i57W5WxyZkofghZQeCqoPO7RjOHgOAiQqCDJKPxE+ptKrYpJ/Idh7X9Wd86KW
        us4SSnUmKHHDnhJVkbWXBYpwpQdkEMICX4fpu2yn7JbHwETMbMORnfAtuf1EpKK4
        McDtamofzYTsoX5ygoet0aNlXE8bJ2WFUzBjA2qxhwKrVQPeKNKf2YyvmDZRtj7B
        IFGGutdIb8zGN0nhIQVngaIG1KkjITGLGRRN9E4dABgZMDh0paSJ1gzv2+rvIecy
        OB9q20gw2tgtnPM15As+4njSoiclnGIur4XjXsaPu01I42TP3yryPXVZg5yBkBEh
        l1jmwLzAEdo0glmw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b1ac8f99 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sat, 14 Dec 2019 12:09:19 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id p8so2717551oth.10
        for <linux-crypto@vger.kernel.org>; Sat, 14 Dec 2019 05:05:22 -0800 (PST)
X-Gm-Message-State: APjAAAWnpUTJoQ8MGA8f2OmUa8zlBrYihNhKpbfZRQNZ25SNE+msBwuh
        gDdCDQNfLigzWNzYI3u8KPeqYaxgra3xFqBN8wA=
X-Google-Smtp-Source: APXvYqxM2PsUzThSYbWQEVNPb3FTKEDlOgQNiLIX+LniF7M7GvMt3wKWiryAe4AOF73I8BpDE4d9q7KRX5Oy7CSER/c=
X-Received: by 2002:a05:6830:1b6a:: with SMTP id d10mr21168278ote.52.1576328721427;
 Sat, 14 Dec 2019 05:05:21 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
 <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
 <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
 <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
 <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com>
 <7d30f7c912a5565b1c26729b438c1a95286fcf56.camel@strongswan.org>
 <CAHmME9rP_AAH6=R7ZRPnu3UPTvZ+c32-XYOr2jstSyQvCaQhnA@mail.gmail.com> <20191213032849.GC1109@sol.localdomain>
In-Reply-To: <20191213032849.GC1109@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 14 Dec 2019 14:05:10 +0100
X-Gmail-Original-Message-ID: <CAHmME9p-dBVbCBoX+p4n3meC5n_GjCuZgMiUfUqG2-G-wqLbyQ@mail.gmail.com>
Message-ID: <CAHmME9p-dBVbCBoX+p4n3meC5n_GjCuZgMiUfUqG2-G-wqLbyQ@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Fri, Dec 13, 2019 at 4:28 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Now, it's possible that the performance gain outweighs this, and I too would
> like to have the C implementation of Poly1305 be faster.  So if you'd like to
> argue for the performance gain, fine, and if there's a significant performance
> gain I don't have an objection.  But I'm not sure why you're at the same time
> trying to argue that *adding* an extra implementation somehow makes the code
> easier to audit and doesn't add complexity...

Sorry, I don't mean to be confusing, but I clearly haven't written
very well. There are two things being discussed here, 32-bit and
64-bit, rather than just one. Let me clarify:

- The motivation for the 64-bit version is primarily performance. Its
performance isn't really in dispute. It's significant and good. I'll
put this in the commit message of the next series I send out.

- The motivation for the 32-bit version is primarily to have code that
can be compared line by line to the 64-bit version, in order to make
auditing easier given the situation with two implementations and also
for general cleanliness. I think there's enormous value in having the
other implementation be "parallel". Rather than two totally different
and foreign implementations, we have two related and comparable ones.
That's a good thing.  As a *side note*, it might also be slightly
faster than the one it replaces, which is great and all I guess, but
not the primary motivation of the 32-bit version.

Does that make sense? That's why I appear to simultaneously be arguing
that performance matters and doesn't matter. The motivation for the
64-bit version is performance. The motivation for the 32-bit version
is cleanliness. Two things, which are related.

I'll make this clear in the commit message of the next series I send.
Sorry again for being confusing.

Jason
