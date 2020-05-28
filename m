Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65C5C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 08:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F91F2075F
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 08:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590654819;
	bh=b+hkukDcY3wWk9NH35StsAnbduxjzZHjk4n+pej6zbw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XaSjIHr2MaXUcoqD7bE5oL0HTs/4zKHHTguBowwF2i6553h0ez7s0VNb+M+YOf1t2
	 xM+6cY2anpOVnmNptIX2GC++sMn6+AfDfakhh31n7d1c0VtVPmNqQeVHwoJbk7zWBr
	 wGLzxSaCiOYkVSbPTjYHrdJLzN9BxdXbXXRmwINw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgE1Idj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 04:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgE1Idi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 04:33:38 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28283214D8
        for <linux-crypto@vger.kernel.org>; Thu, 28 May 2020 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590654818;
        bh=b+hkukDcY3wWk9NH35StsAnbduxjzZHjk4n+pej6zbw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ooTtB7P0P8pvXKcchknaERtrB/rOTvzL+V3/9OiT64bwj+j6gv3LIwiq4JOvQbirh
         pimVtgY7fSc1uF/FFb0Z73Zr/oBmvlaFgquHMy22BP1YUTXmzBuSglFcddntvgWUwG
         aQWG1Whi+k9Lzn9hO+6sjKldmhBNPhrq4w68R7bk=
Received: by mail-il1-f179.google.com with SMTP id a14so26796246ilk.2
        for <linux-crypto@vger.kernel.org>; Thu, 28 May 2020 01:33:37 -0700 (PDT)
X-Gm-Message-State: AOAM530aNOrTRpYNcB7Pa1kYCtr/NtmPLJr/p5ILeO83LYAJCVs9ozTv
        hvUSGQqfyvhLef395evVyoYwa/nd3XUYft0vI3o=
X-Google-Smtp-Source: ABdhPJzawasqG9FnG8TXHOfTl5s51OwBCi0grn7gov6n541LBI049v30JprQgzKLv5HeW1opilBExT5IteQrvMbadoo=
X-Received: by 2002:a92:bb55:: with SMTP id w82mr1838867ili.211.1590654816584;
 Thu, 28 May 2020 01:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <20200528073349.GA32566@gondor.apana.org.au>
In-Reply-To: <20200528073349.GA32566@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 28 May 2020 10:33:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
Message-ID: <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 28 May 2020 at 09:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> wrote:
> > Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> > from the generic implementation in what it returns as the output IV. So
> > fix this, and add some test vectors to catch other non-compliant
> > implementations.
> >
> > Stephan, could you provide a reference for the NIST validation tool and
> > how it flags this behaviour as non-compliant? Thanks.
>
> I think our CTS and XTS are both broken with respect to af_alg.
>
> The reason we use output IVs in general is to support chaining
> which is required by algif_skcipher to break up large requests
> into smaller ones.
>
> For CTS and XTS that simply doesn't work.  So we should fix this
> by changing algif_skcipher to not do chaining (and hence drop
> support for large requests like algif_aead) for algorithms like
> CTS/XTS.
>

The reason we return output IVs for CBC is because our generic
implementation of CTS can wrap any CBC implementation, and relies on
this output IV rather than grabbing it from the ciphertext directly
(which may be tricky and is best left up to the CBC code)

For CTS itself, as well as XTS, returning an output IV is meaningless,
given that
a) the implementations rely on the skcipher_walk infrastructure to
present all input except the last bit in chunks that are a multiple of
the block size,
b) neither specification defines how chaining of inputs should work,
regardless of whether the preceding input was a multiple of the block
size or not.

The CS3 mode that we implement for CTS swaps the final two blocks
unconditionally. So even if the input is a whole multiple of the block
size, the preceding ciphertext will turn out differently if any output
happens to follow.

For XTS, the IV is encrypted before processing the first block, so
even if you do return an output IV, the subsequent invocations of the
skcipher need to omit the encryption, which we don't implement
currently.

So if you are saying that we should never split up algif_skcipher
requests into multiple calls into the underlying skcipher, then I
agree with you. Even if the generic CTS seems to work more or less as
expected by, e.g., the NIST validation tool, this is unspecified
behavior, and definitely broken in various other places.
