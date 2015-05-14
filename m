From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Thu, 14 May 2015 10:59:26 +0800
Message-ID: <20150514025926.GC3853@gondor.apana.org.au>
References: <20150512012158.GA13237@gondor.apana.org.au>
 <20150511062421.GA2266@gondor.apana.org.au>
 <20150506193643.9329.75351.stgit@tstruk-mobl1>
 <20150506193648.9329.27232.stgit@tstruk-mobl1>
 <11243.1431351927@warthog.procyon.org.uk>
 <12222.1431529435@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37335 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbbENC7p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2015 22:59:45 -0400
Content-Disposition: inline
In-Reply-To: <12222.1431529435@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2015 at 04:03:55PM +0100, David Howells wrote:
>
> So what if we want to use a key that's stored in a TPM?  I presume then we
> can't use the crypto interface, but must rather use the *key* as the primary
> interface somehow.

Then it has nothing to do with what we're trying to do here.

The crypto API is providing a generic algorithmic interface for
operations that can then be accelerated by hardware devices.

So anything that cannot be done purely in software does not fall
under our purview.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
