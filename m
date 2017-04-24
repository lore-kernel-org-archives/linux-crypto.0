From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: scomp - allow registration of multiple
 scomps
Date: Mon, 24 Apr 2017 18:22:30 +0800
Message-ID: <20170424102230.GD20943@gondor.apana.org.au>
References: <20170421205430.11551-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:47324 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1168603AbdDXKjm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 06:39:42 -0400
Content-Disposition: inline
In-Reply-To: <20170421205430.11551-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 21, 2017 at 09:54:29PM +0100, Giovanni Cabiddu wrote:
> Add crypto_register_scomps and crypto_unregister_scomps to allow
> the registration of multiple implementations with one call.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
