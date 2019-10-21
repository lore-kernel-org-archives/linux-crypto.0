Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8251CA9EB7
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDC5820B7C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 12:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GSW+qV15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbfJUMEn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:04:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50783 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbfJUMEn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 08:04:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id q13so2979596wmj.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 05:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EsyQ2kF/mtSmOiYow1hBVM0o2JCVCNC1wVtT4i3e0fY=;
        b=GSW+qV15BGuUa1cfsLydezIkY+Lb/vWqLV90vOzXas25hDy+kIF+Ans2UAoCV6OYq6
         K/toNM8GPvn/01PeQAYbMbHA+Fxymww1CRMHIz4S+3EnOShWNbLrZT2714U9NmyqakEz
         lkt36cbm9MxX32+dGW51Utktt3AW1mU6mheveM0Soykj/joLfjKWigvSWJ1NsLPcsd0B
         9OYtNeiL3+LfulnMLUPB7hAjpcdpwdBw9dOmEY3PdZez5JbpqcxT9eb96Uyr/67aU7jc
         +90CkCdlZ1ANaDi1gyjPwVoqeULjedv3UfZ0NFdCIhuJEPP16XGpoE8gdnG7lSIjMxgI
         L6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EsyQ2kF/mtSmOiYow1hBVM0o2JCVCNC1wVtT4i3e0fY=;
        b=V/hHHEnSDYLWIO+SUzros7j5c5XOmBzss+EtSv5Q28Xdu51oJI1g5QZL+m09GyU141
         KfUP82pFeZmGSMDkLV6QX128/Lavzw1ajJPAr67Nu2jVAarpfb2JOEIseIZa/EuZTuP6
         B4Ixy4gX6EXhmdoK+Dl0rv3bajc84nN6cTkFF6F8ssSRkOJMH4sKddYKohmKpZr0Rh7M
         0vetKX7lpmM9EFl9/TavbchJ9DykI/6rRh8efHB4o4QeoVALoqUwn2UMmvPlCSx52MiP
         5hdKhHy6ZvuDd6C8Ru6JBPS+6JbdWer5HLRkzXP73/coIKj9ypJYdUbX8wUaDCC4IW0U
         Zdog==
X-Gm-Message-State: APjAAAV6cw/WR2xbvc1iXIvusJnqSz/CfraYwX17f6wLquxXAUjbFoki
        HtR5pwgNW6SLWC1EQvXs8d0DvQw8w0C+aTuIyH8+2AbnFdE=
X-Google-Smtp-Source: APXvYqxtzK5nSIkzx9itC5JD0mQqEEPKMa2VwaEF/qE7TkS5R8EI/021s5D+kHZuW4qrMsbxxIbFKVe0XKcPjoSxYBk=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr6181114wme.53.1571659481322;
 Mon, 21 Oct 2019 05:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571043883.git.dsterba@suse.com> <a4e3e9db53b01c4092309a75e5b5d703ed344c5a.1571043883.git.dsterba@suse.com>
 <CAKv+Gu8m+CkrWj6fZi4XtEbpcDTM=d8HNS=9A5piJD8v41B-HQ@mail.gmail.com> <20191018130036.GC3001@twin.jikos.cz>
In-Reply-To: <20191018130036.GC3001@twin.jikos.cz>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 21 Oct 2019 14:04:35 +0200
Message-ID: <CAKv+Gu_-oYv9P-abTdtqWX6pR5SWm7mNsTw4WhP=OJDO+1FsQw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] crypto: add test vectors for blake2b
To:     David Sterba <dsterba@suse.cz>
Cc:     David Sterba <dsterba@suse.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Oct 2019 at 15:00, David Sterba <dsterba@suse.cz> wrote:
>
> On Thu, Oct 17, 2019 at 12:22:57PM +0200, Ard Biesheuvel wrote:
> > On Mon, 14 Oct 2019 at 11:17, David Sterba <dsterba@suse.com> wrote:
> > >
> > > Test vectors for blake2b with various digest sizes. As the algorithm is
> > > the same up to the digest calculation, the key and input data length is
> > > distributed in a way that tests all combinanions of the two over the
> > > digest sizes.
> > >
> > > Based on the suggestion from Eric, the following input sizes are tested
> > > [0, 1, 7, 15, 64, 247, 256], where blake2b blocksize is 128, so the
> > > padded and the non-padded input buffers are tested.
> > >
> > >           blake2b-160  blake2b-256  blake2b-384  blake2b-512
> > >          ---------------------------------------------------
> > > len=0   | klen=0       klen=1       klen=32      klen=64
> > > len=1   | klen=32      klen=64      klen=0       klen=1
> > > len=7   | klen=64      klen=0       klen=1       klen=32
> > > len=15  | klen=1       klen=32      klen=64      klen=0
> > > len=64  | klen=0       klen=1       klen=32      klen=64
> > > len=247 | klen=32      klen=64      klen=0       klen=1
> > > len=256 | klen=64      klen=0       klen=1       klen=32
> > >
> >
> > I don't think your vectors match this table. It looks to me that you
> > used the first column for all of them?
>
> You're right, the script that generated each digest picked the key/len
> sequence from the beginning and I did not catch that, sorry.
>
> > > +               .plaintext =
> > > +                       "\x00\x01\x02\x03\x04\x05\x06\x07"
> > > +                       "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> > > +                       "\x10\x11\x12\x13\x14\x15\x16\x17"
> > > +                       "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
> > > +                       "\x20\x21\x22\x23\x24\x25\x26\x27"
> > > +                       "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
> > > +                       "\x30\x31\x32\x33\x34\x35\x36\x37"
> > > +                       "\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f",
> >
> > Given the number of occurrences of this sequence, I suggest we break
> > it out of this data structure, i.e.,
> >
> > static const char blake2s_ordered_sequence[256] = {
> >   ...
> > };
> >
> > and use
> >
> > .plaintext = blake2s_ordered_sequence
> >
> > here, and in all other places where the entire sequence or part of it
> > is being used.
> >
> > I'm adopting this approach for my Blake2s tests as well - I'll cc you
> > on those patches.
>
> That's a great simplification, I'll do the same then.

Excellent. If you cc me on the next revision, I'll do the big endian
tests I promised you.
