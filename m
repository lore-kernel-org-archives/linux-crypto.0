From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: acomp - allow registration of multiple acomps
Date: Fri, 21 Apr 2017 21:16:20 +0800
Message-ID: <20170421131620.GF14803@gondor.apana.org.au>
References: <20170419132305.3127-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42910 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039793AbdDUNQo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:16:44 -0400
Content-Disposition: inline
In-Reply-To: <20170419132305.3127-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 19, 2017 at 02:23:05PM +0100, Giovanni Cabiddu wrote:
> Add crypto_register_acomps and crypto_unregister_acomps to allow
> the registration of multiple implementations with one call.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
