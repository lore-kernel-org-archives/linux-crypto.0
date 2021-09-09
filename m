Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08320C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 03:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FFF61167
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Sep 2021 03:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350398AbhIIDoS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Sep 2021 23:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350291AbhIIDoO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Sep 2021 23:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC78261176;
        Thu,  9 Sep 2021 03:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631158985;
        bh=IsbzwEXjpNgvP9zkG7k9LANlDJU/or9A0h5NT8t4dHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=swwHJNsQJRlN+iXkpNIKL5OH8MV7pMl5TDklD0aC8iEmL/ea+wrWTG1n1Bv8Ltgqy
         pR9J9q7suQqtbWOCkjBWlSVN5oks1YgzFbvU23xz/JrMf549kQaOgmKDx72eRUWEBV
         V5QF4ajZPztHS5Js8BcXZlpC9pF9MMo65lN3FYVGsPIuZ6ys6OkF0eHK04UAjPi95h
         xbuCtdHBRQLOUViYDTpSQ9wOCgso9DPqUmpWmiNSSyHu8gdB885RB4BCfpNhCeslR2
         Ev16UcMRBi50T7nn40JlJENvIl2DFM1XNevNn3c2TCvLUfjYtRaiwwv3wxocXanqI9
         +4imfbzXw9/Ww==
Date:   Wed, 8 Sep 2021 20:43:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] In _extract-crng mix in 64 bits if possible
Message-ID: <YTmCyOTFADDSTdQm@sol.localdomain>
References: <CACXcFmm798P6mPErh9B4thz7uvBG1sUO-eJpa1MB+7ayDyTCvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmm798P6mPErh9B4thz7uvBG1sUO-eJpa1MB+7ayDyTCvw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 09, 2021 at 10:49:20AM +0800, Sandy Harris wrote:
> On some machines arch_get_random_long() gives 64 bits.
> XORing it into a 32-bit state word uses only half of it.
> This change makes it use it all instead.
> 
> Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
> 
> ---
>  drivers/char/random.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

This patch is corrupted and doesn't apply.

> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 57fe011fb5e4..fe7f3366b934 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -988,7 +988,8 @@ static void crng_reseed(struct crng_state *crng,
> struct entropy_store *r)
>  static void _extract_crng(struct crng_state *crng,
>                __u8 out[CHACHA_BLOCK_SIZE])
>  {
> -    unsigned long v, flags;
> +    unsigned long v, flags, *last;
> +    last = (unsigned long *) &crng->state[14] ;

How do you know that this has the right alignment for an unsigned long?

- Eric
