From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Mon, 23 Jan 2017 22:24:17 +0800
Message-ID: <20170123142417.GD19957@gondor.apana.org.au>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Nitin Kumbhar <nkumbhar@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57735 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750761AbdAWOY5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:24:57 -0500
Content-Disposition: inline
In-Reply-To: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 20, 2017 at 05:05:55PM +0530, Nitin Kumbhar wrote:
> Hello,
> 
> This patch series adds support for Elliptic Curve Digital Signature
> Algorithm (ECDSA). To reuse existing ECC functionality, which is
> added as part of ECDH, it separates out ECC and ECDH so that
> only ECC functionality is available for ECDSA even when ECDH is in
> a disabled state.
> 
> Patch #1 restructures ECC and ECDH code such that ECC is not
> dependent on ECDH config.
> 
> Patches #2 & #3 add vli and ecc functions which are required
> for other Elliptic curve algorithms like ECDSA and ECIES.
> 
> Patch #4 adds support for ECDSA. This has been validated for P192
> and P256 elliptic curves.
> 
> Patches #5 and #6 add ECDSA tests to validate ECDSA functionality
> and measure ECDSA performance.

Who is going to use this in the kernel?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
