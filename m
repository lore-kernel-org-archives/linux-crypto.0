From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] Enable RSA Support on the CCP
Date: Fri, 28 Jul 2017 21:54:09 +0800
Message-ID: <20170728135409.GH21401@gondor.apana.org.au>
References: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39942 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdG1NyP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 09:54:15 -0400
Content-Disposition: inline
In-Reply-To: <150032218639.102878.17376499349231172712.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 17, 2017 at 03:16:02PM -0500, Gary R Hook wrote:
> This series accomplishes the following:
> 
>  - Fix RSA support in the base CCP driver
>  - Add the akcipher_set_reqsize() function
>  - Enable RSA support in the crypto layer
>  - Allow for a larger RSA modulus in a version 5 CCP
> 
> ---
> 
> Gary R Hook (4):
>       crypto: ccp - Fix base RSA function for version 5 CCPs
>       crypto: Add akcipher_set_reqsize() function
>       crypto: ccp - Add support for RSA on the CCP
>       csrypto: ccp - Expand RSA support for a v5 ccp

All patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
