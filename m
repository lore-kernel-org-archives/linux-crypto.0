Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F80C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 15 May 2022 00:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiEOApW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 May 2022 20:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiEOApW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 May 2022 20:45:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7687331DC4;
        Sat, 14 May 2022 17:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2696B8068E;
        Sun, 15 May 2022 00:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBC1C340EE;
        Sun, 15 May 2022 00:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652575518;
        bh=21ZV2VqcNekl+OrLs6GDM2wheJuc3zH105sP+KC0ikg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YysBWPs816WUhv83Oq1VVa9hEw6pb/9BBqOjsJ1RnyXioGMsB6kjvBySm847TSy0D
         QDlWxK7NxN4lrbXkYVscA5EHh3iF31H/zhJjqXiHp07JCMT7YFLSb1PPZlThE9FJlr
         T/jbJVRtWyHa8x3fwS4/wrFhdw5WW9hrVbXCSMYw7Ue+E4cpWVJRszTaSeUG1/oo1V
         G1VOfdWN6s/EfoaVbzYnGz1P7BKWqXPO2UQw7BQnSE1F9DoidcurKXmJ7SXLGRdX9W
         3wLCL/NoCbbBI/nqlLE9rE4wNC8dfEMDQPbKUnqNJRqfmx/ah8SW8fuVjMHFdjJkH1
         GvSQAh1GTDYvQ==
Date:   Sat, 14 May 2022 17:45:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: do not pretend to handle premature next security
 model
Message-ID: <YoBNHEqeNahziJt5@sol.localdomain>
References: <20220504113025.285784-1-Jason@zx2c4.com>
 <YntvKcp5PYDUKoFE@sol.localdomain>
 <YnuQlIOuOy7nHvSr@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnuQlIOuOy7nHvSr@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 11, 2022 at 12:32:19PM +0200, Jason A. Donenfeld wrote:
> Hi Eric,
> 
> On Wed, May 11, 2022 at 01:09:13AM -0700, Eric Biggers wrote:
> > A couple very minor comments:
> 
> Thanks, will fix these.
> 
> Jason

Found one more:

 /*
  * Return whether the crng seed is considered to be sufficiently
  * old that a reseeding might be attempted.

It should say "that a reseeding is needed", or something similar.

- Eric
