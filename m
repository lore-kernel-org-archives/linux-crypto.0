From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Tue, 16 Feb 2016 20:19:39 +0000
Message-ID: <20160216201939.GB11908@gondor.apana.org.au>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48881 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbcBPUTo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:19:44 -0500
Content-Disposition: inline
In-Reply-To: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 15, 2016 at 09:01:55AM +0000, Salvatore Benedetto wrote:
> Implement Diffie-Hellman primitives required by the scheme under the
> akcipher API. Here is how it works.
> 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
> 2) Call set_priv_key() to set your own private key (xa) in raw format
> 3) Call decrypt() without passing any data as input to get back the
>    public part which will be computed as g^xa mod p
> 4) Call encrypt() by passing the counter part public key (yb) in raw format
>    as input to get back the shared secret calculated as zz = yb^xa mod p
> 
> A test is included in the patch. Test vector has been generated with
> openssl
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>

Who is going to use this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
