From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/6] Add support for ECDSA algorithm
Date: Thu, 2 Feb 2017 21:57:21 +0800
Message-ID: <20170202135721.GA5289@gondor.apana.org.au>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <20170123142417.GD19957@gondor.apana.org.au>
 <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Nitin Kumbhar <nkumbhar@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51139 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751308AbdBBN5g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 08:57:36 -0500
Content-Disposition: inline
In-Reply-To: <113d3ef8-ef34-0651-71e7-be09ef55727e@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 26, 2017 at 11:30:04AM +0530, Nitin Kumbhar wrote:
> 
> This ECDSA implementation is analogous to the RSA kernel implementation for
> signature generation / verification. It extends ECC family of algorithms
> like ECDH to support signature verification using akcipher. This will be
> used in a way similar to RSA.

Yes but RSA had an in-kernel user in the form of module signature
verification.  We don't add algorithms to the kernel without
actual users.  So this patch-set needs to come with an actual
in-kernel user of ECDSA.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
