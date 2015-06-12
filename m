From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v4 2/4] crypto: add PKE API
Date: Fri, 12 Jun 2015 10:42:46 +0800
Message-ID: <20150612024246.GA30982@gondor.apana.org.au>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
 <20150611190543.31826.357.stgit@tstruk-mobl1>
 <2901639.xlpED6EpBc@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59809 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbbFLCnP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 22:43:15 -0400
Content-Disposition: inline
In-Reply-To: <2901639.xlpED6EpBc@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 12, 2015 at 03:00:42AM +0200, Stephan Mueller wrote:
>
> The testmgr code can mark an entire cipher implementation as fips_allowed=1 as 
> already done for RSA. However, unlike with the other ciphers, that flag must 
> go in conjunction with the used key sizes.
> 
> For FIPS mode, the following restrictions apply:
> 
> - RSA: 2048/3072
> 
> - DSA: L 2048 / N 224; L 2048 / N 256; L 3072 / N 256
> 
> - ECDSA: only the NIST curves
> 
> Any other key sizes for the given ciphers is not allowed in FIPS mode.
> 
> Should that constraint be considered here?

Yes.  However it should be placed into a helper that everybody
can call so that future hardware implementations can also make
the same checks.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
