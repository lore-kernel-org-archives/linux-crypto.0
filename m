From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Mon, 13 Jun 2011 18:06:53 -0400
Message-ID: <1308002818-27802-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1FMWHf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2011 18:07:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Many server systems are seriously lacking in sources of entropy,
as we typically only feed the entropy pool by way of input layer
events, a few NIC driver interrupts and disk activity. A non-busy
server can easily become entropy-starved. We can mitigate this
somewhat by periodically mixing in entropy data based on the
delta between multiple high-resolution clocksource reads, per:

  https://www.osadl.org/Analysis-of-inherent-randomness-of-the-L.rtlws11-developers-okech.0.html

Additionally, NIST already approves of similar implementations, so
this should be usable in high-securtiy deployments requiring a
fair chunk of available entropy data for frequent use of /dev/random.

http://csrc.nist.gov/groups/STM/cmvp/documents/140-1/140sp/140sp750.pdf
(section 6.1 mentions a clock-based seed source).

Yes, thus far, I've only bothered with x86-based clocksources, since that
is what I can test most easily. If this patch series isn't deemed totally
insane, adding support for other clocksources should be trivial.

Also note that unless you explicitly build and load the clock-entropy
driver, there should be little or no change whatsoever to the way anything
behaves right now, its purely opt-in. There's probably room for some
improvement here, and I'm kind of outside my comfort area, but hey, it
seems to work pretty well here in my own testing, so here it is...

Jarod Wilson (5):
  random: add new clocksource entropy interface
  clocksource: add support for entropy-generation function
  hpet: wire up entropy generation function
  tsc: wire up entropy generation function
  misc: add clocksource-based entropy generation driver

 arch/x86/kernel/hpet.c       |   18 ++++++
 arch/x86/kernel/tsc.c        |   18 ++++++
 drivers/char/random.c        |   28 ++++++++++
 drivers/misc/Kconfig         |   14 +++++
 drivers/misc/Makefile        |    1 +
 drivers/misc/clock-entropy.c |  122 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/clocksource.h  |    6 ++
 include/linux/random.h       |    1 +
 kernel/time/clocksource.c    |   33 +++++++++++
 9 files changed, 241 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/clock-entropy.c

CC: Matt Mackall <mpm@selenic.com>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: John Stultz <johnstul@us.ibm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
