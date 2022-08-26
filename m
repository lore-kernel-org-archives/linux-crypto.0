Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE38ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 10:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245027AbiHZK25 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343702AbiHZK2z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 06:28:55 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D3BD0744
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 03:28:53 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRWa0-00FPJ3-Bd; Fri, 26 Aug 2022 20:28:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 18:28:48 +0800
Date:   Fri, 26 Aug 2022 18:28:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: Re: [PATCH 8/9] crypto: qat - expose deflate through acomp api for
 QAT GEN2
Message-ID: <YwigYBNM7O/J6gO1@gondor.apana.org.au>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
 <20220818180120.63452-9-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818180120.63452-9-giovanni.cabiddu@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 18, 2022 at 07:01:19PM +0100, Giovanni Cabiddu wrote:
>
> +	/* Handle acomp requests that require the allocation of a destination
> +	 * buffer. The size of the destination buffer is double the source
> +	 * buffer to fit the decompressed output or an expansion on the
> +	 * data for compression.
> +	 */
> +	if (!areq->dst) {
> +		dlen = 2 * slen;
> +		areq->dst = sgl_alloc(dlen, f, NULL);
> +		if (!areq->dst)
> +			return -ENOMEM;
> +	}

So what happens if the decompressed result is more than twice as
long as the source?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
