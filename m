Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9167BC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 20:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AAF1239FE
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 20:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgLQUIO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 15:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQUIN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 15:08:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76981C0617A7
        for <linux-crypto@vger.kernel.org>; Thu, 17 Dec 2020 12:07:33 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cw27so29916749edb.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Dec 2020 12:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOmQk0x3ccvRlceWbWP6GlZsmAYEOiZMR0Q/yyY99OQ=;
        b=bGdNtPX0MoCL7Rl8ZOlUUcr0begz62DKNFdyqODZRqutDa2Q6dORObDPEElCV3S+M3
         tiLYNwcZ9Kuog9umRyLnJqJAoRSA3vmtGtMd7sdnYOok0Lu96IorEfCenRHF5dlMWa6T
         6x7OuIuCydIYH1kr7i9ubxQFiW664ND4F/roXktfTkDQLmiQ6HQikuMjh8cWzWC+YNbW
         M7HYZale6/TmiMU215cWVN+Lv9piP79nJrcL3zha3FC14d/pxEPo1gRrYgGf0ttRPOoM
         lraQ3/y2lzGStkM4XAvwuqaIHgF3t+xGi7JtMbotzNVqu0CUlHqNYdhfESmu9gNsSJhQ
         HjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOmQk0x3ccvRlceWbWP6GlZsmAYEOiZMR0Q/yyY99OQ=;
        b=JPnEs0YlsgfUhe3ZPuK9Jph+tvJt7C7//aDYPmFGpPvP1IIOFIUW2o/weR7grwTHeS
         rxpq+vnERHZoW67cXRxbM5dmD+Lt4S3a7N+SY9IqFWNExFtNl8V40PAkCIREgm/KA9pb
         55LyXEHH+wAYn0yzFFl5nThsz8bfo/gR7b3WrdMhfaPsw1Fut+XOqOK728fI7BBSUofh
         iIhaFkxsypzEl4SZqujdHZcNkPxNvcE4rNi0B9iMUKBCUhyDrLW/riTszfBaRhHjC9i7
         byvn+0MaRKYqWYKLiU4m3SlwQuUMBMMADITI5wzSsktiNJeffjnuJlkKNu6UpVeXrbld
         fsxA==
X-Gm-Message-State: AOAM531h9zDeh3j8qiGc7Wv2WDo0TJmnTySR8IqR4BQIpfFk6oYsPR3J
        IZCrtOt7/UaUn4NxQdeI9P5PVamyzb+8If38ZC74sA==
X-Google-Smtp-Source: ABdhPJwDePy04S+TEAbB/l0WUoCva/Xi7xKi/eubNc5Leg+G4l43zsZ/K98rDsbbM2EFRXtuSzl392zKo7dwdGlc4tc=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr1106955edw.52.1608235652067;
 Thu, 17 Dec 2020 12:07:32 -0800 (PST)
MIME-Version: 1.0
References: <20201216174146.10446-1-chang.seok.bae@intel.com> <X9utMeDKfjdghy1M@sol.localdomain>
In-Reply-To: <X9utMeDKfjdghy1M@sol.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 17 Dec 2020 12:07:22 -0800
Message-ID: <CAPcyv4h6hiSiE5xC=eccrQcd6Zb+aQeEjQ7bbC5jb_6heQkEsA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] x86: Support Intel Key Locker
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Hansen <dave.hansen@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        ning sun <ning.sun@intel.com>,
        Kumar N Dwarakanath <kumar.n.dwarakanath@intel.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 11:11 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Dec 16, 2020 at 09:41:38AM -0800, Chang S. Bae wrote:
> > [1] Intel Architecture Instruction Set Extensions Programming Reference:
> >     https://software.intel.com/content/dam/develop/external/us/en/documents/architecture-instruction-set-$

https://software.intel.com/content/dam/develop/external/us/en/documents/architecture-instruction-set-extensions-programming-reference.pdf

> > [2] Intel Key Locker Specification:
> >     https://software.intel.com/content/dam/develop/external/us/en/documents/343965-intel-key-locker-speci$

https://software.intel.com/content/dam/develop/external/us/en/documents/343965-intel-key-locker-specification.pdf
