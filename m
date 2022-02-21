Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58450C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Feb 2022 04:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245609AbiBUEGF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Feb 2022 23:06:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245607AbiBUEGD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Feb 2022 23:06:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8A151E7A;
        Sun, 20 Feb 2022 20:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7090AB80DAD;
        Mon, 21 Feb 2022 04:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7351C340E9;
        Mon, 21 Feb 2022 04:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645416338;
        bh=6niB/2nKNpNVfodR8zq5hulu8kbqso984fegXzx/+iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eYF1/Q5FOS7uR5DMwhmkUYMoNiAvCHNC8O7BzlvSird1BKqKQ/YRQAnL+E4yXyqr2
         s9Y/cgZ1eBhpu4RSfN61dlGtK68uWtcJ+nFZws4K5IlT8tqK+THvd2wVBxUR9R5cIQ
         UUbU5Pq+Z9O/W/LwIElJzIdaYOoqhmPTIOTRDz8VIPvRmknbraxYJR44mSyXNImqLj
         e5Erf3Gd8owW544AN5aAH43t59UHGFZT1lrLl0CoWJHR3+CiW3kxLmRwxGptfc1T1F
         ZNNwGDgAqQVaI85sz7ysP87nKWrOaXdqEF9quk2q/sQ2cAHoY4yWZKrZoxjxTkRLRh
         MyF3yMpPc4Yww==
Date:   Sun, 20 Feb 2022 20:05:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: fix locking for crng_init in crng_reseed()
Message-ID: <YhMPkPdzOZr/fT5/@sol.localdomain>
References: <YgQOgqWr0nwqZCh6@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgQOgqWr0nwqZCh6@owl.dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 09, 2022 at 07:57:06PM +0100, Dominik Brodowski wrote:
> crng_init is protected by primary_crng->lock. Therefore, we need
> to hold this lock when increasing crng_init to 2. As we shouldn't
> hold this lock for too long, only hold it for those parts which
> require protection.
> 
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/char/random.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

Though to bikeshed on the variable name, I think that 'became_ready' would be
more self-explanatory than 'complete_init' (this patch) and 'finalize_init'
(the version committed).

- Eric
