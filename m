From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] crypto: scompress - defer allocation of percpu
 scratch buffers
Date: Thu, 3 Aug 2017 14:24:36 +0800
Message-ID: <20170803062436.GK12039@gondor.apana.org.au>
References: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@intel.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:58448 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdHCGYs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 02:24:48 -0400
Content-Disposition: inline
In-Reply-To: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 04:42:35PM +0100, Ard Biesheuvel wrote:
> This is a followup to 'crypto: scompress - eliminate percpu scratch buffers',
> which attempted to replace the scompress per-CPU buffer entirely, but as
> Herbert pointed out, this is not going to fly in the targeted use cases.
> 
> Instead, move the alloc/free of the buffers into the tfm init/exit hooks,
> so that we only have the per-CPU buffers allocated if their are any
> acomp ciphers of the right kind (i.e, ones that encapsulate a synchronous
> implementation) in use (#3)
> 
> Patches #1 and #2 are fixes for issues I spotted when working on this code.
> 
> Ard Biesheuvel (3):
>   crypto: scompress - don't sleep with preemption disabled
>   crypto: scompress - free partially allocated scratch buffers on
>     failure
>   crypto: scompress - defer allocation of scratch buffer to first use

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
