Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A72CC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 11:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiBIL5m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiBIL4G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 06:56:06 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C67E00FA48;
        Wed,  9 Feb 2022 02:56:33 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 74C4F201432;
        Wed,  9 Feb 2022 08:31:16 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 5EBE180F74; Wed,  9 Feb 2022 09:30:22 +0100 (CET)
Date:   Wed, 9 Feb 2022 09:30:22 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, ebiggers@kernel.org
Subject: Re: [PATCH v2 8/9] random: use hash function for crng_slow_load()
Message-ID: <YgN7nmv9A0+Zi5L8@owl.dominikbrodowski.net>
References: <20220209011919.493762-1-Jason@zx2c4.com>
 <20220209011919.493762-9-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209011919.493762-9-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Wed, Feb 09, 2022 at 02:19:18AM +0100 schrieb Jason A. Donenfeld:
> Since we have a hash function that's really fast, and the goal of
> crng_slow_load() is reportedly to "touch all of the crng's state", we
> can just hash the old state together with the new state and call it a
> day. This way we dont need to reason about another LFSR or worry about
> various attacks there. This code is only ever used at early boot and
> then never again.

	Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik
