From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 0/3] crypto: KEYS: convert public key to akcipher api
Date: Sat, 6 Feb 2016 22:27:05 +0800
Message-ID: <20160206142705.GA23978@gondor.apana.org.au>
References: <20160206074731.GF22220@gondor.apana.org.au>
 <20160202180848.2887.9937.stgit@tstruk-mobl1>
 <11215.1454752821@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jmorris@namei.org, Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59147 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbcBFO1R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 09:27:17 -0500
Content-Disposition: inline
In-Reply-To: <11215.1454752821@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 06, 2016 at 10:00:21AM +0000, David Howells wrote:
> 
> Hmmm...  That means that the crypto branch and the security branch are going
> to conflict.

I thought you were OK with it going in now as you said that you'll
fix it up later.  Sorry for the misunderstanding.  Do you want me to
revert?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
