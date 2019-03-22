Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FEBC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 08:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 617C520700
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 08:10:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Jw4IxBQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfCVIKb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 04:10:31 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:47281 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbfCVIKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 04:10:31 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id eeaa3cac;
        Fri, 22 Mar 2019 07:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=KP723Abz1m33mPHiMSHCHIDYsfM=; b=Jw4IxB
        Q9dd3oEsjnHdFqGeMhgTyZs910egFa0EuOm3fNbeAce/m6EUpcyGvUe7KiX9dYYy
        Q80N5SqshnX4+GOHulAcOOP6GyR2s/V2Q/XBon1azv8Iwz4Hv1c6aCTj7WNLOn0d
        SDYe2qwcNcb+ho8FxjNzTO/QT1ojJYDV+SYTlaVN2acyDy2SSy9rJJ2qP2xrTI/G
        7QVQ4qRUFvpmGllXkxKzOpUCU5GnEB9DHkjiqhG+cEzAhITit6nryhHzBjETZzAj
        0DL/15s830k88O7x/JDUVGEn8D5XVQDtGj2dLsElnR+IGyI8yNeEsA2fYWzAPoN7
        LfcxiwwKhQzYvJpw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2c9b8263 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 22 Mar 2019 07:48:44 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id m10so1204952otp.2;
        Fri, 22 Mar 2019 01:10:27 -0700 (PDT)
X-Gm-Message-State: APjAAAV6mVjJzhyiK8wLJ0i/I5MA037urXw/nmzKOrukrFAwe5GDhrsq
        xQYJcq7cPRSW8MW6HFZc4FTvIpFHPEMNnA7hmp4=
X-Google-Smtp-Source: APXvYqwHZMEh/0Ssq1v3l9grxyESzJUlqf/Xw3FwcrcuEzrgpKEelSS2MVzde+uXozf7CUF6UDkepkgmsyGhcpuP5z8=
X-Received: by 2002:a9d:62c8:: with SMTP id z8mr5706217otk.144.1553242226947;
 Fri, 22 Mar 2019 01:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au> <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 22 Mar 2019 02:10:15 -0600
X-Gmail-Original-Message-ID: <CAHmME9rWpTzxTCjG3ynyNwgxndW3DP5+r9NmLX2AMfp1s9vB-g@mail.gmail.com>
Message-ID: <CAHmME9rWpTzxTCjG3ynyNwgxndW3DP5+r9NmLX2AMfp1s9vB-g@mail.gmail.com>
Subject: Re: [PATCH 0/17] Add zinc using existing algorithm implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 22, 2019 at 1:56 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> that implement it, the reluctance of Jason to work with the community
> to fix the issues that he identified in the crypto API means that
> WireGuard will not be able to use these, and is restricted to
> synchronous software implementations.

There's no reluctance to work with the community. I'm pretty deeply
committed to this, as evidenced by the multitudes of patch
submissions, discussions, and popping around from conference to
conference discussing with folks face to face.

> - The way WireGuard uses crypto in the kernel is essentially a
> layering violation - while we already have an asynchronous API that
> implements ChaCha20Poly1305 in a way that WireGuard /could/ benefit
> from, and while we even have support already for async accelerators
> Saying accelerators will not
> matter is a bit like saying there are no American soldiers in Iraq.
> (Note that adding async interfaces to Zinc is not the right way to
> deal with this IMO)

Geopolitics aside, as explained over and over, the point of Zinc is to
just get down simple software function calls, for instances where
async accelerators aren't available. I consider smushing it all
together to be the "layering violation".

> - I don't think Zinc changes should go through Greg's tree and have
> separate maintainers

As I've mentioned before, I'm fine with merges going whichever route
is best for merges. If Herbert thinks it'd be useful to send things in
that direction and would reduce clashes and such, then that's fine
with me.

>  in fact, I am a bit concerned about the fact
> that, after the last Zinc/WG submission in October, Jason has not
> really interacted

Such as... https://www.youtube.com/watch?v=CejbCQ5wS7Q ? November is
after October.

Anyway, I thought it good advice to not post v9 too swiftly after
plumbers, letting things calm a bit and focusing on other improvements
in Zinc in the meanwhile. I've certainly been around.

Looks like Herbert posting this might erupt another contentious thread
of bikeshedding and argument, what a bummer.
