From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - add testvector for pkcs1pad(rsa)
Date: Tue, 20 Jun 2017 11:40:56 +0800
Message-ID: <20170620034056.GE17764@gondor.apana.org.au>
References: <7360423.GCCKX1lbB2@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60898 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdFTDlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:41:16 -0400
Content-Disposition: inline
In-Reply-To: <7360423.GCCKX1lbB2@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 12, 2017 at 11:27:51PM +0200, Stephan Müller wrote:
> The PKCS#1 RSA implementation is provided with a self test with RSA 2048
> and SHA-256. This self test implicitly covers other RSA keys and other
> hashes. Also, this self test implies that the pkcs1pad(rsa) is FIPS
> 140-2 compliant.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
