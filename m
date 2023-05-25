Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42303C77B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 May 2023 00:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjEYAhk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 May 2023 20:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjEYAhj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2023 20:37:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACE69B;
        Wed, 24 May 2023 17:37:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q1yyg-00D229-Hg; Thu, 25 May 2023 08:37:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 25 May 2023 08:37:14 +0800
Date:   Thu, 25 May 2023 08:37:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Zanussi <tom.zanussi@linux.intel.com>
Cc:     davem@davemloft.net, fenghua.yu@intel.com, vkoul@kernel.org,
        dave.jiang@intel.com, tony.luck@intel.com,
        wajdi.k.feghali@intel.com, james.guilford@intel.com,
        kanchana.p.sridhar@intel.com, giovanni.cabiddu@intel.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v5 13/15] crypto: iaa - Add support for default IAA
 'canned' compression mode
Message-ID: <ZG6tun6TOYKr1nxK@gondor.apana.org.au>
References: <20230516215009.51794-1-tom.zanussi@linux.intel.com>
 <20230516215009.51794-14-tom.zanussi@linux.intel.com>
 <ZG3dpbPlRXbF2ZxN@gondor.apana.org.au>
 <fa90e73483b866a0622ad077f4af16978d1c1c8d.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa90e73483b866a0622ad077f4af16978d1c1c8d.camel@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 24, 2023 at 10:58:54AM -0500, Tom Zanussi wrote:
>
> Yes, I think you're right.  The reason we did it this way was that
> we're expecting to add more modes, such as 'dynamic' and/or 'canned-
> dynamic' etc.
> 
> But I don't see a reason we couldn't just register them all and have
> the user choose using the algorithm names, especially if that's the way
> crypto users expect things to work.

Are these modes compatible with the deflate algorithm, that is,
can the generic deflate uncompress the output of these modes and
vice versa, can these modes uncompress the output of the generic
algorithm?

If they're all compatible, then you should just use the "deflate"
algorithm name and use different driver names to differentiate them.
But if they're not compatible then the modes should have distinct
algorithm names.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
