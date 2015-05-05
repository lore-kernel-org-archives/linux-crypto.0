From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Tue, 5 May 2015 09:33:54 +0800
Message-ID: <20150505013354.GA4663@gondor.apana.org.au>
References: <20150430223652.10157.86151.stgit@tstruk-mobl1>
 <20150430223647.10157.82156.stgit@tstruk-mobl1>
 <4227.1430496240@warthog.procyon.org.uk>
 <5543C348.9060004@intel.com>
 <20150503000744.GB16211@gondor.apana.org.au>
 <5547C7F0.5010905@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, linux-kernel@vger.kernel.org, steved@redhat.com,
	vgoyal@redhat.com, james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54919 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbbEEBe0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 21:34:26 -0400
Content-Disposition: inline
In-Reply-To: <5547C7F0.5010905@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2015 at 12:26:40PM -0700, Tadeusz Struk wrote:
> 
> So in this case isn't RNG a hash algorithm as well?

No RNG is at 12 and HASH is 8-11.

> Anyway will something like this be ok with you:

This is unnecesary.  You can use 13/14 (d/e).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
