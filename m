From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Sat, 10 Oct 2015 17:52:29 +0100
Message-ID: <20151010165229.GH32532@n2100.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151010184607.353cb5f3@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:53895 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbbJJQwk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Oct 2015 12:52:40 -0400
Content-Disposition: inline
In-Reply-To: <20151010184607.353cb5f3@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 10, 2015 at 06:46:07PM +0200, Boris Brezillon wrote:
> On Fri, 09 Oct 2015 20:43:33 +0100
> Russell King <rmk+kernel@arm.linux.org.uk> wrote:
> 
> > If the algorithm passed a zero statesize, do not pass a valid pointer
> > into the export/import functions.  Passing a valid pointer covers up
> > bugs in driver code which then go on to smash the kernel stack.
> > Instead, pass NULL, which will cause any attempt to write to the
> > pointer to fail.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> >  crypto/ahash.c | 3 ++-
> >  crypto/shash.c | 3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/crypto/ahash.c b/crypto/ahash.c
> > index 8acb886032ae..9c1dc8d6106a 100644
> > --- a/crypto/ahash.c
> > +++ b/crypto/ahash.c
> > @@ -544,7 +544,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
> >  	struct crypto_alg *base = &alg->halg.base;
> >  
> >  	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
> > -	    alg->halg.statesize > PAGE_SIZE / 8)
> > +	    alg->halg.statesize > PAGE_SIZE / 8 ||
> > +	    alg->halg.statesize == 0)
> 
> Just read Russel's answer to the cover letter, and I wonder if the
> following test wouldn't fix the problem:
> 
> 	    (alg->halg.statesize == 0 && (alg->import || alg->export))
> 
> I mean, the only valid case where statesize can be zero is when you
> don't have any state associated to the crypto algorithm, and if that's
> the case, ->import() and ->export() functions are useless, isn't ?

However, that brings up a question.

If you're using AF_ALG, and you attach to (say) the ARM Neon SHA512
implementation through it, and then use accept() to duplicate it's
state, what prevents the kernel from oopsing when hash_accept() calls
crypto_ahash_export(), which then dereferences the NULL alg->export
function pointer?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
