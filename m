From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v10 0/8] crypto: asynchronous compression api
Date: Tue, 25 Oct 2016 11:47:01 +0800
Message-ID: <20161025034701.GJ18685@gondor.apana.org.au>
References: <1477052394-19826-1-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60216 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753131AbcJYDrl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 23:47:41 -0400
Content-Disposition: inline
In-Reply-To: <1477052394-19826-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 21, 2016 at 01:19:46PM +0100, Giovanni Cabiddu wrote:
> The following patch set introduces acomp, a generic asynchronous
> (de)compression api with support for SG lists.
> We propose a new crypto type called crypto_acomp_type, a new struct acomp_alg
> and struct crypto_acomp, together with number of helper functions to register
> acomp type algorithms and allocate tfm instances.
> This interface will allow the following operations:
> 
>     int (*compress)(struct acomp_req *req);
>     int (*decompress)(struct acomp_req *req);
> 
> Together with acomp we propose a new driver-side interface, scomp, which
> handles compression implementations which use linear buffers. We converted all
> compression algorithms available in LKCF to use this interface so that those
> algorithms will be accessible through the acomp api.
> 
> Changes in v10:
>     - fixed build issues for configurations where CONFIG_CRYPTO_USER is defined

All applied.  Thanks a lot Giovanni!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
