From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] crypto: Key Derivation Function (SP800-108)
Date: Thu, 2 Jun 2016 16:56:37 +0800
Message-ID: <20160602085637.GB15919@gondor.apana.org.au>
References: <17649236.piPdUxUzaM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55027 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbcFBI4p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 04:56:45 -0400
Content-Disposition: inline
In-Reply-To: <17649236.piPdUxUzaM@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2016 at 01:50:57PM +0200, Stephan Mueller wrote:
> Hi,
> 
> this patch set implements all three key derivation functions defined in
> SP800-108.
> 
> The implementation is provided as a template for random number generators,
> since a KDF can be considered a form of deterministic RNG where the key
> material is used as a seed.
> 
> With the KDF implemented as a template, all types of keyed hashes can be
> utilized, including HMAC and CMAC. The testmgr tests are derived from
> publicly available test vectors from NIST.
> 
> The KDF are all tested with a complete round of CAVS testing on 32 and 64 bit.
> 
> The patch set introduces an extension to the kernel crypto API in the first
> patch by adding a template handling for random number generators based on the
> same logic as for keyed hashes.

When you resubmit these patches please actually add a user.  I'm not
going to add new algorithms with no users.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
