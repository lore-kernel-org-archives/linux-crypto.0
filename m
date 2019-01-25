Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10BAC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 924832084C
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 07:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gy4EduS+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfAYHr0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:47:26 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:36346 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfAYHrZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 02:47:25 -0500
Received: by mail-it1-f196.google.com with SMTP id c9so8495772itj.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 23:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=827bJ9grBu+EsiRKUjoQKgKeidmYCRcE7C7Uuj9QU6w=;
        b=gy4EduS+JK6o+4UZiT1BCAUy32/117KLGdyixIXIH9jjJyAuS2mfIdQVsM91CvFoPr
         roq6J2SpqkJojdf4cJMzIQ+7YUfls/5pbt5btINjjQ6kUqbsKb8lcB29rk2tY81b71MJ
         qJqZtyzz92xzEHFImaj+5wsDZoAcxs9yyiefU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=827bJ9grBu+EsiRKUjoQKgKeidmYCRcE7C7Uuj9QU6w=;
        b=keW5yezix3FER/OMIV+DN0LQG0DyxMUoYsA+wbzfwu/ybFFO2oS2rI/MNyQvP66j9a
         6kYSVFV9jG/BqaBQIWgtLed5u8ktj7mXrWAfoSzG9oxxJm9ECTfHAq0aL+VGdNQW2wfI
         vA07iAIvOM0fVJzG/74tTEQJxvPpmapouq4SUeJOKlv4b1zc5byjHaOPh1K28VcVB3c4
         tAbIMRtEvb3zpqZLMK5Z7jLseq2CCv0RRncc8yxEMkzQRuUHOd1cOMWOEuBCIMKHTTlD
         ltBEedBNHGN09v0v/rx/DE2Eb3OGlyseCI/XQuQq0q2GoGRQ/QHYUr3PJaWBEbyfwrmS
         aMMQ==
X-Gm-Message-State: AJcUukfsiwEbrcLY2eY3WUwVBd6FSa9rjjB8mCGRvCPzJLtkGgweQymY
        vl123zejhdBq7y+BaPf99aMvXrRuAOuCpjPl18q/VOK4ldg=
X-Google-Smtp-Source: ALg8bN4EdwFL7VaKCHIyBx+hDCYyIL+bFqiBbfYHOlk42e1YZ4XR8JxUOy+Drj7H7gyymB1x8TJ3R5cp/IzmnJXWy3o=
X-Received: by 2002:a02:4c9:: with SMTP id 192mr6279740jab.2.1548402444764;
 Thu, 24 Jan 2019 23:47:24 -0800 (PST)
MIME-Version: 1.0
References: <20190124163347.12653-1-ard.biesheuvel@linaro.org> <20190125064217.GA700@sol.localdomain>
In-Reply-To: <20190125064217.GA700@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Jan 2019 08:47:13 +0100
Message-ID: <CAKv+Gu_n5K80Dg5i7xMAEwnyhuXAaBaBW8WJMDnmN63mgTPZkQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: arm64/aes-ccm - various bug fixes
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Jan 2019 at 07:42, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 24, 2019 at 05:33:44PM +0100, Ard Biesheuvel wrote:
> > Fix a couple of bugs found by Eric's new testing code, and another
> > issue found by inspection.
> >
> > Ard Biesheuvel (3):
> >   crypto: arm64/aes-ccm - fix logical bug in AAD MAC handling
> >   crypto: arm64/aes-ccm - fix bugs in non-NEON fallback routine
> >   crypto: arm64/aes-ccm - don't use an atomic walk needlessly
> >
> >  arch/arm64/crypto/aes-ce-ccm-core.S | 5 +++--
> >  arch/arm64/crypto/aes-ce-ccm-glue.c | 8 +++-----
> >  2 files changed, 6 insertions(+), 7 deletions(-)
> >
>
> Thanks Ard.  For all three patches:
>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
>
> However, can you add Cc stable to the first two?
>
> BTW: I notice the !may_use_simd() case is still not covered by the self-tests.
> Do you happen to have any suggestion for how to do it?  If there is a way to
> make may_use_simd() temporarily return false, I can easily put a flag in 'struct
> testvec_config' that makes the self-tests sometimes use that context to execute
> the actual encryption/decryption/hashing.
>
> It looks like on arm64, wrapping the operation in local_irq_{disable,enable}()
> or kernel_fpu_{begin,end}() would be sufficient?  But x86 it doesn't look as
> easy as x86 needs a context where 'in_interrupt() && !interrupted_user_mode() &&
> !interrupted_kernel_fpu_idle()'.  Likewise arm32 requires 'in_interrupt()'.
>
> It would be worth doing just for arm64, but ideally it would work on most/all
> architectures.
>

I think the best way to address this is to [conditionally] wrap
may_use_simd() into something cryptoapi specific, which is under the
control of the test framework.
