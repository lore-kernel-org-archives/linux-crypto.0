Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA92C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EFFB207FF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="ni6TIZ2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbfJDOuM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:50:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43017 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388870AbfJDOuM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:50:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id v27so3867111pgk.10
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=O8dxtxZWf+wlgyrNHa8J6WMWv3Y1JgiQq/LyksoMXKo=;
        b=ni6TIZ2xibkbxn64M/sIQDm9VxBwgdCPw6wV7y74lrPNiOONJfsyfxqmIVyv8bEcHb
         lvdOfFt73qel+LqVDHiOJ3BH4NlV20rNJ7UG9XnMLtu4z5sTBI6tLW2SH7tIHHtPyhwT
         C37cOVj8wK6JLS2vk5qLJ7prWHnAdU5UZkruNQCBi69ZghPqHyHa5DT9kz2K9YJnnw2C
         c1+CPsDxDky2VkHSeEOZB4U8mIloJD1LDyFUsaahZ32lit7LUF1OrakzgYl7Ljc2tKfD
         916v/4CCBNd8jGVTC6fEktJPb1W5Lj1fTn1IsRQ6vpP6rwO86QKtRfnlkzFlMjEXd2BW
         bmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=O8dxtxZWf+wlgyrNHa8J6WMWv3Y1JgiQq/LyksoMXKo=;
        b=f1/U0xDz/P/ymJ+qdgRi5YhAgGDf3EAll4onWuWeyCEpc/zv9pmGcGi/Qwt0gNhPqR
         ZEbZst4a6IRXhQaSwTz7g47fIDy6v0OulOyp5aL/NKWH8YCqtOVgHLW1eYptmam5yzYS
         ANTA4ANr+PoNus+rPh87wQVupP7VJAtNqEQuU2db9WNazUnqltZrzZhpBCDWrUVtYhub
         KJmaY4PYfABrKgoytHtGIopw7AcRFHbIHktFSGzOIXjKwglwNh5tIXfz0j8HhPaw5cAw
         YqJ5k0skfDGFa4CH5//Sz7zLZBAZVwFmzBuIU1kkEInlO9husTgvW58KHbX96PJFIpmv
         N16Q==
X-Gm-Message-State: APjAAAV+2BGeq/8EKgXjFp7cVepdV3lvypoRRLX/BpO0VntMQhhU69/5
        5UU5j2J6VvMIkSCS0xZgOdGNuQ==
X-Google-Smtp-Source: APXvYqw9qA4GInd4TM1aL92ziNBZXSEOayzESBiKno87Mbd/KgCtIrozyNL00fwU8clacPNAROKiiQ==
X-Received: by 2002:a17:90a:8416:: with SMTP id j22mr17199825pjn.39.1570200611470;
        Fri, 04 Oct 2019 07:50:11 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:b800:f509:3b99:5225? ([2601:646:c200:1ef2:b800:f509:3b99:5225])
        by smtp.gmail.com with ESMTPSA id v20sm812616pgh.89.2019.10.04.07.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:50:10 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
Date:   Fri, 4 Oct 2019 07:50:09 -0700
Message-Id: <63B7E067-9D6D-4F42-940D-37EDFCDD2E80@amacapital.net>
References: <20191004134233.GD112631@zx2c4.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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
        Josh Poimboeuf <jpoimboe@redhat.com>
In-Reply-To: <20191004134233.GD112631@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
X-Mailer: iPhone Mail (17A854)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Oct 4, 2019, at 6:42 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
> =EF=BB=BFOn Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
>>> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
>>>=20
>> ...
>>>=20
>>> In the future, I would like to extend these interfaces to use static cal=
ls,
>>> so that the accelerated implementations can be [un]plugged at runtime. Fo=
r
>>> the time being, we rely on weak aliases and conditional exports so that t=
he
>>> users of the library interfaces link directly to the accelerated version=
s,
>>> but without the ability to unplug them.
>>>=20
>>=20
>> As it turns out, we don't actually need static calls for this.
>> Instead, we can simply permit weak symbol references to go unresolved
>> between modules (as we already do in the kernel itself, due to the
>> fact that ELF permits it), and have the accelerated code live in
>> separate modules that may not be loadable on certain systems, or be
>> blacklisted by the user.
>=20
> You're saying that at module insertion time, the kernel will override
> weak symbols with those provided by the module itself? At runtime?
>=20
> Do you know offhand how this patching works? Is there a PLT that gets
> patched, and so the calls all go through a layer of function pointer
> indirection? Or are all call sites fixed up at insertion time and the
> call instructions rewritten with some runtime patching magic?
>=20
> Unless the method is the latter, I would assume that static calls are
> much faster in general? Or the approach already in this series is
> perhaps fine enough, and we don't need to break this apart into
> individual modules complicating everything?

I admit I=E2=80=99m a bit mystified too. I think it would be great to have a=
 feature where a special type of static call could be redirected by the modu=
le loader when a module that exports a corresponding symbol is loaded.  Unlo=
ading such a module would be interesting.

Ard, what exactly are you imagining?=
