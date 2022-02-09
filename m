Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318B7C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 08:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbiBIIhE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:37:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242067AbiBIIhA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 03:37:00 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9733C050CDF;
        Wed,  9 Feb 2022 00:36:57 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id D323A20142D;
        Wed,  9 Feb 2022 08:31:15 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 05B9A802CB; Wed,  9 Feb 2022 09:22:27 +0100 (CET)
Date:   Wed, 9 Feb 2022 09:22:26 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, ebiggers@kernel.org
Subject: Re: [PATCH v2 2/9] random: get rid of secondary crngs
Message-ID: <YgN5wp58XHYd7/WA@owl.dominikbrodowski.net>
References: <20220209011919.493762-1-Jason@zx2c4.com>
 <20220209011919.493762-3-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209011919.493762-3-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Just one question (which was already present in the past, but...):

> -	WRITE_ONCE(crng->init_time, jiffies);
> -	spin_unlock_irqrestore(&crng->lock, flags);
> -	if (crng == &primary_crng && crng_init < 2)
> -		crng_finalize_init();
> +	WRITE_ONCE(primary_crng.init_time, jiffies);
> +	spin_unlock_irqrestore(&primary_crng.lock, flags);
> +	if (crng_init < 2) {
> +		invalidate_batched_entropy();
> +		crng_init = 2;

Might this branch be taken twice if crng_reseed() is called concurrently
twice? If so, we'd need to increment crng_init while holding the lock,
such as I suggested in my patch "random: fix locking for crng_init in
crng_reseed()". But that can be deferred to an additional patch.

Thanks,
	Dominik
