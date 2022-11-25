Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB88DC4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 10:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiKYKVG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 05:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKYKVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 05:21:06 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A63F3AC27
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 02:21:02 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyVpB-000iux-0G; Fri, 25 Nov 2022 18:20:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 18:20:49 +0800
Date:   Fri, 25 Nov 2022 18:20:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v2 11/11] crypto: qat - add resubmit logic for
 decompression
Message-ID: <Y4CXAXUnfBHcj4sa@gondor.apana.org.au>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
 <20221123121032.71991-12-giovanni.cabiddu@intel.com>
 <Y4BKgx2axzqsjWch@gondor.apana.org.au>
 <Y4CO3O21Kx/Ywi6S@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CRBasSFNhXywKj@gondor.apana.org.au>
 <Y4CTLD7BdfFt5T5X@gcabiddu-mobl1.ger.corp.intel.com>
 <Y4CT61fknX5aNvpa@gondor.apana.org.au>
 <Y4CVjUAvXx9AIBBa@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4CVjUAvXx9AIBBa@gcabiddu-mobl1.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 10:14:37AM +0000, Giovanni Cabiddu wrote:
>
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index cb3d6b1c655d..bc16e0208169 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -11,6 +11,7 @@
>  #include <linux/crypto.h>
> 
>  #define CRYPTO_ACOMP_ALLOC_OUTPUT      0x00000001
> +#define CRYPTO_ACOMP_NULL_DST_LIMIT    131072

How about simply

	CRYPTO_ACOMP_DST_MAX

Even if it isn't enforced strictly, this is basically the ceiling
on how much effort we are willing to spend on decompressing the
input.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
