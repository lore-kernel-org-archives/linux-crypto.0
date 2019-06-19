Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73381C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49211206E0
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 12:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T2L1mRC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731784AbfFSMhK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:37:10 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37809 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731739AbfFSMhK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 08:37:10 -0400
Received: by mail-io1-f65.google.com with SMTP id e5so37821878iok.4
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 05:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgVxtVWZcVB028eaS05O6WDA2Si5Lt8jvgQG053v8G0=;
        b=T2L1mRC5K4CgcLXaSNPvZIX4o9VmWKKxbydy9xutoy2tJr618gUSuibD1lrMnlqLih
         70gXC/IinKSNu6f2LS36r6nve2/1yghvKjMEu3I4Bhn4N8LLv3DlAMah7xHbt1JFusGd
         Dtx2ZW+V7qLsconPkoImg3LaW/dWdJHA123HYc7b0L7Of6Li4eDix1gph6QeBNfZJRBX
         1eJBxmKSgxwaltZrC0VxK92+Uryd0dP6SxmG59cOBtCbeuX4HtR7LAwVr7pU9WmE+DSv
         5aylDkjRcmPOuLBnBlDGQPIKATsG2/HiyilgZj1bR/VFD214fChwwxALm4in9qFQju05
         UkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgVxtVWZcVB028eaS05O6WDA2Si5Lt8jvgQG053v8G0=;
        b=bUlZBDgq8A0fPMu+jxEq54vy6QWLSIQt1pRYT1OWyg38u0M8S4kppRFUB4y/7k4O5Z
         BnczPVp8fQDOkOFX1lW0eXeNHaPru2FQFXB+N5LdCfTrVOryt7ttUzPcHFlIe6RrcXKV
         Y2ofMURxdfhUgDufy2iS1aPiS1HwHLButkUTnGFdSU5bHXCj6H8fxcjwsqNAmdPs52CF
         5fMuOGYXFehFr94MSvGOICLnLwdR1rkSziukfW5NhIvpPz3X/W/EKwGwkzLeYQmqwgSg
         GaJiMg6WQcg9ZjjZkbaguPVkaYgTKaM0FLGyBDYHyi0Re4U9qsm5LuZub8dv4IPB2RIk
         pMBQ==
X-Gm-Message-State: APjAAAXyyRW9aNmjJZWq3dkWUqJvVOdf6BO+bmEZj12KNh/xVbLqKS/u
        zA6shVII8AgMsbSObqa1cXBuxGeA+YLWv6YFrNn7pg==
X-Google-Smtp-Source: APXvYqxMxKkPcl/yA9aguHRLzAnHjH3llgRx2DCNZ9zjDa/sKgKiBIZ7WxIzikao9ypX0z7ouAc5ukdn7ykrPxBiZ2U=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr10302944jar.2.1560947829635;
 Wed, 19 Jun 2019 05:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
 <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com> <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
 <CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
 <f5de99dd-0b6a-9f7e-46b7-cd3c5ed3100e@gmail.com> <CAKv+Gu9NW2H-TDd66quKSUMpEWGwqEjN-vmf_zueo1tEJLa-xg@mail.gmail.com>
 <b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com>
In-Reply-To: <b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 14:36:57 +0200
Message-ID: <CAKv+Gu91RHpwE6XzdFYcsN77DRJ-4OsFRjxNAyKk92Q3q6dCYw@mail.gmail.com>
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

On Wed, 19 Jun 2019 at 13:33, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 19/06/2019 13:16, Ard Biesheuvel wrote:
> >> Try
> >>   cryptsetup open --type plain -c null /dev/sdd test -q
> >> or
> >>   dmsetup create test --table " 0 417792 crypt cipher_null-ecb - 0 /dev/sdd 0"
> >>
> >> (or just run full cryptsetup testsuite)
> >>
> >
> > Is that your mode-test script?
> >
> > I saw some errors about the null cipher, but tbh, it looked completely
> > unrelated to me, so i skipped those for the moment. But now, it looks
> > like it is related after all.
>
> This was triggered by align-test, mode-test fails the same though.
>
> It is definitely related, I think you just changed the mode parsing in dm-crypt.
> (cipher null contains only one dash I guess).
>

On my unpatched 4.19 kernel, mode-test gives me

$ sudo ./mode-test
aes                            PLAIN:[table OK][status OK]
LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-plain                      PLAIN:[table OK][status OK]
LUKS1:[table OK][status OK] CHECKSUM:[OK]
null                           PLAIN:[table OK][status OK]
LUKS1:[table OK][status OK] CHECKSUM:[OK]
cipher_null                    PLAIN:[table FAIL]
 Expecting cipher_null-ecb got cipher_null-cbc-plain.
FAILED at line 64 ./mode-test

which is why I commented out those tests in the first place.

I can reproduce the crash after I re-enable them again, so I will need
to look into that. But something seems to be broken already.
Note that this is running on arm64 using a kconfig based on the Debian kernel.
