Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AD0C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 18:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406F3208C4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 18:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJcLoYqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbfFQSIF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 14:08:05 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:39906 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFQSIF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 14:08:05 -0400
Received: by mail-pg1-f170.google.com with SMTP id 196so6249311pgc.6
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 11:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YRy4VNkdLsHQxqj3Rb0Y+SzdBelMTd14p3PAwfNhMHk=;
        b=vJcLoYqrOK9VczohujHC3Pj8IeFaDI7Ax4I5KbND+lrKN51MWpOM3OQjXDM0152rT9
         e12p2wYk7XeWm5pzvVWrwTyfsOcFAnB/lrje/gqeCiMV7Wnx7WR/myRuPXJ7vpA3Nj5s
         WIg58J7V6wn4oiJHsdhwy2Au2vUZSzwjFN0+nAFkl1FR6FohkR5lg/A7u34raUfT6onO
         85lmJBXn1t7803spGcqRSNS7oZC/QvNwd6cdGZC7HFprIIrVvQSv8nGREO1+FhoU3F4h
         C84U1SD7cCd7RYYYjhlj+LGohs84Fre98VOI4F0TFOrZfhcVoUCGzShl7OmSAyfevd37
         9hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YRy4VNkdLsHQxqj3Rb0Y+SzdBelMTd14p3PAwfNhMHk=;
        b=PH28/LHv9cC6I89EWkEkB7oD3WR1Uk0wTH2kxhybnaukDYsad9rjr3GKS5Etx9MNQJ
         u0Sag4didM/8ZyfhFlcARA1KQezC0BLzlKpbZ/P4vBq+Eo4RQXN48OyrVmQbfAUhirm4
         Bfzila0GR3R+sGjgj48dZOKUozfbcXpaUi7k41dfk7y6qBbs66lYL1RDEIUYzROgU4/E
         EEEBqXfZg4eH/SnS1i76PNjxSjv+vSzihoMzzi7sJhZzUo1IlKlaiNcOL8xsGabiUpe4
         0Tsq5GnoJ3t0HYBmpdycVxj6Ea/xffVBclIz7dCoaXDk5uuIxF4ZX/kC+gg4QVHS6wQo
         AVGQ==
X-Gm-Message-State: APjAAAVbDAtfmqwwpIg9/+YbKLLJ5ZxvrFRl8AhfA+QjLauzlEiZGLCw
        22Ju5IMTgZ4YSUa8IjO1DVg/BJnjEVaHI3fjailtEA==
X-Google-Smtp-Source: APXvYqxmNcMKctZ/nmQCMF4nsJ67J6+f9mTn7qdUIW/MBwfVxcengtKmpHnVKJ60NUzWcBIB+FHaOZxABCap4udacDM=
X-Received: by 2002:a62:2c8e:: with SMTP id s136mr71039972pfs.3.1560794884609;
 Mon, 17 Jun 2019 11:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
In-Reply-To: <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 17 Jun 2019 11:07:53 -0700
Message-ID: <CAKwvOd=PJ_4whC7AU==Fi22OhQK2MXpHjutH8wBd+-CN-CoH2w@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 11:06 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> In fact, looking closer at that diff, the section in question
> previously had 32b alignment.  Eric, was that change intentional?  It
> seems funny to have a 32b entity size but a 16b alignment.

32B & 16B
-- 
Thanks,
~Nick Desaulniers
