Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C562AEB8FA5
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Sep 2023 09:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjIFJF3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Sep 2023 05:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbjIFJF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2023 05:05:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A64E61;
        Wed,  6 Sep 2023 02:05:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qdoTI-00BH6H-GC; Wed, 06 Sep 2023 17:05:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 06 Sep 2023 17:05:14 +0800
Date:   Wed, 6 Sep 2023 17:05:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Bug in rsa-pkcs1pad in 6.1 and 5.15
Message-ID: <ZPhAyty1r8ASyr+F@gondor.apana.org.au>
References: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 05, 2023 at 11:41:14AM +0100, Giovanni Cabiddu wrote:
>
> Options:
>   1. Cherry-pick 5b11d1a360ea ("crypto: rsa-pkcs1pad - Use helper to set
>      reqsize") to both 6.1.x and 5.15.x trees.
>   2. Revert upstream commit 80e62ad58db0 ("crypto: qat - Use helper
>      to set reqsize").
>      In 6.1 revert da1729e6619c414f34ce679247721603ebb957dc
>      In 5.15 revert 3894f5880f968f81c6f3ed37d96bdea01441a8b7
> 
> Option #1 is preferred as the same problem might be impacting other
> akcipher implementations besides QAT. Option #2 is just specific to the
> QAT driver.
> 
> @Herbert, can you have a quick look in case I missed something? I tried
> both options in 6.1.51 and they appear to resolve the problem.

Yes I think backporting the rsa-pkcs1pad would be the best way
forward.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
