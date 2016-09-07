From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix incorrect accelerator mask for C3X
 devices
Date: Wed, 7 Sep 2016 21:20:00 +0800
Message-ID: <20160907132000.GF17176@gondor.apana.org.au>
References: <1472579760-3698-1-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58684 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752960AbcIGNUG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:20:06 -0400
Content-Disposition: inline
In-Reply-To: <1472579760-3698-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 30, 2016 at 06:56:00PM +0100, Giovanni Cabiddu wrote:
> From: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> 
> Fix incorrect value of ADF_C3XXX_ACCELERATORS_MASK.
> 
> Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
