Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC83C7EE25
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 09:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjFIJaY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 05:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241648AbjFIJ36 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 05:29:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EE483D3;
        Fri,  9 Jun 2023 02:24:19 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q7YLk-000wZ8-RU; Fri, 09 Jun 2023 17:24:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Jun 2023 17:24:04 +0800
Date:   Fri, 9 Jun 2023 17:24:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "meenakshi.aggarwal@nxp.com" <meenakshi.aggarwal@nxp.com>,
        "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
        "V.sethi@nxp.com" <V.sethi@nxp.com>,
        "pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
        "gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iuliana.prodan@nxp.com" <iuliana.prodan@nxp.com>,
        lucas.segarra.fernandez@intel.com
Subject: Re: [PATCH 0/5] Remove CRYPTO_ALG_ALLOCATES_MEMORY flag
Message-ID: <ZILvtASXQKLG43y9@gondor.apana.org.au>
References: <20230523153421.1528359-1-meenakshi.aggarwal@nxp.com>
 <20230523165503.GA864814@google.com>
 <ZHh0DF4meU2ze+g7@gondor.apana.org.au>
 <ZHh/zqNu7XzwJTl5@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHh/zqNu7XzwJTl5@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 01, 2023 at 12:23:58PM +0100, Giovanni Cabiddu wrote:
>
> BTW, some time ago we did an assessment of the users of
> !CRYPTO_ALG_ALLOCATES_MEMORY and we came to the conclusion that we
> cannot just update the documentation.
> dm-crypt uses scatterlists with at most 4 entries. dm-integrity,
> instead, might allocate memory for scatterlists with an arbitrary number
> of entries.

dm-integrity shouldn't be using ALLOCATES_MEMORY at all.  It's
using GFP_KERNEL allocations right next to the crypto operations.

But those are some seriously big crypto operations, 16 thousand
4K pages in one hit?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
