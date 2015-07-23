From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - fix invalid check for keylen in fips mode
Date: Thu, 23 Jul 2015 09:54:08 +0800
Message-ID: <20150723015408.GB9777@gondor.apana.org.au>
References: <20150721001826.24499.51560.stgit@tstruk-mobl1>
 <20150721122521.GA25104@gondor.apana.org.au>
 <55AF9CE5.7040303@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51153 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbbGWByN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 21:54:13 -0400
Content-Disposition: inline
In-Reply-To: <55AF9CE5.7040303@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 22, 2015 at 06:38:45AM -0700, Tadeusz Struk wrote:
> On 07/21/2015 05:25 AM, Herbert Xu wrote:
> > On Mon, Jul 20, 2015 at 05:18:26PM -0700, Tadeusz Struk wrote:
> >> The condition checking allowed key length was invalid.
> >>
> >> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> >>
> >> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> > 
> > Applied.
> > 
> Herbert, Shouldn't this one go to 4.2?

No because we don't have any RSA users in 4.2.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
