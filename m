Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E12C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 13:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983D021855
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 13:14:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vCy7CqwG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfAXNOT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 08:14:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42244 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfAXNOS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 08:14:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id q18so6400136wrx.9;
        Thu, 24 Jan 2019 05:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y/lW7+JZxD/baTt1N3aYvrtz4O/3BooocSajeiT6/vk=;
        b=vCy7CqwGW9x35ONepOc0p6ILh0WFw5zqJGkHDQ014Ok023o2nRXPYR3QuTo0TZkbAg
         UHJHOJm9kvgUrBGPC3SkRNYf3wzcEkYskRId6Kf83RcKCGDCqbjvu09SsAWNOqDpfN/9
         y6bM4Zvlw6KlC41UGawHyOBJeG2TnjFLAGE+Bh8NJaEAelJ5qECUW8bUcZzJwUFymee7
         EJihOae97LQrTIiwq5uqA1vWIRvx5FCYbBKt4GBYBKehx3ACEM8zpNBzUTCtnTvogqgB
         5CkryeOYkhFpaGI64/bxZTg7hM2K2oGW6YnHPtzcFGyhoc7jldSFLojXhGFCn+GbbqH6
         fVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y/lW7+JZxD/baTt1N3aYvrtz4O/3BooocSajeiT6/vk=;
        b=XTjpYJpvJtOJYXv01jUxNN4AHz4vBu/RO0lCwmps8x5tJALEcITrXeI6hk2gZ3WXui
         20MIS86p0dBORXlyTADbFlyaFqH8jAr/jFSFuVKznEmALk2i1KeZ6vTRlTeSdeoGxmPF
         A5RN+zHrzErFDjfnj2319TVla/KGgQGFVqC8l5MBPiiVp1Ztp3wKoj1jXS7RaX7wm7sk
         NUMQrkoFjs+lHSx9iHcSqqUhH+wzPJcodlvII50PnJfI07YrAAZ3pVaApqwJOsdQoxxq
         juYHly62jwTcSRduK5g0lTpBFPpONWa0IzZqcH26JwVViBPLd8VLdwG5Kvpi3DLZUIBv
         WN6g==
X-Gm-Message-State: AJcUukeZk2yG5/rPPXv8YaeTaKHdDVwo/i6+Ue6DUZbDeqFpfZHE4B5K
        UAG6vjD/9lUX9UM6pKT5W0fdegT5
X-Google-Smtp-Source: ALg8bN6RQ6dqns335hjyWjAXPbqnw+Io8QgmgCGcMpY9RuCMA+UNjl/KqQ/ncmcP5LIZDpDzYoArxQ==
X-Received: by 2002:adf:ee46:: with SMTP id w6mr7327037wro.261.1548335656891;
        Thu, 24 Jan 2019 05:14:16 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id l6sm97552451wrv.70.2019.01.24.05.14.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 05:14:16 -0800 (PST)
Date:   Thu, 24 Jan 2019 14:14:14 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC/RFT PATCH 11/15] crypto: testmgr - convert skcipher testing
 to use testvec_configs
Message-ID: <20190124131414.GA13624@Red>
References: <20190123224926.250525-1-ebiggers@kernel.org>
 <20190123224926.250525-12-ebiggers@kernel.org>
 <CAKv+Gu-uELtKc_fNKFLPZ9KqrSMhX+cXuiP79JMR1zm0yo0r8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-uELtKc_fNKFLPZ9KqrSMhX+cXuiP79JMR1zm0yo0r8w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 01:36:23PM +0100, Ard Biesheuvel wrote:
> On Wed, 23 Jan 2019 at 23:53, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Convert alg_test_skcipher() to use the new test framework, adding a list
> > of testvec_configs to test by default.  When the extra self-tests are
> > enabled, randomly generated testvec_configs are tested as well.
> >
> > This improves skcipher test coverage mainly because now all algorithms
> > have a variety of data layouts tested, whereas before each algorithm was
> > responsible for declaring its own chunked test cases which were often
> > missing or provided poor test coverage.  The new code also tests both
> > the MAY_SLEEP and !MAY_SLEEP cases, different IV alignments, and buffers
> > that cross pages.
> >
> > This has already found a bug in the arm64 ctr-aes-neonbs algorithm.
> > It would have easily found many past bugs.
> >
> > I removed the skcipher chunked test vectors that were the same as
> > non-chunked ones, but left the ones that were unique.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> This patch does not apply after applying 1..10 onto cryptodev/master
> 
> Do you have a tree somewhere?

Hello

I got the same with next.
You need to apply "crypto: clarify name of WEAK_KEY request flag" from his repo:
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git branch testmgr-improvements

Regards
