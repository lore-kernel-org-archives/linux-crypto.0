Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB68C282C8
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 09:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7983E21736
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 09:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="fr7YbwxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfA1Jrr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:47:47 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:52761 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfA1Jrq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 04:47:46 -0500
Received: by mail-it1-f194.google.com with SMTP id d11so19661899itf.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Jan 2019 01:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gz6fwVIRsxJfsOehR9yV1xWPf5L1hiXx7mCwXlUn5aw=;
        b=fr7YbwxA+p9V02m6/1Xp9iCDXa/wrxnxGPmnmIkaeHzsJizMK8LEoFp0H73ZNED6TD
         m5VkVC2XZn5XyDK4THCwcSkVVxVmrzJjtZw5+rZbmYbk3z3ev9kG44jmB5cP/j8+K1zq
         tBI4yiKBQJ/ROZXZnoQ7vMJLagzcbOebr0gRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gz6fwVIRsxJfsOehR9yV1xWPf5L1hiXx7mCwXlUn5aw=;
        b=KbcfkzMpqYuEFActe+AyZArga9vH3aOYys9aXjvVi9kqa7QJ9k7R8JGKx/MAO/R8Mj
         R3DG9EtzYF5K6wGPLsH0w3my0ZNe5v5Rv+Cy37oJD8B93woE5sTFI1PhkJ5z48fSq54O
         tBEQR6FcHInCgnf0E86mNPnemMy2NcfvDDpkfD7RHoNO47nt7pJ/jyAykZXYbXbG7Uz9
         iLFZKlzucScmAiws2nFC5b8f0gW5NexAsv8hvXg0aLPznUd/k8VxJ3ha31YIVxhq0p0s
         7bjAC8qHStiokJGw3My6v3ID2TOZZh17RPEiUBxUiam0LLLvO2VBSaAlnOcf7S4tttFY
         ydvw==
X-Gm-Message-State: AJcUukfX4N+LRNm2pnx7mxgWM9eDU6sy3uhF9NEiYYqWuK6lGyzkUNl4
        KEAY/+PYX7G+uz8BwSR0HbMJU6M+A+n0+McfksZOJ4jeUjo=
X-Google-Smtp-Source: ALg8bN6R0t9GRKAkWYSI3Fkn0a0Hqexktd9d4flkWuliD5xlvycf6eT+r3gw/FrvyAFXwDj6y01PPtlj2b3yPYHIAFk=
X-Received: by 2002:a24:edc4:: with SMTP id r187mr10893163ith.158.1548668865574;
 Mon, 28 Jan 2019 01:47:45 -0800 (PST)
MIME-Version: 1.0
References: <20190128085045.6504-1-ebiggers@kernel.org>
In-Reply-To: <20190128085045.6504-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 28 Jan 2019 10:47:34 +0100
Message-ID: <CAKv+Gu_nbKYOvcUxruv00ZBkrCOb3eED-=xw=5nna8sBCuQg4Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: crct10dif assembly cleanup and optimizations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 28 Jan 2019 at 09:57, Eric Biggers <ebiggers@kernel.org> wrote:
>
> The x86, arm, and arm64 asm implementations of crct10dif are very
> difficult to understand partly because many of the comments, labels, and
> macros are named incorrectly: the lengths mentioned are usually off by a
> factor of two from the actual code.  Many other things are unnecessarily
> convoluted as well, e.g. there are many more fold constants than
> actually needed and some aren't fully reduced.
>
> This series therefore cleans up all these implementations to be much
> more maintainable.  I also made some small optimizations where I saw
> opportunities, resulting in slightly better performance.
>

Wonderful, thanks for doing this Eric.

When I ported the code from x86, I noticed that the comments were out
of sync with the code, but I wasn't aware of the other issues at all.

Assuming the new code passes your extended tests,

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

for the series, but with one minor nit for the ARM version: could we
please move the literal pool to .rodata as we did for the arm64
version?



> This is based on top of the pending patches from Ard Biesheuvel.
>
> Eric Biggers (3):
>   crypto: x86/crct10dif-pcl - cleanup and optimizations
>   crypto: arm/crct10dif-ce - cleanup and optimizations
>   crypto: arm64/crct10dif-ce - cleanup and optimizations
>
>  arch/arm/crypto/crct10dif-ce-core.S     | 546 +++++++--------
>  arch/arm/crypto/crct10dif-ce-glue.c     |   2 +-
>  arch/arm64/crypto/crct10dif-ce-core.S   | 496 +++++++-------
>  arch/arm64/crypto/crct10dif-ce-glue.c   |   4 +-
>  arch/x86/crypto/crct10dif-pcl-asm_64.S  | 848 +++++++++---------------
>  arch/x86/crypto/crct10dif-pclmul_glue.c |   3 +-
>  6 files changed, 794 insertions(+), 1105 deletions(-)
>
> --
> 2.20.1
>
