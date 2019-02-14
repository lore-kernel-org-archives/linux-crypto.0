Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9D7C4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83AC2229F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XZhKh0rP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388618AbfBNIeE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:34:04 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:40795 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394645AbfBNIeD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:34:03 -0500
Received: by mail-it1-f193.google.com with SMTP id i2so12465242ite.5
        for <linux-crypto@vger.kernel.org>; Thu, 14 Feb 2019 00:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=olP5ehMgjoCJuZBI0KU4H0QmqOHmgde4rltSpZXovXk=;
        b=XZhKh0rPKZxKS0GzbPT/5Z4mMviqn93/3C8+tCyxcUSAqdnkJsEnpu4QjAeC9K6i0x
         kC0fYwif7dMSIDZAnEDJ6hOQDngUEbXmw/AEU66fA4OFDqOG8MFnMb448S8/xEB2rqaa
         io8YmG/8r5QQ2O6uO/PwEj86lAzS++Zk/wjcfsqQdlZZF381j6kgFZKRkf+AaWgCUN8R
         CmYZRv7WjqcfmU2EMXfkm2hKwmbO6X7Zni1RS3+vMuGjzNCamDzMQ9TaeCypj+ZZjWq3
         sDDMHJl1YUDStiEQvyQy0kSVzPfw07l/ClLn7UE3oVj61CWch7DkzuPgM8xQXHdYv0Pq
         iNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=olP5ehMgjoCJuZBI0KU4H0QmqOHmgde4rltSpZXovXk=;
        b=OEx5MH+25O/vuURfpPpVpLVwR+qgIRHv9dBLN+8DFn1Bz82lNe5PkpmZFkF6ccNEOt
         lqXjg2tX+KyM0VeSQjpN2iT2ua0WN72Wr1QP64KD9hBu56WYtGH4NVVsUUhxl47XSP3h
         93aDGfmkBh3o/oYCG2lMDqGmshzSyrDJgxt9QZQKo5vtaEt8BfBM9IcHdZGqp0rgEj2O
         KFgID5Bvu6xUUTW0bgnqxMixPMbfBplsSc3oRS+IH63VXxPZuR/4rWq729Dwv4fwBhc5
         bo3HkMM9Ga17fgACnkpHqaXnyit7afzOXfaS88dNEhDcHnCxeHvnqSGa3pt7pszl91a8
         UVZg==
X-Gm-Message-State: AHQUAubfxE8yhiEt9sc+qHcX6CKbnpFT5Jd/adf4NEiIVm7i4YlHZ0hZ
        pYxa/MFDc7pBQWKcy+hMVafMihy9Y1vImlvMxeUcaA==
X-Google-Smtp-Source: AHgI3IYdwBGSZR2uBLSsqjO/8AJ3adw3Gf+ord08MS7rYQsXvFeJfbNnyCVSXWoTFfAzeVCobr0F7oTuNezP47G4hjM=
X-Received: by 2002:a24:710:: with SMTP id f16mr1164843itf.121.1550133243023;
 Thu, 14 Feb 2019 00:34:03 -0800 (PST)
MIME-Version: 1.0
References: <20190214080355.8112-1-ebiggers@kernel.org> <20190214080355.8112-6-ebiggers@kernel.org>
 <CAKv+Gu9J_PKP0MfScA+RTV3m7FPyVwD713fBeTjn9cA8sWSVAw@mail.gmail.com> <20190214082827.GB29560@sol.localdomain>
In-Reply-To: <20190214082827.GB29560@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 14 Feb 2019 09:33:51 +0100
Message-ID: <CAKv+Gu_EuPpXvt0xLrA7H1fwWifCifpgaMDiZ_jvA0VT_7H21w@mail.gmail.com>
Subject: Re: [PATCH 5/6] crypto: arm64/aes-blk - update IV after partial final
 CTR block
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 Feb 2019 at 09:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Feb 14, 2019 at 09:14:13AM +0100, Ard Biesheuvel wrote:
> > On Thu, 14 Feb 2019 at 09:04, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Make the arm64 ctr-aes-neon and ctr-aes-ce algorithms update the IV
> > > buffer to contain the next counter after processing a partial final
> > > block, rather than leave it as the last counter.  This makes these
> > > algorithms pass the updated AES-CTR tests.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >
> > I take it this means we return an output IV even if the algorithm
> > could never proceed in a meaningful way, given that we throw away some
> > keystream bits that would be needed in that case.
> >
> > That means this change is strictly there to make the test framework
> > happy, even for cases that can never appear in reality.
> >
> > Wouldn't it be better not to set out_iv for input buffers whose size
> > is not a multiple of the block size?
> >
>
> See the explanation in patch 4 for why the tests test for this.  It's not a
> super strong argument but this seems like the best thing to do.
>

Fair enough.

Do you have a branch with this stuff that I can drop into kernelci
again? Preferably one that already has the tests enabled by default,
and panics on failure.
