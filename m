From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 0/5] crypto: fixes for Marvell hash
Date: Fri, 9 Oct 2015 20:43:10 +0100
Message-ID: <20151009194309.GA7401@n2100.arm.linux.org.uk>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
 <20151009104637.GA18798@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Cooper <jason@lakedaemon.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:51382 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbJITn2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:43:28 -0400
Content-Disposition: inline
In-Reply-To: <20151009104637.GA18798@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

After all, here's a version 3, which fixes the other bug I mentioned
below - we now have correct hash results.  A couple of patches have
been added, one to fix that, and a second patch to factor out the
duplication in the import functions.  This gets openssh working with
the digests enabled.

Acks so far received have been added.  Patch 3 has changed, so I didn't
add the ack for the previous version.  Please re-review patch 3.

Thanks.

 crypto/ahash.c                |  3 +-
 crypto/shash.c                |  3 +-
 drivers/crypto/marvell/hash.c | 80 +++++++++++++++++--------------------------
 3 files changed, 36 insertions(+), 50 deletions(-)

On Fri, Oct 09, 2015 at 11:46:37AM +0100, Russell King - ARM Linux wrote:
> Version 2, same as version 1 but with a different patch 1, thanks to
> Herbert for an alternative approach on that one.
> 
>  crypto/ahash.c                | 3 ++-
>  crypto/shash.c                | 3 ++-
>  drivers/crypto/marvell/hash.c | 9 +++++++++
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> On Fri, Oct 09, 2015 at 11:29:04AM +0100, Russell King - ARM Linux wrote:
> > This small series of patches addresses oopses seen when trying to use
> > the AF_ALG interface via openssl with openssh.  This series does not
> > address all problems, but merely stops the kernel from smashing its
> > kernel stack and oopsing.
> > 
> > With these fixes in place, the kernel no longer oopses.  However, with
> > the digests enabled in openssl, openssh refuses to work, producing the
> > following when attempting to connect to the target system:
> > 
> > Corrupted MAC on input.
> > Disconnecting: Packet corrupt
> > 
> > It's been hard enough to get this far; the crypto code is not the easiest
> > code to debug for a new-comer due to the amount of state needed to be
> > retained to understand the code (all the inline functions masking
> > multiple levels of containerisation and pointer dereference does not
> > make it easy to track what is stored where, and once I've been through
> > one bit of code, I find I'm having to revisit the same piece of code a
> > bit later to re-understand what it's doing.)
> > 
> > It's been difficult enough to find the engine plugin for openssl - the
> > original git repo which hosted it is now dead
> > (http://src.carnivore.it/users/common/af_alg/).  All that seems to be
> > left is someone's modified version on github, which seems to get some
> > maintanence.  Debian doesn't seem to carry AF_ALG openssl support, and
> > seems to only carry one package (strongswan) which supports this
> > interface.
> > 
> > Hence, I'm leaving further debugging to other parties, especially as
> > the userspace tooling for the AF_ALG seems rather lacking.  (Are there
> > any test programs, if so, can their location be documented and placed
> > in Documentation/crypto please?)
> > 
> > I'm not sure who the maintainer for drivers/crypto/marvell is, so I've
> > picked Thomas.  It would be nice if there was an entry in MAINTAINERS
> > for this driver.
> > 
> > The first patch in this series avoids kernel stack smashing if a crypto
> > driver forgets to set the 'statesize' member, but writes to what seems
> > to be a valid pointer passed to its export function.  Of course, this
> > won't completely stop stack smashing if the statesize member is
> > smaller than the data which the export function writes.  This patch is
> > optional.
> > 
> > The second patch adds the necessary statesize members to the Marvell
> > code which were previously missing.  Fixing this uncovered a further
> > problem, which the third patch addresses.
> 
> -- 
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
