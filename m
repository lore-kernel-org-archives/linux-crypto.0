Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DDAC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 01:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D71C5208C3
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 01:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FCN7k0TK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405646AbfIGBcs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 21:32:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33673 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfIGBcs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 21:32:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so8326160wrr.0
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 18:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VwWqR8muZpwLO3ZSZZnow/P1bAyeQ3uL1WDRjIB7Jqg=;
        b=FCN7k0TKYPuf2uCHU0JbWdOYPuYOHIlbwQAzYf8tDo5xEdNbS00yMvGlLV5u+7d/kr
         tjboSfUru+OVe5kJd3qn/MSi9qm3apsfS29OXGzFx74l9PVJ99In0FHQS2ZP9R5sb3T1
         yqkoL6n86rfdI0iKNjdvUGzuTuu2R5vhsjlwa/d7oWhZKtnobzE+NjcqHes1CWN/OX0/
         1yTMA7EYao2lfuF4AF13BLc6xDfhAG84kENgQes2vGChWe1B7lFOa5UPufOVtff0zJLW
         tUpv9KztNWOre7EGCLPxmKVfgiSDqGYSxnh78TugYDOZb7rii8L/mAkhHv6arEaPjO0R
         +JMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VwWqR8muZpwLO3ZSZZnow/P1bAyeQ3uL1WDRjIB7Jqg=;
        b=GHXqnpZd+pq/VtTCu4PfDTzF1qTFUbYpAL4ir3gKXecpqNH2ERxAjRGKtVr7CCItYM
         HKPfG98WmaiuLRhdj67pkbcrufppdY8aUHKBimIxfJfXBuItovSeId4TjWD2q84i7YKx
         CazHs6DQu88raOtDzIuB2uv0iNypHuT2R7yjoBAynDrEi1PaxduaDX8hlIIUBglTHYW1
         7pROmxs0GQevRnmeg1/7FmxBnuRyWzL4OaT2ToL619RD/0Ts5SKLkS35s7StzB5pyZ6H
         xSagqf43B8Z64+hH4GDZKh0sFCTIRpXTz6gJqOJ9QQCa00IhCIrfEm0yzEUHdRjetJnb
         kFxA==
X-Gm-Message-State: APjAAAVWz65gMW2sUyhWE5AUrqi1lT67LxozA3MJMvF2IAiYve3yspWe
        tBvUJsfbA0KvM4I50wOAb9l4a6g9WvPmHKj3OXNx6g==
X-Google-Smtp-Source: APXvYqxZsAFIEd10hSydSjGnTlPOwHDLi4NE/LVvrpft373fgogUQs5Byf8GXF18KSYX0K3eIBtCRKkWbCIP45h8AZs=
X-Received: by 2002:adf:ec48:: with SMTP id w8mr9096074wrn.198.1567819966269;
 Fri, 06 Sep 2019 18:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au> <20190903135020.GB5144@zzz.localdomain>
 <20190903223641.GA7430@gondor.apana.org.au> <20190905052217.GA722@sol.localdomain>
 <20190905054032.GA3022@gondor.apana.org.au> <20190906015753.GA803@sol.localdomain>
 <20190906021550.GA17115@gondor.apana.org.au> <20190906031306.GA20435@gondor.apana.org.au>
 <CAKv+Gu8n5AtzzRG-avEsAjcrNSGKKcs73VRneDTJeTsNc+fUrA@mail.gmail.com> <20190907011940.GA8663@gondor.apana.org.au>
In-Reply-To: <20190907011940.GA8663@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 6 Sep 2019 18:32:29 -0700
Message-ID: <CAKv+Gu85brKkLPJLs_uk5F6fO=+hiej7KojLH8deDtzTeYbUqA@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: skcipher - Unmap pages after an external error
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 6 Sep 2019 at 18:19, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Sep 06, 2019 at 05:52:56PM -0700, Ard Biesheuvel wrote:
> >
> > With this change, we still copy out the output in the
> > SKCIPHER_WALK_COPY or SKCIPHER_WALK_SLOW cases. I'd expect the failure
> > case to only do the kunmap()s, but otherwise not make any changes that
> > are visible to the caller.
>
> I don't think it matters.  After all, for the fast/common path
> whatever changes that have been made will be visible to the caller.
> I don't see the point in making the slow-path different in this
> respect.  It also makes no sense to optimise specifically for the
> uncommon error case on the slow-path.
>

The point is that doing

skcipher_walk_virt(&walk, ...);
skcipher_walk_done(&walk, -EFOO);

may clobber your data if you are executing in place (unless I am
missing something)

If skcipher_walk_done() is called with an error, it should really just
clean up after it self, but not copy back the unknown contents of
temporary buffers.
