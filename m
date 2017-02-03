From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2] crypto: doc - Fix hash export state information
Date: Fri, 3 Feb 2017 18:20:46 +0800
Message-ID: <20170203102046.GB2632@gondor.apana.org.au>
References: <1485444780-17201-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
        Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47179 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752808AbdBCKU5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2017 05:20:57 -0500
Content-Disposition: inline
In-Reply-To: <1485444780-17201-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 26, 2017 at 04:33:00PM +0100, Rabin Vincent wrote:
> From: Rabin Vincent <rabinv@axis.com>
> 
> The documentation states that crypto_ahash_reqsize() provides the size
> of the state structure used by crypto_ahash_export().  But it's actually
> crypto_ahash_statesize() which provides this size.
> 
> Signed-off-by: Rabin Vincent <rabinv@axis.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
