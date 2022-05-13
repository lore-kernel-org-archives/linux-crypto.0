Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303A5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 06:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377322AbiEMG00 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 02:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359614AbiEMG0W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 02:26:22 -0400
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294E5289A8;
        Thu, 12 May 2022 23:26:07 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id AD3032013E7;
        Fri, 13 May 2022 06:26:05 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id C835E80957; Fri, 13 May 2022 08:18:53 +0200 (CEST)
Date:   Fri, 13 May 2022 08:18:53 +0200
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random32: use real rng for non-deterministic randomness
Message-ID: <Yn34Tf4CpSaZBlGi@owl.dominikbrodowski.net>
References: <20220511143257.88442-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220511143257.88442-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Wed, May 11, 2022 at 04:32:57PM +0200 schrieb Jason A. Donenfeld:
> random32.c has two RNGs in it: one that is meant to be used
> deterministically, with some predefined seed, and one that does the same
> exact thing as random.c, except does it poorly. The first one has some
> use cases. The second one no longer does and can be replaced with calls
> to random.c's proper random number generator.
> 
> The relatively recent siphash-based bad random32.c code was added in
> response to concerns that the prior random32.c was too deterministic.
> Out of fears that random.c was (at the time) too slow, this code was
> anonymously contributed by somebody who was likely reusing the alias of
> long time anonymous contributor George Spelvin. Then out of that emerged
> a kind of shadow entropy gathering system, with its own tentacles
> throughout various net code, added willy nilly.
> 
> Stop👏making👏crappy👏bespoke👏random👏number👏generators👏.
> 
> Fortunately, recently advances in random.c mean that we can stop playing
> with this sketchiness, and just use get_random_u32(), which is now fast
> enough. In micro benchmarks using RDPMC, I'm seeing the same median
> cycle count between the two functions, with the mean being _slightly_
> higher due to batches refilling (which we can optimize further need be).
> However, when doing *real* benchmarks of the net functions that actually
> use these random numbers, the mean cycles actually *decreased* slightly
> (with the median still staying the same), likely because the additional
> prandom code means icache misses and complexity, whereas random.c is
> generally already being used by something else nearby.
> 
> The biggest benefit of this is that there are many users of prandom who
> probably should be using cryptographically secure random numbers. This
> makes all of those accidental cases become secure by just flipping a
> switch. Later on, we can do a tree-wide cleanup to remove the static
> inline wrapper functions that this commit adds.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Jakub - If there are no objections to this plan, I intend on taking this
> through the random.git tree, which is what this commit is based on, with
> its recent siphash changes and such. -Jason

Nice! However, wouldn't it be much better to clean up the indirection
introduced here as well? prandom_u32() as wrapper for get_random_u32() and
prandom_bytes() as wrapper for get_random_bytes() seems unnecessary...

Thanks,
	Dominik
