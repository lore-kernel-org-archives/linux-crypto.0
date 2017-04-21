From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: acomp - replace compression known answer test
Date: Fri, 21 Apr 2017 21:16:28 +0800
Message-ID: <20170421131627.GG14803@gondor.apana.org.au>
References: <20170419132718.3438-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42916 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039793AbdDUNQv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:16:51 -0400
Content-Disposition: inline
In-Reply-To: <20170419132718.3438-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 19, 2017 at 02:27:18PM +0100, Giovanni Cabiddu wrote:
> Compression implementations might return valid outputs that
> do not match what specified in the test vectors.
> For this reason, the testmgr might report that a compression
> implementation failed the test even if the data produced
> by the compressor is correct.
> This implements a decompress-and-verify test for acomp
> compression tests rather than a known answer test.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
