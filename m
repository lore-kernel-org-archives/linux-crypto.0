From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 2/2] crypto: omap-sham - omap sha1 & md5 driver
Date: Wed, 14 Apr 2010 14:45:12 +0800
Message-ID: <20100414064512.GB20555@gondor.apana.org.au>
References: <20100414062052.GA20395@gondor.apana.org.au> <4BC56398.40500@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BC56398.40500@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 14, 2010 at 09:41:28AM +0300, Dmitry Kasatkin wrote:
>
> what do you mean "exporting shash object"?
>
> Providing shash alg?
>
> I was not sure if it is needed if ahash is available.
>
> Should I remove shash alg at all?

In that case please remove the shash object.  ahash by itself
is enough.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
