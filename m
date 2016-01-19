From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: Fix crc32c soft dependency
Date: Tue, 19 Jan 2016 13:13:42 -0800
Message-ID: <1453238022.30844.20.camel@schen9-desk2.jf.intel.com>
References: <20160118170605.4e4a022f@endymion.delvare>
	 <20160119075726.GA7842@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <jdelvare@suse.de>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Michal Marek <mmarek@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbcASVNn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 16:13:43 -0500
In-Reply-To: <20160119075726.GA7842@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2016-01-19 at 15:57 +0800, Herbert Xu wrote:
> On Mon, Jan 18, 2016 at 05:06:05PM +0100, Jean Delvare wrote:
> > I don't think it makes sense for a module to have a soft dependency
> > on itself. This seems quite cyclic by nature and I can't see what
> > purpose it could serve.
> > 
> > OTOH libcrc32c calls crypto_alloc_shash("crc32c", 0, 0) so it pretty
> > much assumes that some incarnation of the "crc32c" hash algorithm has
> > been loaded. Therefore it makes sense to have the soft dependency
> > there (as crc-t10dif does.)
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > Cc: Tim Chen <tim.c.chen@linux.intel.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> 
> Well caught.  Patch applied, thanks!

Thanks for the fix.

Tim
