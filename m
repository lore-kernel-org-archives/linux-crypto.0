From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 1/2] crypto: Implement a generic crypto statistics
Date: Wed, 31 Jan 2018 09:33:37 +0100
Message-ID: <20180131083337.rvshu72x5xhh22ef@gauss3.secunet.de>
References: <1515700617-3513-1-git-send-email-clabbe@baylibre.com>
 <3297958.ndliyBY1jk@tauon.chronox.de>
 <20180112090730.GA15630@Red>
 <16302559.hxlYq3rOsN@tauon.chronox.de>
 <20180118085813.GA1988@Red>
 <20180126154328.GA4002@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: LABBE Corentin <clabbe@baylibre.com>, <davem@davemloft.net>,
        <nhorman@tuxdriver.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180126154328.GA4002@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 26, 2018 at 11:43:28PM +0800, Herbert Xu wrote:
> On Thu, Jan 18, 2018 at 09:58:13AM +0100, LABBE Corentin wrote:
> >
> > I have two way of adding a new netlink request
> > - keep the current patch and simply add a new CRYPTO_MSG_GETSTAT which use the same function than CRYPTO_MSG_GETALG
> > 	=> minimal changes, in fact CRYPTO_MSG_GETSTAT and CRYPTO_MSG_GETALG would be the same, but it is easy for userspace to test presence of stat.
> > - Create a new CRYPTO_MSG_GETSTAT which imply lot of code and add a new crypto_user_stat.c
> > 	=> this imply also to change makefile (rename crypto_user.c to crypto_user_base.c) since crypto_user.ko is made of two files.
> > 
> > Which one do you prefer ?
> 
> I think you should check with the crconf author, Steffen Klassert
> since that will be affected by this change.

I still haven't had time to look into the details, but I'm
fine with everything that does not break existing userspace.
Everything else would be a 'no go'.
