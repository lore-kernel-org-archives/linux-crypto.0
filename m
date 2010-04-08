From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: omap-sha1-md5: OMAP3 SHA1 & MD5 driver
Date: Thu, 8 Apr 2010 22:04:21 +0800
Message-ID: <20100408140421.GA25093@gondor.apana.org.au>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com> <20100323113239.GA29837@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100323113239.GA29837@gondor.apana.org.au>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 23, 2010 at 07:32:39PM +0800, Herbert Xu wrote:
>
> My only question is what's your plan with respect to HMAC? If
> you're going to do it in hardware then it's fine as it is.
> 
> Otherwise you need to implement export/import and we also need
> to add ahash support to hmac.c.

Dmitry, did you answer this before or did it get lost in the mail :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
