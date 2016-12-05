From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss: support the Security System PRNG
Date: Mon, 5 Dec 2016 13:57:38 +0100
Message-ID: <20161205125738.GA13525@Red>
References: <1480934922-20732-1-git-send-email-clabbe.montjoie@gmail.com>
 <20161205123705.GA10732@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, maxime.ripard@free-electrons.com,
        wens@csie.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161205123705.GA10732@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 05, 2016 at 08:37:05PM +0800, Herbert Xu wrote:
> On Mon, Dec 05, 2016 at 11:48:42AM +0100, Corentin Labbe wrote:
> > From: LABBE Corentin <clabbe.montjoie@gmail.com>
> > 
> > The Security System have a PRNG.
> > This patch add support for it as an hwrng.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> 
> Please don't add PRNGs to hwrng.  If we have existing PRNGs in
> there please let me know so that we can remove them.
> 

So how to expose PRNG to user space ? or more generally how to "use" a PRNG ?

I found hisi-rng, crypto4xx_ and exynos-rng which seems to be PRNG used as hwrng.

Regards
