From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: doc - clarify hash callbacks state machine
Date: Fri, 16 Mar 2018 23:16:42 +0800
Message-ID: <20180316151642.GA6606@gondor.apana.org.au>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180305103945.3517-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 05, 2018 at 12:39:45PM +0200, Horia Geantă wrote:
> Even though it doesn't make too much sense, it is perfectly legal to:
> - call .init() and then (as many times) .update()
> - subseqently _not_ call any of .final(), .finup() or .export()

Actually it makes perfect sense, because there can be an arbitrary
number of requests for a given tfm.  There is no requirement that
you must finalise the first request before submitting new ones.

IOW there can be an arbitrary number of outstanding requests even
without the user intentionally abandoning any hash request.

So please modify your commit description.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
