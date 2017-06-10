From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/2] crypto: ecdh - add privkey generation support
Date: Sat, 10 Jun 2017 12:18:52 +0800
Message-ID: <20170610041852.GJ14719@gondor.apana.org.au>
References: <1496155969-13765-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        smueller@chronox.de, marcel@holtmann.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53040 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdFJE7V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 00:59:21 -0400
Content-Disposition: inline
In-Reply-To: <1496155969-13765-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 30, 2017 at 05:52:47PM +0300, Tudor Ambarus wrote:
> Hi,
> 
> This patch set adds support for generating ecc private keys.
> ecc private keys are generated using the method of extra random bits,
> equivalent to that described in FIPS 186-4, Appendix B.4.1.
> 
> Generation of ecc private keys is helpful in a user-space to kernel
> ecdh offload because the keys are not revealed to user-space.
> 
> Private key generation is also helpful to implement forward secrecy.
> A public/private key system demonstrates the property of forward secrecy
> if it creates new key pairs for each communication session. These key pairs
> are generated on an as-needed basis and are destroyed after the session
> is over. If an attacker were to record previous encrypted session data,
> they wouldn't be able to decrypt it with possession of a long-term key.
> 
> There are crypto accelerators that are capable of generating and retaining
> ecdh private keys without revealing them to software. This patch set is a
> prerequisite for hardware ecdh with private key generation support.
> 
> Changes in v3:

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
