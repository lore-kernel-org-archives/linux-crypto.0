From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 00/03]: RNG support v2
Date: Sun, 18 Nov 2007 22:32:52 +0100 (MET)
Message-ID: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Cc: johnpol@2ka.mipt.ru, Patrick McHardy <kaber@trash.net>,
	linux-crypto@vger.kernel.org, mb@bu3sch.de,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46263 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbXKRVcy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 16:32:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These patches add support for using the HIFN rng.

The first patch changes the hwrng API to move waiting for availability
of new random into the drivers. This allows to use driver-specific
delays instead of the constant 10us delay used previously, increasing
the HIFN speed from 2.5mbit to almost 15mbit, which is nearly the
theoretical maximum.

The second patch improves the PLL initialization by making the reference
clock configurable and its speed known to the driver, which is needed
to calculate the amount of time to wait between two RNG reads. Since
there is no way to find out the frequency reliably (especially for the
external clock), it adds some sane looking defaults and a module
parameter to override it. It also changes the PLL initialization to
follow the procedure described in the HIFN documentation.

The third patch adds hw_random support. To use the rng, the HW_RANDOM
config option has to be enabled.

Running rngtest on the random number generator indicates that it works
properly, with an average failure ratio of about 1:1000 at ~15mbit:

rngtest: bits received from input: 3155000032
rngtest: FIPS 140-2 successes: 157621
rngtest: FIPS 140-2 failures: 129
rngtest: FIPS 140-2(2001-10-10) Monobit: 20
rngtest: FIPS 140-2(2001-10-10) Poker: 13
rngtest: FIPS 140-2(2001-10-10) Runs: 54
rngtest: FIPS 140-2(2001-10-10) Long run: 43
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=441.005; avg=14730.378; max=21510.187)Kibits/s
rngtest: FIPS tests speed: (min=1.228; avg=55.967; max=62.742)Mibits/s
rngtest: Program run time: 263373905 microseconds

Changes this last posting:

- follow PLL initialization procedure as described in the documentation
- allow to specify clock source without a frequency
- rename pll_ref module parameter to hifn_pll_ref
- discard first rng value after initialization as suggested by the
  documentation
- use ktime instead of get_cycles for delaying rng reads
- adapt to the hwrng API changes
- fix cleanup in initialization error path


Michael, if you're OK with the RNG changes, I'd suggest that all three
patches go through Herbert since the HIFN patches depend on that part.


 drivers/char/hw_random/amd-rng.c    |   12 ++-
 drivers/char/hw_random/core.c       |   24 +----
 drivers/char/hw_random/geode-rng.c  |   12 ++-
 drivers/char/hw_random/intel-rng.c  |   15 ++-
 drivers/char/hw_random/omap-rng.c   |   13 ++-
 drivers/char/hw_random/pasemi-rng.c |   14 ++-
 drivers/char/hw_random/via-rng.c    |   19 ++--
 drivers/crypto/hifn_795x.c          |  192 ++++++++++++++++++++++++++++++++++-
 include/linux/hw_random.h           |    2 +-
 9 files changed, 262 insertions(+), 41 deletions(-)

Patrick McHardy (3):
      [HWRNG]: move status polling loop to data_present callbacks
      [HIFN]: Improve PLL initialization
      [HIFN]: Add support for using the random number generator
