From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix constants table DMA
Date: Wed, 31 Aug 2016 23:19:28 +0800
Message-ID: <20160831151928.GH28366@gondor.apana.org.au>
References: <1472473711-611-1-git-send-email-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51702 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965041AbcHaPTd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 11:19:33 -0400
Content-Disposition: inline
In-Reply-To: <1472473711-611-1-git-send-email-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2016 at 01:28:31PM +0100, Giovanni Cabiddu wrote:
> From: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> 
> Copy const_tab array into DMA-able memory (accesible by qat hw).
> 
> Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
