Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2D5EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jul 2023 20:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjGEUMK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jul 2023 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbjGEUMJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2023 16:12:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA12198D;
        Wed,  5 Jul 2023 13:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BFC661712;
        Wed,  5 Jul 2023 20:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D87C433C7;
        Wed,  5 Jul 2023 20:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688587927;
        bh=jIA4I8df5zxsszIbcx45LiUK8Pr9FjcE9l5Z8LvDBuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NObo0wJ79pzqzvtDPzT5Ow4fCqG0mcsaN97AY9nA9/ARMe3vVDZweh/2XXcrlM0EV
         1ssDySnpoDJsCvl3hwTWfbgj7HTJEnMg2wVTR3n56pKyWw46nGBmsSncWpMtfQdRTQ
         LkKT1N1iLolQ9vrubB33PjUisiIy24WNWOWpnnDeZIeLMG2FkQKPztaO/8f/iuYAIb
         UM83EU2n3eDiDmkzTPYWOz/azKGImm8s0jpHAZpCMg38T2fqdRM3MN1u/4Bgp8ChfW
         zl4TXYLtZGebanG0p4SqGayA13K8hSNEWOxsrC6WypQoiEsnAYkQcijhuWTeoXFkE3
         11/E2fKzZgABg==
Date:   Wed, 5 Jul 2023 13:12:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, agk@redhat.com, snitzer@kernel.org,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, qat-linux@intel.com,
        heinzm@redhat.com, meenakshi.aggarwal@nxp.com,
        horia.geanta@nxp.com, V.Sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net, iuliana.prodan@nxp.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20230705201205.GA866@sol.localdomain>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705164009.58351-2-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 05, 2023 at 05:40:07PM +0100, Giovanni Cabiddu wrote:
> The flag CRYPTO_ALG_ALLOCATES_MEMORY indicates that an algorithm might
> allocate memory in the datapath and therefore sleep.
> Dm-integrity is filtering out implementations of skcipher algorithms
> that have this flag set. However, in the same function it does
> allocations with GFP_KERNEL.

Which function is the above referring to?  The actual encryption/decryption
happens in crypt_journal(), and I don't see any memory allocations there.

> As dm-integrity is re-entrant and capable of handling sleeps that could
> occur during allocations with GFP_KERNEL, then it is also capable of
> using skcipher algorithm implementations that have
> CRYPTO_ALG_ALLOCATES_MEMORY set.
> 
> Remove the filtering of skcipher implementations with the flag
> CRYPTO_ALG_ALLOCATES_MEMORY set.

What about the use of CRYPTO_ALG_ALLOCATES_MEMORY in get_mac()?

> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Link: https://lore.kernel.org/linux-crypto/ZILvtASXQKLG43y9@gondor.apana.org.au/
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>

This needs:

    Fixes: a7a10bce8a04 ("dm integrity: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY")
    Cc: stable@vger.kernel.org

But, are you 100% sure the explanation in commit a7a10bce8a04 was incorrect?

- Eric
