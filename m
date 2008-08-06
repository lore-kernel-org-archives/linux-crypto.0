From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Wed, 6 Aug 2008 19:03:48 +0800
Message-ID: <20080806110348.GA32022@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain> <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Austin Zhang <austin_zhang@linux.intel.com>, bunk@kernel.org,
	dwmw2@infradead.org, davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759552AbYHFLEW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 06, 2008 at 11:42:26AM +0200, Pavel Machek wrote:
>
> > +static int crc32c_intel_final(struct ahash_request *req)
> > +{
> > +	u32 *crcp = ahash_request_ctx(req);
> > +
> > +	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
> > +	return 0;
> 
> This is not user visible, so le32 should be enough.

Unfortunately I don't think le32 exists, it'd definitely be nice
to have it though.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
