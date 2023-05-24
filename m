Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE43BC77B73
	for <linux-crypto@archiver.kernel.org>; Wed, 24 May 2023 09:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjEXJun (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 May 2023 05:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjEXJuf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2023 05:50:35 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3B418B;
        Wed, 24 May 2023 02:50:31 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q1l7V-00CkU8-Pj; Wed, 24 May 2023 17:49:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 May 2023 17:49:25 +0800
Date:   Wed, 24 May 2023 17:49:25 +0800
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
Message-ID: <ZG3dpbPlRXbF2ZxN@gondor.apana.org.au>
References: <20230516215009.51794-1-tom.zanussi@linux.intel.com>
 <20230516215009.51794-14-tom.zanussi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516215009.51794-14-tom.zanussi@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 16, 2023 at 04:50:07PM -0500, Tom Zanussi wrote:
.
> To choose 'fixed' mode:
> 
>   echo "fixed" >  /sys/bus/dsa/drivers/crypto/compression_mode
> 
> To choose 'canned' mode:
> 
>   echo "canned" >  /sys/bus/dsa/drivers/crypto/compression_mode

This seems to be a strange way to switch modes.  How about just
registering both algorithms and then let the user decide which
one to use throught the algorithm name?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
