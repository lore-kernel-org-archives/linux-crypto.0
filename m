From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 4/9] crypto: acomp - add support for lzo via scomp
Date: Tue, 20 Sep 2016 17:26:18 +0800
Message-ID: <20160920092618.GA20808@gondor.apana.org.au>
References: <1473770981-9869-1-git-send-email-giovanni.cabiddu@intel.com>
 <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51371 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbcITJ0b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2016 05:26:31 -0400
Content-Disposition: inline
In-Reply-To: <1473770981-9869-5-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 13, 2016 at 01:49:36PM +0100, Giovanni Cabiddu wrote:
>
> +	lzo_src_scratches = crypto_scomp_alloc_scratches(LZO_SCRATCH_SIZE);
> +	if (!lzo_src_scratches)
> +		return -ENOMEM;

Rather than duplicating the scratch buffer handling in every scomp
algorithm, let's centralize this and put it into scomp.c.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
