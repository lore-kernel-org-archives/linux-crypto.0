Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4698EC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19E712067D
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594284684;
	bh=iOQWTCgIGURnZ4pFe02nC8Sn658NBNaRKoP7uXDodPI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XR2f0Z8KaTws3cWzbY9iZThOSadnvYjchRQx46X1TJLVrCdBiz+/PzVrFWjEs0zxy
	 DTQFmQi+rUDPxqoTu2jQJCkJuo1naVe3vqhuzeyLpfITRpGOH25hV9Vui3RrR9Juch
	 s8NuQ4pjT3GNNHMEnEdK9z3x+AvOk1BFRbPrg5XE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGIIvX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgGIIvX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 04:51:23 -0400
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BBB2067D
        for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2020 08:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594284682;
        bh=iOQWTCgIGURnZ4pFe02nC8Sn658NBNaRKoP7uXDodPI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aujcqdQC5TrZN0/ICl5aTL0HX8dGjW6mT+1opqhdjKXGuUtClAaCYMHtnHUrvnfP5
         4PJo/kf/3geBZOySwGy97AZqMUpqHoq8cEQXvFO95SK/eY9QRB/gi8giYZq9c2/7/v
         xwbNRS53HLQXSMhjV8dlvQt3wtAfv8yLpvHDFsFM=
Received: by mail-ot1-f44.google.com with SMTP id c25so1170243otf.7
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2020 01:51:22 -0700 (PDT)
X-Gm-Message-State: AOAM530ynateq4vqFWsmei7j/iYKzUBJAdiSq7Gw7AArG1Jlo3nzbvVQ
        84Ktq3jZapkNqsW2GyNUa3QIJtZH61m4bTb7vfA=
X-Google-Smtp-Source: ABdhPJwE1tsrIzjnVl3zLY+YOFcyr8Hg8pW6XJ36CrTJiqVGfuHwTs5Sp5eUNTWr4y/njShSsaGSF+GkQE2GvwPP0Cs=
X-Received: by 2002:a9d:6e85:: with SMTP id a5mr12208065otr.90.1594284681780;
 Thu, 09 Jul 2020 01:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200629073925.127538-1-ardb@kernel.org> <20200629073925.127538-6-ardb@kernel.org>
 <20200709082200.GA1892@gondor.apana.org.au>
In-Reply-To: <20200709082200.GA1892@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 9 Jul 2020 11:51:10 +0300
X-Gmail-Original-Message-ID: <CAMj1kXE8HELm1j3jx-+mHrK3OjG6Rjp4jtP_QEYorRBnRxA+=w@mail.gmail.com>
Message-ID: <CAMj1kXE8HELm1j3jx-+mHrK3OjG6Rjp4jtP_QEYorRBnRxA+=w@mail.gmail.com>
Subject: Re: [PATCH 5/5] crypto: arm/ghash - use variably sized key struct
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 9 Jul 2020 at 11:22, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 29, 2020 at 09:39:25AM +0200, Ard Biesheuvel wrote:
> > Of the two versions of GHASH that the ARM driver implements, only one
> > performs aggregation, and so the other one has no use for the powers
> > of H to be precomputed, or space to be allocated for them in the key
> > struct. So make the context size dependent on which version is being
> > selected, and while at it, use a static key to carry this decision,
> > and get rid of the function pointer.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm/crypto/ghash-ce-glue.c | 51 +++++++++-----------
> >  1 file changed, 24 insertions(+), 27 deletions(-)
>
> This introduces some new sparse warnings:
>
> ../arch/arm/crypto/ghash-ce-glue.c:67:65: warning: incorrect type in argument 4 (different modifiers)
> ../arch/arm/crypto/ghash-ce-glue.c:67:65:    expected unsigned long long const [usertype] ( *h )[2]
> ../arch/arm/crypto/ghash-ce-glue.c:67:65:    got unsigned long long [usertype] ( * )[2]
> ../arch/arm/crypto/ghash-ce-glue.c:69:64: warning: incorrect type in argument 4 (different modifiers)
> ../arch/arm/crypto/ghash-ce-glue.c:69:64:    expected unsigned long long const [usertype] ( *h )[2]
> ../arch/arm/crypto/ghash-ce-glue.c:69:64:    got unsigned long long [usertype] ( * )[2]
>


That looks like a sparse bug to me. Since when is it not allowed to
pass a non-const value as a const parameter?

I.e., you can pass a u64[] to a function that takes a u64 const *,
giving the caller the guarantee that their u64[] will not be modified
during the call, even if it is passed by reference.

Here, we are dealing with u64[][2], but the same reasoning holds. A
const u64[][2] formal parameter (or u64 const (*)[2] which comes down
to the same thing) does not require a const argument, it only tells
the caller that the array will be left untouched. This is why the
compiler is perfectly happy with this arrangement.
