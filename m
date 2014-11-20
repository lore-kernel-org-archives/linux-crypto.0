From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Thu, 20 Nov 2014 16:02:05 +0800
Message-ID: <20141120080205.GA29710@gondor.apana.org.au>
References: <1415771371-30774-1-git-send-email-ming.liu@windriver.com>
 <20141112084138.GL6390@secunet.com>
 <20141115031549.GA19208@gondor.apana.org.au>
 <20141120072650.GT6390@secunet.com>
 <20141120074342.GA29544@gondor.apana.org.au>
 <20141120075943.GU6390@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ming Liu <ming.liu@windriver.com>, davem@davemloft.net,
	ying.xue@windriver.com, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141120075943.GU6390@secunet.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 20, 2014 at 08:59:44AM +0100, Steffen Klassert wrote:
>
> Sure, but could be an option if this is really a rare case.

Well it's rare but when it does hit it'll probably be there all
the time for that system.  IOW you either have no apps using the
FPU, but when you do, it's probably going to be hogging it.

> Anyway, I don't mind too much about the solution as long as we
> get it to work :)

:)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
