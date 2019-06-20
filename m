Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4FFC43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 07:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E90D2084B
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 07:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lWtjdJMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfFTHaz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 03:30:55 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41853 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTHaz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 03:30:55 -0400
Received: by mail-io1-f65.google.com with SMTP id w25so41247ioc.8
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2019 00:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OleUuoLJ/awB8gj1L9pb8+s5gnreN1ERy+tmQ30S79M=;
        b=lWtjdJMbHtOsAdidtW99iwblOZlLS7lxCFi7XVqidfsGH7qb6gFm1x0hpVEwGvkQTE
         5tDjTsctDn3ekC/PM5dU94f+GluSKlyWpw+2tFfWXPsqt7+tjWXTcX1dJw0lEVWkof4v
         q/DjDDZyP4UAIn9orVK4ykzsWhVqbI00cgiyENYTxVjzaJeh/SjuDVp+NSVMXVfZABb/
         J5AyKD6eEt8PVPDQvaaSAHU0DW2LxSyrANM513LYDUJb0UPwgnHhlps9GzQLPUxnrq8J
         pPFs15Q1UoAZ5/P0dWhYH4k8qRlnHusQLDrWanqHEeOdgW8c+Zmut7QSuLy7QFAn1rVE
         MwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OleUuoLJ/awB8gj1L9pb8+s5gnreN1ERy+tmQ30S79M=;
        b=HgBytyTSQtUnhtGNcd/pNLxvDQ46fYXPL1i6sqjfFmkbmkWqtgqBT6YxrYLQZeMpfE
         p3Mtwwqn59g6dqjPyEmhoBDkxIIxgPWKlVw/K6p8zhQ6MmalOH5GxRwMZB773y/SyHih
         4YBt2ZijuKMNi9eM7oVqDk9DbUIkTzbXA4wm7jGEsJH6LvH1wiZ1XbR78nZf9MNjSQNg
         k6hzn12855it4LNzz5vwckVUk6mvp9zzFGkbjIKRm66tbyPgtfjSlNGX57IIh2O+vB+C
         36KEIZHJXLRvjtXBQB2LScR77ZFRaRroPGKMWMto4e5fTX6E4zGb7/Y2WX9Pw/aZB5Dg
         J84g==
X-Gm-Message-State: APjAAAVi8ONsz/kE0xIFv0/Y2yaRWaZCt1oyj9nw6g3OVV4ibGu3//+r
        85Vvju3zxS70WeerYtDwBMsDQGugww4roG9g16l8Q7n3
X-Google-Smtp-Source: APXvYqwSgQ+YlxCnDlNipKA4pfu+5Hf7BLz6A0G9Uf+9NCduJO3GV2r4HpYMlxNkkXOApFqe/S3lx05NWq74F7JQWKE=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr28401891iob.49.1561015854360;
 Thu, 20 Jun 2019 00:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
In-Reply-To: <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 09:30:41 +0200
Message-ID: <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Jun 2019 at 03:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jun 19, 2019 at 06:04:17PM -0700, Eric Biggers wrote:
> >
> > > +#define ESSIV_IV_SIZE              sizeof(u64)     // IV size of the outer algo
> > > +#define MAX_INNER_IV_SIZE  16              // max IV size of inner algo
> >
> > Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
> > the same as the inner algorithm's?
>
> In general we allow outer algorithms to have distinct IV sizes
> compared to the inner algorithm.  For example, rfc4106 has a
> different IV size compared to gcm.
>
> In this case, the outer IV size is the block number so that's
> presumably why 64 bits is sufficient.  Do you forsee a case where
> we need 128-bit block numbers?
>

Indeed, the whole point of this template is that it turns a 64-bit
sector number into a n-bit IV, where n equals the block size of the
essiv cipher, and its min/max keysize covers the digest size of the
shash.

I don't think it makes sense to generalize this further, and if I
understand the feedback from Herbert and Gilad correctly, it would
even be better to define the input IV as a LE 64-bit counter
explicitly, so we can auto increment it between sectors.

But that leaves the question how to convey the sector size to the
template. Gilad suggests

essiv(cbc(aes),aes,sha256,xxx)

where xxx is the sector size, and incoming requests whose cryptlen is
an exact multiple of the sector size will have their LE counter auto
incremented between sectors. Note that we could make it optional for
now, and default to 4k, but I will at least have to parse the argument
if it is present and reject values != 4096

Is this the right approach? Or are there better ways to convey this
information when instantiating the template?
Also, it seems to me that the dm-crypt and fscrypt layers would
require major surgery in order to take advantage of this.
