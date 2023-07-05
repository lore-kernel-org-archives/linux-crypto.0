Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 123F7EB64DA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jul 2023 21:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbjGEV5y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjGEV5y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2023 17:57:54 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919BB9F;
        Wed,  5 Jul 2023 14:57:51 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qHAVM-000b7a-Fj; Thu, 06 Jul 2023 07:57:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jul 2023 05:57:37 +0800
Date:   Thu, 6 Jul 2023 05:57:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, agk@redhat.com,
        snitzer@kernel.org, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, heinzm@redhat.com, meenakshi.aggarwal@nxp.com,
        horia.geanta@nxp.com, V.Sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net, iuliana.prodan@nxp.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH 1/3] dm integrity: do not filter algos with
 CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <ZKXnUeueV6ncaJM6@gondor.apana.org.au>
References: <20230705164009.58351-1-giovanni.cabiddu@intel.com>
 <20230705164009.58351-2-giovanni.cabiddu@intel.com>
 <20230705201205.GA866@sol.localdomain>
 <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKXZUl4VgZkMbOL0@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 05, 2023 at 09:57:54PM +0100, Giovanni Cabiddu wrote:
>
> Then we are then back to square one. We need to check how many entries
> are present in the scatterlists encrypted by crypt_journal() before
> adjusting the meaning of !CRYPTO_ALG_ALLOCATES_MEMORY.

Indeed.  I missed the fact that it was preallocating memory with
GFP_KERNEL.

So perhaps the answer is to adjust our API to allow the drivers to
pre-allocate memory.  I'll look into this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
