From: Patrick McHardy <kaber@trash.net>
Subject: [RFC HIFN 00/02]: RNG support
Date: Sat, 17 Nov 2007 20:30:09 +0100 (MET)
Message-ID: <20071117192949.19399.75523.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: johnpol@2ka.mipt.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48299 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759595AbXKQTaL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 14:30:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These two patches add support for using the HIFN rng.

The first patch improves the PLL initialization a bit by making the
reference clock configurable and its speed known to the driver, which
is needed to calculate the amount of time to wait between two RNG reads.
Since there is no way to find out the frequency reliably (especially for
the external clock), it adds some sane looking defaults and a module
parameter to override it. Suggestions how to improve this are welcome.

The second patch adds hw_random support. The ugly part is finding out
when to allow reads from the RNG. It currently translates the public
key engine clock cycles to CPU cycles based on a 4GHz CPU and uses
get_cycles(). The problems with this are obvious, it only works on CPUs
that actually have some kind of cycle counter, has problems with
unsynchronized TSCs and the 4GHz assumption is not very nice either,
but I was reluctant to use ktime for this since it seems rather
expensive to call ktime_get once per 4 bytes of random. Suggestion
for improvement of this are also welcome :)

Running rngtest on the random number generator indicates that it works
properly, with an average failure ratio of about 1:1000 at ~2.5mbit.


 drivers/crypto/hifn_795x.c |  158 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 156 insertions(+), 2 deletions(-)

Patrick McHardy (2):
      [HIFN]: Improve PLL initialization
      [HIFN]: Add support for using the random number generator
