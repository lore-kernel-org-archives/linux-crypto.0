Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC4DC43217
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Dec 2022 10:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiLAKTs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 05:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiLAKTK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 05:19:10 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949C9950E
        for <linux-crypto@vger.kernel.org>; Thu,  1 Dec 2022 02:19:08 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p0gen-002mGm-CR; Thu, 01 Dec 2022 18:19:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Dec 2022 18:19:05 +0800
Date:   Thu, 1 Dec 2022 18:19:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/6] crypto: optimize registration of internal
 algorithms
Message-ID: <Y4h/mYRPtb+TGOla@gondor.apana.org.au>
References: <20221114001238.163209-1-ebiggers@kernel.org>
 <20221114001238.163209-3-ebiggers@kernel.org>
 <Y4epN07Qi7pPCrWb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4epN07Qi7pPCrWb@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 30, 2022 at 07:04:23PM +0000, Eric Biggers wrote:
.
> Ard pointed out that there's a bisection hazard here, since this patch deletes
> the skiptest label, but the last goto to it isn't deleted until patch 6.  Sorry
> about that.  Herbert, do you want to fix this by rebasing, or is it too late?

I don't think it's worth worrying about.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
