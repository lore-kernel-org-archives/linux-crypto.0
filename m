Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB37C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 05:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBPF7F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 00:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBPF7D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 00:59:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3214332505
        for <linux-crypto@vger.kernel.org>; Wed, 15 Feb 2023 21:59:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62B7B825DB
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59824C4339B;
        Thu, 16 Feb 2023 05:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527139;
        bh=mAj6cJTofzKFJkdZhIgcxkSfPSeNbJXA3XB+jznts40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OB/NSn6cgtBrX4StUTPOObB2MiIshyQYvkts/ah7vAsCKuyJdW4OyHtfqpmHa+Vlz
         CzbywER1SePlnEYgMwmVykX46/6g+0pChLZMxwTL+B1eoSQAOOYM0kCvn1Q/Lah1Ez
         PZVaIXYoTnew28stKNyv3KIzLDmg+CnVTIr5hpvgD8qiN28N7tMDkh8vWeSKiWtKpf
         6ZDP+0bmvMQ4kAnv9vPE+gsZMY4yKhUnFHNRuPkFleJESXz8XrFqHMGKLgYGR86clQ
         /talMEmJ5MV29mP5dMNfFjvYdwd3P7GYvR3S8dbINUlAj+XRkRCTQBbTwnYify26qH
         2Gh6NknRWv4wQ==
Date:   Wed, 15 Feb 2023 21:58:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 4/10] crypto: hash - Count error stats differently
Message-ID: <Y+3GIaoMR+2mzAmi@sol.localdomain>
References: <Y+ykvcAIAH5Rsn7C@gondor.apana.org.au>
 <E1pSE2L-00BVkw-GI@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pSE2L-00BVkw-GI@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 05:25:13PM +0800, Herbert Xu wrote:
> Move all stat code specific to hash into the hash code.
> 
> While we're at it, change the stats so that bytes and counts
> are always incremented even in case of error.  This allows the
> reference counting to be removed as we can now increment the
> counters prior to the operation.
> 
> After the operation we simply increase the error count if necessary.
> This is safe as errors can only occur synchronously (or rather,
> the existing code already ignored asynchronous errors which are
> only visible to the callback function).
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/ahash.c            |   82 +++++++++++++++++------------
>  crypto/algapi.c           |   24 --------
>  crypto/crypto_user_stat.c |   38 -------------
>  crypto/hash.h             |   37 +++++++++++++
>  crypto/shash.c            |  128 ++++++++++++++++++++++++++++++++++++----------
>  include/crypto/hash.h     |   85 +++++++++++++++++++++++-------
>  include/linux/crypto.h    |   20 -------
>  7 files changed, 250 insertions(+), 164 deletions(-)

This patch is causing the 'BUG_ON(refcount_read(&alg->cra_refcnt) != 1);' in
crypto_unregister_alg() to be hit at boot time.

Most likely related to the way the algorithm structs are being rearranged (which
really ought to be explained in the commit message).

- Eric
