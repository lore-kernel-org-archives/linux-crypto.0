Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D0CC32789
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 08:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiHPIb0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 04:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiHPIaz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 04:30:55 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9245B131A31
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 22:50:17 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oNpSh-00BVmN-GH; Tue, 16 Aug 2022 15:50:00 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Aug 2022 13:49:59 +0800
Date:   Tue, 16 Aug 2022 13:49:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Robert Elliott <elliott@hpe.com>, tim.c.chen@linux.intel.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        toshi.kani@hpe.com, rwright@hpe.com
Subject: Re: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Message-ID: <YvswB47jT/MFeBtS@gondor.apana.org.au>
References: <20220813231443.2706-1-elliott@hpe.com>
 <Yvq65Xd6GjeLdmO5@sol.localdomain>
 <YvsEN+6k4lTvXY7I@gondor.apana.org.au>
 <2802022.gAprrWTQMp@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2802022.gAprrWTQMp@tauon.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 16, 2022 at 07:09:44AM +0200, Stephan Mueller wrote:
>
> The tcrypt code has only one purpose for FIPS: to allocate all crypto 
> algorithms at boot time and thus to trigger the self test during boot time. 
> That was a requirement until some time ago. These requirements were relaxed a 
> bit such that a self test before first use is permitted, i.e. the approach we 
> have in testmgr.c.
> 
> Therefore, presently we do not need this boot-time allocation of an algorithm 
> via tcrypt which means that from a FIPS perspective tcrypt is no longer 
> required.

Hi Stephan, Eric:

That makes sense.  So the tcrypt code also has the side-effect
of instantiating all the algorithms which testmgr does not do.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
