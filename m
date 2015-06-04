From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v3 2/3] crypto: RSA: KEYS: convert rsa and public key
 to new PKE API
Date: Thu, 4 Jun 2015 14:53:33 +0800
Message-ID: <20150604065333.GB22158@gondor.apana.org.au>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1>
 <20150603224414.22310.17260.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33294 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbFDGxm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 02:53:42 -0400
Content-Disposition: inline
In-Reply-To: <20150603224414.22310.17260.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2015 at 03:44:14PM -0700, Tadeusz Struk wrote:
> Change the existing rsa and public key code to integrate it
> with the new Public Key Encryption API.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

I'd like to see this split into multiple patches.  First of all
the new crypto_akcipher implementation should coexist with the
existing code.  That way the exiting users can be converted over
one-by-one.

Also you should implement the crypto_akcipher completely before
converting anybody over, that means doing encoding/wrapping in
addition to the crypto.

That way we don't have to have craziness like converting in and
out of MPI multiple times.

Lastly you should consider adding an MPI helper that writes to
an existing buffer instead of allocating a new one and copying
it over.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
