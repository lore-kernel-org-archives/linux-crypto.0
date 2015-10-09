From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] crypto: ensure algif_hash does not pass a zero-sized
 state
Date: Fri, 9 Oct 2015 11:41:07 +0100
Message-ID: <20151009104106.GM32532@n2100.arm.linux.org.uk>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <E1ZkUvo-0004QO-U8@rmk-PC.arm.linux.org.uk>
 <20151009103428.GA1410@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:50088 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbJIKlQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 06:41:16 -0400
Content-Disposition: inline
In-Reply-To: <20151009103428.GA1410@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 09, 2015 at 06:34:28PM +0800, Herbert Xu wrote:
> On Fri, Oct 09, 2015 at 11:29:44AM +0100, Russell King wrote:
> > If the algorithm passed a zero statesize, do not pass a valid pointer
> > into the export/import functions.  Passing a valid pointer covers up
> > bugs in driver code which then go on to smash the kernel stack.
> > Instead, pass NULL, which will cause any attempt to write to the
> > pointer to fail.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> The state size should never be zero for a hash algorithm.  Having
> a zero state means that the hash output must always be identical.
> Such an algorithm would be quite useless.
> 
> So how about adding a check upon hash registration to verify that
> the state size is greater than zero? The place to do it would be
> shash_prepare_alg and ahash_prepare_alg.

Do you mean something like this?  As statesize is an unsigned int, testing
for zero should be sufficient.

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 8acb886032ae..9c1dc8d6106a 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -544,7 +544,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	struct crypto_alg *base = &alg->halg.base;
 
 	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
-	    alg->halg.statesize > PAGE_SIZE / 8)
+	    alg->halg.statesize > PAGE_SIZE / 8 ||
+	    alg->halg.statesize == 0)
 		return -EINVAL;
 
 	base->cra_type = &crypto_ahash_type;
diff --git a/crypto/shash.c b/crypto/shash.c
index ecb1e3d39bf0..ab3384b38542 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -585,7 +585,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 
 	if (alg->digestsize > PAGE_SIZE / 8 ||
 	    alg->descsize > PAGE_SIZE / 8 ||
-	    alg->statesize > PAGE_SIZE / 8)
+	    alg->statesize > PAGE_SIZE / 8 ||
+	    alg->statesize == 0)
 		return -EINVAL;
 
 	base->cra_type = &crypto_shash_type;

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
