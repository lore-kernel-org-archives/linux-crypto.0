From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Wed, 5 Aug 2015 10:46:00 +0800
Message-ID: <20150805024600.GA3878@gondor.apana.org.au>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org>
 <1704807.Rn4DsddD6R@tauon.atsec.com>
 <70C201C0-233D-4912-9856-C8C0E7A6A0FA@holtmann.org>
 <14682477.78a1L9JDin@myon.chronox.de>
 <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51143 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbHECqP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 22:46:15 -0400
Content-Disposition: inline
In-Reply-To: <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 03, 2015 at 12:25:31AM -0700, Marcel Holtmann wrote:
> 
> RSA Private Key is n + e + d (including 6 other fields). RSA Public Key is n + e (no other fields).
> 
> So for RSA you would make setkey to take RSA Private Key and setpubkey to take RSA Public Key. Meaning you only have to use one of them since if you have the private key, you always have the public key.
> 
> This real difference here is that you can provide the key in two different key formats. As explained RSA uses two different format.

I don't have a problem with a setpubkey/setprivkey split interface.

However, I'm totally against importing MPI keys which is just silly.
The BER-encoded keys are just raw integers.  Most of the hardware
out there take raw integers.  So it makes no sense to have our
interface take MPIs instead of raw integers, as this would mean
converting into MPIs and then straight back into raw integers
for hardware devices.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
