From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 0/3] crypto: KEYS: convert public key to akcipher api
Date: Sat, 6 Feb 2016 15:47:31 +0800
Message-ID: <20160206074731.GF22220@gondor.apana.org.au>
References: <20160202180848.2887.9937.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47947 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbcBFHri (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 02:47:38 -0500
Content-Disposition: inline
In-Reply-To: <20160202180848.2887.9937.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 02, 2016 at 10:08:48AM -0800, Tadeusz Struk wrote:
> Resend v5 rebased on top of 4.5
> 
> This patch set converts the module verification and digital signature
> code to the new akcipher API.
> RSA implementation has been removed from crypto/asymmetric_keys and the
> new API is used for cryptographic primitives.
> There is no need for MPI above the akcipher API anymore.
> Modules can be verified with software as well as HW RSA implementations.
> 
> Patches generated against cryptodev-2.6

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
