Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80722C43613
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 22:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4922085A
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 22:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zo1OClAy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfFSWoD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:44:03 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39825 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSWoD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 18:44:03 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so995714iod.6
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 15:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cqxlS8TUrayOrx9RbCCJk5wRQ9lf+ZHmU1Gk3w573sA=;
        b=Zo1OClAyhkahly1M3GDgTSgP8bluNQ3KeJKArO+j5QmLCtuO3iq7To5FgWOUm2TQ7H
         vnxsuXXb9FhJZEtz7mnlEpM7m6n1QPIJ428Tktag2AvEf3iFS9wxAIQwevEtXysPQXxr
         F17f2AZUvSmIuo5i/y/ioaQFG2wivHpLH4+EtPD22dBE/YkIIjVt+yMpQen2bEnocUab
         FlWffctvJ22Z82i77vdnmcRkbW14uOwLDAl5ZTFsiJ8BEqN+yEbdvCxmOTWd3BZzqbEx
         Gzixhlz8c1YWVEXGT1+zas646xkbxUlm93S+2MSNB91B0zxwF05m7IK3rQGMrVuJFdFS
         U0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cqxlS8TUrayOrx9RbCCJk5wRQ9lf+ZHmU1Gk3w573sA=;
        b=j5kQFKRs3H1hdv2Ekk7QSnJiUWhNm0xxvkQdKnbPn3uMjfoyEmXsQHQx6MinE3Gr9w
         kkDLgPjWttRL5gs6Z/VdLY4P9Xnrg7B09ycGMoNCaRIiDqvhaXOve6s380aX0aMhS/k6
         Pw/ndbkrJiv3Ao/sxvMmT31+1MQYyD53Ln8klxp4jyCJ8nX9RIfPSfz2ZTJRHg8ej2Gg
         YX70IoM6KaN4JSFsOJ92brDjHPtdl5REsTgRxP1RMWKn2U+scU4QcmIp6KgprL46CW3C
         HKXoRc16XrJiKx+01+5tg5NexHD3EZwlBnvc/eCjAKptdb9VUiuZJztq8NypqpMSRx+d
         enOA==
X-Gm-Message-State: APjAAAW9BMTH63PocLF+jy7lUILF765bq+R0fxNSLAF4hc4N+2hjjiW8
        VdqjIOte1y0Whb1m0hnh9xxtGfeqezeSNnTZuthPlQ==
X-Google-Smtp-Source: APXvYqw/sCUfskyBvggMUZjvIJpXali3ibXg+KltmWlgJQ0z55nAS0Yzei1eJqAONy0eZ2XuO0dBunkxkRJM9M2L9to=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr13301247iom.283.1560984242534;
 Wed, 19 Jun 2019 15:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-7-ard.biesheuvel@linaro.org> <20190619223710.GC33328@gmail.com>
In-Reply-To: <20190619223710.GC33328@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 00:43:50 +0200
Message-ID: <CAKv+Gu8_iPOA58xP+y-UvF7SPt86uYZZRb0Z9jEHo3d3Q6PhCg@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] crypto: arm64/aes - implement accelerated
 ESSIV/CBC mode
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Jun 2019 at 00:37, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jun 19, 2019 at 06:29:21PM +0200, Ard Biesheuvel wrote:
> > Add an accelerated version of the 'essiv(cbc(aes),aes,sha256)'
> > skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
> > This avoids a separate call into the AES cipher for every invocation.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> I'm not sure we should bother with this, since fscrypt normally uses AES-256-XTS
> for contents encryption.  AES-128-CBC-ESSIV support was only added because
> people wanted something that is fast on low-powered embedded devices with crypto
> accelerators such as CAAM or CESA that don't support XTS.
>
> In the case of Android, the CDD doesn't even allow AES-128-CBC-ESSIV with
> file-based encryption (fscrypt).  It's still the default for "full disk
> encryption" (which uses dm-crypt), but that's being deprecated.
>
> So maybe dm-crypt users will want this, but I don't think it's very useful for
> fscrypt.
>

If nobody cares, we can drop it. I don't feel too strongly about this,
and since it is on the mailinglist now, people will be able to find it
and ask for it to be merged if they have a convincing use case.
