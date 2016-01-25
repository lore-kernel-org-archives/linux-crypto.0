From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
Date: Mon, 25 Jan 2016 22:41:01 +0800
Message-ID: <20160125144101.GC8414@gondor.apana.org.au>
References: <20160113214318.GB32766@yogzotot>
 <20160115.152253.1613974535141140248.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: matorola@gmail.com, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160115.152253.1613974535141140248.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 15, 2016 at 03:22:53PM -0500, David Miller wrote:
> From: Anatoly Pugachev <matorola@gmail.com>
> Date: Thu, 14 Jan 2016 00:43:18 +0300
> 
> > This patch adds support for recent oracle hardware (T5/M5, T7/M7 SPARC CPUs),
> > so n2_rng driver would work on them.
> > 
> > 1. n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
> > 2. n2rng: documentation, add DT bindings, vendor prefixes
> > 
> > PS: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=809815#32
> > 
> > Signed-off-by: Anatoly Pugachev <matorola@gmail.com>
> 
> This series looks fine:
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Herbert, please take this via your crypto tree.

I'd love to but unfortunately the pathces are white-space damaged
and all the tabs have turned into spaces.

Anatoly, could you please repost with a mailer that does not eat
tabs for lunch?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
