From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Use devm_hwrng_register instead of hwrng_register
Date: Wed, 31 Aug 2016 23:19:02 +0800
Message-ID: <20160831151902.GF28366@gondor.apana.org.au>
References: <1472374152-19319-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52723 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964863AbcHaPTF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 11:19:05 -0400
Content-Disposition: inline
In-Reply-To: <1472374152-19319-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 28, 2016 at 02:19:12PM +0530, PrasannaKumar Muralidharan wrote:
> By using devm_hwrng_register instead of hwrng_register the .remove
> callback in platform_driver can be removed. This reduces a few lines in
> code.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
