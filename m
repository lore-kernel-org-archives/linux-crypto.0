Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD46AC31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 13:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B61222166E
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 13:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RgUtRygR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfFSNN1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 09:13:27 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41773 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730289AbfFSNN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 09:13:26 -0400
Received: by mail-io1-f66.google.com with SMTP id w25so37920872ioc.8
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 06:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSWvIHqoIGtDBhRJ6HSvvihcZCQQtqciIVVRqtR6+BA=;
        b=RgUtRygRSD2cNeIMgRGdHzRGhna+FOMtEp0dVmSrLw6CirMvKMu8x9fYR4mMrl8wkN
         Qp7rlV9j5497pjDNd/A0NjfrooPJbpw6GjSs45K7m4Js73642UaWS7ghFLMAPT/Sm5D9
         G1FvS6H2OJQyeoKCl3+Q+C/JQn/UIrp3JoQIu9MXrBA5Per0q0SbUYoDTn9t+C4kqeSR
         8MI/gF7tuNmtJiM4FY5p8/5f8bMAgDfftBpt0dbsMH3o5eUhuyfdeaNixXfVuFb0HpVQ
         f7mJzJzJ/9V/VvE6XzZmFpioBvsIk4thwXXCjOp0ZfuRvl8t1dFNfEjOEDbDe3sjxNAH
         KK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSWvIHqoIGtDBhRJ6HSvvihcZCQQtqciIVVRqtR6+BA=;
        b=PB0ba8u/GcDq8jLP2AIjRxaEwPbHq03XW0Fb8OEUNzYwG1+6zb+mK65Sm51sZzbO1N
         r2m9RwAI/kk8oc2+pTLTP7hC7ZlHKXnIx0rRt41PwN29tnpjW/txDoqSRXMlXlI6EeY9
         kmHEt7BCNMNjTCtXtoLUONWwGOCR/RcCL4QUtEYopYWdgQqg8HPQgvX8oduiUPq24yuj
         ZNwCRJzfKeVX5nm+1gvKLV1BgjHVP8W0qGzgzJBAJwIw3/njC/AAnEkN3SIje36DFngG
         SQtfuTJ+Cv/Rq7o3E2urYXfAx1MVQwRjVB2wT9l4XgNr1dITutKnYHoQf5+Vl6bDwtfe
         lWpg==
X-Gm-Message-State: APjAAAWz6QbgQDEYBia2SuK0Sq/XwzVjtWWnJ/726utwXiN+OQLaPXtO
        0i9mHF81O6XVvqj8dn5pyVt0PBwStu8PMNhimvcVDw==
X-Google-Smtp-Source: APXvYqz+pOItGZbGiNHRhqyz++922QvC8MssSGlz2NJpvXErZ5LXO1kqo3KJpbBQwUzbiKLnVgNVJKyCVfnMVF+5k+c=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr10491946jar.2.1560950006153;
 Wed, 19 Jun 2019 06:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com> <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
 <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
 <f5de99dd-0b6a-9f7e-46b7-cd3c5ed3100e@gmail.com> <CAKv+Gu9NW2H-TDd66quKSUMpEWGwqEjN-vmf_zueo1tEJLa-xg@mail.gmail.com>
 <b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com> <CAKv+Gu91RHpwE6XzdFYcsN77DRJ-4OsFRjxNAyKk92Q3q6dCYw@mail.gmail.com>
 <CAKv+Gu_XFbB9TTjMO+=QmZ40H1LV5DB57-zeUEb9dN3yNyia=w@mail.gmail.com>
In-Reply-To: <CAKv+Gu_XFbB9TTjMO+=QmZ40H1LV5DB57-zeUEb9dN3yNyia=w@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 15:13:15 +0200
Message-ID: <CAKv+Gu8bkTbEL+BAk4OoNpaPyJFvnOQS7pgdQj7By+F2MbdO7w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Jun 2019 at 14:49, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 19 Jun 2019 at 14:36, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Wed, 19 Jun 2019 at 13:33, Milan Broz <gmazyland@gmail.com> wrote:
> > >
> > > On 19/06/2019 13:16, Ard Biesheuvel wrote:
> > > >> Try
> > > >>   cryptsetup open --type plain -c null /dev/sdd test -q
> > > >> or
> > > >>   dmsetup create test --table " 0 417792 crypt cipher_null-ecb - 0 /dev/sdd 0"
> > > >>
> > > >> (or just run full cryptsetup testsuite)
> > > >>
> > > >
> > > > Is that your mode-test script?
> > > >
> > > > I saw some errors about the null cipher, but tbh, it looked completely
> > > > unrelated to me, so i skipped those for the moment. But now, it looks
> > > > like it is related after all.
> > >
> > > This was triggered by align-test, mode-test fails the same though.
> > >
> > > It is definitely related, I think you just changed the mode parsing in dm-crypt.
> > > (cipher null contains only one dash I guess).
> > >
> >
> > On my unpatched 4.19 kernel, mode-test gives me
> >
> > $ sudo ./mode-test
> > aes                            PLAIN:[table OK][status OK]
> > LUKS1:[table OK][status OK] CHECKSUM:[OK]
> > aes-plain                      PLAIN:[table OK][status OK]
> > LUKS1:[table OK][status OK] CHECKSUM:[OK]
> > null                           PLAIN:[table OK][status OK]
> > LUKS1:[table OK][status OK] CHECKSUM:[OK]
> > cipher_null                    PLAIN:[table FAIL]
> >  Expecting cipher_null-ecb got cipher_null-cbc-plain.
> > FAILED at line 64 ./mode-test
> >
> > which is why I commented out those tests in the first place.
> >
> > I can reproduce the crash after I re-enable them again, so I will need
> > to look into that. But something seems to be broken already.
> > Note that this is running on arm64 using a kconfig based on the Debian kernel.
>
> Actually, could this be an issue with cryptsetup being out of date? On
> another arm64 system with a more recent distro, it works fine

This should fix the crash you are seeing

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 89efd7d249fd..12d28880ec34 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2357,7 +2357,7 @@ static int crypt_ctr_cipher_old(struct dm_target
*ti, char *cipher_in, char *key
        if (!cipher_api)
                goto bad_mem;

-       if (!strcmp(*ivmode, "essiv")) {
+       if (*ivmode && !strcmp(*ivmode, "essiv")) {
                if (!*ivopts) {
                        ti->error = "Digest algorithm missing for ESSIV mode";
                        return -EINVAL;

Apologies for the sloppiness - this is a check that I had added and
then removed again, given that *ivmode was assigned unconditionally,
but i didn't realize tmp could be NULL.

With these two changes applied, mode-test successfully runs to completion.

Can you recommend another test suite I could run?
